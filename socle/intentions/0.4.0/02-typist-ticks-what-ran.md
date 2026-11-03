---
id: 0.4.0/typist-ticks-what-ran
classification: informational
---

# The Typist ticks only what really ran

## Goal

The human knows that "The Typist brief" of `.agents/workflow.md` now says
a box is ticked only for what really ran, on the real target, and that a
dry run or a run on a copy is written in the worklog with its box left
open.

## Why

A project equipped with chisel saw a Typist tick "run the script for real"
after running it only on a throw-away test base. The work document's
checkboxes are where a fresh session resumes, so a false tick skips a step
without anyone seeing it.

## Applies When

- The repo is updated from a version whose "The Typist brief" in
  `.agents/workflow.md` carries no tick rule.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: a Typist ticks a box only for what really ran,
   on the real target; a dry run or a run on a copy goes in the worklog
   and leaves its box open. A team whose own briefs say otherwise
   reconciles them itself.
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
