# 02 — Templates, front door and skills

**Status:** 🔴 Not Started
**Blocked by:** None — can start immediately. Run before slice 03, which
deletes two skills this slice would otherwise repoint.

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the surfaces a human actually reads first stop teaching a
system that no longer exists. The two task templates and their two
hand-maintained mirrors name the zone's owner and carry no status sediment of
their own; this repo's front door describes the real setup flow, the real
reading gradient and the real preset count; and the satellite skills point at
sections that exist, stop counting role profiles, and stop claiming the
discipline is rendered into the AGENTS block. Nothing gains a function; every
change is a one-clause edit.

Full criterion wording lives in the parent,
`project-management/tasks/20260908-1149-joints-and-minors.spec.md`,
§Acceptance Criteria. What follows is this slice's share, with each check
re-run against this working tree on 2026-09-08 and its count recorded.

## Acceptance criteria

**Owned in full by this slice.**

- [ ] **wayfinding-notes-gone** — `grep -rn "Wayfinding operations" socle/`
      returns nothing.
      *Today:* **1** — `socle/agents/skills/wayfinder/SKILL.md:30`. Only the
      deletion is taken here; the rest of ruling A1 (2), the wayfinder made
      local-first, is chantier 6.
- [ ] **readme-init-truthful** — `README.md` claims no question for `chisel
      init`, and names `chisel-setup` as the questionnaire that fills
      `.agents/project.md` afterwards.
      *Today:* `grep -c "asks one question" README.md` → **1** (line 40, under
      the heading "The one choice setup actually shows you" at line 38, which
      is itself part of the false claim — the whole block runs 38-46);
      `grep -c "chisel-setup" README.md` → **0**.
- [ ] **readme-gradient-current** — `README.md` no longer places program
      design or working notes inside the spec file, and no longer persists the
      plan into it: `grep -n "persists the plan into the spec file" README.md`
      returns nothing.
      *Today:* **1** — the paragraph at `README.md:19-31` still describes one
      spec file holding "program design underneath, the agent's working notes
      at the bottom" and a plan "persists the plan into the spec file", both
      retired by chantier 2.
- [ ] **template-zone-owner** — in both `socle/templates/000-template.spec.md`
      and `project-management/000-template.spec.md`: `grep -c "Human,
      always"` is 0, and each file names "Zone ownership" of
      `.agents/methodology.md` at least once.
      *Today:* each file → `Human, always` **1** (the zone table, line 20),
      `Zone ownership` **0**.
- [ ] **philosophy-presets-current** — `grep -n "Three presets"
      PHILOSOPHY.md` returns nothing; the five presets are named, and auto is
      not described as a project permission.
      *Today:* `grep -c "Three presets" PHILOSOPHY.md` → **1** (line 131,
      naming `chisel-default`, `chisel-supervised`, `chisel-auto`). The five
      are those three plus `chisel-auto-light` and `chisel-light`, per
      `socle/agents/formulas/`. Line 129 still calls auto a "permission to run
      without stopping"; ruling G10 retired that framing.
- [ ] **profiles-uncounted** — `grep -rn "three role profiles" socle/`
      returns nothing.
      *Today:* **1** — `socle/agents/skills/upgrade-v2/SKILL.md:13`. The fix
      is "the role profiles"; do not substitute a new number.
- [ ] **retro-block-pointer-accurate** — `grep -rn "rendered into the AGENTS
      block" socle/` returns nothing.
      *Today:* **1** — `socle/agents/skills/retro/SKILL.md:117`. Verified
      false: `socle/templates/AGENTS-block.md:14` points a reader at
      `.agents/discipline.md` rather than inlining it.
- [ ] **template-sediment-gone** — none of the four template files carries a
      `**Status:**` or `**Version:**` header line **of its own**.
      *Today:* each of the four carries exactly two, at lines 3 and 4:
      `socle/templates/000-template.spec.md`,
      `socle/templates/000-template.work.md`,
      `project-management/000-template.spec.md`,
      `project-management/000-template.work.md`. The two work files' `Version:`
      value runs onto the following lines — the whole header goes, not just
      line 4.
      **Do not delete `**Status:** [Status Emoji & Text]` at line 71 of either
      spec template.** That line is inside the fenced Spec Document Template
      block: it is the header the template *prescribes* for real spec
      documents, not a header the template file carries of its own. A bare
      `grep -c '\*\*Status:\*\*'` counts 2 in the spec files for this reason.
- [ ] **agents-md-persist-destination** — this repo's `AGENTS.md` names the
      work document as where the plan is persisted.
      *Today:* `grep -c "work document" AGENTS.md` → **0**;
      `AGENTS.md:12-13` reads "plan approved by the human and PERSISTED into
      the file".
- [ ] **suite-green** (this slice's own run) — `bash test/run.sh`, run with a
      `python3` that has `tomllib`, reports 0 failed, with the "integrity: no
      pointer into thin air" scenario passing.
      *Today:* `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → **9
      scenarios, 94 assertions, 0 failed**. This slice edits two installed
      templates and six installed skill pages, so the integrity scenario is
      the guard that no repointed reference lands on a path that does not
      exist.

**Split with another slice — this slice does its half only.**

- [ ] **prototype-capture-aligned** (clause 3 only) — the close-time cleanup
      of consumed prototype branches is written in exactly one place, and that
      place is `socle/agents/skills/prototype/SKILL.md`, beside rule 6's
      capture instruction.
      *Today:* written in **zero** places — `grep -rn "prototype branch"
      socle/agents/formulas/ socle/agents/methodology.md` returns nothing, and
      rule 6 (line 31) states the capture (throwaway branch out of main, plus
      a context pointer) without saying when the branch may go.
      Clauses 1 and 2 — `delete the code` gone from `socle/agents/
      discipline.md`, the side-lane row naming the throwaway branch — are
      slice 01's. **This slice writes the cleanup sentence exactly once and
      touches no other file with it.** See Notes.
- [ ] **tracker-pointer-resolves** (this slice's three carriers) — each names
      a section that exists, carrying the title with the number, per parent
      Implementation Decision 1:
      `socle/agents/skills/wayfinder/SKILL.md:30` means the issue tracker →
      **`§B2 · Link to an external tracker`**;
      `socle/agents/skills/slice-task/SKILL.md:17` means where slices are
      published → **`§B · Coordination`**;
      `socle/agents/skills/code-review/SKILL.md:18` means where task files
      live → **`§B · Coordination`**.
      *Today:* `grep -rn "Tracker section" socle/` → ~~**5** across 5 files~~
      **4** across 4 files (re-measured 2026-09-09: slice 01 repointed the
      methodology carrier; the four left are wayfinder, slice-task,
      code-review and triage);
      `grep -rn "§B · Coordination" socle/` → **0**;
      `grep -rn "§B2 · Link to an external tracker" socle/` → **0**.
      The criterion closes at slice 03, when the last carrier leaves with the
      `triage` file.
- [ ] **factory-claim-degraded** (this slice's one carrier) —
      `PHILOSOPHY.md:134` stops presenting the factory as a product cell and
      presents it as a possible destination, perhaps outside chisel; no beads
      machinery is written.
      *Today:* `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` →
      **2** (`socle/agents/methodology.md:65`, `PHILOSOPHY.md:134`).
      Co-owned with slice 01, which holds the methodology carrier. The E1
      sentence and `philosophy-presets-current` land in the same paragraph:
      the new sentence cannot be stated coherently inside a paragraph that
      miscounts the presets.
- [ ] **work-on-invocation-current** (this slice's one carrier) —
      `AGENTS.md:12` names `<spec-document>` instead of `work on task <file>`
      / `work on slice <file>`.
      *Today:* `grep -rn "work on slice <file>\|work on task <file>" socle/
      AGENTS.md` → **2** (`socle/agents/profiles/README.md:67`,
      `AGENTS.md:12` — both forms on that one line).
      Co-owned with slice 01, which holds the profiles carrier.

## Files map

Indicative, motivated by the parent's Architecture, never a strict limit. The
reviewer judges deviations a posteriori.

**Modify:**

- `socle/templates/000-template.spec.md` and
  `socle/templates/000-template.work.md` — B1 (the zone table names the
  zone's owner and points at "Zone ownership" of `.agents/methodology.md`)
  and F1.8 (the file's own Status/Version headers go).
- `project-management/000-template.spec.md` and
  `project-management/000-template.work.md` — the same two edits. These are
  hand-maintained mirrors, not managed installs: chisel is not installed on
  itself. Per parent Implementation Decision 7 they differ from the sources on
  one line — the methodology link is repo-relative
  (`../socle/agents/methodology.md`) where the source is install-relative
  (`/.agents/methodology.md`). Keep that difference.
- `README.md` — A4 (the real setup flow: `chisel init` installs with safe
  defaults and asks nothing; `chisel-setup` is the questionnaire, run
  afterwards, that fills `.agents/project.md`) and the stale gradient
  paragraph at lines 19-31.
- `PHILOSOPHY.md` — range extended to 68-136 by the foreman rulings of
  2026-09-09 in Notes — E1 (the factory sentence at line 134) and the preset
  count with auto's framing (lines 126-142).
- `AGENTS.md` — the plan's persist destination and the invocation vocabulary,
  lines 10-13.
- `socle/agents/skills/wayfinder/SKILL.md` — A1 (1) and A1 (2), line 30.
- `socle/agents/skills/slice-task/SKILL.md` — A1 (1), line 17.
- `socle/agents/skills/code-review/SKILL.md` — A1 (1), line 18.
- `socle/agents/skills/upgrade-v2/SKILL.md` — F1.2, line 13.
- `socle/agents/skills/retro/SKILL.md` — F1.6, line 117.
- `socle/agents/skills/prototype/SKILL.md` — F1.5's cleanup habit, clause 3
  of `prototype-capture-aligned`, beside rule 6.

**Avoid:** everything under `test/` and `bin/`;
`socle/agents/methodology.md`; `socle/agents/discipline.md`;
`socle/agents/project.md.tpl`; `socle/agents/formulas/`;
`socle/agents/profiles/`; and specifically
`socle/agents/skills/triage/`, `socle/agents/skills/grill-with-docs/` and
`socle/agents/skills/sync-upstream/`, which slice 03 removes — a pointer
repointed there is work thrown away. `upstream.lock.json` and
`test/fixtures/golden-tree.txt` are slice 03's alone.

Do not extend A1's three renames into the bare `§B`, `§C`, `§F`, `§B1` and
`§H` citations elsewhere in the socle: parent Implementation Decision 2 gives
that sweep to chantier 5 by name, and a helpful sweep makes this diff
unreviewable.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Verification

- Re-run each criterion command above and record the after-count beside the
  before-count.
- `grep -rn "Tracker section" socle/` must drop from ~~5 to 2~~ 4 to 1 (the
  triage carrier, slice 03's; the methodology carrier was slice 01's and is
  already gone — re-measured 2026-09-09), and both
  `grep -rn "§B · Coordination" socle/` and
  `grep -rn "§B2 · Link to an external tracker" socle/` must be non-zero.
- `diff` the two spec templates against each other and the two work templates
  against each other: the only surviving difference must be ~~the methodology
  link's relative form~~ the relative form of the one doctrine pointer each
  template keeps (install-relative in `socle/templates/`, repo-relative in the
  `project-management/` mirror) — amended 2026-09-09 at `plan-review`, see
  the foreman rulings in Notes.
- Confirm `**Status:** [Status Emoji & Text]` still stands inside the fenced
  Spec Document Template block of both spec templates.
- `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` — expect 9 scenarios, 94
  assertions, 0 failed. Two of the files this slice edits ship, so the golden
  tree comparison and the integrity scenario both matter: a repointed
  reference that names a missing path fails "integrity: no pointer into thin
  air", and a filename change would fail the byte-for-byte tree comparison.
  This slice changes no filename.
- `git diff --check`.

## References

- Parent spec:
  `project-management/tasks/20260908-1149-joints-and-minors.spec.md` —
  §Scope (the per-ruling carrier table and the two front-door riders ruled
  in), §Acceptance Criteria (full wording), §Implementation Decisions 1, 2, 7,
  11, 12, and the slice-02 entry of §Slices & Dependencies.
- `project-management/review-360-decisions.md` — rulings A1, A4, B1, E1,
  F1.2, F1.5, F1.6, ruling G10 (auto is not a project permission) and G18
  (direct prose).
- `socle/agents/methodology.md`, "Zone ownership" — the doctrine the
  template's new wording points at.
- `socle/templates/000-template.spec.md`, "The two zones" — the table ruling
  B1 rewrites.
- `socle/templates/AGENTS-block.md:14` — the pointer that proves the `retro`
  claim false.
- `socle/agents/skills/chisel-setup/SKILL.md` — the questionnaire `README.md`
  must name; read it to describe the flow accurately, and do not edit it
  (parent Implementation Decision 8: §D's new field needs no change there).
- `project-management/archive/20260828-2217-split-spec-and-work-documents/03-formulas-follow.md`,
  section "Proposals — reported, not typed" — where the `AGENTS.md` and
  `profiles/README.md` vocabulary residues were first recorded, and why no
  slice of that task owned them.

## Notes

Only material written into this file before a work document exists. The
Mason's notes, snippets and worklog belong in
`02-templates-front-door-and-skills.work.md`, created at `plan`.

**Architect note, 2026-09-08 · `architect`.** Every count above was produced
by running its command against this working tree on branch `review-360`, not
copied from the parent. All of them agree with the parent's "Verified counts"
table.

**Re-verified, 2026-09-08 · `architect`.** Every criterion command and every
line reference in this file was re-run against the working tree after the
first Architect run was interrupted. Every count held. Two line references
were wrong and are corrected above: the `asks one question` hit is at
`README.md:40`, not 38 (38 is the heading of the block, which runs 38-46), and
the persist claim spans `AGENTS.md:12-13`, not 11-12. The suite baseline was
re-run: `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → 9 scenarios, 94
assertions, 0 failed.

**Two of this slice's criteria are riders the Owner may strike.**
`readme-gradient-current` and `philosophy-presets-current` come from staleness
left by chantiers 1 and 2 rather than from one of this chantier's seven
rulings, and the parent rules them in only because A4 and E1 open both files
anyway. If they are struck at spec review, this slice loses two criteria and
keeps the rest; `factory-claim-degraded` still needs the `PHILOSOPHY.md`
carrier, and the parent's own reason for the pairing stands — E1's new
sentence sits in the paragraph that miscounts the presets.

**`prototype-capture-aligned` is split, and the parent attributes it to slice
01 alone.** The parent lists the criterion under slice 01's "Criteria it
closes" while putting `socle/agents/skills/prototype/SKILL.md` ("F1.5 cleanup
habit") in *this* slice's files-to-modify map. Reading applied, so that
"exactly one place" survives: slice 01 owns clauses 1 and 2 and writes no
cleanup sentence; this slice owns clause 3 and is the single home. The
criterion goes green only after both land. Reported to the spawner rather than
resolved against the parent, which this slice may not edit.

**`factory-claim-degraded` and `work-on-invocation-current` name no closing
slice in the parent.** Both are listed as "contributed to" by slices 01 and 02
and closed by neither, because each grep spans one carrier in each slice.
Whichever of the two lands second closes them, by re-running the full grep.
Recorded so a `diff-review` of slice 02 alone does not read a non-empty grep
as a failure.

**The CHANGELOG entry is not this slice's.** The parent's Deliverables ask for
one dated entry recording the pass, the three removals and the standing
intention on `triage`. It is not in this slice's map, which lists only the two
template mirrors under `project-management/`. See slice 03's Notes.

**Foreman note, 2026-09-09 · `foreman`.** The `tracker-pointer-resolves`
arithmetic was written before slice 01 landed. Slice 01 repointed the
methodology carrier (commit `3ec5ac5`), so this slice starts from 4 carriers,
not 5, and leaves 1, not 2. Both figures are struck and re-measured above; the
three carriers this slice repoints are unchanged. Spotted by slice 01's
Inspector as a heads-up.

**Foreman rulings at `plan`, 2026-09-09 · `foreman`.** Two points raised by the
Mason's program design (work document, commit `9ff9088`), decided by the
thread owner under the Owner's standing go:

1. *Proposal door, `PHILOSOPHY.md:112-124`.* The pipeline bullets still
   describe the retired single task file ("shapes the task file", "gets the
   plan approved and persisted", no work document). Ruled IN for this slice:
   it is the same defect the parent ruled in for `README.md:19-31`, in a file
   the slice already opens, one bullet list in size. The Files map range for
   `PHILOSOPHY.md` extends to 112-136. No criterion is added; the edit is
   judged by the Architect and the Inspector on the two existing axes.
2. *Mirror diff of the work templates.* After F1.8 deletes the header block,
   the two work templates would be byte-identical, so the Verification
   bullet's "only surviving difference" has nothing to survive for that pair.
   Reading applied: the bullet binds the spec pair as written; for the work
   pair, byte-identical is acceptable, and so is a single one-line difference
   of the same kind (a doctrine pointer in install-relative form in the
   source, repo-relative in the mirror) if the Architect keeps the Mason's
   recommendation to reinstate one. Parent Implementation Decision 7 is
   read the same way.

**Foreman rulings at `plan-review`, 2026-09-09 · `foreman`.** The Architect's
round-1 report (SEND BACK, eight findings, two open questions answered, four
escalations) leaves three points to the thread owner:

3. *Escalation 1, the mirror-diff bullet.* Ruling 2 above read around a
   wording that F1.8 makes false. With the Architect's answer to open
   question 2 (one doctrine pointer reinstated in each work template, one
   line, install-relative in the source and repo-relative in the mirror) the
   assertion becomes true again for both pairs. The Verification bullet is
   amended accordingly, struck and dated, above.
4. *Escalation 2, open question 1.* Ruled IN: `socle/agents/skills/upgrade-v2/SKILL.md:12`
   drops the count of the presets in the same clause where F1.2 drops the
   count of the profiles. One clause, a file the map already assigns, no
   criterion added; a false count of the presets is the defect
   `philosophy-presets-current` repairs one file over.
5. *Escalation 3, finding 8.* Ruled IN: `PHILOSOPHY.md:68-84` (the 🤖 zone
   and "persisted into the slice file", the retired single-file model) and
   `PHILOSOPHY.md:89-90` ("with the planner reviewing the diff", which
   contradicts the Architect profile: the Inspector reviews the diff and is
   never its author) ride along with 112-136, for the same reason ruling 1
   gave: the same defect, in a file the slice already opens, small. The
   `PHILOSOPHY.md` range in the Files map is now 68-136. The Owner approved
   this slice's README and PHILOSOPHY riders as staleness left by chantiers 1
   and 2; this extends that rider inside the same file and is reported to
   the Owner as reversible.
   Escalation 4 is record only and stands confirmed.
