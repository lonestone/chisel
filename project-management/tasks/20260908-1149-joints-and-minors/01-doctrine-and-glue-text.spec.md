# 01 — Doctrine and glue text

**Status:** 🔴 Not Started
**Blocked by:** None — can start immediately. Run before slice 03, which
removes carriers this slice would otherwise rename.

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the socle's own doctrine, glue template, profiles and
formulas stop contradicting the rulings the 360 review already settled. A
reader of an equipped repo finds every pointer resolving to a section that
exists, the factory presented as a possible destination rather than a product
cell, the model claim narrowed to models and tiers, the tier-resolution rule
stated where the profiles are read, the prototype side lane naming the
throwaway branch, one numbered discipline rule gone, and ruling G16 (which
spawns are fresh) written where the Foreman reads it. Nothing gains a
function; every change is a one-clause edit.

Full criterion wording lives in the parent,
`project-management/tasks/20260908-1149-joints-and-minors.spec.md`,
§Acceptance Criteria. What follows is this slice's share, with each check
re-run against this working tree on 2026-09-08 and its count recorded.

## Acceptance criteria

**Owned in full by this slice.**

- [ ] **architecture-index-declared** — §D · Documentation reference of
      `socle/agents/project.md.tpl` declares an "Architecture index" field
      whose default is `doc/architecture/ARCHITECTURE.md`.
      *Today:* `grep -c "Architecture index" socle/agents/project.md.tpl` → **0**.
      §D starts at line 142.
- [ ] **sdd-bench-pointer-gone** — `grep -rn "SDD-bench" socle/` returns
      nothing.
      *Today:* **1** — `socle/agents/methodology.md:14`.
- [ ] **model-claim-scoped** — `grep -n "Nothing in this socle names a model
      or a vendor" socle/agents/methodology.md` returns nothing, and the
      replacement sentence restricts the claim to models and tiers.
      *Today:* **1** — `socle/agents/methodology.md:324`.
- [ ] **tiers-prose-only** — `socle/agents/profiles/README.md` states that a
      tier is resolved at read time by the delegator at spawn, and that a
      generated definition carries no model field.
      *Today:* `grep -cE "resolved at read time|no model field"
      socle/agents/profiles/README.md` → **0**. The rule is stated nowhere.
- [ ] **rewrite-label-selfstanding** — `grep -rn "rewrite label"
      socle/agents/formulas/` returns nothing, and exactly one socle file
      carries the rule, stated so that it is understood without its original
      context.
      *Today:* formulas → **5**, one per file
      (`chisel-default.formula.toml:222`, `chisel-auto.formula.toml:213`,
      `chisel-auto-light.formula.toml:176`,
      `chisel-supervised.formula.toml:229`, `chisel-light.formula.toml:197`);
      `grep -c "rewrite label" socle/agents/methodology.md` → **1** (line 437,
      inside the `doc/architecture/` paragraph, where the clause reads as a
      trailing aside). The surviving copy is the methodology one, rewritten to
      name what a temporary rewrite label is and to give an example.
- [ ] **update-redirect-rule-gone** — `socle/agents/discipline.md` has 11
      numbered rules, none of them the `update` redirect, and
      `grep -c "upgrade-v2" bin/chisel.sh` is at least 1.
      *Today:* `grep -cE "^[0-9]+\. " socle/agents/discipline.md` → **12**.
      Rule **11** (line 72) is "A refused `update` is a redirect" — the one
      that goes. Rule **12** (line 77, a section reference names its file and
      its title) survives and becomes rule 11.
      `grep -c "upgrade-v2" bin/chisel.sh` → **2**, already satisfied; the CLI
      is not edited.
- [ ] **role-reuse-in-socle** — `socle/agents/profiles/foreman.md` states
      ruling G16: judging roles are spawned fresh, the Mason is reused from
      plan through typing within a live thread.
      *Today:* `grep -c "G16" socle/agents/profiles/foreman.md` → **0**; the
      rule lives only in this repo's `AGENTS.md:18-19`. The two-part spawn
      bullet this statement follows is at line 34.
- [ ] **suite-green** (this slice's own run) — `bash test/run.sh`, run with a
      `python3` that has `tomllib`, reports 0 failed, with the "integrity: no
      pointer into thin air" scenario passing.
      *Today:* `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → **9
      scenarios, 94 assertions, 0 failed**. The five formula edits make this
      criterion load-bearing here: the suite parses every formula.

**Split with another slice — this slice does its half only.**

- [ ] **prototype-capture-aligned** (clauses 1 and 2 only) — `grep -n "delete
      the code" socle/agents/discipline.md` returns nothing, and the prototype
      side-lane row names the throwaway branch and its pointer.
      *Today:* `grep -c "delete the code" socle/agents/discipline.md` → **1**
      (line 98, the side-lane table); `grep -c "throwaway branch"
      socle/agents/discipline.md` → **0**.
      Clause 3 of the criterion — the close-time cleanup of consumed prototype
      branches written in exactly one place — is slice 02's, in
      `socle/agents/skills/prototype/SKILL.md`. **This slice must not write
      that cleanup sentence**, or "exactly one place" becomes two. See Notes.
- [ ] **tracker-pointer-resolves** (this slice's one carrier) —
      `socle/agents/methodology.md:35` names a section that exists. It means
      the external tracker (the reserved word "ticket"), so per parent
      Implementation Decision 1 it becomes **`§B2 · Link to an external
      tracker`** of `.agents/project.md`, carrying the title with the number.
      *Today:* `grep -rn "Tracker section" socle/` → **5** across 5 files
      (`agents/methodology.md`, `agents/skills/wayfinder/SKILL.md`,
      `slice-task/SKILL.md`, `code-review/SKILL.md`, `triage/SKILL.md`);
      `grep -rn "§B2 · Link to an external tracker" socle/` → **0**.
      The criterion closes at slice 03, when the fifth carrier leaves with the
      `triage` file.
- [ ] **factory-claim-degraded** (this slice's one carrier) —
      `socle/agents/methodology.md:65` stops presenting the factory as a
      product cell and presents it as a possible destination, perhaps outside
      chisel; no beads machinery is written.
      *Today:* `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` →
      **2** (`socle/agents/methodology.md:65`, `PHILOSOPHY.md:134`).
      Co-owned with slice 02, which holds the `PHILOSOPHY.md` carrier. The
      full grep goes empty only when both have landed.
- [ ] **work-on-invocation-current** (this slice's one carrier) —
      `socle/agents/profiles/README.md:67` names `<spec-document>` instead of
      `work on slice <file>`.
      *Today:* `grep -rn "work on slice <file>\|work on task <file>" socle/
      AGENTS.md` → **2** (`socle/agents/profiles/README.md:67`,
      `AGENTS.md:12`).
      Co-owned with slice 02, which holds the `AGENTS.md` carrier.

## Files map

Indicative, motivated by the parent's Architecture, never a strict limit. The
reviewer judges deviations a posteriori.

**Modify:**

- `socle/agents/methodology.md` — four edits and one rewrite: the A1 (1)
  pointer at line 35, the A3 (1) SDD-bench reference at line 14, the E1
  factory sentence at line 65, the F1.7 model claim at line 324, and the F1.8
  rewrite-label sentence at line 437 made self-standing.
- `socle/agents/discipline.md` — the F1.5 prototype side-lane row (line 98)
  and the F1.9 rule deletion with its renumber (rule 11 out, rule 12 becomes
  11).
- `socle/agents/project.md.tpl` — the A1 (3) "Architecture index" field in §D
  (line 142 onward).
- `socle/agents/profiles/README.md` — the E2 tier-resolution statement, and
  the invocation clause at line 67.
- `socle/agents/profiles/foreman.md` — ruling G16, one bullet in the "What it
  does" list after the two-part spawn bullet (line 34).
- the five `socle/agents/formulas/*.formula.toml` — removal of the
  rewrite-label clause from the `close` step only, nothing else.

**Avoid:** everything under `test/` and `bin/`; `socle/templates/`;
everything under `socle/agents/skills/` — in particular
`socle/agents/skills/prototype/SKILL.md`, which is slice 02's and carries
clause 3 of `prototype-capture-aligned`; all of `project-management/`;
`README.md`; `PHILOSOPHY.md`; `AGENTS.md`.

The `discipline.md` overlap with slice 03 (the triage side-lane row at line
102) is accepted and recorded in the parent: two different rows of one table.
This slice does not touch that row.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Verification

- Re-run each criterion command above and record the after-count beside the
  before-count.
- `grep -rn "Tracker section" socle/` must drop from 5 to 4, and the surviving
  four must be the wayfinder, slice-task, code-review and triage carriers.
- `grep -rn "§B2 · Link to an external tracker" socle/` must be at least 1.
- `grep -cE "^[0-9]+\. " socle/agents/discipline.md` must be 11, and the
  section-reference rule must read `11.`.
- Parent Implementation Decision 9 is the guard on the renumber: the only
  rule-number citations in the socle are `discipline.md:69` ("rule 9") and
  `skills/retro/SKILL.md:8` ("discipline.md rule 8"), both below 11. Re-run
  `grep -rn "rule [0-9]" socle/` and confirm nothing new cites 11 or 12.
- `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` — expect 9 scenarios, 94
  assertions, 0 failed. Below python 3.11 the formula parse check reports SKIP
  and the run announces a green it has not earned; the five formula edits make
  that the difference between a real and a fake pass here.
- `git diff --check`.

## References

- Parent spec:
  `project-management/tasks/20260908-1149-joints-and-minors.spec.md` —
  §Scope (the per-ruling carrier table), §Acceptance Criteria (full wording),
  §Architecture (why `methodology.md`'s five edits stay in one slice),
  §Implementation Decisions 1, 2, 5, 6, 9, 10, 11, 12, and the slice-01 entry
  of §Slices & Dependencies.
- `project-management/review-360-decisions.md` — rulings A1, A3 (1), E1, E2,
  F1.5, F1.7, F1.8, F1.9, and the addenda carrying G16 (role reuse) and G18
  (direct prose).
- `socle/agents/skills/prototype/SKILL.md`, rule 6 — the wording the
  discipline's prototype row must align on: throwaway branch out of main,
  plus a context pointer to it.
- `socle/agents/project.md.tpl`, §D · Documentation reference — the field
  list the new "Architecture index" entry joins.
- `test/installer.sh`, scenario "integrity: no pointer into thin air" — what
  counts as a pointer, and why a renamed section reference must name a
  section that exists.

## Notes

Only material written into this file before a work document exists. The
Mason's notes, snippets and worklog belong in
`01-doctrine-and-glue-text.work.md`, created at `plan`.

**Architect note, 2026-09-08 · `architect`.** Every count above was produced
by running its command against this working tree on branch `review-360`, not
copied from the parent. All of them agree with the parent's "Verified counts"
table.

**Re-verified, 2026-09-08 · `architect`.** Every criterion command and every
line reference in this file was re-run against the working tree after the
first Architect run was interrupted. All counts and all line numbers held
unchanged; nothing in this slice needed correction. Parent Implementation
Decision 9's guard was re-checked directly: `grep -rn "rule [0-9]" socle/`
returns exactly two citations, `discipline.md:69` ("rule 9") and
`skills/retro/SKILL.md:8` ("discipline.md rule 8"), both below 11, so removing
rule 11 moves nothing that is cited. The suite baseline was re-run:
`PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → 9 scenarios, 94 assertions,
0 failed.

**`prototype-capture-aligned` is split across two slices, and the parent
attributes it to this one alone.** The parent lists the criterion under slice
01's "Criteria it closes", but its third clause — the close-time cleanup of
consumed prototype branches written in exactly one place — needs an edit to
`socle/agents/skills/prototype/SKILL.md`, which sits in slice 02's
files-to-modify map ("`prototype` (F1.5 cleanup habit)"). Verified today: that
cleanup is written in **zero** places — `grep -rn "prototype branch"
socle/agents/formulas/ socle/agents/methodology.md` returns nothing, and rule
6 of the prototype skill states the capture but not the cleanup. Reading
applied here, so that "exactly one place" survives: this slice owns clauses 1
and 2 and writes no cleanup sentence; slice 02 owns clause 3 and is the single
home. The criterion goes green only after both land. Reported to the spawner
rather than resolved against the parent, which this slice may not edit.

**`factory-claim-degraded` and `work-on-invocation-current` name no closing
slice in the parent.** Both are listed as "contributed to" by slices 01 and 02
and closed by neither, because each grep spans one carrier in each slice.
Whichever of the two lands second closes them, by re-running the full grep.
Recorded so a `diff-review` of slice 01 alone does not read a non-empty grep
as a failure.

**The CHANGELOG entry is not this slice's.** The parent's Deliverables ask for
one dated entry recording the pass, the three removals and the standing
intention on `triage`; this slice's files-to-avoid map excludes all of
`project-management/`. See slice 03's Notes.
