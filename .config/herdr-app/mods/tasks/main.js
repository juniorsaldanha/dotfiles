// Tasks: one list per space (to-do, doing, done). Doing tasks belong to an agent and run a clock;
// branch and PR are tracked. Agents edit the same file with `herdr-tasks` (see that script).
// Roles (props.role): the panel (default); "toggle", the tab-bar button that shows or hides it.
import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex, Input, InputState } from "gpui-base";
import { spaces, agents, panes, exec, readTextFile, writeTextFile, watchFolder, appHome, checking, theme, layout, run, props } from "herdr";

const PANEL = "tasks-panel";
const dir = () => `${appHome()}/tasks`;
const fileOf = (space) => `${dir()}/${space}.json`;
const now = () => Date.now();
const stop = (_e, cx) => cx.stop_propagation();
const find = (n, id) => n?.id === id ? n : (n?.children ?? []).reduce((f, c) => f ?? find(c, id), null);
const spent = (t) => (t.spent_ms ?? 0) + (t.status === "doing" && t.started_at ? now() - t.started_at : 0);
const fmt = (ms) => { const m = Math.floor(ms / 60000); return m >= 60 ? `${Math.floor(m / 60)}h${String(m % 60).padStart(2, "0")}m` : `${m}m`; };
const parse = (text) => { try { return JSON.parse(text ?? "") ?? { tasks: [] }; } catch { return { tasks: [] }; } };
const SECTIONS = [["todo", "To do"], ["doing", "Doing"], ["done", "Done"]];

function toggle() {
  const t = theme(), node = find(layout(), PANEL), on = node && !node.hidden;
  return h_flex().size_full().pr(6).items_center().bg(t.chrome).border_b(1).border_color(t.border)
    .child(h_flex().id("toggle-tasks").h(26).px(8).gap(5).flex_none().items_center().rounded(6)
      .text_size(12).bg(on ? t.selected : t.chrome).text_color(on ? t.foreground : t.muted)
      .hover((s) => s.bg(t.hover)).on_mouse_down("left", stop)
      .on_click(() => run("layout.toggle", { id: PANEL }))
      .child(svg("mods/workspace-chrome/circle-check.svg").size(14)).child("Tasks"));
}

export default class Tasks extends View {
  init(_props, cx) {
    this.role = props()?.role ?? "panel";
    if (this.role === "toggle") return;
    this.data = { tasks: [] }; this.text = null; this.space = null; this.picking = null; this.error = null;
    this.input = InputState.new({ placeholder: "Add a task…" });
    this.input.on("submit", (_e, cx) => this.add(cx));
    if (checking()) return;
    cx.spawn(async (cx) => {
      await exec("mkdir", ["-p", dir()]);
      for (;;) { await watchFolder(dir()); this.load(cx); }
    });
    // Clocks show minutes; PRs appear when pushed.
    cx.timer.every(30000, (cx) => { if (this.data.tasks.some((t) => t.status === "doing")) cx.notify(); });
    cx.timer.every(60000, (cx) => this.findPrs(cx));
  }

  load(cx) {
    const space = this.space;
    if (!space) return;
    cx.spawn(async (cx) => {
      const text = await readTextFile(fileOf(space)).catch(() => null);
      if (space !== this.space) return;
      this.text = text; this.data = parse(text); cx.notify();
    });
  }

  // Read, change, compare-and-swap; a writer in between (an agent) means read again and redo.
  edit(cx, change) {
    const space = this.space;
    cx.spawn(async (cx) => {
      for (let i = 0; i < 3; i++) {
        const text = await readTextFile(fileOf(space)).catch(() => null);
        const data = parse(text);
        if (change(data) === false) return;
        const next = JSON.stringify(data, null, 1);
        try {
          await writeTextFile(fileOf(space), next, text);
          if (space === this.space) { this.text = next; this.data = data; this.error = null; cx.notify(); }
          return;
        } catch (e) { this.error = String(e); }
      }
      cx.notify();
    });
  }

  task(data, id) { return data.tasks.find((t) => t.id === id); }

  add(cx) {
    const title = this.input.value().trim();
    if (!title) return;
    this.input.set_value("");
    this.edit(cx, (d) => { d.tasks.push({ id: Math.random().toString(16).slice(2, 8), title, status: "todo", agent: null, branch: null, pr: null, created_at: now(), started_at: null, done_at: null, spent_ms: 0 }); });
  }

  start(cx, id, agent) {
    this.picking = null;
    const branch = panes().find((p) => p.pane === agent.pane)?.branch ?? null;
    this.edit(cx, (d) => {
      const t = this.task(d, id); if (!t) return false;
      if (t.status !== "doing") t.started_at = now();
      Object.assign(t, { status: "doing", agent: agent.address, done_at: null, branch: branch ?? t.branch });
    });
  }

  move(cx, id, status) {
    this.edit(cx, (d) => {
      const t = this.task(d, id); if (!t) return false;
      if (t.status === "doing") { t.spent_ms = spent(t); t.started_at = null; }
      if (status === "todo") t.agent = null;
      Object.assign(t, { status, done_at: status === "done" ? now() : null });
    });
  }

  remove(cx, id) { this.edit(cx, (d) => { d.tasks = d.tasks.filter((t) => t.id !== id); }); }

  findPrs(cx) {
    const space = spaces().find((s) => s.id === this.space);
    const want = this.data.tasks.filter((t) => t.branch && !t.pr && t.status !== "todo" && !["main", "master"].includes(t.branch));
    if (!space || space.machine || !want.length) return;
    cx.spawn(async (cx) => {
      for (const t of want) {
        const cwd = panes().find((p) => p.terminal === t.agent)?.cwd ?? space.folder;
        const r = await exec("gh", ["pr", "view", t.branch, "--json", "url", "-q", ".url"], { cwd }).catch(() => null);
        const url = r?.code === 0 ? r.stdout.trim() : "";
        if (url) this.edit(cx, (d) => { const x = this.task(d, t.id); if (!x || x.pr) return false; x.pr = url; });
      }
    });
  }

  row(t, c, mine) {
    const agent = t.agent && agents().find((a) => a.address === t.agent);
    const btn = (id, label, action, color) => div().id(`${id}-${t.id}`).px(6).h(20).flex().items_center().rounded(5).text_size(11)
      .text_color(color ?? c.muted).cursor_pointer().hover((s) => s.bg(c.hover).text_color(c.foreground)).on_click((_e, cx) => action(cx)).child(label);
    const meta = [
      t.agent && h_flex().gap(4).items_center()
        .child(div().size(6).rounded(3).bg(agent ? c[agent.status] ?? c.idle : c.dim))
        .child(div().max_w(120).truncate().child(agent ? `${agent.program?.name ?? agent.app} · ${t.agent}` : `${t.agent} (gone)`)),
      t.branch && div().max_w(140).truncate().child(`⎇ ${t.branch}`),
      (t.status !== "todo" || t.spent_ms > 0) && div().child(`⏱ ${fmt(spent(t))}`),
      t.pr && div().id(`pr-${t.id}`).text_color(c.accent).cursor_pointer().on_click(() => exec("open", [t.pr]))
        .child(`PR #${t.pr.match(/(\d+)\/?$/)?.[1] ?? "↗"}`),
    ].filter(Boolean);
    const picking = this.picking === t.id;
    return v_flex().id(`task-${t.id}`).flex_none().px(10).py(7).gap(4).rounded(8).bg(c.surface).border_1().border_color(t.status === "doing" ? c.working : c.border)
      .child(h_flex().gap(6).items_start()
        .child(div().flex_1().min_w(0).text_size(13).text_color(t.status === "done" ? c.muted : c.foreground).child(t.title))
        .child(h_flex().flex_none().gap(2)
          .when(t.status === "todo", (el) => el.child(btn("start", "Start", (cx) => {
            if (mine.length === 1) this.start(cx, t.id, mine[0]);
            else { this.picking = picking ? null : t.id; cx.notify(); }
          }, mine.length ? c.accent : c.dim)))
          .when(t.status === "doing", (el) => el.child(btn("done", "Done", (cx) => this.move(cx, t.id, "done"), c.done)).child(btn("back", "Stop", (cx) => this.move(cx, t.id, "todo"))))
          .when(t.status === "done", (el) => el.child(btn("reopen", "Reopen", (cx) => this.move(cx, t.id, "todo"))))
          .child(btn("rm", "×", (cx) => this.remove(cx, t.id)))))
      .when(meta.length > 0, (el) => el.child(h_flex().flex_wrap().gap_x(10).gap_y(2).text_size(11).text_color(c.dim).children(meta)))
      .when(picking, (el) => el.child(h_flex().flex_wrap().gap(4).pt(2)
        .when(!mine.length, (el) => el.child(div().text_size(11).text_color(c.dim).child("No agent in this space: start one first")))
        .children(mine.map((a) => h_flex().id(`pick-${t.id}-${a.address}`).px(6).h(22).gap(4).items_center().rounded(5).text_size(11)
          .bg(c.raised).cursor_pointer().hover((s) => s.bg(c.hover)).on_click((_e, cx) => this.start(cx, t.id, a))
          .child(div().size(6).rounded(3).bg(c[a.status] ?? c.idle)).child(`${a.program?.name ?? a.app} · ${a.address}`)))));
  }

  render(cx) {
    if (this.role === "toggle") return toggle();
    const c = theme(), space = spaces().find((s) => s.active);
    if (space?.id !== this.space) { this.space = space?.id ?? null; this.data = { tasks: [] }; this.picking = null; this.load(cx); }
    const mine = agents().filter((a) => a.space === this.space);
    return v_flex().id("tasks").size_full().min_h(0).rounded(10).overflow_hidden().bg(c.background).border_1().border_color(c.border).text_color(c.foreground).text_size(13)
      .child(h_flex().h(42).flex_none().px(14).gap(8).items_center().border_b(1).border_color(c.border)
        .child(div().font_semibold().child("Tasks"))
        .child(div().flex_1().min_w(0).truncate().text_right().text_size(12).text_color(c.dim).child(space?.name ?? "")))
      .child(h_flex().flex_none().m(8).px(10).h(30).items_center().rounded(7).border_1().border_color(c.input).bg(c.surface)
        .child(Input.new(this.input).flex_1().min_w(0).h_full().text_size(13).text_color(c.foreground)))
      .when(Boolean(this.error), (el) => el.child(div().px(14).text_size(11).text_color(c.blocked).child(this.error)))
      .child(v_flex().id("tasks-list").flex_1().min_h(0).overflow_y_scrollbar().px(8).pb(8).gap(4).children(SECTIONS.flatMap(([status, label]) => {
        const list = this.data.tasks.filter((t) => t.status === status);
        return [h_flex().flex_none().pt(8).pb(2).px(2).gap(6).text_size(11).font_semibold().text_color(c.muted)
          .child(label).child(div().text_color(c.dim).child(String(list.length))), ...list.map((t) => this.row(t, c, mine))];
      })));
  }
}
