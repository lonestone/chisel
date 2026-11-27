---
id: unreleased/readme-presents-and-points
classification: informational
---

# The README presents the repo and points to the docs

## Goal

The human knows that `.agents/discipline.md` now asks that the README
presents the repo and points to the docs, and that `code-review` flags a
doc that grows beyond a threshold.

## Why

A README that takes each feature's reference grows into the only page
nobody reads to the end. The reference belongs in the living docs, and the
README gets a line and a link. A review that flags the growth of an
existing doc catches the drift while the diff is small.

## Applies When

- The repo is updated from a version whose `.agents/discipline.md` has no
  "Docs present and point" rule.

## Do Not Apply When

- Never: there is nothing to apply. `discipline.md` and the `code-review`
  skill are managed files and the copy `chisel update` makes carries the
  change; the session only reads it to the human. `project.md` gains an
  optional line, `Docs growth flagged above`, in §D · Documentation
  reference; without it `code-review` keeps 10 %, so nothing is written.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: the README presents the repo and links to the
   docs, a feature adds a line and a link there while its reference goes
   in the living docs, and `code-review` flags as a judgement call an
   existing doc that the diff grows by more than 10 %, or by the
   threshold the project sets in §D.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.
- Adding the §D line to a project's `project.md`: the skill falls back to
  10 % without it.

## Reference Paths

- `.agents/discipline.md` — **copy**, by the update.
- `.agents/skills/code-review/SKILL.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
