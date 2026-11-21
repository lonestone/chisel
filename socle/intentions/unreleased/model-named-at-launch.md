---
id: unreleased/model-named-at-launch
classification: informational
---

# The launcher names the model of a sub-agent

## Goal

The human knows that `.agents/workflow.md` and `.agents/reference.md` now
say that whoever launches a Mason or a Typist resolves its tier to a
concrete model and names it explicitly at launch.

## Why

A sub-agent launched without a model inherits its launcher's. A project
equipped with chisel saw its Typist run on the same model as its
Architect although the socle default for the Typist is *mid*: the tier was
lost at launch.

## Applies When

- The repo is updated from a version whose "The Mason brief" and "The
  Typist brief" in `.agents/workflow.md`, and "Model tiers" in
  `.agents/reference.md`, do not say to name the model at launch.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` and `reference.md` are
  managed files and the copy `chisel update` makes carries the change; the
  session only reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: the launcher of a Mason or a Typist resolves the
   tier to a model and names it at launch, because an unnamed model is the
   launcher's own. A team that has not filled §H of `.agents/project.md`
   gets the socle default; filling it is the team's choice.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`, and §H of `.agents/project.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
