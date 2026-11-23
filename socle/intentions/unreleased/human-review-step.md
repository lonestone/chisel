---
id: unreleased/human-review-step
classification: informational
---

# The workflow gains a human review of the pull request

## Goal

The human knows that `.agents/workflow.md` now has a step 8, the human
review, that the close writes a synthesis from a new template, and that the
review runs in crit.

## Why

A pull request was reviewed from its raw diff, whatever its size. The
workflow now asks the Mason for a one-page synthesis at the close, and the
Architect opens the review on it: the human reads the synthesis, then the
proofs, then the reading guide, and may stop after the first. Without
knowing it, a team keeps reviewing diffs the old way, and does not know
crit must be installed on the machine that runs the review.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` has no
  step 8, "Human review".

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` and the synthesis
  template are managed files and the copy `chisel update` makes carries the
  change; the session only reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences: the close writes a synthesis from
   `.agents/synthesis.md.tpl`, on the frontier tier; step 8 has the human
   read it first, then the proofs, then the reading guide; a spec may carry
   a `**Review depth:**` line, `full` or `strategic`, as the spec template
   now shows; and `crit` (https://crit.md) must be installed on the machine
   that runs the review. A team whose own steps say otherwise reconciles
   them itself.
   Done when: the human has read it.

## Out of Scope

- The review section of `.agents/project.md`: its own intention,
  `unreleased/review-section`, adds it.
- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/synthesis.md.tpl` — **copy**, by the update.
- `project-management/000-template.spec.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
