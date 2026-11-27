---
id: unreleased/glue-commits
classification: migration
---

# The glue points to where the repo's commit rule is written

## Goal

The glue, `.agents/project.md`, has an "L · Commits" section that points to
the repo's commit rule, and the repo has that rule written where the section
points, by default in `CONTRIBUTING.md`.

## Why

The Mason and Typist briefs of `.agents/workflow.md` say to read the commit
rule where §L · Commits points. Without it, an agent commits with a format
the repo refuses, and a human contributor has nowhere to read the rule. The
rule lives once, in `CONTRIBUTING.md`, where a human looks too; the glue
only points to it.

## Applies When

- `.agents/project.md` has no "L · Commits" heading, or
- no commit rule is written in the repo: no `CONTRIBUTING.md`, or a
  `CONTRIBUTING.md` with no commit rule, and no docs page that holds it.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.
- The commit rule lives in a docs page: §L points there, and no file is
  written.

## Observable Gaps

1. **The section.** Signal: no "L · Commits" heading. Add the section at
   the end of the glue, with a `Commit rule` line that names the file and
   its section where the rule lives. Done when: the section exists and its
   `Commit rule` line names an existing file or page.
2. **The rule.** Signal: no commit rule found anywhere. Read the commit
   linter (a commitlint config, a `commit-msg` hook, a lint script) or,
   without one, `git log` for the shape of recent headers. Write
   `CONTRIBUTING.md` from `.agents/skills/chisel-setup/CONTRIBUTING.md.tpl`
   when the repo has none, or add its Commits section when the file has no
   commit rule, each placeholder filled. Done when: the file holds a
   "Commits" section with no placeholder left.

## Out of Scope

- The glue's other sections.
- Installing or changing a commit linter.
- Any other part of an existing `CONTRIBUTING.md`.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the place of the project's rule.
- `.agents/skills/chisel-setup/CONTRIBUTING.md.tpl` — **adapt**: the
  Commits section, filled for the project.

## Validation

- `.agents/project.md` has a `## L · Commits` section with a `Commit rule`
  line.
- The place that line names holds the commit rule.

## Record Result

`chisel record unreleased/glue-commits --applied`, or
`--skipped "<reason>"` after the human's word.
