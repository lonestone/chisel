---
id: unreleased/glue-branches
classification: migration
---

# The glue says how a task's branch is cut and where it works

## Goal

The glue, `.agents/project.md`, has a "K · Branches" section that says how
each task's branch is named and based, and whether it works in its own
worktree.

## Why

The rule "A branch per task" of `.agents/discipline.md` reads the glue for
the branch's name, its base and the worktree choice. A glue without the
section leaves the rule without its settings; writing them down lets the
project choose, and lets every agent read the choice in one place.

## Applies When

- `.agents/project.md` has no "K · Branches" heading.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.

## Observable Gaps

1. **The section.** Signal: no "K · Branches" heading. Ask the worktree
   question of the setup skill, and add the section with the answer, at the
   end of the glue, with a `Branch` line and a `Worktree` line. Without an
   answer, write the reference's default: `yes, in .worktrees/<branch>`.
   Done when: the section exists and its `Worktree` line starts with `yes`
   or `no`.

## Out of Scope

- The glue's other sections.
- Creating or removing a worktree.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the project's answer.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the question.

## Validation

- `.agents/project.md` has a `## K · Branches` section with a `Worktree`
  line.

## Record Result

`chisel record unreleased/glue-branches --applied`, or
`--skipped "<reason>"` after the human's word.
