# 05 — chisel-beads: neutralized install + the convention

**Status:** 🔴 Not Started
**Blocked by:** 04, 08

**What to build:** The B1 = beads branch, end to end — validated in vivo by
`../factory-bench/prototypes/cohab-bd-init.md`. When the user picks beads, the
setup: requires a CLEAN working tree (bd's auto-commit is unavoidable — no
config disables it), runs `bd init`, re-owns the auto-commit under its own
message, then NEUTRALIZES the beads discourse: `bd setup claude --remove` +
`bd setup codex --remove`, strip of the BEADS block in AGENTS.md by its
BEGIN/END markers, removal of the vendored `beads` skill (one normative
discourse in the repo — Q16-b), `.beads/hooks/` kept. In its place, the
**chisel-beads convention** (normative socle text): the bead points to the
spec via `--spec-id` and never contains it (`design`/`acceptance_criteria`
EMPTY by convention; `bd lint`/validation left off or configured
accordingly); inter-task coordination (status, claim/lease, edges, priority)
lives in the bead, intra-task progression (implementation checkboxes = the
Mason resume point) stays in the MD; roles sign with `--actor`
architect/mason/inspector; `external_ref` reserved for the B2 bridge. Team
routine: `bd dolt pull` at session start, `bd dolt push` at session end;
guards in black and white: never `git push --mirror` (destroys
`refs/dolt/data`), verify the assignee after every claim while
gastownhall/beads#3575 is open. Plus the tooled **markdown→beads upgrade**:
re-run of setup §B creating beads for OPEN tasks only, `--spec-id` to their
MD files, blocking edges recreated, archive untouched.

## Acceptance criteria

- [ ] Setup with B1 = beads on a dirty-tree fixture refuses and says why; on
      a clean tree it completes with: no BEADS block in AGENTS.md/CLAUDE.md,
      no SessionStart `bd prime` hook, no vendored `beads` skill, bd CLI
      still functional (`bd create`/`bd ready`), `chisel check` clean
- [ ] A task created under the convention on the fixture yields a bead with
      `--spec-id` set to the MD file, empty design/ACs fields, `--actor` per
      role — asserted via `bd show`
- [ ] The convention text carries the sync routine and the two guards
      verbatim (`push --mirror`, assignee-after-claim) and states when server
      mode applies (simultaneous agents on one machine only)
- [ ] markdown→beads upgrade on a fixture with open + archived tasks: beads
      exist for open tasks only, edges match the files' "Blocked by", archive
      byte-intact; the MD files lose coordination state (status/who) to the
      beads

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation. Open at plan gate (parent Notes): where the
installed formulas live for bd (`.beads/formulas/` vs `.agents/formulas/` —
copy/symlink?), and the bd version prerequisite / bd-not-installed behaviour._
