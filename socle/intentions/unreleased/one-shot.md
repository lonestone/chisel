---
id: unreleased/one-shot
classification: informational
---

# A task can run in one shot

## Goal

The human knows that a task can run in one shot, with the final review as
its only possible human stop, and that the word "one-shot" of the old
glossary is now "quick fix".

## Why

Small tasks went through every human stop of the workflow, the spec
reading first. The one shot lets the Architect take a small task, or one
the human asks for, from the spec to the pull request with no stop but
the final review, and that one only when the spec keeps it. The code
review, the gates and the pull request still run. A team that does not
know it keeps reading specs it did not need to read, and reads "one-shot"
in the old sense where the workflow now means the lane.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` has no
  section "The one shot".

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md`, `reference.md`,
  `discipline.md` and `methodology.md` are managed files and the copy
  `chisel update` makes carries the change; the session only reads it to
  the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences: the Architect takes the one shot when it
   writes the spec, if it judges the task small or the human asks, and
   writes a `**One shot:**` line in the spec, with its reason and whether
   the final review is kept or skipped; the pull request repeats it; a
   human who asks for the full lane always gets it, and no project setting
   switches it on. With the final review, approving it is the word for the
   merge, and the Architect says so when it hands the review; without it,
   the merge goes as the glue's merge and publish section says. The spec
   interview now switches from `grilling` to `wayfinder` when it tangles.
   Work done without a task artifact is now called a quick fix.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`, which may still say "one-shot" in the old sense: a project
  that does reconciles itself.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.
- `.agents/discipline.md` — **copy**, by the update.
- `.agents/methodology.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
