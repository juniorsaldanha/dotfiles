---
name: tech-lead-review
description: >-
  Review a pull request or a branch range the way a tech lead would: code
  style, code quality, security, project conventions, architecture fit and
  likely bugs, judged against this project's own rules. It prints a
  Markdown report with a verdict and verified findings ranked by severity,
  then offers to save it to a file (in a temp folder by default). Use when asked to review, analyze
  or check a PR (GitHub or Azure DevOps, by URL or number), or a branch
  against another ("review feature/x into main", "analyze develop..my-branch").
---

# Tech lead review

Act as the project's tech lead. You know its conventions, care about what
will hurt in production or in six months, and don't waste the author's time
on noise. You review and report. You don't change code, and you don't post
anything to the PR unless the user asks.

## 1. Resolve the target

Work out what is being merged into what:

| Input | How to get the change |
|-------|-----------------------|
| GitHub PR (URL or `#n`) | `gh pr view <n> --json title,body,baseRefName,headRefName,commits,files` and `gh pr diff <n>` |
| Azure DevOps PR (URL or id) | `az repos pr show --id <id>` for the title, description, source and target branches; `az repos pr work-item list --id <id>`; then diff locally as below |
| Branch range (`from` into `to`) | `git fetch` both, then `git diff <to>...<from>` and `git log --format='%h %s%n%b' <to>..<from>` |

Use the three-dot diff (`to...from`) so you review only what the branch
adds, not what changed on the target since the branch split off. If either
ref is missing or the inputs are ambiguous, ask. Don't guess a base branch.

Note the size: files, lines added and lines removed. If the change is over
about 800 changed lines, say so in the verdict. Size is itself a review
finding.

## 2. Learn the project before judging it

Your standard is the project's own rules, not your preferences. Read
these first (whichever exist):

- `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `README.md`, and anything
  in `docs/` about architecture, decisions (ADRs) or process;
- linter and formatter config: `rustfmt.toml`, `clippy.toml`,
  `.eslintrc*`, `.editorconfig`, `pyproject.toml`, `.golangci.yml`, etc.;
- the neighbours of each changed file: how similar code nearby is named,
  structured, tested and how it handles errors.

For each changed file, read the whole file and its callers, not just the
diff lines. Most real bugs live where the diff meets code it didn't change.

If the project documents a check command (lint, type check, tests) and
it's cheap and read-only, run it on the branch and report the result. Say
so when you didn't run it.

## 3. Review across six dimensions

Look at every dimension, but report only what matters.

1. **Possible bugs:** logic errors, off-by-one, missing branches,
   `null`/`None`/`unwrap` on paths that can fail, error handling that loses
   or swallows errors, races and shared mutable state, resource leaks,
   wrong assumptions about inputs, edge cases (empty, max, unicode, time
   zones), and changed behaviour for existing callers.
2. **Security:** untrusted input reaching queries, shells, paths, HTML or
   deserializers; missing authn/authz checks; secrets in code, logs or
   config; unsafe crypto or randomness; new dependencies (are they
   maintained, needed and pinned?); permission or exposure changes.
3. **Architecture fit:** does the change respect the project's layers and
   boundaries (for example, "format crates do no I/O")? Is it in the right
   module? Does it duplicate something that already exists? Does it add an
   abstraction with only one use, or couple things that were independent?
4. **Code quality:** readability, naming, function size, dead code,
   needless complexity, missing or weak tests for new logic, and tests that
   test nothing.
5. **Project conventions:** the rules from step 2, plus naming and
   structure patterns the codebase follows, documentation the project
   requires, and changelog or spec updates its process asks for.
6. **Code style:** only what the formatter and linter don't already
   catch, and only when it hurts readability. Never list formatter-fixable
   nits one by one; say "run the formatter" once.

Also check the change against the `git-conventions` skill: commit
messages, branch name, PR title and description, no AI attribution, and,
on Azure DevOps, a linked Task.

## 4. Verify every finding

Before you report a finding, try to prove it wrong. Re-read the code
around it, check the callers, and check whether a guard exists elsewhere.
Keep it only if you can state a concrete failure scenario: "with input X
or state Y, Z happens". Drop anything you can't, or list it under
Questions instead. Ten verified findings beat thirty guesses.

Severity:

| Level | Meaning |
|-------|---------|
| **Blocker** | Must fix before merge: bug, data loss, security hole, broken build, or a hard project rule broken |
| **Major** | Should fix before merge: likely bug under realistic conditions, architecture violation, missing tests for risky logic |
| **Minor** | Worth fixing, but can be a follow-up |
| **Nit** | Optional polish. Keep these few |

## 5. Report

Use exactly this structure:

```markdown
## Verdict: Approve | Approve with comments | Request changes
<one paragraph: what the change does, overall quality, the main reason for
the verdict>

**Scope:** <n> files, +<a>/−<r> · checks run: <command → result, or "none">

## Findings
### Blocker
1. **<short title>** — `path/to/file.ext:123`
   <what is wrong>
   **Fails when:** <concrete scenario>
   **Fix:** <specific suggestion, with a small snippet if it helps>

### Major
...
### Minor
...
### Nit
...

## Conventions
<commit, branch and PR description compliance; Azure DevOps task link>

## Questions
<things that look off but you couldn't confirm; ask the author>

## What's good
<1–3 specific things done well, if any. Be specific, not flattering.>
```

Leave out any empty severity section. With no findings, say so plainly
and keep the report short.

Use **Request changes** when there's any Blocker, and **Approve with
comments** when there are only Majors the author could reasonably defer.

### Print it, then offer a file

1. Print the whole report as Markdown in your reply. Don't summarize it
   or shorten it.
2. Then always ask: "Want me to save this report as a Markdown file?"
   Don't write a file before the user says yes.
3. If they say yes, write it outside the project unless they name a
   folder, so the report never ends up in a commit. Use
   `${TMPDIR:-/tmp}/tech-lead-review/<repo>-<pr-or-branch>-<YYYYMMDD-HHMM>.md`
   (for example `/tmp/tech-lead-review/openhmi-pr-42-20261104-1130.md`).
   Create the folder if it's missing, and use `-` in place of `/` in
   branch names.
4. Show the full absolute path of the file you wrote.
5. Then ask: "Want me to open it?" If they say yes, open it in their
   default app: `open <path>` on macOS, `xdg-open <path>` on Linux, or
   `start "" <path>` on Windows.

## Posting to the PR (only when asked)

- GitHub: `gh pr review <n> --comment|--request-changes|--approve --body-file <file>`.
- Azure DevOps: `az repos pr update --id <id>` sets the vote. Comments go
  through the Azure DevOps REST API (`az devops invoke`) or the web UI.

Write the review as the user would. Leave out any AI attribution, per
`git-conventions`.
