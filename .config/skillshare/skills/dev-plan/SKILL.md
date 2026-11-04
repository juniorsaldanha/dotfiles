---
name: dev-plan
description: >-
  Kick off a piece of development work in three gated steps: classify it
  (feature, fix, refactor, improvement, perf, docs, test, chore), specify
  it (problem, scope, acceptance criteria, plan grounded in the codebase),
  then trigger the execution of the plan on a properly named branch. Use
  when asked to start, plan, kick off or scope a task ("let's build X",
  "plan a fix for Y", "start a refactor of Z", "/dev-plan").
---

# Dev plan

Turn a request into an approved spec and plan, then execute it. Three
steps, each ending in a gate: don't move on until the user confirms. If
the user says "go" or "skip the questions", collapse the gates, but still
show the spec before writing code.

## 1. Define: what kind of work is it?

Classify the request into exactly one type. The type drives the branch
prefix, the commit type and what the spec must contain.

| Type | Means | Commit type | Branch prefix |
|------|-------|-------------|---------------|
| **feature** | new behaviour for the user | `feat` | `feature/` |
| **fix** | something works wrong; make it work right | `fix` | `bugfix/` (`hotfix/` if urgent in production) |
| **refactor** | change structure, keep behaviour identical | `refactor` | `chore/` |
| **improvement** | make existing behaviour better (UX, DX, clarity), no new capability | `feat` or `refactor` | `feature/` |
| **perf** | make it faster or cheaper, same behaviour | `perf` | `chore/` |
| **docs** | documentation only | `docs` | `chore/` |
| **test** | add or fix tests only | `test` | `chore/` |
| **chore** | build, CI, dependencies, tooling | `build`/`ci`/`chore` | `chore/` |

If the repo already uses other prefixes or types (check `git branch -a`
and `git log`), follow the repo. Branch and commit rules come from the
`git-conventions` skill.

If the request mixes types ("add X and clean up Y"), say so and propose
splitting it into separate plans. One plan, one type.

State the type and a one-line summary, and ask the user to confirm:

> **Type:** fix · **Summary:** login fails when the email has uppercase letters. Right?

## 2. Specify: what exactly, and how?

### Learn the context first

Before asking anything, read what you can find yourself:

- `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `README.md`, `docs/`;
- the code the change touches, its callers and its tests;
- for a **fix**: reproduce it or find the root cause in the code. Don't
  spec a fix for a symptom.

Then ask only what the code can't tell you, a few questions at a time,
with a recommended answer for each. Stop asking once the spec below can
be filled in without guessing.

### Write the spec

Use this structure. Leave out sections marked with the types they don't
apply to.

```markdown
# <type>: <title>

## Problem
<what is wrong or missing today, and who it affects>

## Goal
<the outcome in one or two sentences>

## Scope
**In:** <what this work changes>
**Out:** <what it explicitly does not change>

## Current behaviour            <!-- fix only -->
<steps to reproduce, actual vs expected, root cause with file:line>

## Invariants                   <!-- refactor and perf -->
<behaviour that must stay identical; how you'll prove it (existing tests,
new characterization tests, benchmark before/after with numbers)>

## Acceptance criteria
- [ ] <observable, testable statement>
- [ ] <...>

## Plan
1. <small step> — `path/to/file.ext` — verify: <test or command>
2. <...>

## Risks and open questions
<what could go wrong, migration or rollback needs, anything unresolved>

## Branch
`<prefix>/<short-description>`
```

Plan rules:

- Each step is small enough to verify on its own, and says how.
- For **feature** and **fix**, write the failing test first (for a fix,
  the test that reproduces the bug).
- For **refactor**, make sure tests cover the behaviour before moving
  code; add them as step 1 if they don't.
- Reuse what the codebase already has. Name the existing helper, module
  or pattern each step builds on.
- No steps "for later". If it's not needed for the acceptance criteria,
  it's out of scope.

### Save it and get approval

Print the full spec in your reply. Then save it:

- if the project keeps plans somewhere (`docs/plans/`, `specs/`, an ADR
  folder), save it there;
- otherwise save it outside the repo, at
  `${TMPDIR:-/tmp}/dev-plan/<repo>-<branch-with-dashes>-<YYYYMMDD-HHMM>.md`,
  so it never lands in a commit by accident.

Show the absolute path, then ask:

> Spec saved at `<path>`. Approve it and start execution?

Edit and re-show the spec until the user approves it.

## 3. Execute: trigger the plan

Only after approval:

1. **Check the working tree.** If it has uncommitted changes, ask whether
   to stash, commit or carry them before going on.
2. **Create the branch** from the up-to-date default branch (or the base
   the user names), using the name from the spec.
3. **Work the plan in order.** Track the steps with your harness's
   todo/task tool if it has one. For each step: make the change, run its
   verify command, and don't start the next step while this one fails.
   If your harness offers a plan-execution or subagent workflow and the
   plan has independent steps, you may use it.
4. **Commit as you go**, one commit per coherent step, following
   `git-conventions` with the commit type from step 1.
5. **Stop and ask** when reality disagrees with the spec: a step turns
   out wrong, the scope grows, or an acceptance criterion can't be met.
   Update the spec file with what changed rather than drifting silently.
6. **Finish** by checking every acceptance criterion and running the
   project's full check (lint, type check, tests). Report:

```markdown
## Done: <type>: <title>
**Branch:** `<branch>` · **Commits:** <n> · **Checks:** <command → result>

### Acceptance criteria
- [x] <criterion> — <how it was verified>
- [ ] <criterion> — <why not met>

### Deviations from the spec
<what changed and why, or "none">
```

Don't push or open a PR unless the user asks. When they do, follow
`git-conventions` for the PR, and offer the `tech-lead-review` skill on
the branch first.
