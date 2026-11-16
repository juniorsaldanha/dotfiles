#!/usr/bin/env python3
"""Token usage per agent, read from the agents' own session logs.

argv: <address>:<kind>:<pid> ...   kind: claude | codex
stdout: {"<address>": {"model", "input", "output", "cache_read", "cache_write", "total"}}
"""
import glob, json, os, subprocess, sys

HOME = os.path.expanduser("~")


def kids(pid):
    try:
        out = subprocess.run(["pgrep", "-P", pid], capture_output=True, text=True).stdout.split()
    except Exception:
        return []
    return out + [k for c in out for k in kids(c)]


def claude_logs(pid):
    # Every Claude config dir: ~/.claude, and ~/.claude-work etc. (CLAUDE_CONFIG_DIR accounts).
    for p in [pid] + kids(pid):
        for conf in glob.glob(f"{HOME}/.claude*/"):
            try:
                sid = json.load(open(f"{conf}sessions/{p}.json"))["sessionId"]
            except Exception:
                continue
            main = glob.glob(f"{conf}projects/*/{sid}.jsonl")
            if main:
                # Newer Claude Code keeps its Task subagents' logs beside the session.
                account = os.path.basename(conf.rstrip("/"))[len(".claude"):].lstrip("-") or None
                return main + glob.glob(main[0][:-6] + "/subagents/*.jsonl"), account
    return [], None


def claude_usage(pid):
    # ponytail: re-reads whole logs each poll; keep per-file offsets if logs grow past tens of MB.
    seen, u, model = set(), dict(input=0, output=0, cache_read=0, cache_write=0), None
    logs, account = claude_logs(pid)
    for f in logs:
        with open(f, errors="replace") as fh:
            for line in fh:
                if '"usage"' not in line:
                    continue
                try:
                    m = json.loads(line).get("message") or {}
                except ValueError:
                    continue
                us, mid = m.get("usage"), m.get("id")
                if not us or mid in seen:  # one API message is logged once per content block
                    continue
                seen.add(mid)
                model = m.get("model") or model
                u["input"] += us.get("input_tokens", 0)
                u["output"] += us.get("output_tokens", 0)
                u["cache_read"] += us.get("cache_read_input_tokens", 0)
                u["cache_write"] += us.get("cache_creation_input_tokens", 0)
    return u, model, account


def codex_usage(pid):
    path = None
    for p in [pid] + kids(pid):
        out = subprocess.run(["lsof", "-p", p, "-Fn"], capture_output=True, text=True).stdout
        hits = [l[1:] for l in out.splitlines() if l.startswith("n") and "/rollout-" in l and l.endswith(".jsonl")]
        if hits:
            path = hits[0]
            break
    u, model = dict(input=0, output=0, cache_read=0, cache_write=0), None
    if not path:
        return u, model, None
    with open(path, errors="replace") as fh:
        for line in fh:
            if '"token_count"' not in line and '"turn_context"' not in line:
                continue
            try:
                d = json.loads(line).get("payload") or {}
            except ValueError:
                continue
            model = d.get("model") or model
            tot = (d.get("info") or {}).get("total_token_usage")
            if tot:  # running totals: the last one wins
                cached = tot.get("cached_input_tokens", 0)
                u = dict(input=tot.get("input_tokens", 0) - cached, output=tot.get("output_tokens", 0),
                         cache_read=cached, cache_write=0)
    return u, model, None


def main():
    res = {}
    for arg in sys.argv[1:]:
        addr, kind, pid = arg.rsplit(":", 2)
        try:
            u, model, account = (claude_usage if kind == "claude" else codex_usage)(pid)
        except Exception:
            continue
        res[addr] = dict(u, model=model, account=account, total=sum(u.values()))
    json.dump(res, sys.stdout)


if __name__ == "__main__":
    main()
