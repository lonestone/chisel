# 01 — Recomposition: discipline core + formulas, rules retired

**Status:** 🟢 Complete
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

- [x] `socle/agents/rules/` and `socle/agents/workflows.md` no longer exist;
      `discipline.md` + 2 formula TOMLs shipped and installed by `init`
      (CLI tests updated and green, including update/check on the new files)
- [x] The two formulas parse (`version` integer, gates on the waiting step);
      Controlled carries exactly 3 human gates, Auto zero — diff between the
      two files is gates + escalation wording only
- [x] No step description names a vendor tool or a ledger backend — roles are
      roster names, tiers abstract, writes via the ledger convention pointer
- [x] A no-bd session executes the Controlled formula as a checklist on a
      fixture and stops at each of the 3 gates (logged), reproducing the v1
      sequence per the parity checklist
- [x] Every v1 rule obligation is traceable to its new home (discipline line,
      formula step, or skill) — a mapping note in this slice's Notes; nothing
      silently dropped

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-26 · Architect+Mason fused, delegation pre-approved by the Owner)

### D0 — The deferred sub-point: where persist-the-plan know-how lives

**Decision: in the `plan` step description of each formula. No new file.**

Rationale (one source per concept, per the parent's dedup rule "structure →
templates; doctrine → methodology; triggering → formula steps"):

1. Persist-the-plan is a **step obligation** (when to persist, what to
   persist, where it lands) — the parent assigns triggering to formula
   steps. Its **why** already lives in `methodology.md` ("Why persist the
   plan" + the cost-gradient section); its **where-in-the-file** already
   lives in the artifact templates (`000-task-file-template.md` zones and
   `slice-task`'s slice template, which literally ships a
   "Design — persisted at plan time" section). A third file would make a
   *fourth* home for one concept — the opposite of the constraint.
2. A `.md` next to the TOMLs would be dragged into `.beads/formulas` by the
   directory symlink decided in the parent's Notes — foreign matter in a
   directory the ledger tool scans.
3. The near-duplication between the two formulas is **not** a second source:
   it is the same source in two modes, and the slice's own AC mandates it
   (the diff between the files must be gates + escalation wording only).
   Guarded by a test asserting both files declare the same step ids.

### D1 — Target file tree

```
socle/agents/
├── discipline.md                          ★ NEW (ambient core)
├── formulas/                              ★ NEW
│   ├── chisel-controlled.formula.toml     ★ NEW (3 human gates)
│   └── chisel-auto.formula.toml           ★ NEW (0 gates)
├── rules/                                 ✖ DELETED (3 files)
├── workflows.md                           ✖ DELETED
├── methodology.md                         (untouched — slice 07)
├── project.md.tpl                         (untouched — slice 04)
└── skills/                                (untouched — tiers = slice 03)
socle/templates/
├── AGENTS-block.md                        ✎ rewritten as the v2 router
└── 000-task-file-template.md              ✎ absorbs workflows §6
bin/chisel.sh                              ✎ managed list + copy step
test/run.sh                                ✎ layout asserts + new group 7
```

Fixtures are unchanged: they are pre-chisel source repos (no `.agents/`),
so the composition change is entirely visible through `init`'s output.

### D2 — `discipline.md` (the ambient invariant core)

Starts from the prototype draft (6 rules), completed with what the retired
prose owned and nothing else owns: session hygiene (workflows §8) and the
side-lanes routing table (workflows §7). Shape:

1. Read before acting (reading list = `.agents/project.md` §C).
2. Plan first — nothing half-decided crosses into code; when the work has a
   spec file the plan is persisted **there** before any code (pointer to the
   formula's `plan` step, per D0).
3. Human-owned zones (🧑) are law — surface the conflict, never silently
   contradict.
4. Verify before "done" — gate commands from `.agents/project.md` §F;
   evidence first, red output reported red.
5. The bridge rule — real, scoped, multi-step work → PROPOSE the pipeline;
   inform, never force; one-shot stays cheap.
6. Escalate, don't improvise — blocked twice on the same thing, or forced
   outside the approved plan → stop and ask (in Auto: escalate one rung —
   never force a passage).
7. Session hygiene — create in one sitting, build fresh from the file, hand
   off a session that has gone long.
8. Side lanes table (broken thing / undecidable design question / reading
   legwork / too foggy to slice / idle improvement / external issues) →
   the six skills, as in the retired workflows §7.

Ledger-neutral and vendor-neutral: no backend, no model name, no W-label.
Closes with the pointer to `.agents/formulas/`.

### D3 — The two formulas

Both `version = 1` (integer), `type = "workflow"`, vars `{{task}}`/`{{spec}}`,
seven steps chained by `needs`: `interview → spec → plan → type → verify →
review → close`.

**Invariant kept by construction:** every step's description body is
byte-identical across the two files; Auto appends one trailing paragraph per
step where the human's absence changes behaviour (assumption-writing,
escalation), and Controlled carries the three `[steps.gate] type = "human"`
blocks. So `diff` shows: the header comment, `formula`/`description`, the
3 gate blocks, and the appended escalation paragraphs — nothing else.

Gate placement (the gate sits on the step that WAITS):

| Gate | Sits on | Means |
|---|---|---|
| spec approved | `plan` | the Owner validates scope, ACs, seams before planning |
| plan approved + typist chosen | `type` | one fused gate (parity delta 3, accepted) |
| review arbitration | `close` | the Owner arbitrates the findings before closing |

Sizing check stays **in-step** in `spec` (parity delta 2, recommendation
adopted), stated out loud, never a gate.

Neutrality rules applied to every description: roles are roster names
(Architect / Mason / Inspector / Owner), tiers are abstract (frontier / mid /
cheap — never a model name), and every write goes through the glue: task
paths and the dated journal entry via `.agents/project.md` §A, coordination
state via the §B tracker convention. The words for the ledger backend
("bd", "beads", "the file") never appear in a step.

### D4 — `AGENTS-block.md` v2 (the router)

Keeps the existing HTML comment verbatim (it is the user-facing doc of the
managed-block mechanism, and slice 03 of v1 made it a deliverable). Body,
from the prototype router: (1) always `.agents/discipline.md` + read
`.agents/project.md` §C; (2) real scoped work → the Controlled formula,
executed as an ordered checklist top to bottom (`needs` gives the order,
each `[steps.gate] type = "human"` reads "stop and ask the human", progress
is tracked in the spec file itself); one line saying the Auto formula is the
same pipeline without human gates, used only when the human explicitly asks
AND the project glue enables it; (3) paths via `.agents/project.md`,
doctrine via `.agents/methodology.md`.

### D5 — `bin/chisel.sh`

- `AGENTS_RULES_SRC` / `WORKFLOWS_SRC` → `DISCIPLINE_SRC` +
  `AGENTS_FORMULAS_SRC`.
- `copy_managed_files`: `cp -R socle/agents/formulas` + `cp discipline.md`
  in place of the rules dir and workflows.md.
- `managed_relative_files`: `find .agents/skills .agents/formulas`, plus
  `.agents/discipline.md` (was `.agents/workflows.md`).
- Nothing else moves: adapters, manifest, `check`, `update` semantics and
  the project-owned contract are untouched. **`update` does not delete a v1
  `.agents/rules/`** — removing stale files on an equipped repo is the
  `upgrade-v2` skill's job (parent decision: no heavy machinery in
  `update`).

### D6 — `test/run.sh`

- `assert_full_layout`: rules/workflows assertions replaced by
  `.agents/discipline.md`, `.agents/formulas/` and the two TOMLs; plus two
  new negative assertions (no `.agents/rules`, no `.agents/workflows.md`).
- group 4 (update): also hand-edit a formula file and assert it comes back
  byte-identical to the socle source.
- group 5 (check): hand-edit `.agents/discipline.md` → exit 1, path named.
- NEW group 7 (formula shape, run against the installed tree):
  `version = 1` in both; exactly 3 `type = "human"` in Controlled and 0 in
  Auto; identical ordered step-id lists; a real TOML parse when the
  interpreter has `tomllib` (skipped, and said out loud, when it does not —
  the repo's floor is a bare `python3`); and the neutrality grep (no
  W0/W1/W2 label, no vendor model name) over the files this slice ships.

### D7 — Order of execution

1. Persist this design (done — nothing half-decided crosses the line).
2. `discipline.md`, the two formulas, router v2; delete `rules/` +
   `workflows.md`; fold the retired §6 "where things live" table into
   `000-task-file-template.md` (which owns structure) and repoint its link.
3. `bin/chisel.sh`, then `test/run.sh`.
4. `bash test/run.sh` green + the AC greps.
5. Parity checklist walk on a freshly equipped fixture by an agent with no
   context (dry run, no writes), logged in Notes.
6. Two-axis review (Standards + Spec, parallel, fixed point `e54cfaa`),
   findings applied.
7. Slice + parent statuses, mapping table, CHANGELOG, explicit-path commit.

### Verification

- `bash test/run.sh` → all green, real output pasted in Notes.
- `bash -n bin/chisel.sh`.
- `grep -rn "W0\|W1\|W2"` and a vendor-name grep over the files this slice
  ships → empty.
- `grep -rn "rules/task-\|workflows.md" socle/` → only the three
  out-of-scope residuals (methodology.md, code-review SKILL.md), listed in
  Notes as slice 03/07 debt.
- Both TOMLs parse with a real TOML parser (run locally with a 3.11+
  interpreter even though the suite skips it on older ones).

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

Grilled 2026-08-26 (see parent Notes): formula names = `chisel-controlled` /
`chisel-auto`; the typist-brief rule lives in each profile's "Inputs" section
(slice 02). The point left open at this slice's plan gate — where
persist-the-plan know-how lives — is decided in **D0** above: the `plan` step
description of each formula, no new file.

### Mapping v1 → v2 — every obligation's new home

Sources retired by this slice: `rules/task-creation.md` (TC),
`rules/task-progressing.md` (TP), `rules/task-completion.md` (TX),
`workflows.md` (WF). Recover any of them with
`git show e54cfaa:socle/agents/<path>`. Nothing below is dropped; where a
line's new home is another slice, it says which.

| # | v1 obligation | Source | New home |
|---|---|---|---|
| 1 | Interview first (`grilling`), one question at a time with a recommended answer, facts looked up, decisions to the human | TC 1 | formula step `interview` |
| 2 | `domain-modeling` underneath: glossary terms, ADR only when hard to reverse AND surprising AND a real trade-off | TC 1 | step `interview` (paths via glue §G); the three ADR criteria stay in the `domain-modeling` skill |
| 3 | `prototype` detour when a design question can't be settled on paper | TC 1 | step `interview` + `discipline.md` side lanes |
| 4 | Sketch the seams, prefer existing, the fewer the better, confirm with the human | TC 2 | step `interview` + Controlled gate 1 ("spec approved") |
| 5 | Write the task file from the template, reading gradient, name from the task-id script, workspace/archive paths | TC 3 | step `spec` (structure itself stays in `templates/000-task-file-template.md`) |
| 6 | Sizing check ALWAYS, out loud; yes → its own single slice, no folder; no → `slice-task`; human arbitrates | TC 4 | step `spec`, in-step (parity delta 2) + `slice-task` skill + Controlled gate 1 |
| 7 | Dated changelog line at creation | TC 5 | step `spec` ("dated entry in the project journal declared in §A") |
| 8 | STOP, fresh session, `work on task/slice <file>`; the build must work from the file | TC 6 | step `plan` ("in a FRESH session — the build works from the file") + `discipline.md` 7 |
| 9 | No task file for casual/one-shot work; recognize real work and PROPOSE, never force | TC "default behaviour" | `discipline.md` 5 (the bridge rule) |
| 10 | The rules apply to one-shots too, minus the file bookkeeping | TP preamble | `discipline.md` preamble |
| 11 | Read README + changelog at session start | TP | `discipline.md` 1 (reading list, glue §C) |
| 12 | Read the file fully, plus what it links to | TP | step `plan` |
| 13 | Update the Status | TP | steps `plan` and `close` |
| 14 | 🧑 zones are the human's; never contradicted silently — stop and surface | TP | `discipline.md` 3 (+ the Auto self-check in step `plan`) |
| 15 | Plan first, always | TP | `discipline.md` 2 |
| 16 | **Persist the plan before code**: target section per shape, decisions locked, file tree, seam methods, diagrams, migration notes, TDD order | TP | step `plan` — **D0** |
| 17 | The "Architecture docs (evergreen)" list of pages to write at completion, never inside the task workspace | TP | step `plan` (last clause) + step `close` |
| 18 | Why persisting matters (invisible to review / dependent slices / re-runs) | TP | one line in step `plan`; the full rationale already lives in `methodology.md` |
| 19 | Model policy (named vendor models, don't spawn expensive tiers on big contexts) | TP, WF §0 | abstract tiers on every step role (frontier / mid / cheap); the tier→model cascade is **slice 03**. Vendor names deliberately leave the socle (parent Scope) |
| 20 | Delegation is OFFERED, the human decides, never without a yes | TP | Controlled gate 2 ("plan approved + typist chosen") + step `type` |
| 21 | The brief is artifacts only, never the planning conversation | TP | step `type`; the per-role detail of what each role receives → **slice 02** (profile "Inputs") |
| 22 | The Design must cite its references — the delegate follows links, not vibes | TP | step `plan` |
| 23 | The planner never implements; it reviews the delegate's diff | TP | step `type` ("the Architect never types what it planned") + step `review` (Inspector is never the author) |
| 24 | A delegate that cannot implement from the artifacts = a finding against the plan | TP | step `type` ("if the plan left something to figure out, it goes back to the Architect") + `methodology.md` |
| 25 | The delegation boundary is the plan; the typist never plans or designs | TP | step `type` + `methodology.md` (dex phase table) |
| 26 | Vertical slices, something demoable at each step | TP | step `type` |
| 27 | TDD at the agreed seams (`tdd`): red before green, public interfaces | TP | step `type` + `tdd` skill |
| 28 | Typecheck and tests regularly, full suite at the end | TP | step `type` + step `verify` (gate commands §F) |
| 29 | Where baselines / tasks / evergreen docs live | TP, TX, WF §6 | glue §A/§D + the new "Where each kind of content lives" section of `templates/000-task-file-template.md` |
| 30 | Lint, tests, build at completion | TX | step `verify` |
| 31 | Browser check when UI behaviour changed | TX | step `verify` |
| 32 | Two-axis review (`code-review`): Standards + Spec = the 🧑 zones | TX | step `review` + the `code-review` skill |
| 33 | Fix or report findings before declaring complete | TX | step `review` → Controlled gate 3 ("review arbitration") → step `close` |
| 34 | Re-check your work, clean up | TX | `discipline.md` 4 + step `close` |
| 35 | Status 🟢, ACs ticked, file moved to the archive | TX | step `close` |
| 36 | Dated changelog line at completion | TX | step `close` |
| 37 | Roadmap only when it exists AND a roadmap-level change was made — the human owns it | TX | step `close` |
| 38 | Promote evergreen docs (§D, never the task workspace), start from the architecture index, update the README | TX | step `close` + `methodology.md` (artifact ladder) |
| 39 | Protocol/evergreen pages never brand a temporary rewrite label | TX | step `close` (last line) + `methodology.md` |
| 40 | Vocabulary table (task, slice, seam, plan approval, ready slice, delegate) | WF header | `methodology.md` glossary owns the vocabulary (Task, Slice, Seam, Blocking edge, Frontier = "ready"); "plan approval" is Controlled gate 2 and "delegate" is step `type`. The WF table itself was a second copy — retired, not lost |
| 41 | The ⚙️/🧰 legend (rule files vs skills) | WF header | **retired**: it described the v1 file layout. The 🧑/🤖 zone symbols are defined in the task file template |
| 42 | The decision tree ambient → task? → one session? | WF §1 | `discipline.md` 5 + the sizing check in step `spec`. The W0/W1/W2 node labels are dropped (parent AC) |
| 43 | "Ambient = a task without the file", same discipline minus the artifacts | WF §2 | the whole point of `discipline.md` (preamble + rules 1, 2, 4, 5) |
| 44 | CREATE / WORK step tables and their gates | WF §3 | the seven formula steps + the three gates |
| 45 | Why a fresh build session | WF §3 | step `plan` + `discipline.md` 7 |
| 46 | Big feature: parent + slices, the slice loop, "ready" slices, the file must stand alone | WF §4 | `slice-task` skill (owns slicing and the frontier) + the template's new "Where each kind of content lives" + one formula run per slice |
| 47 | Who thinks / who types, the four phases, "nothing half-decided crosses this line" | WF §5 | `methodology.md` (dex phase table, doctrine) + step `type` + `discipline.md` 2 |
| 48 | Where things live, one task vs parent + slices (table + on-disk tree) | WF §6 | **moved verbatim-in-substance into `templates/000-task-file-template.md`** |
| 49 | Side lanes: broken thing / undecidable design / reading legwork / too foggy / idle improvement / external issues | WF §7 | **`discipline.md` "Side lanes" table** (same six skills, same routing) |
| 50 | Session hygiene: create in one sitting, build fresh, hand off past ~120k tokens | WF §8 | `discipline.md` 7 |
| 51 | Rules of thumb: unsure → stay ambient; the one-session question out loud; most work stays small (~40% one-shot) | WF §9 | `discipline.md` 5 + step `spec` + `methodology.md` (already carries the distribution and the sizing doctrine) |

**Known residuals, owned by later slices** (they point at files this slice
deleted; the Owner scoped them out of here):

- `socle/agents/methodology.md` lines 5, 8, 94, 116 — → slice 07 (doc rewrite).
- `socle/agents/skills/code-review/SKILL.md` line 72 (model policy link) —
  → slice 03 (tiers).
- `PHILOSOPHY.md` lines 6, 125 — → slice 07.

These are the only remaining references to `rules/` or `workflows.md` in the
repo outside `project-management/` (verified by grep, below). Anyone
installing the socle between this slice and slices 03/07 gets those four
pointers dangling — flagged to the Owner, deliberately not fixed here.

### Worklog (2026-08-26)

- Wrote `socle/agents/discipline.md` from the prototype draft: the six ambient
  rules, plus rule 7 (session hygiene, from the retired workflows §8) and the
  side-lanes table (workflows §7). Ledger- and vendor-neutral throughout.
- Wrote the two formulas from the prototypes, with one structural change to
  the prototype: the step bodies are now byte-identical across the two files
  and Auto only APPENDS its "no human here" paragraph to each. The prototype
  abbreviated Auto's descriptions as "Same as Controlled", which would have
  made the file diff much larger than the AC allows.
- Completed the step bodies with everything the mapping table above traces to
  a step (sizing check out loud, the create/build session break and its
  trigger phrases, checkboxes as resume point, roadmap clause, architecture
  index, evergreen promotion, protocol-wording rule).
- Rewrote `socle/templates/AGENTS-block.md` as the v2 router, keeping the
  opening HTML comment (the user-facing doc of the managed-block mechanism —
  a deliverable of v1 slice 03) verbatim. Verified there is still exactly one
  `-->` in the file, so the comment cannot self-terminate early.
- Folded the retired workflows §6 into `socle/templates/000-task-file-template.md`
  ("Where each kind of content lives") and repointed the two references that
  slice deletion would have left dangling (the §6 link, and the "see
  `task-creation` rule" line found by the Standards review).
- `bin/chisel.sh`: `AGENTS_RULES_SRC`/`WORKFLOWS_SRC` → `AGENTS_FORMULAS_SRC`/
  `DISCIPLINE_SRC` in the three places that matter (constants,
  `copy_managed_files`, `managed_relative_files`). Nothing else changed —
  adapters, manifest, `check`, and the managed-vs-project-owned contract are
  untouched.
- `test/run.sh`: layout assertions swapped, two negative assertions added
  (init must never lay down `rules/` or `workflows.md` again), `update` and
  `check` now exercise a formula and `discipline.md`, and a new group 7 for
  the formula invariants and the neutrality greps.

### Verification output

`bash test/run.sh`, real run against the committed fixtures (TMPDIR pointed
at the session scratchpad), with `python3` 3.13 on PATH so the optional TOML
parse actually runs: **103 passed, 0 failed.** On the default interpreter
(3.9, no `tomllib`) the same run is 102 passed, 0 failed plus one printed
`SKIP: TOML parse check` — the suite says so out loud instead of silently
passing.

Group 7 lines, verbatim:

```
-- 7. formulas: shape, gates, neutrality --
PASS: formulas: controlled declares version = 1 (integer)
PASS: formulas: auto declares version = 1 (integer)
PASS: formulas: controlled version is not a quoted string
PASS: formulas: auto version is not a quoted string
PASS: formulas: controlled carries exactly 3 human gates
PASS: formulas: auto carries zero human gates
PASS: formulas: controlled declares step ids at all
PASS: formulas: both declare the same ordered step ids
PASS: formulas: seven steps in controlled
PASS: formulas: auto only ADDS to the shared step bodies (gates + escalation)
PASS: neutrality: no W0/W1/W2 mode label in the recomposed layer
PASS: neutrality: no vendor or model name in the recomposed layer
PASS: neutrality: no ledger backend named in a formula step
PASS: formulas: both parse as TOML (version integer, 7 unique step ids)
```

Both new invariant checks were mutation-tested rather than trusted: removing
one word from an Auto step body makes the "only ADDS" check report a removed
line, and the ledger grep fires on a probe file containing `bd create`.

Greps (AC 3, and the parent's W-label / vendor AC for the files this slice
ships):

```
$ grep -rn -E 'W0|W1|W2' socle/agents/discipline.md socle/agents/formulas/ \
    socle/templates/AGENTS-block.md
(none)
$ grep -rn -iE 'cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai|claude' <same files>
(none)
$ grep -rn -iE '\bbd\b|beads|CHANGELOG' socle/agents/formulas/
(none)
$ grep -rn -E 'rules/task-|workflows\.md|\.agents/rules' socle/ bin/ test/ README.md PHILOSOPHY.md AGENTS.md
→ only the four out-of-scope residuals listed above (methodology.md ×4,
  code-review/SKILL.md ×1, PHILOSOPHY.md ×2) and the test assertions that
  check those paths are ABSENT from an equipped repo.
```

`bash -n bin/chisel.sh` and `bash -n test/run.sh` → syntax OK.
`chisel update` then `chisel check` on the equipped scratch fixture → the
five recomposed files re-render and check reports `clean — no divergence`.

### Parity checklist walk — no-ledger session on an equipped fixture (AC 4)

Method: a throwaway JS project (`toy-utils`: README, `package.json` with
lint/test/build scripts, one source module) equipped with `chisel init` from
this working tree — no ledger tooling installed anywhere. Then an agent
session with **zero context about the project or about this slice** was given
the fixture path and one request, "add a slugify function with tests", and
asked to report — read-only, writing nothing — what the repo's own
instructions route it to, citing the file and line for every step. Two runs:
one before the review fixes, one after.

Route actually taken by the fresh session: `CLAUDE.md` → `AGENTS.md` block →
`.agents/discipline.md` → reading list `.agents/project.md` §C → bridge rule
(rule 5: this is real scoped work) → `chisel-controlled.formula.toml` as a
checklist. It executed the seven steps in `needs` order and stopped at
exactly three points.

| Parity dimension (`../factory-bench/prototypes/parity-report.md`) | Result of the walk |
|---|---|
| **Sequence** | qualification → interview (`grilling` + `domain-modeling`) → spec file from the template with the task-id script → sizing check out loud (answer: fits one pass, no slicing) → dated changelog entry → SESSION BREAK → persisted plan → typist → TDD at the seam → §F gate commands → two-axis review → close/archive/changelog/evergreen docs. Every step cited to its source (formula step, discipline rule, or skill). Zero steps invented, zero skipped |
| **Stop points** | the 3 human gates, at the designed places: before `plan` (spec approved), before `type` (plan approved + typist), before `close` (review arbitration). The walker also noted the finer per-question stops that the `grilling` skill itself imposes inside `interview` — the same "gates diluted in the interview prose" that arm A of the bench showed, now explicitly attributed to the skill |
| **Session break** | found and cited: the `spec` step's STOP plus the `plan` step's "in a FRESH session", reinforced by discipline rule 7. This is the one dimension the FIRST run did not surface — the fix came from the review, and the second run confirms it |
| **Artifacts** | template-conform task file in the workspace, dated changelog line, status/checkbox tracking in the spec file, glossary/ADR lazily via `domain-modeling`, evergreen promotion at close — all resolved through the glue, no hardcoded path |
| **Verification** | TDD red-before-green during `type`, typecheck + touched tests as you go, full lint/test/build at `verify`, then the two-axis review with a pinned fixed point and no re-ranking |

Two observations from the walk that are NOT slice-01 defects: the fixture's
`.agents/project.md` §F still says "none configured" (the setup
questionnaire, slice 04, is what fills it — `init` alone cannot), and
`methodology.md` still points at the retired files (residuals above). The
real pilot on a real repo with a human at the gates stays the parent's
AC 3, in slice 06.

### Two-axis review (2026-08-26, fixed point `e54cfaa`)

Run per `skills/code-review`: two sub-agents in parallel, Standards and Spec
(the spec being the 🧑 zones of this slice and of the parent), aggregated
without re-ranking. Findings and their disposition:

**Applied**

| Axis | Finding | Fix |
|---|---|---|
| Spec | The create/build **session boundary** had no home: no step tells the creating session to stop, the trigger phrases `work on task/slice <file>` had disappeared from the socle, and the router's "execute as an ordered checklist top to bottom" read as one continuous session | added the STOP + both trigger phrases to the `spec` step of both formulas; the router now says the pipeline spans more than one session |
| Spec / Standards | "Run typechecking regularly, single test files regularly, full suite at the end" (TP) had no home — `verify` is end-of-pipeline only | added to the `type` step of both formulas |
| Standards | `socle/templates/000-task-file-template.md` still said "(see `task-creation` rule)" — a pointer to a file this slice deletes, in a file this slice edits | repointed to the formula's `interview` step; templates now grep clean |
| Standards | Two bare `grep`s writing step-id files would abort the suite under `set -euo pipefail` with no FAIL line if they ever matched nothing | guarded with `|| true` (symmetrically on both gate counts too) plus a non-empty assertion |
| Standards | The neutrality loop word-split an unquoted newline-delimited list — a repo path containing a space would break it | iterate over relative literals, join to `$REPO_ROOT` inside the loop |
| Standards | The `AGENTS-block` restated discipline rules 1–2 inside a block whose own last line says it "only routes" | trimmed to a pointer; the ambient core is stated once, in `discipline.md` |
| Standards | Group 7's comment claimed to run against the installed tree while the neutrality greps read the socle sources | comment corrected, and it now says why later-slice files are excluded |
| Standards | The "most work should stay small / if everything becomes a big feature the method has failed" calibration (WF §9) had no home | added to `discipline.md` rule 5 |
| Spec | AC3's ledger half was never asserted by a test (only vendor names and W-labels were) | new assertion: no ledger backend word in a formula step (mutation-tested) |
| Spec | AC2's "diff = gates + escalation only" was maintained by hand, not by a test | new assertion: every Auto step body is the Controlled body with lines ADDED and none removed (mutation-tested) |
| Parity walk | "the project journal declared in §A" — §A has no field named *journal*; the walker had to guess it meant Changelog | wording aligned with the glue's actual field name in both formulas and in `discipline.md` |

**Declined, with reason**

- *Standards: the hardcoded `7`/`3`/`0` in group 7 is Duplicated Code.* These
  are the invariants under test (seven steps, three gates, zero gates) —
  writing them once as a variable would make the test assert its own input.
  Changing the pipeline SHOULD break three assertions.
- *Standards: `assert_path_absent .agents/rules` can never fail.* It fails the
  moment someone re-adds a `cp -R rules` to `copy_managed_files` — which is
  exactly the regression it guards. It is not a test of `update`'s behaviour
  on a v1 repo (that is slice 06's `upgrade-v2`).
- *Standards: the neutrality grep excludes `methodology.md`, which still ships
  vendor model names.* Deliberate: that file belongs to slices 03 and 07. The
  test comment now says so.
- *Standards: workflows §5's think/type diagram is lost.* Its doctrine (the
  four phases, their owners, what is delegable) is `methodology.md`'s
  dex-phase table, which is unchanged; the diagram was a second rendering.
- *Both axes: dangling pointers in `methodology.md`, `code-review/SKILL.md`
  and `PHILOSOPHY.md`.* Real, and recorded above as residuals — the Owner
  scoped those three files to slices 03 and 07.
