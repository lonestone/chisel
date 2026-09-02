# Chisel equips itself with the socle it ships

**Status:** 🟠 Blocked — starts once chisel v2 is closed
(`20260826-1512-chisel-v2.spec.md`)

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before any code. Keep it short.

## Context

Chisel builds the socle and does not install it. The repo has no `.agents/`
at all: no skill is reachable from a session working here, no
`discipline.md`, no formula, no profile, no writing rules, no `docs/`. Its
`AGENTS.md` is 810 bytes, claims *"It dogfoods the methodology it ships"*,
then describes the v1 pipeline it has since retired and cites a socle
"imported from the music-downloader pilot at slice 01" that has moved twice
since.

Every repo the Owner names as well-equipped — music-downloader, sun-agenda —
carries what chisel ships: `.agents/skills/` reachable, an `AGENTS.md` that
routes to a documentation index, per-area guidelines. Chisel is the only one
that does not, and it is the one that makes them.

The cost is measured, not suspected. Through the whole v2 task, the agents
working in this repo had the task file and nothing else: no `tdd`, no
`code-review`, no `codebase-design`, no `writing-great-skills`. The drift
recorded in the v2 audit round — an inflated test suite, invented numeric
limits, roles fused into one session — happened in a repo where none of the
rules that forbid those things were readable.

The task template itself points at `doc/agents/methodology.md` and
`doc/agents/workflows.md`. Neither path exists here. Those pointers were
copied from the pilot repo and have never resolved in chisel.

## Scope

**Included:**

- `bin/chisel.sh init` (or `upgrade-v2`) actually run on this repo, producing
  a real `.agents/` from `socle/` — with the loop that decision creates named
  and answered: chisel is both the source and the installation.
- `AGENTS.md` rewritten against v2 reality: the formulas, the profiles, the
  modes, the tracker case in use. It routes; it does not restate.
- The repo's own reading rules and documentation home — the equivalent of
  what music-downloader keeps under `doc/`, sized for a repo of this shape.
- The task template's dead pointers repaired against paths that exist here.
- The tracker case decided for chisel itself: markdown or beads. The v2
  ruling deferred this to after v2; after v2 is now.
- One session run end to end under the installed socle, as the proof.

**Not Included:**

- Any change to `socle/` content. This task installs the socle; it does not
  edit it. A defect found while installing is reported, and fixed by its own
  task.
- The pilot migrations of other repos (they belong to slice 06 of the v2
  task).
- `sync-upstream` on the vendored skills pinned at `2ab9580`.

## Acceptance Criteria

- [ ] `.agents/` exists in this repo and `bin/chisel.sh check` is clean
- [ ] `AGENTS.md` names no retired v1 artifact: `grep -nE "W0|W1|W2|workflows\.md|rules/task-" AGENTS.md` returns nothing
- [ ] Every path cited by `AGENTS.md` and by
      `project-management/000-task-file-template.md` resolves in this repo
- [ ] The skills the socle ships are reachable from a session opened at the
      repo root, by the same mechanism a user's repo gets
- [ ] A task carried out under the installed socle, its file linked here

## Seams

- Seam 1: `bin/chisel.sh check` run at this repo's root — the same command a
  user's repo answers, answering here.
- Seam 2: the installed tree itself — `.agents/` compared against what the
  manifest says `init` produces, with the source/installation loop stated
  rather than hidden.

## Architecture

The one decision that is not mechanical: chisel is the source of the socle
AND its installation target. `.agents/skills/x` would point at
`socle/agents/skills/x` in the same working tree.

**Decided by the Owner, 2026-08-26: a real installed copy.**
`bin/chisel.sh init` is run on this repo exactly as on any user repo;
`.agents/` is a committed copy of what `socle/` ships. This is the only mode
where chisel lives what a user lives — `init`, `update` and `check` are
exercised for real here — and a red `check` becomes a useful signal: the
socle was edited without updating the repo's own installation. The standing
cost (run `update` after every socle edit) is why this task stays blocked
until v2 closes and the socle stops moving. Rejected: symlinks into `socle/`
(check would compare a file to itself and verify nothing; a session editing
an "installed" file would silently edit the shipped source) and a
manifest-recorded exception (fixes the drift but never exercises the
installer).

---

> 🧑 **REVIEW IF RELEVANT** — program design.

## Implementation Decisions

_Empty at creation. Persisted at plan time by the implementing session._

## Testing Strategy

The suite's standing rules (`test/TESTS.md`) apply unchanged. This task
installs into the repo rather than changing installer behavior, so it is
expected to buy no new assertions; whatever it does need is argued against
those rules, not around them.

## Slices & Dependencies

- **Depends on:** `20260826-1512-chisel-v2.spec.md` — the socle must stop moving
  before it is installed.
- **Related:** slice 06 of the v2 task (the pilot migrations of other repos
  answer the same question from the other side).

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Deliverables

- [ ] `.agents/` present, `check` clean
- [ ] `AGENTS.md` rewritten
- [ ] Documentation home + the repo's own reading rules
- [ ] `project-management/000-task-file-template.md` pointers repaired
- [ ] Tracker case decided and recorded
- [ ] Dated `CHANGELOG.md` entry

## Notes & Snippets

**State observed at creation (2026-08-26).** Root of the repo: `bin/`,
`project-management/`, `scripts/`, `socle/`, `test/`, plus `AGENTS.md`,
`CLAUDE.md` (one line, `@AGENTS.md`), `PHILOSOPHY.md`, `README.md`,
`package.json`, `upstream.lock.json`. No `.agents/`, no `.claude/`, no
`docs/`.

What `socle/agents/` ships and this repo does not have: `discipline.md`,
`methodology.md`, `foreman.md`, `project.md.tpl`, `user.md.tpl`, `formulas/`
(3 presets), `profiles/` (architect, mason, inspector, checker), and 20
skills — `chisel-beads`, `chisel-setup`, `code-review`, `codebase-design`,
`diagnosing-bugs`, `domain-modeling`, `grill-with-docs`, `grilling`,
`handoff`, `improve-codebase-architecture`, `prototype`, `research`, `retro`,
`slice-task`, `sync-upstream`, `tdd`, `triage`, `upgrade-v2`, `wayfinder`,
`writing-great-skills`.

Reference repo for the target shape: `../music-downloader` — `.agents/skills/`
holding symlinks into `doc/agents/skills/`, an `AGENTS.md` routing to
`apps/documentation/INDEX.md` with per-area guidelines. Its own `AGENTS.md`
still carries the retired W0/W1/W2 vocabulary, so it is a shape reference,
not a text to copy.

## References

- `project-management/tasks/20260826-1512-chisel-v2.spec.md` — the v2 task, its
  audit round and its post-audit rulings
- `../factory-bench/research/audit-process-dur.md` — where the drift this
  task addresses was measured
