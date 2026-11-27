---
id: unreleased/origin-head-and-own-rebase
classification: migration
---

# The repo knows its default branch, and the glue says whether an agent rebases its own

## Goal

The repo's `origin/HEAD` is set, and the "K · Branches" section of the glue,
`.agents/project.md`, has a `Rebase own branch` line.

## Why

The rule "A branch per task" of `.agents/discipline.md` lets an agent rebase
its own branch onto the main branch and push it with `--force-with-lease`.
A guard that allows the forced push only off the default branch needs
`origin/HEAD` to tell which branch that is. The glue line lets a project
forbid the rebase.

## Applies When

- `git symbolic-ref refs/remotes/origin/HEAD` fails in a repo that has an
  `origin` remote, or
- `.agents/project.md` has a "K · Branches" section with no
  `Rebase own branch` line.

## Do Not Apply When

- The repo has no `origin` remote: the first gap is skipped.
- The repo has no "K · Branches" section: `unreleased/glue-branches` writes
  it, with the line.

## Observable Gaps

1. **`origin/HEAD`.** Signal: `git symbolic-ref refs/remotes/origin/HEAD`
   fails. Run `git remote set-head origin -a`, and tell the human in one
   line. It writes only a local ref.
   Done when: the command above prints a ref.
2. **The rebase line.** Signal: §K has no `Rebase own branch` line. Add
   `- **Rebase own branch:** allowed (pushed with --force-with-lease)` at
   the end of the section. Write `forbidden` when the human says so.
   Done when: the line exists and says `allowed` or `forbidden`.

## Out of Scope

- The glue's other sections.
- Rebasing or pushing any branch.

## Reference Paths

- `.agents/project.md` — **adapt**: the line of the reference, with the
  project's answer.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the origin step.

## Validation

- `git symbolic-ref refs/remotes/origin/HEAD` prints a ref, or the repo has
  no `origin`.
- `.agents/project.md` §K has a `Rebase own branch` line.

## Record Result

`chisel record unreleased/origin-head-and-own-rebase --applied`, or
`--skipped "<reason>"` after the human's word.
