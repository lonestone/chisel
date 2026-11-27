---
id: unreleased/retro-is-written-down
classification: informational
---

# The retro is written down

## Goal

The human knows that the `retro` skill now writes its proposals to a retro
document beside the spec, and that the archive moves it with the other
documents of the task.

## Why

A retrospective said only in a close report is gone with the session, and
the rule "The repo is the only memory" of `.agents/discipline.md` says
where conclusions live. The old `## Retrospective` section of the spec
template was written by hand and rarely filled. A proposal that targets the
installed socle also needs the right owner: `update` overwrites a local
edit there, so the fix belongs to chisel's maintainers.

## Applies When

- The repo is updated from a version whose `retro` skill puts its proposals
  in the close report only.

## Do Not Apply When

- Never: there is nothing to apply. The skill, `workflow.md` and
  `reference.md` are managed files and the copy
  `chisel update` makes carries the change; the session only reads it to
  the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: the close step now writes a retro document
   (`<time-id>-<intention>.retro.md`) beside the spec, the archive moves
   spec, work, synthesis and retro together, and the spec template no
   longer has a Retrospective section. Retrospective sections already
   archived stay as they are.    Done when: the human has read it.

## Out of Scope

- The `## Retrospective` sections of archived specs.

## Reference Paths

- `.agents/skills/retro/SKILL.md` — **copy**, by the update.
- `.agents/workflow.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
