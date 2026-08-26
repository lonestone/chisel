# 06 — upgrade-v2 skill + LOG.md, pilot migration = parity check

**Status:** 🔴 Not Started
**Blocked by:** 04

**What to build:** The v1→v2 migration path — a SKILL, not machinery in
`update` (the system is young; the agent migrates file by file, the human
validates). `upgrade-v2` on a v1-equipped repo: removes the 3 rules +
`workflows.md`, poses `discipline.md` / formulas / profiles / generated
definitions, renames `CHANGELOG.md` → `LOG.md` (v2 default — collision with
the boilerplate's release changelog; path already glue-configurable §A),
fills the new glue sections (§B1–B3, tiers) by incremental questionnaire,
leaves existing tasks/archive untouched. The socle's own default texts switch
to `LOG.md` (template, discipline/formula wording, setup default); the
narrative journal stays HANDWRITTEN by the agent after each task — never
generated from the beads audit trail; ADRs unchanged (D5-G). Then the real
proof: migrate at least one real pilot (evea-ai by Pierrick,
music-downloader by its own agent) and run the **parity re-verification** — a
real Controlled × markdown session end-to-end on the migrated repo, checked
against `../factory-bench/prototypes/parity-report.md` (same sequence, gates,
artifacts, verification), including one sliced case (`slice-task`), which the
prototype bench never exercised.

## Acceptance criteria

- [ ] `upgrade-v2` on a v1 fixture: rules + workflows.md gone, v2 files
      posed, `CHANGELOG.md` → `LOG.md`, existing tasks/archive byte-intact,
      `chisel check` clean after
- [ ] Socle defaults all say `LOG.md`; a v2 fresh install never creates a
      `project-management/CHANGELOG.md`
- [ ] At least one real pilot migrated via the skill (human-validated diff)
- [ ] Parity session on the migrated pilot logged against the parity
      checklist — no missing step, no missing gate, artifacts conform; the
      sliced case exercised
- [ ] No LOG generation from audit trail anywhere in the socle (the decision
      is written down where LOG discipline is defined)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
