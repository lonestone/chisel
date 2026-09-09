# 02 — Templates, front door and skills — work

Created by `mason` at `plan`, 2026-09-09. Spec:
`project-management/tasks/20260908-1149-joints-and-minors/02-templates-front-door-and-skills.spec.md`.

## Program Design

Persisted at `plan` by `mason`, 2026-09-09 18:34 CEST, from the spec's
approved system design.

Every edit below is one clause of prose, one table row, or a header block
deleted. No function, branch or data structure is added, so there is no seam
to test and no TDD cycle: the seam the parent spec names is the installed
socle text surface, and its observable behaviour is the criterion greps plus
the installer suite. The design question is therefore only *what exact words
land where*, and *in what order*, so the counts and the suite can be checked
after each file rather than at the end.

### Rules this design works under

- **The suite must provably survive.** `test/installer.sh` pins, and none of
  it may move: the golden-tree path comparison (`test/fixtures/golden-tree.txt`
  is a path listing — no file content is compared, so a text edit inside an
  installed file cannot break it, and this slice renames nothing), the two
  recursive prose greps over the installed `.agents/` (`to-lessons`, and the
  invented numeric limits `40 lines|8 lines|half of the slice|half the
  spend|target ~`), the v1-citer assertion, and the integrity scenario. No
  line written anywhere may contain one of those pinned strings.
- **The integrity scenario's scope, read at plan.** `test/installer.sh:355-356`
  scans only `AGENTS.md`, `.agents/`, `.claude/agents/` and `.codex/agents/`
  of the installed tree. It counts as a pointer (1) any `.agents/…` path in
  the text and (2) a markdown link to a **sibling** file, and demands the
  target exist. Consequence for this slice: the six skill pages are in scope
  (they install under `.agents/skills/`), and the two installed templates are
  **not** (they install as `project-management/000-template.*.md`). The only
  `.agents/…` paths this slice writes are `.agents/project.md` and
  `.agents/methodology.md`; both exist in an installed tree.
- **`test/installer.sh:404-405` pins who may cite the retired v1 layer:**
  exactly `.agents/skills/upgrade-v2/SKILL.md`. That file's citation of
  `.agents/rules/task-*.md` and `.agents/workflows.md` is at lines 10-11 and
  is **not** touched by the F1.2 edit at line 12-13.
- **Every pointer written is in the installed `.agents/…` form**, never
  `socle/…`. The two hand-maintained mirrors under `project-management/` are
  the single exception, per parent Implementation Decision 7: their
  methodology reference is repo-relative because chisel is not installed on
  itself.
- **Rule 11 of the discipline** (a section reference names its file and its
  title) governs every reference written: `§B · Coordination of
  `.agents/project.md``, `§B2 · Link to an external tracker of
  `.agents/project.md``, `"Zone ownership" of `.agents/methodology.md``.
- **No internal identifier ships.** No ruling id, no `review-360-decisions.md`
  file name, no chantier number in any socle file, any template, `README.md`,
  `PHILOSOPHY.md` or `AGENTS.md`. Checked at plan:
  `grep -rn "ruling [A-Z]\?[0-9]" socle/` returns nothing today, so this slice
  keeps that property.
- **G18, direct prose.** Statement first; an image only where it carries what
  the statement does not.
- **No sweep.** Parent Implementation Decision 2: the bare `§B`, `§C`, `§F`,
  `§B1` and `§H` citations elsewhere in these same files are chantier 5's.
  Untouched.

### Edit 1 — the four template files (B1 and F1.8)

Line numbers are as of this working tree, 2026-09-09, branch `review-360`,
HEAD `f60512e`.

**1a · F1.8, the files' own Status/Version headers.** In each of the four
files the header block sits between the H1 and `## Context`, and the whole
block goes — value continuation lines included, per the slice spec.

| File | Lines deleted | Result |
|---|---|---|
| `socle/templates/000-template.spec.md` | 3-5 (`**Status:**`, `**Version:**`, blank) | H1, blank, `## Context` |
| `project-management/000-template.spec.md` | 3-5 (same) | H1, blank, `## Context` |
| `socle/templates/000-template.work.md` | 3-8 (`**Status:**`, `**Version:**` running to line 7, blank) | H1, blank, `## Context` |
| `project-management/000-template.work.md` | 3-8 (same) | H1, blank, `## Context` |

Exactly one blank line survives between the H1 and `## Context` in all four.

**Do not touch `**Status:** [Status Emoji & Text]` at line 71 of either spec
template.** It is inside the fenced Spec Document Template block: the header
the template *prescribes*, not one the template file carries. After the edit
`grep -c '\*\*Status:\*\*'` is **1** in each spec template (that fenced line)
and **0** in each work template.

**1b · B1, the zone table and the bullet under it — lines 18-28 of both spec
templates.** Two edits in one place. The table's "Who reads it" column stops
saying "Human", and the file gains the pointer at the doctrine that owns the
question. Target table:

> | Zone | Who reads it | What belongs there |
> |---|---|---|
> | 🧑 **REVIEW CAREFULLY** | The zone's owner, before any code | Context, Scope, named Acceptance Criteria, Seams, Architecture / system design |
> | 🧑 **REVIEW IF RELEVANT** | The zone's owner, for medium/large tasks | Implementation Decisions, Testing Strategy, Slices & Dependencies, Deliverables, References, Notes, Retrospective |

The third bullet under it today reads "The 🧑 zones are the human's
decisions." That is the same contradiction in prose, in the same block, so it
goes with the table row; leaving it would ship B1 half-applied. The bullet
list becomes (first and last bullets unchanged):

> - The 🧑 REVIEW CAREFULLY zone must fit in working memory. Prefer a diagram or
>   mockup over three paragraphs.
> - In the default preset the zone's owner is you, the human. Who owns which
>   zone under the other presets is "Zone ownership" of
>   `.agents/methodology.md`.
> - The 🧑 zones carry their owner's decisions. Surface a conflict; never
>   silently contradict one.
> - There is no agent zone here. The coding agent's working space is the work
>   document, a different file with a different owner.

Verified at plan: `socle/agents/methodology.md:103` is `## Zone ownership`, so
the reference resolves.

**In the mirror `project-management/000-template.spec.md` the same bullet
carries the repo-relative form**, per parent Implementation Decision 7:

> - In the default preset the zone's owner is you, the human. Who owns which
>   zone under the other presets is "Zone ownership" of
>   [methodology.md](../socle/agents/methodology.md).

This is the one line on which the mirror differs from the source — the same
role line 4 played before F1.8 deleted it. The criterion greps `Human,
always` (→ 0) and `Zone ownership` (→ ≥ 1); both hold in both forms.

**1c · what edit 1 does to the mirror diff, recorded because the spec's
Verification asks for something that will no longer be true.** Measured at
plan: today the only difference between the two spec templates is line 4, and
the only difference between the two work templates is line 7 — both inside the
header block F1.8 deletes. So after edit 1a:

- the **spec** pair still differs on exactly one line, the new B1 pointer
  (1b);
- the **work** pair becomes **byte-identical**, because nothing else in that
  file names the methodology.

The slice spec's Verification bullet ("the only surviving difference must be
the methodology link's relative form") and parent Implementation Decision 7
("Keep that difference") therefore cannot both be satisfied for the work pair.
This is a finding against the two documents, not a licence to invent a
difference. See Open question 2 — the Architect rules whether the work
template keeps a doctrine pointer of its own.

### Edit 2 — `README.md` (A4, and the stale gradient paragraph)

**2a · the gradient paragraphs, lines 19-31.** The block still describes one
spec file holding the program design and the working notes, and a plan
persisted into it. Both were retired by chantier 2. Target:

> ## The default
>
> By default, every gate stays at the human. A task starts as an interview
> (one question at a time, a recommended answer with each), which shapes a
> **reading-gradient** spec document: the decisions worth reviewing carefully
> sit at the top, the rest ordered after them — detail is never cut, only
> ordered. That document holds the requirement and nothing else; the program
> design and the working notes live in a work document beside it, created by
> the session that implements the task.
>
> **Seams** — the public boundaries a feature is tested through — are agreed
> before any code is typed. A fresh session then plans against the real code
> and **persists the plan into the work document** before writing a line: a
> plan that only lives in the conversation is invisible to the next session,
> to the completion review, and to a crash. Typing runs from that persisted
> plan, and it can run on a cheaper model; whoever reviews a design never
> types the work it approved.

Three clauses changed, all inside the block the slice's files map assigns:
the gradient sentence, the persist destination, and the last clause — which
read "the Architect who planned it never types what it planned" and is stale
for a second reason: the program design is now the Mason's own, written at
`plan` and typed by the same Mason within one live thread, with the Architect
validating rather than authoring it. Recorded because the criterion did not
ask for that third clause.

**2b · A4, the setup block, lines 38-46.** The heading is part of the false
claim, so the heading goes with the block. Verified at plan against
`bin/chisel.sh:653-676`: `cmd_init` reads no input at all — it copies,
renders, writes the manifest and prints one line. Verified against
`socle/agents/skills/chisel-setup/SKILL.md:1-31`: the skill is the
questionnaire, it requires `.agents/.chisel.json` to exist first, it walks
sections A through H one at a time, and it is re-runnable per section. Target:

> ## Setup, after init
>
> `chisel init` installs the socle with safe defaults and asks nothing. The
> questionnaire is the `chisel-setup` skill, run afterwards in an agent
> session: it reads the repo, proposes each section of `.agents/project.md`
> one at a time, and writes back what you confirm. Re-run it later to revisit
> a single section.
>
> The answer worth knowing about up front is **§B1 · Where task statuses
> live, of `.agents/project.md`.** The default is the task files themselves —
> nothing to install. The other answer is a committed `bd` database when a
> repo wants queries instead of a reading session; adding it later is tooled
> and only touches open tasks.

The second paragraph keeps the §B1 material the current block carries: it is
true, and A4 only rules on *who asks*. `chisel-setup` is now named once,
which is what the criterion greps. `README.md:60-62` mentions the
`sync-upstream` skill but claims no path, so it needs no edit here (parent
Implementation Decision 3).

### Edit 3 — `PHILOSOPHY.md` (the preset count, and E1)

One paragraph, lines 126-136, carrying three stale claims: auto framed as a
permission (retired by ruling G10), "Three presets" where there are five, and
the factory as a product cell. Rewritten as two paragraphs. The preset
placements are taken from `socle/agents/methodology.md:47-55`, read at plan.

> On top of that discipline, chisel varies on two axes, and they vary
> independently: the **human gates** (who stops the run and reads) and the
> **validation sub-agents** (which fresh reviewers run — a Checker on the
> spec, an Architect on the program design, an Inspector on the diff). Five
> presets place themselves on those two axes: `chisel-default` (every gate at
> the human, all three reviewers), `chisel-light` (two gates — the spec, and
> the diff review the human holds himself — no reviewers),
> `chisel-supervised` (one gate, the Owner approving the spec, all three
> reviewers), `chisel-auto` (no gate; a doubting step blocks and reports
> instead, all three reviewers) and `chisel-auto-light` (no gate, no
> reviewer). Which preset governs a run is the human's choice at each
> invocation, never a permanent project setting. **Beads** — a committed
> status database — is a separate, additive axis: a beads-equipped repo stays
> fully usable under the default.
>
> **A factory is a possible destination, not a cell of this product.** Whether
> it belongs inside chisel stays an open question: chisel is meant to be light
> enough to drop into any repo, and a factory implies a lot of bespoke work.
> No factory machinery is described until a real need settles that question.

The factory paragraph is deliberately shorter than the one slice 01 landed in
`socle/agents/methodology.md:65-70` and shares no sentence with it beyond the
opening claim, which is the claim itself. Ruling E1 names both files, so both
carry it; the parent criterion requires a surviving sentence in each.

Lines 138-142 (the retired size-based labels) and lines 144-149 (the
reference list) are untouched. Lines 112-124 are untouched — see Notes &
Snippets, proposal door.

### Edit 4 — `AGENTS.md` (the persist destination, and the invocation form)

One bullet, lines 10-13. Today:

```
- Task lifecycle: interview → seams agreed → task file (reading gradient) →
  sizing check out loud → work from the file in a fresh session
  (`work on task <file>` / `work on slice <file>`); plan approved by the human
  and PERSISTED into the file before any code; two-axis review at completion.
```

Becomes:

```
- Task lifecycle: interview → seams agreed → spec document (reading gradient)
  → sizing check out loud → work from the spec/work pair in a fresh session
  (`work on task <spec-document>` / `work on slice <spec-document>`); plan
  approved by the human and PERSISTED into the work document before any code;
  two-axis review at completion.
```

That is the whole edit: it closes `agents-md-persist-destination` (the file
names the work document) and this slice's carrier of
`work-on-invocation-current` (both `<file>` forms leave the one line that
carried them). `<spec-document>` is the form the other five invocation sites
already use, five of them re-counted by slice 01 at `type`.

### Edit 5 — the three surviving A1 (1) carriers

Each names `.agents/project.md, Tracker section` — a section title that has
never existed in `socle/agents/project.md.tpl`. Targets verified at plan:
`## B · Coordination` at `project.md.tpl:43`, `### B2 · Link to an external
tracker` at `project.md.tpl:103`.

**5a · `socle/agents/skills/wayfinder/SKILL.md:30` — A1 (1) and A1 (2).** The
line is one long paragraph of three sentences. The middle sentence is the
"Wayfinding operations" reference, which no glue section defines; it is
deleted outright. The first is repointed to §B2, because the sentence is about
the issue tracker (parent Implementation Decision 1). The third is unchanged.
Result:

> **Where the map, its child tickets, blocking, and frontier queries
> physically live is tracker-specific.** The issue tracker is defined in §B2 ·
> Link to an external tracker of `.agents/project.md`. If no tracker has been
> provided, default to the local-markdown tracker.

Only the deletion and the repoint are taken. The rest of ruling A1 (2) — the
wayfinder made local-first — is chantier 6, and no other line of this file
moves.

**5b · `socle/agents/skills/slice-task/SKILL.md:17`.** Whole line replaced:

> Where slices are published is defined in §B · Coordination of
> `.agents/project.md`.

**5c · `socle/agents/skills/code-review/SKILL.md:18`.** Only the closing
clause after the em dash changes:

> … — see §B · Coordination of `.agents/project.md`.

`socle/agents/skills/triage/SKILL.md:48` is the fourth carrier and is **not
touched**: it leaves with its file at slice 03, which is why that file is on
this slice's files-to-avoid map and why `tracker-pointer-resolves` closes
there and not here.

### Edit 6 — `upgrade-v2` (F1.2) and `retro` (F1.6)

**6a · `socle/agents/skills/upgrade-v2/SKILL.md:12-13.** The sentence reads
"v2 replaces them with an ambient discipline core, three workflow presets and
three role profiles, and it renames the narrative journal." F1.2 stops the
count of the profiles: "three role profiles" → "the role profiles". Do not
substitute a new number. The same clause also counts the presets at three
where `socle/agents/formulas/` holds five — see Open question 1; this design
takes the criterion-only edit unless the Architect rules otherwise, and the
line rewraps to 80 columns.

Criterion-only form:

> v2 replaces them with an ambient discipline core, three workflow presets and
> the role profiles, and it renames the narrative journal.

Form if Open question 1 is answered yes:

> v2 replaces them with an ambient discipline core, the workflow presets and
> the role profiles, and it renames the narrative journal.

Lines 9-11 of this file, which name `.agents/rules/task-*.md` and
`.agents/workflows.md`, are **not touched**: `test/installer.sh:404-405`
asserts that this file and no other cites the retired v1 layer.

**6b · `socle/agents/skills/retro/SKILL.md:117`.** The claim is verified
false: `socle/templates/AGENTS-block.md:14` points a reader at
`.agents/discipline.md` rather than inlining it. The bullet becomes:

> - `.agents/discipline.md`: the ambient core, which the AGENTS block points a
>   reader at. Same sparing rule.

### Edit 7 — `prototype` (F1.5 clause 3, the close-time cleanup)

`socle/agents/skills/prototype/SKILL.md` rule 6 (line 31) states the capture —
a throwaway branch out of main plus a context pointer — and never says when
that branch may go. Measured at plan: the cleanup habit is written in **zero**
places anywhere in `socle/`. This slice writes it **once**, appended to rule
6, and touches no other file with it. Target text, appended to the end of rule
6:

> **The branch goes at close.** When the task that consumed the answer closes,
> the throwaway branches it points at are deleted — the validated decision is
> in the main branch by then, and the prototype has nothing left to prove.
> Deleting them earlier throws away the primary source while the decision is
> still being applied.

`socle/agents/skills/prototype/UI.md:100-105` and `LOGIC.md:71` describe the
capture and say nothing about when the branch may go; they stay that way, so
"exactly one place" survives. `socle/agents/discipline.md` is slice 01's and
already carries clauses 1 and 2 (`delete the code` gone, the side-lane row
naming the throwaway branch and its pointer, at line 93) — this slice does not
open that file. The phrase "the throwaway branches it points at" is the
distinctive string the after-count greps for; it appears nowhere in `socle/`
today.

### Order of operations

Ordered so each step is verifiable on its own, and the step that writes new
`.agents/…` pointers (edit 5, the only one the integrity scenario can judge)
gets a suite run immediately behind it.

1. **Edit 1**, the four template files — one commit. Verify:
   `template-zone-owner` (both spec templates: `Human, always` → 0,
   `Zone ownership` → 1), `template-sediment-gone` (`^\*\*Status:\*\*` → 0 and
   `^\*\*Version:\*\*` → 0 in all four; the fenced `**Status:** [Status Emoji &
   Text]` still present in both spec templates), and the two pairwise diffs.
2. **Edit 2**, `README.md` — one commit. Verify `readme-init-truthful`
   (`asks one question` → 0, `chisel-setup` → 1) and
   `readme-gradient-current` (`persists the plan into the spec file` → 0).
3. **Edit 3**, `PHILOSOPHY.md` — one commit. Verify
   `philosophy-presets-current` (`Three presets` → 0, the five named) and the
   full `factory-claim-degraded` grep over `socle/ PHILOSOPHY.md README.md`
   → 0, which closes that criterion since slice 01 took the other carrier.
4. **Edit 4**, `AGENTS.md` — one commit. Verify
   `agents-md-persist-destination` (`work document` → ≥ 1) and the full
   `work-on-invocation-current` grep over `socle/ AGENTS.md` → 0, which closes
   that criterion for the same reason.
5. **Edit 5**, the three A1 carriers — one commit. Verify `Tracker section`
   4 → 1 (`triage` only), `§B · Coordination` 0 → 2,
   `§B2 · Link to an external tracker` 1 → 2, and
   `wayfinding-notes-gone` → 0. **Then run the suite**: this is the step that
   writes installed pointers.
6. **Edit 6**, `upgrade-v2` and `retro` — one commit. Verify
   `profiles-uncounted` → 0 and `retro-block-pointer-accurate` → 0.
7. **Edit 7**, `prototype` — one commit. Verify clause 3 of
   `prototype-capture-aligned`: `grep -rl "the throwaway branches it points
   at" socle/` → exactly one file, and rule 6 read through.
8. **Full run:** `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`, expecting
   9 scenarios, 94 assertions, 0 failed, with the formula parse check
   reporting PASS and not SKIP and the integrity scenario green. Then
   `git diff --check`, then `grep -rn "socle/" ` over the six edited skill and
   template paths to prove no repo-path leak into installed text. Then record
   every after-count beside its before-count in the Worklog.

Commits use explicit paths only. `project-management/review-360-notes.md` and
`project-management/review-360-analysis.md` are untracked Owner files: never
read, never staged, and `git add -A` / `git add .` are never used.

### What this slice does NOT do

- No edit under `test/`, `bin/`, `upstream.lock.json`,
  `socle/agents/methodology.md`, `socle/agents/discipline.md`,
  `socle/agents/project.md.tpl`, `socle/agents/formulas/` or
  `socle/agents/profiles/`.
- No touch to `socle/agents/skills/triage/`,
  `socle/agents/skills/grill-with-docs/` or
  `socle/agents/skills/sync-upstream/` — slice 03 removes all three, so a
  pointer repointed there is work thrown away.
- No section-reference sweep (`§B`, `§C`, `§F`, `§B1`, `§H` bare citations
  stay as they are), no example model names, no CHANGELOG entry, no edit to
  `socle/agents/skills/chisel-setup/SKILL.md`.
- No second copy of the prototype cleanup sentence anywhere.
- No status change in any `.spec.md`, and no edit to any `.spec.md` at all.

### Criteria shared with another slice, and which share is this one's

| Criterion | This slice's share | The other share | Who closes it |
|---|---|---|---|
| `tracker-pointer-resolves` | the three carriers `wayfinder:30`, `slice-task:17`, `code-review:18` (edit 5) | `methodology.md:35` — slice 01, landed; `triage:48` — slice 03, leaves with its file | slice 03. After this slice the grep is **1**, not 0, and that is the design |
| `factory-claim-degraded` | `PHILOSOPHY.md:134` (edit 3) | `methodology.md:65` — slice 01, landed | **this slice**: it is the second to land, so its run of the full grep takes it to 0 |
| `work-on-invocation-current` | `AGENTS.md:12` (edit 4) | `profiles/README.md:67` — slice 01, landed | **this slice**, same reason |
| `prototype-capture-aligned` | clause 3 only: the cleanup sentence, written once, in `prototype/SKILL.md` (edit 7) | clauses 1 and 2 in `discipline.md` — slice 01, landed (`delete the code` gone, the row naming the throwaway branch at line 93) | **this slice**: both other clauses are already green, so clause 3 closes it |
| `suite-green` | this slice's own run (step 8) | every slice runs it | each slice for its own run; slice 03 for the fixture |

Measured at plan, so the table above is fact and not inference: slice 01's
three landed halves were re-checked against this tree —
`grep -rn "§B2 · Link to an external tracker" socle/` → 1
(`methodology.md:35`), `grep -rn "Factory = auto" socle/` → 0 inside `socle/`,
`grep -rn "work on slice <file>\|work on task <file>" socle/` → 0 inside
`socle/`, `grep -n "delete the code" socle/agents/discipline.md` → 0 and
`grep -n "throwaway branch" socle/agents/discipline.md` → 1 at line 93.

### Open questions for the Architect

**1 · `upgrade-v2/SKILL.md:12` counts the presets at three, in the same clause
F1.2 edits. Extend the edit, or leave it?** The sentence reads "an ambient
discipline core, three workflow presets and three role profiles".
`socle/agents/formulas/` holds five formula files, so "three workflow presets"
is false by the same verified-count defect F1.2 exists to remove, one clause
away from the words the criterion names. `profiles-uncounted` greps only
"three role profiles", so the criterion goes green either way.
**Recommendation: extend it** — "the workflow presets and the role profiles",
the same de-counting F1.2 applies to the profiles, in the same sentence, at no
extra reading cost for a reviewer. Both forms are written out in edit 6a; say
which one lands. Not decided here because the count of the presets is not a
carrier this slice's spec lists, and stretching a criterion is a scope
decision.

**2 · After F1.8 the two work templates carry no pointer to the doctrine and
no link to the spec template. Reinstate one clause, or ship them
pointer-free?** The `**Version:**` block being deleted is the only place
either work template names `methodology.md`, and the only place it links to
its sibling spec template. The spec templates lose nothing, because B1's new
bullet puts a methodology reference back. Two consequences, both real: the
shipped work template stops pointing a reader at the doctrine that explains
it, and the two work templates become byte-identical, which makes the slice
spec's Verification bullet and parent Implementation Decision 7 unsatisfiable
for that pair (see edit 1c). **Recommendation: reinstate one clause**, at the
end of the work template's first Context paragraph — "The reasoning behind the
split is 'The two documents' of `.agents/methodology.md`" in the source and
the repo-relative link in the mirror. That restores the doctrine pointer, and
restores the one-line difference the parent decision tells this slice to keep.
Not decided here: the slice spec is explicit that "the whole header goes", and
adding prose to a shipped template is more than the deletion F1.8 orders.
Whichever way it is ruled, edit 1c's finding stands and the Verification
bullet needs its wording fixed by whoever owns that document — this slice may
not edit a `.spec.md`.

Both questions are about the *how* at its boundary with scope, and neither
blocks: the criterion-only branch of each is written out above and is
deliverable as it stands.

## Worklog

- **2026-09-09 18:34 CEST · `mason` · `plan`.** Read the role contract
  (`socle/agents/profiles/mason.md`), `socle/agents/discipline.md`, the `plan`
  step of `socle/agents/formulas/chisel-auto.formula.toml`, both templates
  (`project-management/000-template.spec.md`,
  `000-template.work.md`), this slice's spec in full, the parent spec in full
  (§Scope, §Acceptance Criteria, §Seams, §Architecture, §Implementation
  Decisions 1-12, §Testing Strategy, §Slices & Dependencies, §Notes), slice
  01's spec/work pair for shape, and the decisions record's entries A1, A3,
  A4, B1, E1, E2, F1.2 / F1.5 / F1.6 / F1.8 / F1.9, G10 and G18. Read every
  carrier named in the files map, plus `bin/chisel.sh` (`cmd_init`,
  `managed_relative_files`, the template copies at lines 284-285),
  `socle/agents/skills/chisel-setup/SKILL.md`, `test/installer.sh` (the
  integrity scenario's scope and pointer definition, the pinned prose greps,
  the v1-citer assertion) and `test/fixtures/golden-tree.txt`. Persisted this
  program design. Verified **all sixteen grep before-counts plus the suite
  baseline — seventeen rows** in the table under Notes & Snippets against this
  working tree; every one matched the slice spec, including both struck
  figures the 2026-09-09 foreman note re-measured. Nothing typed in any
  carrier.

## Implementation Checkboxes

- [ ] Edit 1 — the four template files: the Status/Version headers deleted
      (`socle/templates/000-template.spec.md` 3-5,
      `project-management/000-template.spec.md` 3-5,
      `socle/templates/000-template.work.md` 3-8,
      `project-management/000-template.work.md` 3-8) and the B1 zone table
      plus its bullet in both spec templates
- [ ] Edit 2 — `README.md`: the gradient paragraphs at 19-31, and the setup
      block at 38-46
- [ ] Edit 3 — `PHILOSOPHY.md`: the preset/auto/factory paragraph at 126-136,
      rewritten as two paragraphs
- [ ] Edit 4 — `AGENTS.md`: the task-lifecycle bullet at 10-13
- [ ] Edit 5 — the three A1 carriers: `wayfinder/SKILL.md:30`,
      `slice-task/SKILL.md:17`, `code-review/SKILL.md:18`; then a suite run
- [ ] Edit 6 — `upgrade-v2/SKILL.md:12-13` and `retro/SKILL.md:117`
- [ ] Edit 7 — `prototype/SKILL.md` rule 6: the close-time cleanup sentence,
      written once
- [ ] Verification — every criterion command re-run, after-count recorded
      beside its before-count in the Worklog
- [ ] `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` → 9 scenarios, 94
      assertions, 0 failed, parse check PASS not SKIP; then `git diff --check`

## Notes & Snippets

**Before-counts, verified by `mason` at `plan`, 2026-09-09, branch
`review-360`, HEAD `f60512e`.** Each command was run against this working
tree, not copied from the spec. Sixteen grep rows plus the suite baseline —
seventeen. All of them agree with the slice spec as it now stands, including
the two figures the foreman note of 2026-09-09 struck and re-measured, so no
stop-and-re-read applies.

| Command | Spec says | Measured | Expected after this slice |
|---|---|---|---|
| `grep -rn "Wayfinding operations" socle/` | 1 (`wayfinder:30`) | 1, same line | **0** |
| `grep -c "asks one question" README.md` | 1 (line 40) | 1, line 40 | **0** |
| `grep -c "chisel-setup" README.md` | 0 | 0 | **1** |
| `grep -c "persists the plan into the spec file" README.md` | 1 (line 27) | 1, line 27 | **0** |
| `grep -c "Human, always" socle/templates/000-template.spec.md` | 1 (line 20) | 1, line 20 | **0** |
| `grep -c "Human, always" project-management/000-template.spec.md` | 1 (line 20) | 1, line 20 | **0** |
| `grep -c "Zone ownership" socle/templates/000-template.spec.md` / mirror | 0 / 0 | 0 / 0 | **1 / 1** |
| `grep -c "Three presets" PHILOSOPHY.md` | 1 (line 131) | 1, line 131 | **0** |
| `grep -rn "three role profiles" socle/` | 1 (`upgrade-v2:13`) | 1, same line | **0** |
| `grep -rn "rendered into the AGENTS block" socle/` | 1 (`retro:117`) | 1, same line | **0** |
| `**Status:**` / `**Version:**` header lines, four template files | 2 each | spec files: `^\*\*Status:\*\*` 2 (lines 3 and 71) and `^\*\*Version:\*\*` 1 (line 4); work files: 1 and 1 (lines 3 and 4, value running to 7) | **spec files 1 (the fenced line only) and 0; work files 0 and 0** |
| `grep -c "work document" AGENTS.md` | 0 | 0; the persist claim is at lines 12-13 | **≥ 1** |
| `grep -rn "Tracker section" socle/` | 4 across 4 files | 4 — `wayfinder:30`, `slice-task:17`, `code-review:18`, `triage:48` | **1** (`triage:48`, slice 03's) |
| `grep -rn "§B · Coordination" socle/` | 0 | 0 | **2** |
| `grep -rn "§B2 · Link to an external tracker" socle/` | 0 | **1** — `methodology.md:35`, landed by slice 01 | **2** |
| `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` | 2 | **1** — `PHILOSOPHY.md:134`; `socle/` already clean (slice 01) | **0 — closes here** |
| `grep -rn "work on slice <file>\|work on task <file>" socle/ AGENTS.md` | 2 | **1** — `AGENTS.md:12`; `socle/` already clean (slice 01) | **0 — closes here** |
| `grep -rn "prototype branch" socle/agents/formulas/ socle/agents/methodology.md` | 0 | 0; and 0 across all of `socle/` | still 0 — the cleanup is written in the skill's own words, verified by `grep -rl "the throwaway branches it points at" socle/` → **1 file** |
| `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` | 9 / 94 / 0 | **9 scenarios, 94 assertions, 0 failed**; parse check PASS, integrity scenario green | 9 / 94 / 0 |

Two rows read lower than the slice spec's "*Today*" figures because slice 01
landed in between, exactly as the foreman note of 2026-09-09 says: `§B2 · Link
to an external tracker` is already 1 rather than 0, and `Tracker section` is 4
rather than 5. `Factory = auto` and the `work on …` grep are each down to
their single remaining carrier, which is this slice's. No figure contradicts
the spec.

**Five extra facts checked at plan, not in the spec.**

- `socle/agents/project.md.tpl` really carries `## B · Coordination` (line 43)
  and `### B2 · Link to an external tracker` (line 103), so all three A1
  repoints land on sections that exist — the whole point of the criterion.
- `socle/agents/methodology.md:103` really is `## Zone ownership`, so B1's new
  reference resolves.
- `bin/chisel.sh:653-676` (`cmd_init`) reads no input: the A4 claim that init
  asks nothing is verified against the code, not assumed from the ruling.
- `bin/chisel.sh:284-285` copies `socle/templates/000-template.spec.md` and
  `000-template.work.md` **verbatim** to `project-management/` in the target
  repo. So the socle sources must keep install-relative pointers, and
  `socle/templates/000-template.work.md:6` pointing at
  `/project-management/000-template.spec.md` is correct in installed form —
  which is also why deleting it costs a real navigation link (Open question 2).
- `test/fixtures/golden-tree.txt` is a **path listing**: no installed file's
  content is compared byte for byte. A text edit inside an installed template
  or skill page therefore cannot fail the tree comparison, and this slice
  renames nothing.

**One thing the suite pins that is easy to trip on.** `test/installer.sh:281`
greps the whole installed `.agents/` for `40 lines|8 lines|half of the
slice|half the spend|target ~` and fails if any appears; line 276 does the
same for `to-lessons`. None of the wording above contains one, and this note
exists so a later revision of the design does not introduce one by accident.

**Proposal door, `mason` at `plan`, 2026-09-09 18:34 CEST —
`PHILOSOPHY.md:112-124` still describes the retired single task file.** The
"One task — two sessions" bullet says an interview "shapes the task file" and
that a fresh session "gets the plan approved and persisted", with no work
document anywhere; the "parent task with slices" bullet says the same. It is
the identical defect the parent ruled in for `README.md:19-31`, in the file
directly above the paragraph this slice rewrites, and it will keep teaching
one task file to every reader of the front door. The three evaluations:
**size** — one bullet list, three or four clauses, the same kind of edit as
edit 2a; **risk** — low, and inside a file this slice already opens, but
outside the line range its spec assigns (`PHILOSOPHY.md` lines 126-142);
**can I deliver cleanly without it** — yes, entirely: the criteria this slice
owns are about lines 126-136 and are met without touching 112-124, so nothing
here is held together by a workaround. Reported, not acted on. Not a blocker.

**Nothing was found wrong in the slice spec's counts.** The two findings
against the documents are both about instructions rather than figures, and
both are recorded above where the work happens: edit 1c (the mirror-diff
verification becomes unsatisfiable for the work pair once F1.8 deletes the
line that carried the difference) and Open question 2 (the doctrine pointer
the same deletion removes). Neither is edited into the spec: a `.spec.md` is
read-only to this role.

## Diff-Review Findings

Written by the Inspector at `diff-review`.
