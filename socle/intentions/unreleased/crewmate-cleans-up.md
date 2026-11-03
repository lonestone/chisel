---
id: unreleased/crewmate-cleans-up
classification: informational
---

# The Crewmate stops what it started before it reports

## Goal

The human knows that the close step of `.agents/workflow.md` now has the
Crewmate stop everything it started, and only that, before its report.

## Why

A Crewmate starts Docker containers, dev servers and background processes
to run its tests, and left them running after its report: ports stayed
taken and the machine filled up. Stopping by pattern (`pkill -f`,
`--all`) is worse: it stops the work of other agents and other projects on
the same machine. So each one is stopped by its own identifier, its
container name or id, or its PID.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` close step
  does not say to stop what the Crewmate started.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human, who decides whether their own habits change.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it in one
   sentence: at the close, the Crewmate stops what it started, by
   identifier, never by pattern. A team whose own brief or instructions
   say otherwise reconciles them.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.

## Validation

- The close step of `.agents/workflow.md` says to stop what the Crewmate
  started, by identifier.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
