// Agents dashboard: tiles (counts, sub-agents, tokens, providers) over a filterable, sortable table
// of every agent. Opens as a dialog (`mod.open:agents-dashboard`) or a tab
// (`tab.new {mod: "agents-dashboard"}`). Tokens come from the agents' own session logs (usage.py).
import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex, InputState, Input } from "gpui-base";
import { agents, terminals, exec, hc, appHome, theme, run, props, closeOverlay } from "herdr";

const STATUSES = ["all", "working", "blocked", "done", "idle"];
const KIND = { "claude-code": "claude", claude: "claude", codex: "codex" };
const COLS = [
  // [key, label, width (null: grows)]
  ["name", "Agent", null],
  ["status", "Status", 104],
  ["provider", "Provider", 150],
  ["uptime", "Running", 92],
  ["since", "In status", 92],
  ["subs", "Sub-agents", 92],
  ["tokens", "Tokens", 104],
];

const fmtTokens = (n) =>
  n == null ? "—" : n >= 1e9 ? (n / 1e9).toFixed(1) + "B" : n >= 1e6 ? (n / 1e6).toFixed(1) + "M"
    : n >= 1e3 ? (n / 1e3).toFixed(1) + "k" : String(n);

const fmtDur = (ms) => {
  if (ms == null || ms < 0) return "—";
  const m = Math.floor(ms / 60000), h = Math.floor(m / 60), d = Math.floor(h / 24);
  return d ? `${d}d ${h % 24}h` : h ? `${h}h ${m % 60}m` : m ? `${m}m` : `${Math.floor(ms / 1000)}s`;
};

function provider(model, app, programName) {
  const m = (model || "").toLowerCase();
  if (/claude|opus|sonnet|haiku|fable/.test(m)) return "Anthropic";
  if (/gpt|codex|^o\d/.test(m)) return "OpenAI";
  if (/gemini/.test(m)) return "Google";
  if (/grok/.test(m)) return "xAI";
  if (/kimi|moonshot/.test(m)) return "Moonshot";
  if (app === "claude-code") return "Anthropic";
  if (app === "codex") return "OpenAI";
  return programName || app || "Unknown";
}

export default class AgentsDashboard extends View {
  init(p, cx) {
    // props.role "button": the tab-bar button that opens the dashboard (no polling of its own).
    this.button = (props() ?? p)?.role === "button";
    if (this.button) return;
    this.usage = {};
    this.details = {}; // address -> `hc get` (created_ms, status_ms): terminals() leaves the times out
    this.status = "all";
    this.provider = "all";
    this.sort = { key: "uptime", desc: true };
    this.input = InputState.new({ placeholder: "Filter by space, tab, title, program or model" });
    this.input.on("change", (_e, cx) => cx.notify());
    this.refresh(cx);
    // Data the app doesn't push: token counts and the clocks. Every 20 s is plenty for both.
    cx.timer.every(20000, (cx) => this.refresh(cx));
  }

  refresh(cx) {
    cx.spawn(async (cx) => {
      await Promise.all(agents().map(async (a) => {
        try {
          const r = await hc(["get", a.address, "--json"]);
          if (r.code === 0) this.details[a.address] = JSON.parse(r.stdout);
        } catch (_) { /* gone meanwhile */ }
      }));
      const args = terminals()
        .filter((t) => t.state === "live" && KIND[t.status?.app ?? t.report?.app] && t.foreground?.pid)
        .map((t) => `${t.address}:${KIND[t.status?.app ?? t.report?.app]}:${t.foreground.pid}`);
      if (args.length) {
        try {
          const r = await exec("/usr/bin/python3", [`${appHome()}/mods/agents-dashboard/usage.py`, ...args]);
          if (r.code === 0) this.usage = JSON.parse(r.stdout || "{}");
        } catch (e) {
          console.log("agents-dashboard: usage failed", String(e));
        }
      }
      cx.notify();
    });
  }

  rows() {
    const now = Date.now();
    const terms = terminals();
    const byAddr = new Map(terms.map((t) => [t.address, t]));
    return agents().map((a) => {
      const t = { ...this.details[a.address], ...byAddr.get(a.address) };
      const u = this.usage[a.address];
      const subs = terms.filter((s) => s.parent === a.address && s.state === "live");
      return {
        a, t, u,
        name: `${a.space_name} / ${a.tab_name}`,
        title: a.title || "",
        status: a.status,
        program: a.program?.name ?? a.app ?? "agent",
        model: u?.model ? u.model + (u.account ? ` · ${u.account}` : "") : null,
        provider: provider(u?.model, a.app, a.program?.name),
        uptime: t.created_ms ? now - t.created_ms : null,
        since: t.status_ms ? now - t.status_ms : null,
        subs: subs.length,
        subsWorking: subs.filter((s) => s.status === "working" || s.status?.state === "working").length,
        tokens: u?.total ?? null,
      };
    });
  }

  view(all) {
    const q = this.input.value().trim().toLowerCase();
    const list = all.filter((r) =>
      (this.status === "all" || r.status === this.status) &&
      (this.provider === "all" || r.provider === this.provider) &&
      (!q || [r.name, r.title, r.program, r.model, r.provider, r.a.address].some((s) => s && s.toLowerCase().includes(q))));
    const { key, desc } = this.sort;
    const val = (r) => (key === "status" ? STATUSES.indexOf(r.status) : r[key]);
    list.sort((x, y) => {
      const a = val(x), b = val(y);
      const c = a == null ? 1 : b == null ? -1 : typeof a === "string" ? a.localeCompare(b) : a - b;
      return a == null || b == null ? c : desc ? -c : c;
    });
    return list;
  }

  // ---- pieces ----

  tile(t, label, value, sub, color) {
    return v_flex().flex_1().min_w(150).gap(6).p(14).rounded(10).bg(t.surface).border(1).border_color(t.border)
      .child(div().text_size(11).text_color(t.muted).child(label.toUpperCase()))
      .child(div().text_size(26).font_semibold().text_color(color ?? t.foreground).child(String(value)))
      .child(div().text_size(12).text_color(t.dim).truncate().child(sub ?? ""));
  }

  providersTile(t, rows) {
    const by = {};
    for (const r of rows) {
      const p = (by[r.provider] ??= { agents: 0, tokens: 0 });
      p.agents++;
      p.tokens += r.tokens ?? 0;
    }
    const total = Object.values(by).reduce((s, p) => s + p.tokens, 0) || 1;
    const palette = [t.accent, t.ansi5, t.ansi6, t.ansi3, t.ansi2, t.ansi4];
    const entries = Object.entries(by).sort((a, b) => b[1].tokens - a[1].tokens || b[1].agents - a[1].agents);
    return v_flex().flex_none().w_full().gap(8).p(14).rounded(10).bg(t.surface).border(1).border_color(t.border)
      .child(div().text_size(11).text_color(t.muted).child("PROVIDERS"))
      .child(h_flex().h(8).w_full().rounded(4).overflow_hidden().bg(t.raised)
        .children(entries.map(([, p], i) => div().h_full().flex_basis(`${(p.tokens / total) * 100}%`).bg(palette[i % palette.length]))))
      .children(entries.map(([name, p], i) =>
        h_flex().id(`prov-${name}`).gap(8).items_center().text_size(12).rounded(4).px(4).cursor_pointer()
          .when(this.provider === name, (e) => e.bg(t.selected))
          .hover((s) => s.bg(t.hover))
          .on_click((_e, cx) => { this.provider = this.provider === name ? "all" : name; cx.notify(); })
          .child(div().size(8).rounded(4).bg(palette[i % palette.length]))
          .child(div().flex_1().text_color(t.foreground).child(name))
          .child(div().text_color(t.dim).child(`${p.agents} agent${p.agents === 1 ? "" : "s"}`))
          .child(div().w(64).text_color(t.muted).child(fmtTokens(p.tokens)))));
  }

  chip(t, id, label, on, onClick, color) {
    return h_flex().id(id).h(26).px(10).gap(6).items_center().rounded(13).text_size(12).cursor_pointer()
      .border(1).border_color(on ? t.accent : t.border)
      .bg(on ? t.selected : t.surface).text_color(on ? t.foreground : t.muted)
      .hover((s) => s.bg(t.hover))
      .on_click((_e, cx) => { onClick(); cx.notify(); })
      .when(!!color, (e) => e.child(div().size(7).rounded(4).bg(color)))
      .child(label);
  }

  cell(width, el) {
    return width ? div().w(width).flex_none().child(el) : div().flex_1().min_w(0).child(el);
  }

  header(t) {
    return h_flex().h(32).px(12).gap(8).items_center().border_b(1).border_color(t.border).text_size(11).text_color(t.muted)
      .children(COLS.map(([key, label, w]) => {
        const on = this.sort.key === key;
        return this.cell(w, h_flex().id(`sort-${key}`).gap(4).cursor_pointer().hover((s) => s.text_color(t.foreground))
          .on_click((_e, cx) => {
            this.sort = on ? { key, desc: !this.sort.desc } : { key, desc: key !== "name" && key !== "provider" };
            cx.notify();
          })
          .when(on, (e) => e.text_color(t.foreground))
          .child(label.toUpperCase())
          .child(on ? (this.sort.desc ? "↓" : "↑") : ""));
      }));
  }

  row(t, r) {
    const color = t[r.status] ?? t.unknown;
    const muted = (s) => div().text_size(12).text_color(t.muted).truncate().child(s);
    return h_flex().id(`row-${r.a.address}`).h(48).px(12).gap(8).items_center().border_b(1).border_color(t.border)
      .cursor_pointer().hover((s) => s.bg(t.hover))
      .on_click((_e, _cx) => {
        run("agent.focus", { terminal: r.a.address });
        if (props()?.overlay) closeOverlay(props().overlay);
      })
      .child(this.cell(null, v_flex().gap(2)
        .child(h_flex().gap(6).items_center()
          .child(div().text_size(13).text_color(t.foreground).truncate().child(r.name))
          .child(div().text_size(11).text_color(t.dim).child(r.a.address))
          .when(r.a.pinned, (e) => e.child(div().text_size(11).text_color(t.accent).child("pinned"))))
        .child(div().text_size(11).text_color(t.dim).truncate().child(r.title))))
      .child(this.cell(104, h_flex().gap(6).items_center()
        .child(r.status === "working" ? div().size(8).rounded(4).bg(color).loop("opacity", { from: 0.35, to: 1, period: 1200 }) : div().size(8).rounded(4).bg(color))
        .child(div().text_size(12).text_color(color).child(r.status))))
      .child(this.cell(150, v_flex()
        .child(div().text_size(12).text_color(t.foreground).truncate().child(r.provider))
        .child(div().text_size(11).text_color(t.dim).truncate().child(r.model ?? r.program))))
      .child(this.cell(92, muted(fmtDur(r.uptime))))
      .child(this.cell(92, muted(fmtDur(r.since))))
      .child(this.cell(92, muted(r.subs ? `${r.subsWorking}/${r.subs} working` : "—")))
      .child(this.cell(104, v_flex()
        .child(div().text_size(12).text_color(t.foreground).child(fmtTokens(r.tokens)))
        .when(!!r.u, (e) => e.child(div().text_size(10).text_color(t.dim).child(`↑${fmtTokens(r.u.input + r.u.cache_write)} ↓${fmtTokens(r.u.output)}`)))));
  }

  renderButton(t) {
    const blocked = agents().filter((a) => a.status === "blocked").length;
    return h_flex().size_full().pr(6).items_center().justify_end().bg(t.chrome).border_b(1).border_color(t.border)
      .child(h_flex().id("open-agents-dashboard").h(26).px(8).gap(5).flex_none().items_center().rounded(6)
        .text_size(12).bg(t.chrome).text_color(t.muted)
        .hover((s) => s.bg(t.hover).text_color(t.foreground))
        .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .on_click(() => run("mod.open", { name: "agents-dashboard" }))
        .child(svg("mods/agents-dashboard/gauge.svg").size(14).flex_none())
        .child("Dashboard")
        .when(blocked > 0, (e) => e.child(div().px(5).rounded(7).bg(t.blocked).text_size(10)
          .text_color(t.background).child(String(blocked)))));
  }

  render(cx) {
    const t = theme();
    if (this.button) return this.renderButton(t);
    const all = this.rows();
    const list = this.view(all);
    const count = (s) => all.filter((r) => r.status === s).length;
    const subs = all.reduce((s, r) => s + r.subs, 0);
    const subsWorking = all.reduce((s, r) => s + r.subsWorking, 0);
    const tokens = all.reduce((s, r) => s + (r.tokens ?? 0), 0);
    const out = all.reduce((s, r) => s + (r.u?.output ?? 0), 0);
    const cached = all.reduce((s, r) => s + (r.u?.cache_read ?? 0), 0);
    const longest = all.reduce((m, r) => (r.uptime ?? 0) > (m?.uptime ?? -1) ? r : m, null);
    const providers = ["all", ...new Set(all.map((r) => r.provider))];

    return v_flex().id("agents-dashboard").size_full().bg(t.background).text_color(t.foreground)
      .child(h_flex().h(52).flex_none().px(20).items_center().justify_between().border_b(1).border_color(t.border)
        .child(h_flex().gap(10).items_center()
          .child(div().text_size(16).font_semibold().child("Agents"))
          .child(div().text_size(12).text_color(t.dim).child(`${list.length} of ${all.length} shown`)))
        .child(h_flex().gap(8)
          .child(this.chip(t, "refresh", "Refresh tokens", false, () => this.refresh(cx)))
          .when(!!props()?.overlay, (e) => e.child(this.chip(t, "close", "Close", false, () => closeOverlay(props().overlay))))))
      .child(v_flex().flex_1().min_h(0).p(20).gap(16).overflow_y_scrollbar()
        // Tiles
        .child(h_flex().gap(12).flex_wrap()
          .child(this.tile(t, "Agents", all.length, `${count("idle")} idle · ${count("done")} done`))
          .child(this.tile(t, "Working", count("working"), longest ? `longest: ${longest.name}` : "", t.working))
          .child(this.tile(t, "Needs you", count("blocked"), count("blocked") ? "waiting on an answer" : "nothing waiting", count("blocked") ? t.blocked : null))
          .child(this.tile(t, "Sub-agents", subs, `${subsWorking} working now`))
          .child(this.tile(t, "Tokens", fmtTokens(tokens), `${fmtTokens(out)} out · ${fmtTokens(cached)} cache reads`))
          .child(this.tile(t, "Longest running", fmtDur(longest?.uptime), longest?.name ?? "")))
        .child(this.providersTile(t, all))
        // Filters
        .child(h_flex().gap(8).items_center().flex_wrap()
          .child(h_flex().h(30).w(320).px(10).items_center().rounded(8).bg(t.surface).border(1).border_color(t.input)
            .child(Input.new(this.input).flex_1().text_size(13).text_color(t.foreground)))
          .children(STATUSES.map((s) => this.chip(t, `st-${s}`, s === "all" ? "All" : `${s} ${count(s)}`,
            this.status === s, () => { this.status = s; }, s === "all" ? null : t[s])))
          .child(div().w(1).h(20).bg(t.border))
          .children(providers.map((p) => this.chip(t, `pv-${p}`, p === "all" ? "All providers" : p,
            this.provider === p, () => { this.provider = p; }))))
        // Table
        .child(v_flex().rounded(10).border(1).border_color(t.border).bg(t.surface).overflow_hidden()
          .child(this.header(t))
          .children(list.map((r) => this.row(t, r)))
          .when(!list.length, (e) => e.child(div().p(24).text_size(13).text_color(t.dim)
            .child(all.length ? "No agent matches these filters." : "No agents running.")))));
  }
}
