---
id: unreleased/actions-carry-a-verb
classification: informational
---

# A name that acts carries a verb

## Goal

The human knows that the writing rule of `.agents/discipline.md` now asks
that a command or a function that acts is named with a verb.

## Why

A name such as `library artists` hides whether it reads or changes
something. `library retag-artists-from-tidal` says what it does before
anyone runs it, and a reader or a reviewer finds a misnamed action at a
glance.

## Applies When

- The repo is updated from a version whose writing rule in
  `.agents/discipline.md` has no sentence on naming actions.

## Do Not Apply When

- Never: there is nothing to apply. `discipline.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: a command or a function that acts is named with
   a verb (`library retag-artists-from-tidal`, not `library artists`).
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.
- Renaming the project's existing commands and functions.

## Reference Paths

- `.agents/discipline.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
