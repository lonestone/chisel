# 04 — Skills follow

**Status:** 🟡 In Progress (typed and diff-reviewed 2026-09-02; commit and close pending)
**Blocked by:** 02 — doctrine follows (complete 2026-09-02). The review skill
judges "the whole spec document" as the doctrine slice defines it. Shares no
file with slice 3 (complete) or slice 5.

**What to build:** the four skills that still speak the one-document model
teach the split instead: the review skill judges the whole spec document with
the work document as evidence; the slicing skill publishes spec documents and
emits a template with no Design section; the beads and retro skills name the
right document for each artifact; and the three vendored skills record the
divergence in their `x-upstream` block.

## Acceptance criteria

This slice owns four parent criteria in full and contributes the final share
to one task-closing check; full wording and the governing system design stay
in `project-management/tasks/20260828-2217-split-spec-and-work-documents.md`,
§Acceptance Criteria.

- [ ] **spec-axis-judges-the-whole-spec** (owned in full) — `grep -n
  "Context, Scope, Acceptance Criteria, Seams"
  socle/agents/skills/code-review/SKILL.md` returns nothing; the skill's
  spec-source and Spec sub-agent steps make the whole spec document, system
  design included, the requirement, and the work document evidence only — a
  divergence between the two designs being a finding to judge.
- [ ] **slice-task-emits-spec-documents-only** (owned in full) — `grep -n
  "Design — persisted at plan time" socle/agents/skills/slice-task/SKILL.md`
  returns nothing; each slice is published as `<NN>-<slug>.spec.md`, the
  emitted template carries no Design section, and it says the implementing
  session creates the matching work document at its `plan` step.
- [ ] **beads-and-retro-name-the-right-document** (owned in full) — `grep -n
  "the persisted Design" socle/agents/skills/chisel-beads/SKILL.md` and
  `grep -n "The spec file's persisted Design, implementation checkboxes"
  socle/agents/skills/retro/SKILL.md` both return nothing, while `grep -n
  "spec-id" socle/agents/skills/chisel-beads/SKILL.md` still matches; the
  beads skill's "1 · What owns what" gives intent, acceptance criteria and
  seams to the spec document and program design plus checkboxes to the work
  document; `--spec-id` still points at the spec document.
- [ ] **upstream-notes-tell-the-truth** (owned in full) — the `changes` field
  of the `x-upstream` block of `code-review`, `slice-task` and `retro`
  records the divergence this task adds. `chisel-beads` is our own and has
  none.
- [ ] **no-file-says-the-spec-file** (final share of the parent task's
  closing check — this slice contributes, never closes) — after this slice,
  `grep -rn "the spec file" socle/` returns nothing but formula-free: the
  last non-formula occurrence is `socle/agents/skills/retro/SKILL.md:42`, and
  slice 3 already emptied the formulas, so this share should leave the
  repo-wide grep at zero. The retro line is a **re-pointing, not a rename**
  (recorded proposal from slice 02): blockers now live in the task's
  documents, so the Sources line must say where they actually are.
- [ ] **suite-green** (slice share) —
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passes with zero
  failures.

## System design

The parent spec's Architecture and Implementation Decisions are settled
input. The doctrine landed at `863094c` (methodology, discipline, profiles)
and the formulas landed at `fd1dc95` are the wording these skills must agree
with:

- `code-review/SKILL.md` — the Spec axis stops enumerating four sections:
  the whole spec document, system design included, is the requirement; the
  work document (program design, worklog) is evidence only, and a divergence
  between the two designs is a finding, never a requirement to judge against.
  The spec-source lookup names the spec document and its matching work
  document by the landed convention (`.spec.md` / `.work.md`).
- `slice-task/SKILL.md` — publishes `<NN>-<slug>.spec.md` files; its emitted
  slice template loses the Design section and the agent zone; it states the
  implementing session creates the matching work document at `plan`.
- `chisel-beads/SKILL.md` — "1 · What owns what" reflects the two-document
  split; the worked example uses the `.spec.md` suffix; `--spec-id` keeps
  pointing at the spec document (parent decision 6: no `work-id` pointer).
- `retro/SKILL.md` — its "Sources" section names the work document for the
  worklog and program design, and re-points the blocker line: blockers live
  in the task's documents (implementation → work document; pre-`plan` → spec
  Notes), per amended discipline rule 6 — no journal line, no escalation
  bead.
- The three vendored skills (`code-review`, `slice-task`, `retro`) update
  the `changes` field of their `x-upstream` block to record the divergence;
  `chisel-beads` has none.
- Where a skill touches blocker reporting, same dedup rule as everywhere:
  one line plus a pointer to `.agents/methodology.md` ("Escalation, and the
  blocked-task report"), in the installed path form — never `socle/…`, never
  a restated rule.
- No 🤖 zone survives in any of the four skills' text or emitted templates
  (G14 point 7).

## Files map

**Modify:** `socle/agents/skills/code-review/SKILL.md`,
`socle/agents/skills/slice-task/SKILL.md`,
`socle/agents/skills/chisel-beads/SKILL.md`,
`socle/agents/skills/retro/SKILL.md`.

**Avoid:** the formulas, the profiles, the templates, `bin/`, `test/`, every
other skill, and the other files of the four skill directories (notably
`chisel-beads/CHANGING-CASE.md` — the blocked-status gap recorded by slice 02
stays an unowned proposal, not this slice's work). Shares no file with
slice 3 or slice 5.

## Verification

- Socle text seam: the criteria greps above, plus
  `grep -rn "the spec file" socle/` (expect zero repo-wide after this slice),
  `grep -rn "AGENT ZONE\|🤖" socle/agents/skills/` on the four directories,
  and a cross-file read of the four skills against the landed doctrine and
  formulas for step-by-step consistency.
- Installer seam: `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — no
  test change expected.

## References

- Parent system design and decisions:
  `project-management/tasks/20260828-2217-split-spec-and-work-documents.md`,
  §Architecture, §Implementation Decisions, the slice-4 entry of §Slices &
  Dependencies, and the four criteria named above.
- Owner rulings: `project-management/review-360-decisions.md`, G14, G15
  (Addendum 3), G16/G17 (Addendum 4).
- Precedents: slices 02 and 03 in this folder — the landed doctrine and
  formula wording these skills must agree with.

---

---

> 🧑 **REVIEW IF RELEVANT** — program design, persisted at plan time.

## Design — persisted at plan time

Persisted at the `plan` step by `mason`, 2026-09-02 17:34. Written under the
parent spec's §Implementation Decisions, decision 10: this combined plain
`.md` artifact temporarily serves as this slice's work record, so the program
design, the implementation checkboxes and the worklog live in this section
until slice 05 migrates the convention. Signed role plus date and time, the
way `socle/agents/methodology.md` ("Escalation, and the blocked-task report")
requires of everything written into a task's documents.

No code is typed at `plan`. Validation of this design is the Architect's at
`plan-review`; the Owner's go comes after it. Per ruling G16
(`project-management/review-360-decisions.md`, Addendum 4) the same Mason
carries the plan, the plan-review corrections and the typing.

**Revised at `plan-review` round 1 by `mason`, 2026-09-02 18:02** — the
Architect returned NOT VALIDATED on round 1: one blocking defect, seven
non-blocking adjustments, everything else validated (the counts, the suite
constraints, the task-citation claim, and rulings (a), (b), (d), (e), (f),
(g)). What this revision changed: **ruling (c) is replaced** — round 1 had
the emitted slice template carry ONE 🧑 banner, which re-decided an Owner
ruling (G14 point 7: the spec document keeps its **two** 🧑 zones) and, worse,
erased a boundary the landed spec template had already drawn by assigning
`## Notes` to REVIEW IF RELEVANT; the template now emits both zones, and the
"a slice that grows a second half" sentence is gone with the reasoning that
produced it. §2's slice-task rows and untouched list are recomputed against
that correction, including the blank-line footprint the deletions leave. §0
names the two recursive greps the suite runs over the whole installed tree
and corrects "nothing checks their prose"; the forbidden-literals list
declares which entries actually bind and which are belt. §3 gains the
task-citation criterion. Root cause of the blocking defect, named so it is
not repeated: round 1 reasoned about the reading gradient from the *shape of
the artifact* ("a five-section stub has no honest boundary") instead of from
the ruling and the landed template that already answer it — a 🧑 zone is never
re-decided by the Mason, in any mode, and "the boundary is not obvious" is a
reason to go read where it was drawn, never to draw it.

### 0 · What was read, and the state it was read in

The slice document above (six criteria, System design, Files map,
Verification); the parent spec
`project-management/tasks/20260828-2217-split-spec-and-work-documents.md`
(§Architecture with its section-boundary table and naming rule,
§Implementation Decisions 1, 2, 5, 6, 7, 11 and 12, the slice-4 entry of
§Slices & Dependencies, the four criteria this slice owns, and §Notes &
Snippets for the verified grep counts and the two fictional task paths); the
doctrine landed at `863094c` — `socle/agents/methodology.md` (Glossary, "Zone
ownership", "Escalation, and the blocked-task report", "The two designs",
"Why a two-axis review at completion", "Artifact ladder") and
`socle/agents/discipline.md` rules 2, 6, 7 and 12 plus "The pipeline, for
real scoped work"; the four profiles, `mason.md` and `inspector.md` in full;
the formulas landed at `fd1dc95`, `chisel-default.formula.toml` in full as the
reference wording for the `plan`, `diff-review` and `close` steps these
skills echo; the two templates `socle/templates/000-template.spec.md` and
`000-template.work.md`; `socle/agents/project.md.tpl` §A · Task workspace and
§B1 · Where task statuses live; the Owner's rulings G14, G15, G16 and G17 in
`project-management/review-360-decisions.md`; the four skills in full; and
`test/installer.sh` (the managed-file drift group, and the "no pointer into
thin air" integrity check).

**Gate baseline confirmed before designing**, on the pre-work tree:
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` → **9 scenarios, 94
assertions passed, 0 failed**, suite at 592 lines of its 600-line cap.

**What the suite asserts about these four files, and therefore what this
design must not disturb.** No assertion reads these files for what they
teach: the only ones that NAME a skill are the managed-file drift checks,
which append a marker to the installed copy of `code-review/SKILL.md` and
demand `chisel check` reports it — content-agnostic, since the checksums
derive from the socle source. But two assertions do grep the whole installed
`.agents/` tree recursively, so they read these four files along with
everything else, and three mechanical constraints bind:

- **Installed-pointer integrity.** Every `.agents/…` path written in the text
  must resolve in the INSTALLED tree; `socle/…` paths never match the check's
  pattern, so the design must guard the installed form itself. All the paths
  this design writes are already installed: `.agents/project.md`,
  `.agents/methodology.md`, `.agents/profiles/mason.md`. Markdown links to a
  SIBLING file are also checked — `chisel-beads`' two links to
  `CHANGING-CASE.md` resolve and stay untouched, and no new sibling link is
  written. No text may name `.agents/workflows.md` or `.agents/rules/task-*.md`:
  a separate assertion pins `upgrade-v2` as their only licit citer.
- **Two recursive content greps over the installed tree.**
  `grep -rq "to-lessons"` (`test/installer.sh:276`) must find nothing — the
  old name of `retro`, which none of my replacement text writes — and
  `grep -rqE "40 lines|8 lines|half of the slice|half the spend|target ~"`
  (`:281`) must find nothing, the no-invented-numeric-limit rule. Neither is
  at risk from this design: it writes no figure at all, and names `retro`
  only by its current name. They are listed because they are the two
  assertions that would actually catch a careless sentence here.
- **The line cap** applies to `test/` only, and no test changes.

**Forbidden literals — strings this design must never write into `socle/`.**
Checked against my own replacement text before typing, and sorted by what
actually binds:

- **Binding, repo-wide or socle-wide, so a careless sentence anywhere in the
  four files breaks a criterion:** `the spec file` (this slice's own closing
  share), `Design section` — already at **zero** across `socle/`, a live
  tripwire, which is why a rewritten paragraph says "carries no program
  design" and never that phrase — and `AGENT ZONE` / `🤖`, greped over
  `socle/agents/skills/`.
- **Binding, but only on the file the criterion names:**
  `Context, Scope, Acceptance Criteria, Seams` (code-review), `Design —
  persisted at plan time` (slice-task), `the persisted Design`
  (chisel-beads), `The spec file's persisted Design, implementation
  checkboxes` (retro).
- **Belt, not binding here, and named so nobody mistakes them for
  criteria:** `checkboxes in {{spec}}` is scoped to `socle/agents/formulas/`,
  `Criterion 1` to `socle/templates/000-template.spec.md` (which is why the
  placeholder rename of §4(e) is a doctrine-consistency ruling and not a
  criterion), and `000-task-file-template` appears in none of these four
  files. They stay on the list as a belt, at no cost.

### 1 · Program design — the target shape of the four skills

Stated once here; §2 turns it into per-file edits. Three rules govern every
edit, so they are not repeated per file:

**(a) The vocabulary rule.** Only "the spec file" is retired outright. "Task
file(s)", plural or generic, stays: `socle/agents/project.md.tpl` §B1 itself
says "Work is tracked as task files in this repo", and a task now genuinely
has two files. So a "task file" mention is edited **only where the sentence
says which of the two documents owns something** — that is where the phrase
has become false. Generic mentions (where work lives, what git syncs, what a
user may pass as an argument) are left, and §2 names each one it leaves.

**(b) The dedup rule for blocker reporting.** Where a skill touches blockers
it gets one line plus a pointer to `.agents/methodology.md` ("Escalation, and
the blocked-task report"), in the installed path form, and never restates the
rule. Only `retro` touches blockers; `code-review`, `slice-task` and
`chisel-beads` mention them nowhere and gain no such line.

**(c) No agent zone survives** (G14 point 7) — not in the skills' text, not in
the template `slice-task` emits.

**`code-review` — the Spec axis judges the whole spec document.** The
enumeration of four sections goes, and with it the sentence that made the
agent zone "context, not requirements" — there is no agent zone to demote.
What replaces it, in the landed `diff-review` wording of the formulas: the
requirement of the Spec axis is the WHOLE spec document, system design
included; its matching work document is handed over as **evidence only**,
never a reference to judge against; and a divergence between the spec
document's system design and the work document's program design is **a finding
to judge**, reported as such. The spec-source lookup names the pair by the
landed convention — `<name>.spec.md`, with `<name>.work.md` beside it — and
says that a closed task's pair sits in the archive together, since `close`
archives both. The Spec sub-agent's brief gains the divergence clause and
labels the two paths it receives, because that sub-agent has no other access
to the distinction. The Standards axis, the smell baseline, the tier cascade
and the aggregation step are untouched.

**`slice-task` — publishes spec documents, and emits no program design.** The
publishing step writes `<NN>-<slug>.spec.md`, states that no work document is
created at slicing time, and says the implementing session creates the
matching `<NN>-<slug>.work.md` beside the slice at its `plan` step, from the
work template declared in §A · Task workspace of `.agents/project.md`.

The emitted template loses the program-design heading, its one-line body and
the agent zone that followed, and it **emits both 🧑 zones**, because a slice
document is a spec document and the Owner's ruling G14 point 7 gives the spec
document exactly two: REVIEW CAREFULLY, then REVIEW IF RELEVANT. The boundary
is not invented here — the landed `socle/templates/000-template.spec.md`
draws it, and it puts `## Notes` on the REVIEW IF RELEVANT side. So: a
REVIEW CAREFULLY banner follows the title and the Status block, mirroring the
spec template, and covers what to build and the acceptance criteria; the
existing separator and banner before the deleted heading are **kept**, the
banner re-worded to REVIEW IF RELEVANT and scoped to what precedes the work
document; `## Notes` stays under it, re-scoped the way the spec template
scopes it — only what is written before the work document exists (the spec
review's findings, a pre-`plan` blocker), explicitly not the Mason's working
space. The trailing paragraph that justified a program design in the slice
file is rewritten to send that material to the work document instead. The
vertical-slice rules, the wide-refactor/expand–contract passage, the quiz step
and the stale-paths paragraph are untouched.

**`chisel-beads` — "1 · What owns what" reflects the two documents.** The bead
still owns coordination BETWEEN tasks, word for word. What changes is the
other side of the line: the task's own **documents** own everything else — the
spec document owns intent, acceptance criteria, seams and the system design;
the work document the implementing session creates at `plan` owns the program
design and the implementation checkboxes, which are the resume point when a
session dies. `--spec-id` keeps pointing at the spec document and no second
pointer is invented (parent decision 6); one sentence says why the work
document needs none — its path is the spec's with `.work.md` in place of
`.spec.md`. The worked example's `Spec:` line takes the `.spec.md` suffix,
which is the mid-task change the parent spec's §Notes & Snippets predicted for
the fictional path it allows. The `--actor` four-role list is left alone
(parent decision 11), the validation/`bd lint` passage keeps its meaning with
one noun corrected, and sections 3, 4 and 5 are untouched.

**`retro` — the Sources name the right document, and the blocker line is
re-pointed.** The corroborating list becomes a pair: the spec document (its
decisions and its pre-`plan` Notes) and its work document (program design,
implementation checkboxes, worklog, Notes & Snippets, the Inspector's
findings), then the diff and commits, then the journal entry. The blocker line
is a **re-pointing, not a rename** (the proposal slice 02 recorded): a
retrospective looks for a blocker where the task keeps it — implementation
blocker in the work document, pre-`plan` blocker in the spec document's Notes,
each signed role plus date and time, the ruling on it recorded in the same
place — and the line says plainly that there is **no journal line and no
separate escalation item to look for**, which is what G15 retired. Form and
destinations by pointer, per rule (b). The Primary source (transcripts), the
seven improvement categories, the target-file resolution step and the Files
reference are untouched.

**The three `x-upstream` blocks** get one honest sentence each recording this
fork's divergence, appended to the existing `changes` string rather than
replacing its history: `code-review` — the spec source is the task's spec
document, whole and system design included, with the work document as evidence
only; `slice-task` — publishes one `.spec.md` per slice and emits no program
design, the implementing session creating the `.work.md` at `plan`; `retro` —
sources name the spec/work pair, and a blocker is read where the task's
documents keep it rather than in the journal. `chisel-beads` is ours and has
none.

### 2 · Target edits, by carrier

Line numbers are the pre-work state, verified by reading each file whole at
`plan`. Every range not listed as edited is **untouched**, and the untouched
ranges are named explicitly so a reviewer can check the footprint.

**`socle/agents/skills/code-review/SKILL.md` (104 lines).**

| Lines | Now | Target |
|---|---|---|
| 3 | `description`: "Spec (does the code match what the originating issue/PRD asked for?)" | "…what the task's spec document asked for?" — the trigger phrases of the same line stay verbatim |
| 8 | `changes: "adapted: spec source is the task file, …"` | records this task's divergence (§1, last paragraph) |
| 14 | "does the code faithfully implement the originating issue / PRD / spec?" | "does the code implement the whole spec document, system design included?" |
| 35–39 | item 2 of "Identify the spec source": "The task file for the current work … The task file's 🧑 zones (…four sections…) are the spec; its 🤖 agent zone is context, not requirements." | the task's spec document `<name>.spec.md` under the workspace declared in `.agents/project.md`, or its archive where a closed pair sits together; the WHOLE spec document is the requirement, system design included; the matching `<name>.work.md` beside it is evidence only, and a divergence between the two designs is a finding |
| 86 | Spec sub-agent input: "The path or fetched contents of the spec." | the two labelled paths — spec document (requirement), work document (evidence only, when one exists) |
| 87 | the Spec brief, three questions (a)(b)(c) | same three, plus (d): a divergence between the spec document's system design and the work document's program design is a finding; never judge the diff against the program design |
| 89 | "If the spec is missing…" | "If no spec document is found…" |

*Untouched:* 1–2, 4–7, 9–13, 15–19 (including line 18's generic "task files"
and its `Tracker section` pointer — rule (a), and see §4), 20–34, 40–85, 88,
90–104.

**`socle/agents/skills/slice-task/SKILL.md` (134 lines).**

| Lines | Now | Target |
|---|---|---|
| 9 | `changes: "adapted: publishes slices into the task folder; …"` | records this task's divergence |
| 85 | default path `…/<NN>-<slug>.md` | `…/<NN>-<slug>.spec.md` |
| 87–88 | "The parent task file (if one exists) stays in place and links to the slice folder." | "The parent spec document (if one exists) stays in place and links to the slice folder." + one sentence: no work document is created at slicing time; the implementing session creates `<NN>-<slug>.work.md` beside the slice at its `plan` step, from the work template declared in §A · Task workspace of `.agents/project.md` |
| 105–106 | `- [ ] Criterion 1 (machine-verifiable)` ×2 | named criteria, the landed spec template's rule: `- [ ] **descriptive-name** (machine-verifiable)` ×2 |
| 95–98 | template head: title, then the Status and Blocked-by block ("What to build" is 100–101 and is untouched) | the four lines themselves unchanged; **after 98**, insert blank + `---` + blank + `> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.`, mirroring `socle/templates/000-template.spec.md:71–75`. The banner FOLLOWS the title and the Status block; it is never placed above the title |
| 108–110 | `---`, blank, `> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).` | **KEPT.** Only the banner text changes: re-worded to scope the zone to what is written into the slice document before its work document exists — which is `## Notes`, exactly where the landed spec template's zone table puts it |
| 112–119 | `## Design — persisted at plan time`, blank, its one-line body, blank, `---`, blank, the agent-zone banner, blank | deleted as one block |
| 120–122 | `## Notes` — "_Wiring, migration notes, TDD order, worklog — filled during implementation._" | `## Notes` kept where it is, under the REVIEW IF RELEVANT banner, re-scoped: only what is written before the work document exists — the spec review's findings, a pre-`plan` blocker; not the Mason's working space, whose notes, snippets and worklog live in the work document |
| 132–134 | "The **Design** section is different: it is written at PLAN time…" | rewritten: this document carries no program design; the target shapes, signatures and illustrative snippets are written at `plan` into the matching `.work.md`, which also holds the worklog and the implementation checkboxes |

**Blank-line footprint of the template edit**, stated so `diff-review` can
check it without re-deriving it. The insertion after 98 adds
`blank / --- / blank / banner`, and line 99's existing blank then separates
the banner from "What to build" — the same spacing as
`socle/templates/000-template.spec.md:71–77`. The deletion takes 112–119 as
one block: that is both blanks which flanked the deleted body (113, 115) and
both which flanked the agent banner (117, 119), while line **111's blank
survives**, so the REVIEW IF RELEVANT banner is followed by exactly one blank
line and then `## Notes`. Net on the emitted template: four lines in, eight
out, no double blank line anywhere, and every `---` separator still flanked
by one blank line on each side.

*Untouched:* 1–8, 10–24 (including line 17's `Tracker section` pointer and
line 24's generic "a task file path" — rule (a), and see §4), 25–84, 86,
89–94, 95–99 apart from the four lines inserted after 98, 100–104, 107, 111,
123–131.

**`socle/agents/skills/chisel-beads/SKILL.md` (211 lines).**

| Lines | Now | Target |
|---|---|---|
| 31–35 | "**The task file owns everything else, including progress INSIDE the task.** Intent, acceptance criteria, seams, the persisted Design — and the implementation checkboxes…" | "**The task's own documents own everything else…**": the spec document owns intent, acceptance criteria, seams and the system design; the work document created beside it at `plan` owns the program design and the implementation checkboxes, the resume point when a session dies. Neither moves into the database; a bead is a coordination record, not a copy of the spec |
| 38–39 | "the bead should be pointing at the file that already says it" | "…at the document that already says it" |
| 48 | `--spec-id "<path to the task file, from the repo root>"` | `"<path to the task's spec document, from the repo root>"` |
| 53–55 | "**`--spec-id` is the whole link.** … pointing at the specification document." | kept, plus one sentence: the work document beside it needs no pointer of its own — its path is the spec's with `.work.md` in place of `.spec.md` |
| 56 | "They live in the file `--spec-id` names." | "…in the spec document `--spec-id` names." |
| 75 | worked example `Spec:` line, `…/01-thing.md` | `…/01-thing.spec.md` |
| 96 | "keeps the acceptance criteria in the task file on purpose" | "…in the spec document on purpose" |

Rule (a) promised that §2 names every generic "task file" mention it leaves,
so here they are, all three deliberate: line 9 ("While §B1 says they live in
the task files") quotes `socle/agents/project.md.tpl` §B1's own words and
would diverge from the file it quotes if edited; line 20 ("converting
existing task files") is about the CHANGING-CASE procedure, which converts
both documents of a task; and line 146 ("the task files are git's business")
is true of the pair and reads better plural — nothing there says which of the
two documents owns anything.

*Untouched:* 1–30 (including line 9's quotation of §B1's own "task files" and
line 20's CHANGING-CASE sentence), 36–37, 40–47, 49–52, 57–74, 76–95, 97–211
— the whole of sections 3, 4 and 5, the `--actor` four-role bullet (parent
decision 11), the `bd lint` passage apart from line 96, and both links to
`CHANGING-CASE.md`, which stays out of this slice's map entirely.

**`socle/agents/skills/retro/SKILL.md` (115 lines).**

| Lines | Now | Target |
|---|---|---|
| 8 | `changes:` — its sources clause reads "(spec file, worklog, diff, journal entry)" | the clause names the spec/work pair, and the string gains the one sentence of §1 recording this task's divergence |
| 38 | "The spec file's persisted Design, implementation checkboxes, and Notes — including whatever was noted without stopping along the way." | split into two bullets: the **spec document** — its decisions and its Notes, written before a work document existed; and its **work document** — program design, implementation checkboxes, worklog, Notes & Snippets and the Inspector's findings, including whatever was noted without stopping along the way |
| 39 | "The worklog and the journal entry it produced." | "The dated journal entry the close produced." — the worklog is named in the work-document bullet, so it is not claimed twice |
| 42 | "Any blocker or escalation written into the spec file." | the re-pointing: any blocker, and the ruling on it, where the task keeps it — implementation blocker in the work document, pre-`plan` blocker in the spec document's Notes, each signed role plus date and time; form and destinations in `.agents/methodology.md` ("Escalation, and the blocked-task report"); no journal line and no separate escalation item to look for |
| 98 | "The implementation session (Architect planning, Mason typing)" | "(the Mason designing its program design at `plan`, then typing it)" — the landed doctrine gives the plan to the Mason and the `plan-review` verdict to the Architect. Out-of-criterion truth fix, ruled under §4(e) with lines 3 and 14 of `code-review` |

*Untouched:* 1–7, 9–37 (the whole Primary-source passage), 40–41, 43–97, 99–115
— the seven improvement categories, the target-file resolution step, the
nothing-is-auto-applied rule, and the Files reference.

### 3 · Implementation order, and the resume point

One file at a time, in the slice document's own order, `retro` last because it
is the file that takes the repo-wide grep to zero — running that grep straight
after its edit is the cheapest proof. The checkboxes below ARE the resume
point: a fresh Mason restarts at the first unticked one.

- [x] 1 · `code-review/SKILL.md` — lines 35–39 first (the criterion's grep),
  then 86–89, then 3, 14, 8. Re-read the file whole afterwards: the Spec axis
  must say the same thing in the description, the axis definition, the
  spec-source step and the sub-agent brief.
- [x] 2 · `slice-task/SKILL.md` — the emitted template first, **95–122**:
  the insertion point is after 98, and 93–94 (`<slice-template>` and its
  blank) are untouched, so the surgery's footprint is exactly §2's. Then the
  publishing step (85–88), then 105–106, then 132–134, then 9.
- [x] 3 · `chisel-beads/SKILL.md` — 31–39, then 48–56, then 75, then 96.
- [x] 4 · `retro/SKILL.md` — 38–42 first, then 8, then 98.
- [x] 5 · The four owned criteria greps, run and pasted into the worklog:
  `grep -n "Context, Scope, Acceptance Criteria, Seams" socle/agents/skills/code-review/SKILL.md`,
  `grep -n "Design — persisted at plan time" socle/agents/skills/slice-task/SKILL.md`,
  `grep -n "the persisted Design" socle/agents/skills/chisel-beads/SKILL.md`,
  `grep -n "The spec file's persisted Design, implementation checkboxes" socle/agents/skills/retro/SKILL.md`
  — all four empty; plus `grep -n "spec-id" socle/agents/skills/chisel-beads/SKILL.md`,
  which MUST still match, and the three `changes` fields read back.
- [x] 6 · The slice's share of the closing checks:
  `grep -rn "the spec file" socle/` → zero repo-wide (this slice's share is
  the last non-formula carrier), `grep -rni "spec file" socle/` on the four
  directories for the stricter form, `grep -rn "AGENT ZONE\|🤖" socle/agents/skills/`
  → zero, and `grep -rn "Design section" socle/` → still zero (the sibling
  criterion my own replacement text must not break). Plus the parent
  criterion **no-task-citation-points-at-a-missing-file**, which this slice
  moves: re-suffixing the worked example at `chisel-beads/SKILL.md:75`
  changes one of the two fictional paths the criterion allows, so its command
  (copied whole from the parent spec) must print **exactly two** lines — the
  payroll path unchanged, and the beads example in its new `.spec.md` form —
  and no third. Run it before and after the beads edit, and paste both
  outputs into the worklog: it is the one criterion whose expected output
  this slice is supposed to change.
- [x] 7 · Cross-file read of the four skills against the landed doctrine and
  formulas: same requirement/evidence split as `chisel-default`'s
  `diff-review` and `socle/agents/profiles/inspector.md`; same document
  boundary as the two templates; every path written in its installed
  `.agents/…` form; no contract restated that a profile or a formula already
  owns.
- [x] 8 · `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — expect 9
  scenarios, 94 assertions, 0 failed, unchanged from the baseline. Zero test
  changes are expected; a needed test change is a finding, not a fix.
- [ ] 9 · Commit — the thread owner's call. Left unticked unless it orders
  otherwise: the precedent of slice 03 was to leave the diff uncommitted so
  the Inspector reviews the working tree at `diff-review`.

Files-to-modify, complete and closed: the four `SKILL.md` files named in the
Files map. Nothing else — no other file of those four directories
(`chisel-beads/CHANGING-CASE.md` included, an unowned proposal), no other
skill, no formula, no profile, no template, no test, no glue. A needed touch
outside that map is not typed: it goes to the worklog and to my spawner
through the proposal door.

### 4 · Rulings — the sensitive spots, decided rather than improvised

No open question survives this design. The four spots the work order named
are ruled here, with three more the reading raised.

- **(a) `--spec-id` language. RULING: stays pointed at the spec document,
  and gains one sentence — no more.** Parent decision 6 is explicit that
  `--spec-id` is untouched and that no `work-id` pointer exists, and the
  criterion requires `grep -n "spec-id"` to keep matching. What the noun
  inside the placeholder says is a different question: "path to the task
  file" no longer names one file, so it becomes "path to the task's spec
  document" under rule (a). The added sentence says why the work document
  needs no pointer (its path is derived), which is the question a reader of
  the two-document model will otherwise ask the skill and not find answered.
- **(b) `code-review`'s "Identify the spec source" step. RULING: yes, spell
  out the pairing — in one clause, not a paragraph.** The step already sends
  the reviewer to the archive for a closed task, and `close` now archives
  both files together; a reviewer told only about `.spec.md` would find the
  program design it is meant to read as evidence and not know it may. One
  clause covers it: the pair sits together, in the workspace or in the
  archive.
- **(c) The emitted slice template's zone banners. RULING: BOTH 🧑 zones are
  emitted — the ruling is the Owner's and is applied, not re-decided.**
  (Round 1 ruled one banner; the Architect returned it as the blocking defect
  and it is corrected here.) The chain is short and leaves the Mason nothing
  to choose. A slice document IS a spec document — the Glossary of
  `socle/agents/methodology.md` says a slice "lives as
  `tasks/<time-id>-<feature>/<NN>-<slug>.spec.md`". G14 point 7, an Owner
  ruling recorded in `project-management/review-360-decisions.md`, says the
  spec document keeps **its two 🧑 zones** and loses the agent zone. And
  "Zone ownership" in the methodology adds that a 🧑 zone is never overridden
  silently, in any mode. So the emitted template carries REVIEW CAREFULLY
  after its Status block and REVIEW IF RELEVANT before `## Notes`, and the
  agent zone goes. The boundary needed no invention either: the zone table of
  `socle/templates/000-template.spec.md` already assigns `## Notes` to REVIEW
  IF RELEVANT, so round 1's single banner would have moved Notes into REVIEW
  CAREFULLY — erasing a drawn boundary rather than avoiding an invented one.
  The parent criterion **spec-document-is-all-review-surface** is satisfied
  by construction, since both zones are 🧑 and no agent zone remains, and the
  criterion greps `AGENT ZONE\|🤖`, which a 🧑 mark does not match.
- **(d) `retro`'s Sources beyond line 42. RULING: two more lines move, and
  they are named.** Line 38 is the criterion's own target. Line 39 also names
  single-document artifacts — it claims the worklog, which now lives in the
  work document and is already named in the new work-document bullet, so it
  keeps only the journal entry. Nothing else in Sources names a
  single-document artifact: lines 16–36 are about transcripts and about rule
  8 of the discipline, and both stay true.
- **(e) `slice-task`'s "Criterion 1" placeholders. RULING: renamed to named
  criteria.** Not demanded by any criterion of this slice — the parent's
  **named-criteria-in-the-spec-template** greps the template only — but the
  slice's own Verification orders a cross-file read "against the landed
  doctrine … for step-by-step consistency", and the landed spec template makes
  a named criterion a rule of every spec document. Emitting a template that
  breaks a rule the template next door states is the two-discourses defect
  this chantier exists to remove. One line pair; cheap to decline, and
  declining leaves a recorded contradiction. **The same rationale carries
  `retro:98`** ("Architect planning, Mason typing"), which no criterion
  reaches either: the landed doctrine gives the program design to the Mason
  at `plan` and the Architect the `plan-review` verdict, so the parenthesis
  as it stands teaches the pipeline wrong in a file this slice already opens.
  One parenthesis, same class, same mandate — and, like the placeholders,
  cheap to decline with the contradiction then recorded rather than fixed.
- **(f) `code-review`'s frontmatter description and its axis definition
  (lines 3 and 14). RULING: edited, minimally.** They still say "originating
  issue/PRD" while the same file's `changes` field claims the fork moved the
  spec source — a self-contradiction inside one file, and the field is
  rewritten by this slice anyway. One clause each; every discovery trigger of
  line 3 stays verbatim.
- **(g) The `Tracker section` pointers (`code-review:18`, `slice-task:17`).
  RULING: left alone, recorded as a proposal.** The glue's section is now
  named §B1 · Where task statuses live, so the phrase points at a title that
  no longer exists — but it has five carriers in `socle/`, and one of them is
  `socle/agents/methodology.md:35`, landed by slice 02 and outside this
  slice's map. Repairing two of five would leave the socle saying it two ways,
  which is worse than saying it wrongly once. Recorded in §5.

### 5 · Recorded proposals — reported, not acted on

Filed here and reported to my spawner under the proposal door; none of them
blocks this slice, and none is typed by it.

1. **The stale `Tracker section` pointer, five carriers.**
   `socle/agents/methodology.md:35`, `socle/agents/skills/code-review/SKILL.md:18`,
   `socle/agents/skills/slice-task/SKILL.md:17`,
   `socle/agents/skills/wayfinder/SKILL.md:30`,
   `socle/agents/skills/triage/SKILL.md:48`. Size: five one-line edits. Risk:
   low, but it crosses three slice maps and the landed doctrine. Deliverable
   without it: yes, entirely — ruling (g).
2. **Bare section references in `chisel-beads` (`§B1` at lines 3 and 8, `§B2`
   at line 62)**, against discipline rule 12, which wants file plus title at
   first mention. Size: three clauses. Risk: low. Belongs with the vendored-
   skills audit, like decision 11's `--actor` gap it sits beside.
3. **`chisel-beads/CHANGING-CASE.md` and the blocked-status gap** recorded by
   slice 02: unowned by design, and this slice's Files map puts the file out
   of reach. Unchanged, still open.

### 6 · Implementation worklog

(No typing yet — the entries below are `plan`-side. Dated entries continue
here at `type`, one per work session: what was attempted, what landed, what
was reverted and why, each signed with the role plus the date and the time. A
needed touch outside the files map is recorded here before it is reported.)

**`mason`, 2026-09-02 17:34 — `plan`.** Read the slice document, the parent
spec, the doctrine at `863094c`, the formulas at `fd1dc95`, the two
templates, the glue template, the Owner's rulings G14–G17, the four skills in
full and `test/installer.sh`. Ran the gate baseline before designing: 9
scenarios, 94 assertions passed, 0 failed, suite at 592 lines. Persisted the
design above. Verified that nothing written at `plan` moved the criteria
greps (`the spec file` in `socle/` still 1, `Design section` still 0) or
added a third line to the task-citation command — it still prints exactly the
two allowed fictional paths. No code typed, no file under `socle/` touched.

**`mason`, 2026-09-02 18:02 — `plan-review` round 1, NOT VALIDATED, design
revised.** One blocking defect and seven non-blocking adjustments, all folded
in; the revision note under the section header records what moved and why.
The defect was mine and it was a boundary violation, not a detail: ruling (c)
re-decided the composition of a 🧑 zone, which no Mason decides — G14 point 7
had already ruled the spec document keeps its two zones, and the landed spec
template had already placed `## Notes` in the second one. §4(c) is rewritten
to apply that ruling, §1 and §2 are recomputed against it (including the
blank-line footprint the corrected deletions leave), and the sentence that
deferred the gradient to "a slice that grows a second half" is gone. Nothing
under `socle/` touched by this round either; the design is still `plan`-only
and awaits re-validation.

**`plan-review` round 2, 2026-09-02 — VALIDATED.** The Architect
re-validated the revised design (round 2 of two), with four remarks marked
fold-in-as-you-type rather than blocking, and the Owner then approved
typing. Recorded here, in the work record, because it is the verdict that
authorised the `type` step: the Mason's contract lets typing start only from
a design `plan-review` has answered VALIDATED. Entered by `mason`,
2026-09-02 18:11, from the verdict as it was relayed — the Architect writes
its own verdict where the preset puts it, and this line is a pointer to it,
not a substitute.

**`mason`, 2026-09-02 18:05 — `type`, all four files, VALIDATED design
executed.** *(Stamp corrected 2026-09-02 18:11: this entry first read 17:59,
which put the typing BEFORE the round-1 revision above and was impossible.
The two neighbouring stamps are the ones to trust as read off the clock —
17:34 at `plan` and 18:11 for this correction; the round-1 revision's 18:02
and the 17:59 that stood here were written by hand, out of order, and 18:05
is the honest reconstruction: typing followed the round-2 VALIDATED verdict,
which followed the round-1 revision. Recorded rather than quietly
overwritten, per the never-erased rule.)* Round-2 remarks folded as typed: §3 item 2 now states the
emitted-template footprint as **95–122** with the insertion point after 98
(93–94 untouched), matching §2; the second banner is a short noun phrase in
the landed template's voice — "— notes written before the work document
exists." — not a sentence; the `AGENT ZONE`/`🤖` grep over
`socle/agents/skills/` is this slice's own Verification line, not a parent
criterion, and was run as such; and the "95–98" row was read as an insertion
after 98, the four lines themselves left byte-identical.

Edits, in the order the design set them:

- `code-review/SKILL.md` — 3 (description: the Spec axis names the task's
  spec document), 8 (`changes` keeps its history, gains the two-document
  divergence), 14 (axis definition: the whole spec document, system design
  included), 35–39 → 35–42 (spec source: `<name>.spec.md`, the archive
  holding a closed task's two documents together, the whole spec document as
  requirement, `<name>.work.md` as evidence only, divergence as a finding),
  86 (two labelled paths for the sub-agent), 87 (the brief gains clause (d)),
  89 ("no spec document is found"). The 🤖 sentence went with the
  enumeration.
- `slice-task/SKILL.md` — 9 (`changes`), 83–88 → 83–92 (publishes one spec
  document per slice as `<NN>-<slug>.spec.md`; the parent spec document stays
  in place; a new paragraph says no work document is created at slicing time
  and the implementing session creates `<NN>-<slug>.work.md` at `plan` from
  the work template declared in §A · Task workspace of `.agents/project.md`),
  emitted template 95–122 (REVIEW CAREFULLY banner inserted after 98 with the
  separator, mirroring the spec template; named-criteria placeholders; the
  program-design heading, its body and the agent zone deleted; the kept
  separator and second banner re-worded to REVIEW IF RELEVANT; `## Notes`
  re-scoped to pre-`plan` writers), 132–134 (the trailing paragraph sends the
  program design to the `.work.md`).
- `chisel-beads/SKILL.md` — 31–39 ("1 · What owns what" split across the two
  documents; "the document that already says it"), 48 (`--spec-id`
  placeholder names the spec document), 53–55 (one sentence: the work
  document needs no pointer, its path is derived), 56 ("the spec document
  `--spec-id` names"), 75 (worked example takes `.spec.md`), 96 (acceptance
  criteria live in the spec document). Two re-wraps ride along, both
  mechanical: the `--design` list and the `bd lint` paragraph tail, re-flowed
  to the file's width after the noun changed length. `--actor` untouched
  (parent decision 11).
- `retro/SKILL.md` — 8 (`changes`: the sources clause names the pair, plus
  the divergence sentence), 38–42 → 38–50 (Sources become spec document /
  work document / diff / journal entry / the blocker re-pointing with one
  pointer to `.agents/methodology.md`), 98 (the Mason designs at `plan` then
  types, per §4(e)).

**Verification, run in this order and all green.** The four owned criteria
greps return nothing (`Context, Scope, Acceptance Criteria, Seams` in
code-review; `Design — persisted at plan time` in slice-task; `the persisted
Design` in chisel-beads; `The spec file's persisted Design, implementation
checkboxes` in retro), while `grep -n "spec-id"` in chisel-beads still
matches three lines (49, 54, 59). `grep -rn "the spec file" socle/` → **zero
repo-wide**, the slice's share of the parent's closing check delivered;
`grep -rni "spec file"` over the four directories → zero;
`grep -rn "AGENT ZONE\|🤖" socle/agents/skills/` → zero;
`grep -rn "Design section" socle/` → still zero, the sibling tripwire intact;
`grep -rn "socle/" ` over the four directories → zero, no repo path leaked
into installed text. **no-task-citation-points-at-a-missing-file** printed
exactly two lines before the beads re-suffix (`…/01-thing.md` plus the
payroll path) and exactly two after (`…/01-thing.spec.md` plus the payroll
path) — the mid-task change the parent spec predicted, and no third path.
`git diff --check` clean. `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` →
**9 scenarios, 94 assertions passed, 0 failed**, suite still at 592 lines:
identical to the `plan` baseline, zero test changes, and the "no pointer into
thin air" integrity check passes with the one pointer this slice adds
(`.agents/methodology.md`, new to `retro`; the `.agents/project.md` mentions
were already there) resolving in the installed tree.

**Left alone, deliberately.** Nothing outside the four `SKILL.md` files was
touched — `chisel-beads/CHANGING-CASE.md` included. Inside them: the three
generic "task file(s)" mentions of chisel-beads (9, 20, 146) and slice-task's
line 24, per rule (a); the `Tracker section` pointers (code-review 18,
slice-task 17) per ruling (g); the `--actor` four-role list per parent
decision 11; and code-review's Standards axis, smell baseline, tier cascade
and aggregation step. The two untracked Owner files in the tree were not read
and not touched. Not committed: the Inspector reviews the uncommitted diff.
No blocker.

**`mason`, 2026-09-02 18:11 — `diff-review` findings applied.** The Inspector
passed both axes with no blocking finding; the thread owner ruled four
judgement calls to apply, plus the two evidence fixes above. What changed:

- **S-1** — `slice-task/SKILL.md:113–114`: the emitted template's two
  criterion placeholders were identical, teaching a shape the landed spec
  template does not use. The second is now `- [ ] **suite-green** — all tests
  pass`, matching `socle/templates/000-template.spec.md:96–97` pair for pair.
- **S-2** — `code-review/SKILL.md:36–43`: "where a closed task's two
  documents sit together" was false for a sliced parent, which has a spec
  document and never a work document. Hedged to "a closed task's documents —
  both, when a work document exists — sit together", the same shape as the
  hedge already standing on the sub-agent's input line. One re-wrap of the
  block's tail rides along.
- **S-3** — `retro/SKILL.md:8`: the `changes` field stated the two-document
  fact twice, once in the rewritten parenthetical and once in the appended
  clause. The appended clause now carries only what the parenthetical does
  not — where a blocker is read — and the field's upstream history is intact.
- **S-4** — `code-review/SKILL.md:8`: the field still opened on "spec source
  is the task file" while lines 3 and 14 had retired that vocabulary in the
  same file. Now "spec source is the task's spec document, not the
  originating issue/PRD"; the rest of the field is untouched.

P-1 and P-2 need no fix and are left as the Inspector recorded them. Still
four files, still no commit. No blocker.

## Notes

Created 2026-09-02 at the start of slice 04, in accordance with the parent
spec's intermediate-convention decision.
