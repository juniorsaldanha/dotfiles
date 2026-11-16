---
name: herdr-tasks
description: >-
  Keep the Herdr space's task list in sync while you work. Use whenever you
  run inside Herdr (HC_TERMINAL_ID is set) and start, finish or drop a piece
  of work: move tasks to-do → doing → done with the `herdr-tasks` CLI so the
  Tasks panel shows who is on what, the branch, the time spent and the PR.
---

# Herdr tasks

Every Herdr space has a task list (to-do, doing, done), shown in the app's
Tasks panel. You keep it true. Only applies when `HC_TERMINAL_ID` is set.

## Rules

1. **Before starting work**, run `herdr-tasks ls`. If the work matches a
   to-do, use its id; otherwise `herdr-tasks add "<short title>"` (prints the id).
2. **Start it**: `herdr-tasks start <id>`. This attaches the task to you
   (your terminal), starts its clock and records the current git branch.
   Switch to the work branch *before* starting, so the right branch is recorded.
   Only one task in "doing" per agent: finish or stop the previous one first.
3. **Finish it**: `herdr-tasks done <id>` once the work is complete (and
   pushed, if it has a PR). The PR is found with `gh` from the branch; pass
   `--pr <url>` when you opened one yourself.
4. **Stopped without finishing** (blocked, handed back, abandoned):
   `herdr-tasks todo <id>`. This stops the clock and detaches you.
5. A PR opened later: `herdr-tasks pr <id> <url>`.

Ids may be shortened to a unique prefix. `herdr-tasks --help` lists all commands.
Don't edit `~/.config/herdr-app/tasks/*.json` by hand; use the CLI.
