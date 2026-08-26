# 04 — Setup §B redesigned + glue v2

**Status:** 🔴 Not Started
**Blocked by:** 02, 03

**What to build:** The setup chooses the case. `project.md.tpl` §B is split
into three sub-sections and `chisel-setup` asks them in PLAIN HUMAN LANGUAGE —
zero jargon on screen (no "ledger"; formulations like "where do task statuses
live?", each option explained in one line):

- **B1 coordination**: markdown (default) | beads embedded | beads server —
  server pitched ONLY for several simultaneous agents on one machine, never
  as the multi-dev answer
- **B2 external-tracker bridge**: none (default) | GitHub | Plane — carried by
  the bead's `external_ref` when beads is active
- **B3 auto**: disabled (default) | enabled — the glue authorization without
  which an Auto invocation is refused (piloting stays an invocation posture;
  this is the switch that *allows* it)

The setup also poses `.agents/user.md` for the current dev (slice 03's
mechanism) and its gitignore entry. Whatever the case chosen,
profiles/formulas/generated definitions install ALWAYS. Changing case later:
piloting = trivial glue flag edit; B1 markdown→beads = tooled re-run of setup
§B (delegated to slice 05); downgrade = immediate `git revert`, late
downgrade not tooled. The actual beads execution path (bd init +
neutralization) is slice 05 — this slice ships the questionnaire, the glue
template, and the branch point.

## Acceptance criteria

- [ ] Fresh init + questionnaire on a fixture writes §B1/B2/B3 into
      `project.md` with the documented defaults (markdown, none, disabled)
      when the user accepts everything
- [ ] Questionnaire wording review: no occurrence of "ledger", "formula",
      "bead" (except naming the beads option itself) in what the user is
      shown for §B — one-line explanations per option
- [ ] `user.md` created for the current dev at setup and gitignored;
      re-running setup does not clobber an existing one
- [ ] With B3 = disabled, an "auto" invocation on the fixture is refused by
      the texts (formula/discipline reference the glue switch); with
      enabled, it proceeds
- [ ] Profiles, formulas and generated definitions are present after setup in
      ALL B1 branches (markdown fixture asserted here; beads branch asserted
      in slice 05)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation. GitLab as a B2 option stays an OPEN question
(reopened by the v1 field test, not covered by the chantier) — do not add it
silently._
