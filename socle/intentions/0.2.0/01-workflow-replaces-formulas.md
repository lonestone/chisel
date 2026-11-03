---
id: 0.2.0/workflow-replaces-formulas
classification: migration
---

# One prose workflow replaces the formulas and the profiles

## Goal

The repo carries no formula, preset, role profile or rendered agent
definition, and its own words name the current roles: the Architect, the
Crewmate, the Typist and the reviewers of `code-review`.

## Why

0.1.x shipped formulas with five presets (`.agents/formulas`), role
profiles (`.agents/profiles`: Foreman, Architect, Checker, Mason,
Inspector), and agent definitions rendered from them into `.claude/agents/`
and `.codex/agents/`. 0.2.0 replaced them with one prose workflow,
`.agents/workflow.md`, and four roles. `chisel update` removes the retired
files it installed and nobody edited; a file someone edited, a profile the
project wrote itself, and the project's own text naming the retired pieces
are left for an agent and the human. A repo that keeps them has two
methods, and its agents follow whichever they read first.

## Applies When

- A file exists in `.agents/formulas`, `.agents/profiles`,
  `.claude/agents/` or `.codex/agents/`; or
- a line outside the chisel markers of `AGENTS.md`, or in the README, CI
  or the glue, names the Foreman, a formula or preset, a profile, the
  Checker, the Mason or the Inspector.

## Do Not Apply When

- The human has decided, after reading this intention, to keep the 0.1.x
  method.

## Observable Gaps

1. **The retired files.** Signal: a file in one of the four directories.
   For each, compare its sha256 with its entry in the manifest's `managed`
   map. Same hash: the closing `chisel update` removes it, nothing to do.
   Another hash, or no entry: show it to the human and ask whether its
   content moves into a project instruction (`AGENTS.md`, outside the
   markers) or goes. A definition the user wrote in `.claude/agents/` for
   another purpose stays.
   Done when: the human has ruled on every file the closing update would
   not remove, and the ruling is applied.

2. **The project's own words.** Signal: a line outside the managed files
   that names a retired piece. List each with its replacement: the Foreman
   → the Architect; a formula or preset → `.agents/workflow.md`; the Mason
   → the Crewmate or the Typist; the Checker and the Inspector → the
   reviewers of `code-review`. Fixing them is the human's decision, line by
   line.
   Done when: the human has ruled on every line.

## Out of Scope

- The archive: an archived task keeps its bytes, retired names included.
- A skill chisel does not ship.
- Source code and git history.

## Reference Paths

- `.agents/workflow.md` — **copy**: the roles and the steps.
- `AGENTS.md` — **adapt**: the block between the markers is chisel's, the
  rest is the project's.

## Validation

- The closing `chisel update` prints no `orphaned:` line under the four
  directories.
- A search of the repo's own text, archive excluded, for the retired names
  finds only what the human chose to keep.

## Record Result

`chisel record 0.2.0/workflow-replaces-formulas --applied`, or
`--skipped "<reason>"` after the human's word.
