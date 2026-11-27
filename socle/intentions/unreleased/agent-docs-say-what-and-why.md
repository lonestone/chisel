---
id: unreleased/agent-docs-say-what-and-why
classification: informational
---

# A doc an agent writes says what and why

## Goal

The human knows that `.agents/discipline.md` now asks that a doc an agent
writes is concise, and that the close step of `.agents/workflow.md` points
to that rule when it promotes material into the living docs.

## Why

Docs written by agents drift toward a long text version of the code, which
goes stale at the next change and hides the few points that matter. What
and why, the overall architecture and the delicate points stay true longer
and are read to the end.

## Applies When

- The repo is updated from a version whose "Docs present and point" rule
  has no paragraph on how an agent's docs are written.

## Do Not Apply When

- Never: there is nothing to apply. `discipline.md` and `workflow.md` are
  managed files and the copy `chisel update` makes carries the change; the
  session only reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: a doc an agent writes is concise, says what and
   why, the overall architecture and the delicate points, welcomes
   diagrams and is never a text version of the code; the close step points
   to that rule.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/discipline.md` — **copy**, by the update.
- `.agents/workflow.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
