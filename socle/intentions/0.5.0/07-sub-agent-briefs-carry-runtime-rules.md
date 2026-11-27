---
id: 0.5.0/sub-agent-briefs-carry-runtime-rules
classification: informational
---

# Sub-agent briefs carry the runtime rules

## Goal

The human knows that `.agents/workflow.md` now tells the Architect and the
Mason what every sub-agent brief carries, because a sub-agent receives
nothing but its brief.

## Why

A sub-agent does not inherit the rules of the repo or of the runtime that
launched it. Sessions of projects equipped with chisel lost time or work
to a wait in the foreground that blocked the sub-agent, a chained git
command that erased uncommitted work, test servers and containers left
running, a first report lost before the second, a threshold in a spec read
in the wrong direction, and code copied instead of reused.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` carries
  no such list before "The Mason brief".

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: every sub-agent brief now carries five rules
   (long commands in the background, a git command that erases alone in
   its call, stop what it started, reuse existing code, say what a setting
   means and which way it acts), and the Mason writes its plan report in
   the work document before sending it. A team whose own briefs say
   otherwise reconciles them itself.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
