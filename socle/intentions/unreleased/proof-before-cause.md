---
id: unreleased/proof-before-cause
classification: informational
---

# Proof before cause

## Goal

The human knows that `.agents/discipline.md` now asks an agent to cite its
proof before it gives a cause or asks them to act, and that the rules after
"Read before acting" moved down one number.

## Why

Sessions lost time on a cause stated as fact that nobody had read, then
on the human acting on it. One line of proof, or "not verified", costs
little and stops the chain early.

## Applies When

- The repo is updated from a version whose `.agents/discipline.md` has no
  "Proof before cause" rule.

## Do Not Apply When

- Never: there is nothing to apply. `discipline.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: before an agent gives a cause or asks them to
   act, it cites in one line the proof it read, or writes "not verified";
   the rules after the first are renumbered, and the `retro` skill cites
   the memory rule by its title. A project text that cites a discipline
   rule by number reconciles it itself.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/discipline.md` — **copy**, by the update.
- `.agents/skills/retro/SKILL.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
