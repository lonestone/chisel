---
id: unreleased/typist-by-default
classification: informational
---

# The Crewmate hands the typing to a Typist

## Goal

The human knows that `.agents/workflow.md` now has the Crewmate launch a
Typist once the plan is approved, at the *mid* tier, or *cheap* when the
plan is mechanical, and type itself only a retouch of a few lines or while
the plan is not settled.

## Why

The workflow said "By default the Crewmate types itself", so nothing sent
the typing to a cheaper model: on 2026-11-03 one of chisel's own tasks ran
383 calls, all at the frontier tier, none of them a Typist's. An approved
plan is a complete brief, and typing it needs no frontier judgement. The
frontier tier stays with the Architect, the Crewmate's plan and the
reviewers.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` says the
  Crewmate types itself by default.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md`, `methodology.md` and
  `reference.md` are managed files and the copy `chisel update` makes
  carries the change; the session only reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it in two
   sentences: once the plan is approved, the Crewmate launches a Typist at
   the *mid* tier, or *cheap* when the plan is mechanical; the cascade of
   `.agents/reference.md`, "Model tiers", resolves the model, so a team
   that wants other models names them in `.agents/project.md`, section H,
   or a dev in `.agents/user.md`. A team whose own instructions say the
   Crewmate types itself reconciles them.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/methodology.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
