# 01 — Recomposition: discipline core + formulas, rules retired

**Status:** 🔴 Not Started
**Blocked by:** None — can start immediately

**What to build:** The layered replacement of the normative prose. The socle
ships `discipline.md` (the ambient invariant core — applies to EVERY
conversation, with or without a task file: read-first, plan-first, 🧑 zones
are law, verify before "done", bridge rule, escalate-don't-improvise) and two
formulas (Controlled / Auto: same steps, the difference is exactly the three
`[steps.gate] type="human"` blocks + escalation wording), versioned in the
socle with neutral step wording — ledger writes go through an indirect
convention à la §B Tracker, never "bd" or "file" hardcoded in a step. The
three rules (`task-creation`, `task-progressing`, `task-completion`) and
`workflows.md` DISAPPEAR; their step know-how moves into the skills the steps
point to; the AGENTS block becomes the v2 router (always: discipline; real
scoped work: the formula as an ordered checklist, each human gate = "stop and
ask"). First drafts to start from (paths relative to this repo's root, as in the
parent task): `../factory-bench/prototypes/recomposition/` and
`../factory-bench/prototypes/formulas/`. A fresh agent session in an equipped
fixture must route exactly as v1 did (parity checklist,
`../factory-bench/prototypes/parity-report.md`).

## Acceptance criteria

- [ ] `socle/agents/rules/` and `socle/agents/workflows.md` no longer exist;
      `discipline.md` + 2 formula TOMLs shipped and installed by `init`
      (CLI tests updated and green, including update/check on the new files)
- [ ] The two formulas parse (`version` integer, gates on the waiting step);
      Controlled carries exactly 3 human gates, Auto zero — diff between the
      two files is gates + escalation wording only
- [ ] No step description names a vendor tool or a ledger backend — roles are
      roster names, tiers abstract, writes via the ledger convention pointer
- [ ] A no-bd session executes the Controlled formula as a checklist on a
      fixture and stops at each of the 3 gates (logged), reproducing the v1
      sequence per the parity checklist
- [ ] Every v1 rule obligation is traceable to its new home (discipline line,
      formula step, or skill) — a mapping note in this slice's Notes; nothing
      silently dropped

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation. Grilled 2026-08-26 (see parent Notes): formula
names = `chisel-controlled` / `chisel-auto`; the typist-brief rule lives in
each profile's "Inputs" section (slice 02). Still open at THIS slice's plan
gate: where persist-the-plan know-how lives (formula `plan` step description
vs a small pointed file), under one-source-per-concept._
