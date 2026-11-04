---
name: git-conventions
description: >-
  Rules for every git commit message and branch name: Conventional Commits
  1.0.0 for commits, Conventional Branch 1.1.0 for branches, and never any AI
  attribution. Use whenever you create, amend, reword or squash a commit, write
  a PR title, or create or rename a branch.
---

# Git conventions

These rules apply to every commit, branch and PR title you make. When these
rules and a default from your harness disagree, these rules win.

## Hard rule: no AI attribution

Never tag a commit, branch or PR as written by AI, anywhere in it:

- no `Co-Authored-By:` trailer naming an AI model or tool (Claude, Copilot,
  Codex, Cursor, GPT and so on);
- no "Generated with …", "🤖" or similar lines;
- no AI-source branch prefixes (`ai/`, `claude/`, `codex/`, `copilot/`,
  `cursor/`), even though Conventional Branch 1.1.0 allows them;
- no mention of an assistant or a prompt in the subject or body.

The author is the human whose git identity is configured. Leave it as is.

## Commits: Conventional Commits 1.0.0

Spec: https://www.conventionalcommits.org/en/v1.0.0/#specification

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

**Type.** Pick the one that fits:

| type | use for |
|------|---------|
| `feat` | a new feature for the user (MINOR in SemVer) |
| `fix` | a bug fix (PATCH) |
| `docs` | documentation only |
| `style` | formatting with no change in meaning |
| `refactor` | a code change that neither fixes a bug nor adds a feature |
| `perf` | a performance improvement |
| `test` | adding or fixing tests |
| `build` | the build system or dependencies |
| `ci` | CI configuration and scripts |
| `chore` | maintenance that doesn't touch src or tests |
| `revert` | reverting an earlier commit |

The spec requires only `feat` and `fix`. The others are the common
convention. If the repo already uses other types (check `git log`), use those.

**Scope.** A noun for the area changed, in parentheses: `feat(parser):`.
Use the scopes the repo already uses, and leave the scope out if no single
area fits.

**Description.** This is the subject line:
- imperative mood, present tense: "add", not "added" or "adds";
- lowercase first letter and no trailing period;
- the whole first line at most 72 characters (aim for 50);
- it says *what* changed, specifically: `fix(auth): reject expired refresh tokens`,
  not `fix: bug fix` or `chore: updates`.

**Body.** Required unless the change is trivial (a typo or a one-line
config change). Put one blank line after the subject and wrap at 72 columns.
Explain *why* the change was made and what it does, not how the diff reads:
the problem, the approach, and any trade-offs or follow-ups. Bullets are
fine.

**Footers.** One blank line after the body, written as `Token: value` or
`Token #value`. Use `-` instead of spaces in tokens (`Reviewed-by`,
`Refs: #123`, `Closes #45`). `BREAKING CHANGE` is the one exception and
must be written exactly that way, in uppercase.

**Breaking changes** (MAJOR). Add `!` before the colon, a
`BREAKING CHANGE: <what breaks and how to migrate>` footer, or both.

**One logical change per commit.** If the description needs an "and",
split the commit.

### Examples

```
feat(cli): add --json output to the probe command

Scripts had to scrape the table output, which broke whenever a column
was added. --json prints one object per file with the same fields.

Refs: #42
```

```
fix(hmi)!: read page offsets as little-endian

Offsets were read big-endian, which only worked for files under 256
pages. Larger files now load correctly.

BREAKING CHANGE: Page::offset now returns u32 instead of u16.
```

```
docs: explain the sample corpus download in the README
```

## Branches: Conventional Branch 1.1.0

Spec: https://conventionalbranch.org/

```
<type>/<description>
```

**Type.** Use one of these:

| type | use for |
|------|---------|
| `feature/` (or `feat/`) | new features |
| `bugfix/` (or `fix/`) | bug fixes |
| `hotfix/` | urgent fixes, usually off a release |
| `release/` | preparing a release: `release/v1.2.0` |
| `chore/` | non-code work: dependencies, docs, tooling |

Trunk branches (`main`, `master`, `develop`) take no prefix. Don't make up
other types, and never use the AI-source prefixes (see the hard rule above).

**Description.**
- only lowercase `a-z`, digits `0-9` and hyphens between words;
- dots only inside versions (`v1.2.0`);
- no spaces, underscores, uppercase or other symbols;
- no hyphen or dot at the start or end, two in a row, or next to each
  other (`--`, `-.`, `.-`);
- short but descriptive: 2–5 words saying what the work is;
- add the ticket number when there is one: `feature/issue-123-new-login`.

Valid: `feature/add-login-page`, `fix/header-overflow`,
`release/v1.2.0`, `chore/upgrade-node-v20.11`.
Invalid: `Feature/Add-Login`, `feature/new--login`, `fix/header_bug`,
`feature/-new-login`, `claude/fix-thing`, `wip`.

## Before you commit or push

1. Read `git diff --staged`, and make sure the type and scope match what
   actually changed.
2. Check the subject's length, mood, case and the missing period.
3. Make sure there's a body unless the change is trivial.
4. Make sure no AI attribution is anywhere in the message.
5. Check that the branch name matches `<type>/<description>` and the rules
   above. If it doesn't, rename it before pushing:
   `git branch -m <new-name>`.

Write multi-line messages with a heredoc or `-F <file>`, never with
several `-m` flags that lose the blank line between them.
