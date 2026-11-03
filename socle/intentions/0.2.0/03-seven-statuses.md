---
id: 0.2.0/seven-statuses
classification: migration
---

# Open tasks carry one of seven statuses

## Goal

Every open task, and every open bead when beads is the tracker, carries
one of the seven statuses of `.agents/workflow.md`: `draft`, `ready`,
`in-progress`, `blocked`, `deferred`, `done`, `cancelled`.

## Why

0.1.x had thirteen statuses, most of them waiting states that a formula
moved through. 0.2.0 keeps seven: plan approval is the `**Plan:**` line of
the work document, not a status. A task left on a retired status is one
the workflow does not know how to pick up.

## Applies When

- An open task file, in the tasks directory the task workspace section of
  the glue names, has a status that is not one of the seven; or
- the tracker is beads and `.beads/formulas` exists, or `status.custom`
  declares a retired value.

## Do Not Apply When

- None beyond the human's decision.

## Observable Gaps

1. **The task files.** Signal: an open task whose status line is not one
   of the seven. Show the human the list old → new first, then edit by the
   table below. A task moved from `waiting-plan-approval` keeps its plan
   unapproved: say so on its work document's `**Plan:**` line.
   Done when: every open task carries one of the seven.

   | Old | New |
   |---|---|
   | `creating`, `waiting-business-approval`, `waiting-design-approval` | `draft` |
   | `ready` | `ready` |
   | `planning`, `waiting-plan-approval`, `in-progress`, `waiting-diff-approval` | `in-progress` |
   | `done` | `done` |
   | `blocked`, `stalled` | `blocked` |
   | `deferred` | `deferred` |
   | `cancelled` | `cancelled` |

2. **Beads.** Signal: the tracker section names beads, or `.beads/`
   exists. Re-declare
   `bd config set status.custom "draft:active,done:done,cancelled:done"`,
   move each open bead off a retired value with `bd update <id> --status`
   by the same table, and remove the formulas link with
   `git rm .beads/formulas`.
   Done when: every open bead carries one of the seven, and
   `.beads/formulas` is gone.

## Out of Scope

- The archive, and the content of open task files beyond their status
  line.

## Reference Paths

- `.agents/workflow.md` — **copy**: the seven statuses ("Statuses").
- `.agents/skills/chisel-beads/SKILL.md` — **copy**: the beads adapter.

## Validation

- A search of the open task files for the status line finds only the
  seven values.
- `git diff --stat` on the archive is empty.

## Record Result

`chisel record 0.2.0/seven-statuses --applied`, or
`--skipped "<reason>"` after the human's word.
