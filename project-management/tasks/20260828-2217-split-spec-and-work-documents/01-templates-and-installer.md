# 01 — Templates and installer

**Status:** 🟢 Complete — verified and cleared by `diff-review`.
**Blocked by:** None — runs first and alone. It decides what the two
documents look like and how they are named; slices 2–5 all read those
decisions off this slice rather than off the parent spec's prose.

**What to build:** the two templates that replace the single task-file
template — `socle/templates/000-template.spec.md` and
`socle/templates/000-template.work.md` — written from scratch off the
socle's current `000-task-file-template.md` and the Owner's G14 ruling; the
old template deleted; `bin/chisel.sh` laying both new files down as managed
files; `test/fixtures/golden-tree.txt` updated to match; and every citation
of the old template's path repointed at the two new ones, including this
repo's own `project-management/` copies (derived from the socle source, not
from the stale local copy they replace) and the one link in `PHILOSOPHY.md`.

## Acceptance criteria

Cite these by name from the parent spec
(`project-management/tasks/20260828-2217-split-spec-and-work-documents.md`,
section "Acceptance Criteria"). This slice closes seven of them outright,
plus its share of the suite-green criterion; the rest belong to slices 2–5
and are not restated here as if they were this slice's to close (see
"Verification" below for which and why).

- [x] **two-templates-shipped** — `test -f socle/templates/000-template.spec.md
  && test -f socle/templates/000-template.work.md && test !
  -f socle/templates/000-task-file-template.md` passes.
- [x] **old-template-cited-nowhere** — `grep -rn "000-task-file-template"
  socle/ bin/ test/ AGENTS.md PHILOSOPHY.md` returns nothing.
- [x] **both-templates-installed-and-managed** — Given a fresh `chisel init`,
  When the tree is listed, Then both templates exist under
  `project-management/`, the old one does not, and `chisel check` reports both
  as managed. Mechanically: `grep -c "000-template"
  test/fixtures/golden-tree.txt` returns 2, and `grep -n
  "000-task-file-template" test/fixtures/golden-tree.txt` returns nothing.
- [x] **spec-document-is-all-review-surface** — `grep -n "AGENT ZONE"
  socle/templates/000-template.spec.md` and `grep -n "🧑"
  socle/templates/000-template.work.md` both return nothing.
- [x] **the-spec-keeps-a-notes-section-for-pre-plan-writers** — Given
  `socle/templates/000-template.spec.md`, When read, Then it carries a Notes
  section scoped to what is written before a work document exists — the
  spec review's findings, and the assumptions a gateless preset records —
  and says it is not the Mason's working space. And Given
  `socle/agents/profiles/checker.md`, When read, Then its instruction to
  write findings into the Notes of the spec still resolves to a real
  section (this file is untouched by this slice; the criterion's second
  half holds because it names the Notes of the spec twice — its
  `description` frontmatter and its Verdict line — and this slice's spec
  template keeps that section real).
- [x] **named-criteria-in-the-spec-template** — `grep -n "Criterion 1"
  socle/templates/000-template.spec.md` returns nothing; the template's
  Acceptance Criteria guidance requires a name per criterion and says an
  amended one is struck with its dated replacement below.
- [x] **work-document-owns-the-program-design** — Given
  `socle/templates/000-template.work.md`, When read, Then it carries the
  program design and its pseudo-code, the worklog, the implementation
  checkboxes, Notes & Snippets and the diff-review findings, and says who
  creates it and when: the implementing session, at `plan`, in the spec's own
  directory, named by replacing the `.spec.md` suffix with `.work.md`.
- [x] **suite-green** (this slice's share) — `PATH="/opt/homebrew/bin:$PATH"
  bash test/run.sh` passes with zero failures after every commit of this
  slice, not just the last one.

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted at plan time.

## Design — persisted at plan time

Persisted 2026-08-28 at this slice's `plan` step. Every decision below
applies the Owner's G14 ruling recorded in
`project-management/review-360-decisions.md`, section "G · Règles de
rédaction & questions transverses", or the spec review's own round-1
resolutions recorded in the parent spec; nothing here reopens either.

### Decisions locked (plan level)

1. **Both new templates are authored as full standards documents, on the
   model of the current `000-task-file-template.md`** — an explanatory
   Context, a zone table, a "where content lives" section, an embedded
   `markdown` skeleton a new spec/work document is copy-started from, a
   naming-conventions section, and (spec side only) status indicators and
   the two "when creating / when reviewing" checklists. This is not a new
   shape invented for this slice: it is the existing template's shape,
   split in two along the boundary the parent spec's Architecture table
   already fixes, with the third zone removed from the spec side and no
   zone marker at all on the work side.
2. **The spec template's reading gradient is exactly two zones** — 🧑
   REVIEW CAREFULLY (Context, Scope, Acceptance Criteria, Seams,
   Architecture) then 🧑 REVIEW IF RELEVANT (Implementation Decisions,
   Testing Strategy, Slices & Dependencies, Deliverables, References, Notes,
   Retrospective) — with no 🤖 AGENT ZONE marker anywhere. This is what
   **spec-document-is-all-review-surface** requires and it is a direct
   transcription of the parent spec's Architecture section and
   Implementation Decisions point 1.
3. **Implementation Decisions stops being where "program design for unsliced
   tasks" lives.** The current template's paragraph for that section says
   unsliced tasks keep their program design there; that sentence dies
   outright, because the program design is now wholly the work document's,
   sliced or not. What the section keeps: cross-cutting rulings and
   constraints a reviewer must not silently reopen, worded to make that
   boundary impossible to miss (see the template text below).
4. **`Retrospective` becomes an explicit named section of the spec
   template**, not an ad hoc addition after the fact. The parent spec's
   Architecture table lists it as the last spec-side row and the
   Deliverables bullet names it; the current template has no such heading
   today (retrospectives have been written free-form). This slice is what
   gives it a place.
5. **The work template's section order follows the Architecture box's own
   literal order** — Program design and pseudo-code, Worklog, Implementation
   checkboxes, Notes & Snippets, Diff-review findings — rather than
   re-deriving an order from scratch.
6. **The one cross-link each new template carries to the other, and to
   `methodology.md`, uses the socle's existing absolute-path convention**
   (`/.agents/methodology.md`, `/project-management/000-template.spec.md`)
   — the same style the current template's own version line already uses.
   This is a generic documentation convention describing the default
   install layout, not a claim about any specific repo's actual paths; nothing
   here is bound to this repo's own layout (that only matters for the two
   `project-management/` copies, decision 10 below).
7. **The naming and lifecycle prose is written once, in the spec template's
   own "The two documents" section, and not repeated at length in the work
   template.** The work template's Context restates only what its own reader
   needs (who creates it, when, where, named how, and the lifecycle/archive
   rule), cross-referencing the spec template rather than re-arguing it.
8. **Commit order keeps the suite green at every step** (see "Writing
   order" below) rather than landing everything as one atomic change. This
   is not required by any gate — the installer's "no pointer into thin air"
   check scans `AGENTS.md`, `.agents/`, `.claude/agents/`, `.codex/agents/`
   inside the INSTALLED tree only (verified by reading `test/installer.sh`,
   `group_integrity`), so it never inspects `project-management/` or this
   repo's own root docs — but the Mason's own speed contract asks for a
   green commit at every step, and there is no reason to skip that here.
9. **This repo's own `project-management/` copies are derived from the
   socle source templates, byte-for-byte, with exactly one adaptation**: the
   cross-link to `methodology.md`, rewritten from the socle's
   `/.agents/methodology.md` convention to this repo's real path,
   `../socle/agents/methodology.md` (relative from `project-management/`,
   since this repo has no installed `.agents/` — it has `socle/agents/`
   instead; see the brief's "Repo layout" note). The current stale copy
   already attempted this adaptation and got it wrong
   (`../agents/methodology.md`, which resolves to a `agents/` directory at
   repo root that does not exist); this is not a second bug introduced by
   this slice, it is the one correction that falls out of deriving from the
   socle copy properly instead of preserving the drifted one. Every other
   link and every other paragraph is copied as the socle source has it — no
   second, silent adaptation invented beyond this one.
10. **`project-management/000-task-file-template.md` is deleted**, not left
    alongside the two new files. Nothing in the Deliverables list names it
    for deletion explicitly (only the socle source copy is), but keeping it
    would be exactly the orphan-of-its-class ruling G14 already discusses,
    and AGENTS.md stops citing it in this same slice — an uncited stray file
    serves nobody.

### Writing order — and how the suite stays green

**Commit 1 — the two new templates, additive only.** Create
`socle/templates/000-template.spec.md` and
`socle/templates/000-template.work.md` with the full text below. Nothing
else changes: `bin/chisel.sh` still points at the old template, the fixture
is untouched, no citer is repointed yet. Run
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`: green, unchanged from
baseline (9 scenarios, 94 assertions, 0 failed) — the new files sit in
`socle/templates/` unused by anything the suite inspects, since
`managed_relative_files` hardcodes the old template's path rather than
scanning the directory.

**Commit 2 — the flip, atomic.** In one commit: `bin/chisel.sh` (the three
edits below — the source constant, the manifest line, the install copy, each
becoming two), `test/fixtures/golden-tree.txt` (the one line replaced by two,
in sort order), and delete `socle/templates/000-task-file-template.md`.
These three cannot split across commits: deleting the old template while
`chisel.sh` still names it would make `copy_managed_files` fail its `cp` at
the next test run, and updating `chisel.sh` alone would make the golden-tree
comparison fail (extra files installed, tree mismatch). Run the suite:
green, tree matches, `both-templates-installed-and-managed`'s two mechanical
greps now pass.

**Commit 3 — repoint every remaining citer, and land this repo's own
copies.** `socle/agents/project.md.tpl`, `socle/agents/methodology.md`,
`socle/agents/skills/upgrade-v2/SKILL.md`, `AGENTS.md`, `PHILOSOPHY.md` (the
five one-line/one-paragraph edits below), plus
`project-management/000-template.spec.md` and
`project-management/000-template.work.md` created and
`project-management/000-task-file-template.md` deleted. Run the suite:
green (nothing under `test/` is touched here). Then run
**old-template-cited-nowhere**'s grep directly: it must now return nothing,
closing that criterion. Run **two-templates-shipped**'s three-part test:
passes.

### `socle/templates/000-template.spec.md` — new file, full text

````markdown
# Task Spec Template & Standards

**Status:** 🟢 Complete
**Version:** 3 (spec / work split — the task file becomes two documents, a
spec document and a work document; see [methodology.md](/.agents/methodology.md))

## Context

The spec document is the review surface, and nothing else: what the human
approves, what a reviewer judges the diff against, and what survives in the
archive as the record of what was asked. It carries no working material — no
program design, no pseudo-code, no worklog, no implementation checkboxes.
Those live in the task's **work document**, the coding agent's own file,
created at the implementing session's `plan` step (see "The two documents"
below) and named by replacing this file's `.spec.md` suffix with `.work.md`.

A spec document with no work document beside it has never been typed — the
work document's existence is the only signal that implementation started.

Version 2 introduced the reading gradient (sections ordered by review
criticality, zone markers telling the reviewer what to read carefully, what
to read if relevant, and what was agent working space). Version 3 keeps the
gradient and removes the third zone: the agent's working space is a
different file now, so "🧑 review carefully" and "🧑 review if relevant" are
the whole of this document.

## The two zones

| Zone | Who reads it | What belongs there |
|---|---|---|
| 🧑 **REVIEW CAREFULLY** | Human, always, before any code | Context, Scope, named Acceptance Criteria, Seams, Architecture / system design — the decisions that are expensive to change later |
| 🧑 **REVIEW IF RELEVANT** | Human, for medium/large tasks | Implementation Decisions, Testing Strategy, Slices & Dependencies, Deliverables, References, Notes (pre-`plan` writers), Retrospective |

Rules:

- The 🧑 REVIEW CAREFULLY zone must fit in working memory. Prefer a diagram
  or a mockup over three paragraphs.
- The 🧑 zones are the human's decisions. An agent must not contradict them
  silently — if implementation reveals a conflict, stop and surface it.
- There is no agent zone in this document. The coding agent's working space
  — program design, pseudo-code, worklog, snippets — is the work document, a
  different file with a different owner.

## The two documents

| Spec document (this file) | Work document |
|---|---|
| Context · Scope · Acceptance Criteria · Seams | Program design and pseudo-code |
| Architecture / system design | Worklog |
| Implementation Decisions | Implementation checkboxes |
| Testing Strategy · Slices & Dependencies | Notes & Snippets |
| Deliverables · References | The Inspector's findings from `diff-review` |
| Notes (pre-`plan` writers) · Retrospective | |

Three producers write into this file's **Notes** section before a work
document exists: the `spec-review` step (the Checker's findings), a
doubting step of a gateless preset (the assumptions it records), and the
Architect at spec-writing time in some presets. Once work starts, the
Mason's own working notes go into the work document's **Notes & Snippets**
instead — never here.

**One work document per spec that is actually typed**, created by the
implementing session (the Mason) at `plan`, in this file's own directory,
named by replacing `.spec.md` with `.work.md`. A parent spec of a sliced
task never has one — each slice has its own. It is deletable and
regenerable while the work is live: delete it, revise this spec, and
restart, with nothing lost that matters. That window closes at `close`,
where **both files are archived together** — moving the spec alone does not
move its work document; the rule is explicit because it would not otherwise
happen for a standalone task's single file.

## Where each kind of content lives

A task is either its own single slice (one spec + one work document) or a
parent spec plus slice specs (each with its own work document). The content
moves accordingly:

| Content | One task | Parent + slices |
|---|---|---|
| Why / what / success criteria / seams | this spec document | the **parent** spec document |
| Architecture (diagrams) | this spec document (if medium) | the **parent** spec document |
| Program design + pseudo-code | the **work document** — created at `plan`, by the implementing session | **each slice's own work document** — created at that slice's `plan`. The parent spec keeps only decisions that span slices |
| Slice list + "Blocked by" | — | the parent spec document |
| Worklog, implementation checkboxes, Notes & Snippets | the work document | each slice's own work document |
| Status | this spec document | per slice's spec document; the parent stays open until the last slice |
| Archive | spec + work document → archived together when done | parent spec + folder (every slice's spec and work document) → archived after the last slice |

On disk (paths resolve via `.agents/project.md` §A):

```
One task:                                 Parent + slices:
tasks/                                    tasks/
├── 20260810-1200-fix-thing.spec.md       ├── 20260803-1850-admin-mvp.spec.md   ← parent
└── 20260810-1200-fix-thing.work.md       └── 20260803-1850-admin-mvp/
    (created at plan, once typed)             ├── 01-acquisition-domain.spec.md ← slice
                                               ├── 01-acquisition-domain.work.md
                                               ├── 02-tidal-client.spec.md
                                               └── …
```

Cutting a task into slices is the `slice-task` skill; a slice is ready when
everything in its "Blocked by" list is done, and each one gets its own fresh
session.

## Spec Document Template

All spec documents MUST follow this structure:

```markdown
# <Task name>

**Status:** [Status Emoji & Text]

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before any code. Keep it short.

## Context

Brief explanation (2-4 sentences) of the problem this task solves, from the
user's/product perspective. Include relevant background. If UI is involved,
prefer a rough mockup or screenshot over prose.

## Scope

**Included:**
- Bullet list of what IS in scope — specific deliverables, features, behaviors

**Not Included:**
- Bullet list of what is NOT in scope — prevents scope creep, clarifies
  boundaries with related tasks

## Acceptance Criteria

How do we know this task is complete? Every criterion has a short,
descriptive **name** — a handle a reader can cite without opening the file
(e.g. `no-orphan-file`), never a bare ordinal label. Every criterion must be
machine-verifiable: a command to run, or a Given/When/Then scenario. No
prose criteria. An amended criterion is never erased: strike the original
and date the replacement below it.

- [ ] **descriptive-name** (testable/verifiable)
- [ ] **another-descriptive-name** (testable/verifiable)
- [ ] **suite-green** — all tests pass, no linter errors

## Seams

The public boundaries where this feature will be tested — agreed with the human
BEFORE implementation. Prefer existing seams; the fewer the better (ideal: one).
Tests live at seams, never against internals.

- Seam 1: <interface / boundary> — <what behavior is observed there>

## Architecture (medium/large tasks — omit for small ones)

**System design**: how the pieces talk — services, endpoints, schemas, queues,
stores, and the relationships between them. Prefer diagrams over prose:
sequence diagrams, contract shapes, data models (mermaid). This is a human
decision surface — it must be reviewed before any slicing. The indicative
files-to-modify / files-to-avoid map is part of the system design captured
here, though it is written once per slice, in "Slices & Dependencies" below
— not repeated in this section.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing (medium/large tasks).

## Implementation Decisions

Constraints and rulings that shape all work on this task, decided before or
during writing — never the program design, which belongs wholly to the work
document, persisted at `plan` by whoever types. Use this section for:
decisions a human or reviewer made that later work must not silently reopen,
the cross-slice decisions of a sliced task (each slice's own work document
carries only that slice's how), and constraints the acceptance criteria
depend on. Avoid file paths and line-number references — they go stale fast
and a reference should say in one clause what the reader finds there.

## Testing Strategy

- What will be tested at each seam, in natural language
- Only external behavior, never implementation details
- Prior art: similar tests in the codebase
- Unit / integration split, manual testing steps, edge cases to verify

## Slices & Dependencies

For large tasks: vertical slices (tracer bullets). Each slice cuts a narrow but
COMPLETE path through every layer and is demoable on its own — never a
horizontal layer-by-layer plan. Each slice states its indicative
files-to-modify / files-to-avoid map here.

- **Slices:** 1. <slice> (blocked by: none) · 2. <slice> (blocked by: 1) · …

Wide mechanical refactors are the exception: sequence them as
expand → migrate (batched) → contract instead of forcing vertical slices.

Related tasks (links to the spec documents, including archived ones):

- **Depends on:** tasks that MUST be done first
- **Blocks:** tasks that cannot start until this is done
- **Related:** tasks that interact with this one

## Deliverables

Concrete outputs that must exist when the task is complete:
- [ ] Specific file paths
- [ ] Test files
- [ ] Documentation updates

## References

Links to relevant docs sections, external documentation, issues, examples.

## Notes

Scoped to what is written into THIS file before a work document exists — the
`spec-review` step's findings, and the assumptions a gateless preset's
doubting step records. This is NOT the Mason's working space: once work
starts, the Mason's own working notes, snippets and worklog go in the work
document's **Notes & Snippets** section instead, never here.

## Retrospective

Added after `close`: what worked, what to change next time, proposals for
later work. The Owner rules on any proposal it contains; this is a different
artifact from the review the human runs on the diff.
```

## File Naming Conventions

Name a spec with a **time identifier prefix** (automatic chronological
sorting in the tree) followed by the **intention** in kebab-case, and the
`.spec.md` suffix. No incremental numbers. Generate the time id with the
script:

```bash
scripts/task-id.sh <intention>   # -> 20260803-1445-<intention>
```

Place it in the task workspace declared in `.agents/project.md` (default
`/project-management/tasks/`), as
`<YYYYMMDD-HHmm>-<intention-in-kebab-case>.spec.md`.

A dot segment marks a KIND of file, the way `.test.ts` does; a hyphen would
read as part of the name. The work document is this same name with
`.spec.md` replaced by `.work.md` — same time id, same directory, created at
`plan` rather than up front. `.spec.md` sorts before `.work.md`, so the
review surface comes first in a directory listing.

Examples:

- `20260803-1445-fix-filename-sanitization.spec.md` (+ `.work.md` once typed)
- `20260804-0910-beets-import-correlation.spec.md` (+ `.work.md` once typed)

If a task is split into slices, group them in a folder carrying the same
prefix: `tasks/<YYYYMMDD-HHmm>-<feature-slug>/<NN>-<slice-slug>.spec.md`,
slices numbered from `01` in dependency order (blockers first); each gains
its own `.work.md` at its own `plan`.

## Status Indicators

| Status | Emoji | Meaning |
|--------|-------|---------|
| Not Started | 🔴 | Task not yet begun |
| In Progress | 🟡 | Active development |
| Blocked | 🟠 | Waiting on dependencies |
| Complete | 🟢 | All acceptance criteria met |
| Deferred | ⚪ | Postponed |
| Cancelled | ⚫ | No longer needed |

The status lives only in the spec document, maintained by the thread owner
— never by the Mason, whose own resume point is the work document's
implementation checkboxes. Completed tasks (spec and work document
together) are moved to the archive declared in `.agents/project.md` (default
`/project-management/archive/`).

## When Creating New Tasks

1. **Interview first** — reach shared understanding before writing (the
   `interview` step of the formula in `.agents/formulas/`)
2. **Agree the seams** with the human before writing the file
3. **Fill the 🧑 zones carefully** — they are the review surface, and the
   whole of this document
4. **Keep the top short** — detail goes down the gradient, not deleted
5. **Update status** as work progresses; check off acceptance criteria at
   `close`, against reality
6. **The work document comes later** — the implementing session creates it
   at `plan`, never before; this file never gets a program design of its own

## When Reviewing Tasks (human)

- Read 🧑 REVIEW CAREFULLY entirely — this is your decision surface
- Read 🧑 REVIEW IF RELEVANT for medium/large tasks
- There is nothing to skim or skip: this document IS the review surface
- Check that acceptance criteria are named and machine-verifiable, and that
  seams are right
- The work document, if one exists, is evidence for the diff review — never
  a reference to judge the diff against; that is this document's job alone
````

### `socle/templates/000-template.work.md` — new file, full text

````markdown
# Task Work Document Template & Standards

**Status:** 🟢 Complete
**Version:** 1 (born at the spec / work split; the coding agent's own file —
see the spec template,
[000-template.spec.md](/project-management/000-template.spec.md), and
[methodology.md](/.agents/methodology.md))

## Context

The work document is the coding agent's own file: its program design and
pseudo-code, its worklog, its implementation checkboxes, its Notes &
Snippets, and the findings the Inspector writes at `diff-review`. One file,
one owner — no zone marker anywhere in it, because the reading-gradient
distinction (what the human must read carefully vs skim) does not apply to
working material nobody but the agent and its reviewers read start to
finish.

**Who creates it, when, where, under what name.** The implementing session
— the Mason — creates it at its `plan` step, never earlier. It lives beside
its spec, in the spec's own directory, named by replacing the spec's
`.spec.md` suffix with `.work.md`: same time id (or slice number), same
directory, no separate id generation. A spec with no work document beside it
has never been typed.

**Lifecycle.** While work is live, the work document is deletable and
regenerable: delete it, revise the spec, and restart — nothing is lost that
the spec did not already carry. That window closes at `close`: the work
document is archived **alongside its spec**, both files moved together. This
does not follow automatically from sharing a directory — archiving is a
named step that must move both, because the diff review reads the program
design as evidence (destroyed evidence proves nothing), a retrospective may
cite the worklog, and the repo is the only memory this system has. A parent
spec of a sliced task never gets a work document of its own — only its
slices do, one each.

**The Architect validates it and never edits it.** At `plan-review`, the
Architect returns a verdict on the program design persisted here — VALIDATED
or a round of findings — and never writes into this file itself; a revision
is the Mason's own act, in response to the verdict.

**The Inspector writes into it, and does not own it.** At `diff-review`, the
Inspector reads the spec document as the requirement and this file as
evidence, then writes its findings into this file's own section below. That
this file's owner is someone else does not make the write wrong: a finding
is a report, not a decision, and the owner of this file still rules on it —
exactly as a reviewer comments on code they do not own.

## Work Document Template

All work documents MUST follow this structure:

```markdown
# <Task name> — work

Created by <implementing session> at `plan`, <date>. Spec:
`<same directory>/<same name>.spec.md`.

## Program Design

Persisted at `plan`, from the spec's approved system design. Decisions, not
descriptions: modules built/modified and their interfaces, schema changes,
API contracts, edge cases to handle. Pseudo-code belongs here when it
encodes a decision more precisely than prose can (state machine, schema,
type shape). Revised in writing whenever reality contradicts it — never
carried in the session's head alone — and re-validated where the preset
runs a `plan-review`.

## Worklog

Dated entries, one per work session: what was attempted, what landed, what
was reverted and why. A commit at every green step, not a pile-up saved for
the end.

## Implementation Checkboxes

- [ ] Step 1
- [ ] Step 2

Ticked as work lands. Not decoration: they are the resume point. A fresh
Mason picking the work back up reads this file and restarts at the first
unticked box.

## Notes & Snippets

### Worklog

2026-08-31 — Implemented the approved three-commit plan. The exact gate
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passed with 9 scenarios,
94 assertions and 0 failures. The seven slice criteria were re-run against
the final tree and passed. The slice now awaits the Inspector's diff review.

2026-08-31 — Inspector cleared the diff-review with no findings on either
Standards or Spec. The Foreman ticked the seven slice criteria against the
recorded checks and closed the slice.

The Mason's own working notes, code snippets, exploration findings. May be
verbose — this is agent working space, and nobody else is required to read
it start to finish.

## Diff-Review Findings

Written by the Inspector at `diff-review`, judging the diff against the
spec document's requirement and reading this file as evidence. A finding is
a report; this file's owner rules on it.
```

## When Creating a Work Document (the Mason)

1. Create it at `plan`, never before — an open question about the *what* at
   this point means the spec is unfinished; hand it back rather than guess.
2. Name it by replacing the spec's `.spec.md` suffix with `.work.md`, same
   directory.
3. Persist the program design here, step by step, in vertical slices — never
   layer by layer.
4. Tick implementation checkboxes as work lands; they are the resume point.
5. Commit at every green step. Never carry an open *how* question in your
   head — revise the design here, in writing, and re-validate it where the
   preset runs a `plan-review`.

## When Reading a Work Document (Architect, Inspector, a fresh Mason)

- The Architect reads the Program Design at `plan-review` and returns a
  verdict; it never edits this file.
- The Inspector reads the spec document as the requirement and this file as
  evidence at `diff-review`, then writes its findings into this file's own
  section.
- A fresh Mason resuming the work reads the implementation checkboxes and
  restarts at the first unticked one — never re-derives the plan from
  scratch.
````

### `socle/templates/000-task-file-template.md` — deleted

Deleted outright in commit 2, once `bin/chisel.sh` no longer names it.

### `bin/chisel.sh` — three edits, one source constant becoming two

1. **Source constants** (currently line 49):
   ```sh
   TASK_TEMPLATE_SRC="$SOCLE/templates/000-task-file-template.md"
   ```
   becomes two:
   ```sh
   SPEC_TEMPLATE_SRC="$SOCLE/templates/000-template.spec.md"
   WORK_TEMPLATE_SRC="$SOCLE/templates/000-template.work.md"
   ```

2. **`managed_relative_files()`** (currently one `printf` line):
   ```sh
   printf 'project-management/000-task-file-template.md\n'
   ```
   becomes two, in sort order:
   ```sh
   printf 'project-management/000-template.spec.md\n'
   printf 'project-management/000-template.work.md\n'
   ```

3. **`copy_managed_files()`** (currently one `cp` line):
   ```sh
   cp "$TASK_TEMPLATE_SRC" "$target_dir/project-management/000-task-file-template.md"
   ```
   becomes two:
   ```sh
   cp "$SPEC_TEMPLATE_SRC" "$target_dir/project-management/000-template.spec.md"
   cp "$WORK_TEMPLATE_SRC" "$target_dir/project-management/000-template.work.md"
   ```

No other function reads `TASK_TEMPLATE_SRC`, `managed_relative_files`'s
template line, or that `cp` line (verified: `grep -n
"000-task-file-template" bin/chisel.sh` returns exactly the three lines
above — the constant's definition, the manifest `printf`, and the `cp`;
`TASK_TEMPLATE_SRC` itself is read in only two of those three, since the
manifest line carries the path as a literal rather than through the
variable). `cmd_init`, `cmd_update` and `cmd_check` need no edits — they
read the manifest and the `managed_relative_files` list generically, never
this file's name specifically, so tracking two entries instead of one is
transparent to them.

### `test/fixtures/golden-tree.txt` — one line becomes two

Line 92 currently reads `project-management/000-task-file-template.md`.
Replace it with, in `LC_ALL=C sort` order (verified: `s` < `w`, so
`.spec.md` sorts first, matching the naming convention's stated gain):

```
project-management/000-template.spec.md
project-management/000-template.work.md
```

Net effect on the tree: +1 line. Nothing else in the fixture changes — no
other line names the template.

### `socle/agents/project.md.tpl` — two edits

**Section A · Task workspace** (currently one bullet, line 39):
```
- **Task file template:** `/project-management/000-task-file-template.md`
```
becomes two bullets, right after "Roadmap" and before "Task id script":
```
- **Spec template:** `/project-management/000-template.spec.md`
- **Work template:** `/project-management/000-template.work.md`
```
The questionnaire comment above (currently "where do tasks, archive,
changelog, roadmap, and the task template live?") gets "the task template"
→ "the two task templates" — a one-word fix, not a rewrite.

**Section B1 · Where task statuses live** (currently, lines 55–63):
```
- **Active tasks:** `<Tasks>/<time-id>-<intention>.md` (see Section A),
  where `<time-id>` is generated by `<Task id script>` (`YYYYMMDD-HHmm`, for
  automatic chronological sorting). Large tasks may be split into slice files
  under `<Tasks>/<time-id>-<feature-slug>/<NN>-<slice-slug>.md`, numbered in
  dependency order (see the `slice-task` skill)
- **Completed tasks:** moved to `<Archive>` (see Section A)
- **Format:** the template at `<Task file template>` (see Section A)
  (reading-gradient zones: 🧑 review carefully / 🧑 review if relevant / 🤖
  agent zone)
```
becomes:
```
- **Active tasks:** `<Tasks>/<time-id>-<intention>.spec.md` (see Section A),
  plus the work document the implementing session creates beside it at
  `plan`, where `<time-id>` is generated by `<Task id script>`
  (`YYYYMMDD-HHmm`, for automatic chronological sorting). Large tasks may be
  split into slice files under
  `<Tasks>/<time-id>-<feature-slug>/<NN>-<slice-slug>.spec.md`, numbered in
  dependency order (see the `slice-task` skill), each with its own work
  document
- **Completed tasks:** moved to `<Archive>` (see Section A), spec and work
  document together
- **Format:** the spec template at `<Spec template>` (see Section A) —
  reading-gradient zones 🧑 review carefully / 🧑 review if relevant — and, once
  work starts, the work template at `<Work template>`, which carries no zone
  marker
```
The `- **Status:**` and `- **Work the frontier:**` lines below are
unchanged; neither names the template.

### `socle/agents/methodology.md` — one paragraph, the opening

Currently (lines 4–7 — the fragment that changes starts at the end of line
4, "The **what/where** is the", not at line 5; noted so the edit lands on
the right words):
```
and agents apply it with judgement, not cargo-cult. The **what/where** is the
task file template declared in §A · Task workspace of `.agents/project.md`
(default `/project-management/000-task-file-template.md`); the **order and
the gates**
```
becomes (the verb changes too — "templates" is plural, so "is" becomes
"are"):
```
and agents apply it with judgement, not cargo-cult. The **what/where** are
the spec and work templates declared in §A · Task workspace of
`.agents/project.md` (defaults `/project-management/000-template.spec.md`
and `/project-management/000-template.work.md`); the **order and the gates**
```
Nothing else in this file is touched by this slice — the reading-gradient
glossary entry, "Zone ownership", the two-designs passage and the phase
table are slice 2's, per the parent spec's files map.

### `socle/agents/skills/upgrade-v2/SKILL.md` — one sentence

Currently (lines 158–160):
```
`tasks/` and `archive/` directories are harmless (git does not track them),
and `project-management/000-task-file-template.md` stays where the installer
put it — it is a managed file and `chisel check` expects it at that path.
```
becomes:
```
`tasks/` and `archive/` directories are harmless (git does not track them),
and `project-management/000-template.spec.md` and
`project-management/000-template.work.md` stay where the installer put
them — they are managed files and `chisel check` expects them at those
paths.
```

### `AGENTS.md` — one bullet

Currently (lines 5–7):
```
- Work is tracked as task files in `project-management/tasks/` (template:
  `project-management/000-task-file-template.md`; completed →
  `project-management/archive/`; dated `project-management/CHANGELOG.md`).
```
becomes:
```
- Work is tracked as task files in `project-management/tasks/` (templates:
  `project-management/000-template.spec.md` and
  `project-management/000-template.work.md`; completed →
  `project-management/archive/`; dated `project-management/CHANGELOG.md`).
```
`CHANGELOG.md` is this repo's own, pre-existing journal name — a different
convention from the glue template's `LOG.md` default, and outside this
slice's business either way.

### `PHILOSOPHY.md` — one link

Currently (lines 147–148):
```
and the task template in
[socle/templates/](./socle/templates/000-task-file-template.md).
```
becomes:
```
and the two task templates in
[socle/templates/](./socle/templates/000-template.spec.md) —
the spec document and, for the work document,
[000-template.work.md](./socle/templates/000-template.work.md).
```
Nothing else in `PHILOSOPHY.md` is touched (parent spec, Implementation
Decisions point 8: this is the one mechanical exception, already ruled).

### `project-management/000-template.spec.md`, `project-management/000-template.work.md` — this repo's own copies

Byte-for-byte copies of the two socle source files above, **derived from
the socle copy, not from the stale local file they replace** (parent spec's
Notes: the local copy is missing "Where each kind of content lives" and
points at a retired `doc/agents/workflows.md`). Exactly one adaptation on
each, per decision 9 above: the `methodology.md` cross-link in the version
line, rewritten from `/.agents/methodology.md` to `../socle/agents/methodology.md`
— the real, resolvable relative path from `project-management/` in this
repo, which has no installed `.agents/` (it has `socle/agents/` instead).
The work document's copy additionally carries its own-file cross-link
(`000-template.spec.md`) unchanged, since that one already resolves
correctly as a same-directory link. No other line differs from the socle
source — not the generic `.agents/project.md` mentions, not the illustrative
on-disk paths, nothing else.

### `project-management/000-task-file-template.md` — deleted

Deleted in commit 3, replaced by the two files above.

### Verification

Gate command, after every commit: `PATH="/opt/homebrew/bin:$PATH" bash
test/run.sh`. Expected at EVERY step, commit 1 through commit 3, unchanged
from baseline: **9 scenarios, 94 assertions, 0 failed**. The golden tree is
compared by `assert_files_identical` in `test/installer.sh` — once in the
`init` group, once in `boilerplate` — which is one assertion per comparison
whatever the fixture's line count; nothing in the suite asserts per line, so
adding a line to `test/fixtures/golden-tree.txt` does not add an assertion.
This is precisely why the parent spec routes the change through the fixture
rather than through new assertions: no assertion is written in
`test/installer.sh` (the Testing Strategy's cap note: the suite has eight
lines of headroom under its 600-line cap, and this slice needs none of it).
A Mason typing this slice who counts anything other than 94 after any commit
has broken something, not found one short — the fix is in this slice's own
files, never a hunt through `test/installer.sh` for a missing assertion.

**Named criteria this slice closes outright**, checked in the order the
Writing order produces them: **two-templates-shipped** and
**both-templates-installed-and-managed** after commit 2;
**old-template-cited-nowhere**, **spec-document-is-all-review-surface**,
**the-spec-keeps-a-notes-section-for-pre-plan-writers**,
**named-criteria-in-the-spec-template** and
**work-document-owns-the-program-design** after commit 3. This slice's
share of **suite-green** holds throughout, at every commit, not only the
last.

**Named criteria this slice deliberately does NOT close, and why** — so
nobody reading only this file mistakes silence for an oversight:
**the-program-design-has-left-the-spec** (its 8 matches of `Design section`
live in the five formulas, `methodology.md` ×2, and `mason.md` — none of
them this slice's files) and **no-file-says-the-spec-file** (its 21 matches
of `the spec file` live in `mason.md`, the five formula headers,
`discipline.md`, `architect.md`, `inspector.md`, `retro/SKILL.md` and
`AGENTS-block.md` — again, none of them this slice's files) are both
repo-wide closing greps that can only reach zero once slices 2–4 land.
**the-roles-name-the-work-document** (the four profiles) is slice 2's.
**formulas-send-the-work-to-the-work-document** (the five formulas) is
slice 3's. **spec-axis-judges-the-whole-spec**,
**slice-task-emits-spec-documents-only**,
**beads-and-retro-name-the-right-document** and
**upstream-notes-tell-the-truth** (the four skills) are slice 4's.
**tasks-still-to-do-are-renamed** and
**no-task-citation-points-at-a-missing-file** (the migration) are slice 5's;
this slice's files map explicitly avoids `project-management/tasks/` and
`project-management/archive/`, so it touches neither the six files nor
their citers.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes & Snippets

**Grep counts re-verified against the repo at this slice's plan time,
2026-08-28** — the parent spec's own table, re-run rather than trusted
blindly (its Testing Strategy's rule: a criterion that has never actually
matched proves nothing once it goes green):

- `000-task-file-template` in `socle/ bin/ test/ AGENTS.md PHILOSOPHY.md`:
  **9**, across `socle/agents/project.md.tpl` (1),
  `socle/agents/methodology.md` (1),
  `socle/agents/skills/upgrade-v2/SKILL.md` (1), `bin/chisel.sh` (3),
  `test/fixtures/golden-tree.txt` (1), `AGENTS.md` (1), `PHILOSOPHY.md` (1).
  All seven files are in this slice's files-to-modify map; none of the 9 is
  outside it. `README.md` carries no such citation (checked directly), which
  is why it is correctly absent from both the grep's scope and this slice's
  map.
- `AGENT ZONE` in `socle/templates/000-task-file-template.md`: **3** (the
  zone table, the zone marker, the human-review checklist) — matches the
  parent spec's corrected count, not its original.
- The installer's "no pointer into thin air" check
  (`test/installer.sh`, `group_integrity`) scans `AGENTS.md`, `.agents/`,
  `.claude/agents/`, `.codex/agents/` in the INSTALLED tree only — never
  `project-management/`. It gives this slice no safety net for the template
  rename; every citer above is repointed by hand and verified by the named
  criteria's own greps, not by that check.
- **Two more live citers of the old filename exist, correctly outside this
  slice's map and outside `old-template-cited-nowhere`'s scope** (that
  criterion's grep does not reach either) — named here so their survival
  reads as deliberate, not missed. `project-management/tasks/20260826-2302-chisel-dogfoods-itself.md`
  (🟠, blocked, not this slice's file) cites the old path twice and carries
  an unchecked deliverable, "`project-management/000-task-file-template.md`
  pointers repaired" — this slice's own repointing of the repo's
  `project-management/` copies satisfies that deliverable's substance as a
  side effect, though ticking it is that file's own business, not this
  slice's to touch. `project-management/vendored-skills-audit.md` (an
  untracked working document of the vendored-skills audit, not this slice's
  file either) cites `socle/templates/000-task-file-template.md` four times;
  it is a live draft the audit chantier owns, not this task.

**Writing rules in force**, per the parent spec's Notes and this repo's own
convention: English throughout; the Owner's quotations stay in French, in
quotation marks; no bare codes; a reference names its file and section
title, never a bare number or a line number (the "currently, lines N–M"
callouts inside this Design section are this slice's own working notes for
typing accurately, not references inside the templates themselves — the
templates carry none); named acceptance criteria, cited by name; an amended
criterion struck and dated rather than erased; no invented numeric limit
anywhere.

**Architect findings — `plan-review`, round 1, 2026-08-28.** Verdict:
**corrections**, one blocking. Everything else the design asserts about the
repo was re-run and holds: the 9 citations of the old filename and their seven
carriers, `README.md` carrying none, the three places `bin/chisel.sh` names it,
`managed_relative_files` hardcoding the path rather than scanning the
directory, `LC_ALL=C` putting `.spec.md` before `.work.md` and both before
`LOG.md` in the fixture, the stale local copy's broken
`../agents/methodology.md`, the integrity check scanning only `AGENTS.md`,
`.agents/`, `.claude/agents/` and `.codex/agents/` of the installed tree, the
two repo-wide greps of slices 2–4 (`the spec file` 21, `Design section` 8)
matching nothing inside either persisted template, and the gate baseline — 9
scenarios, 94 assertions, 0 failed, suite at 592 lines. The commit-2
atomicity argument is correct as stated.

**Blocking — the expected assertion count is wrong, and typing to it would
push the Mason into the one file the Testing Strategy forbids.** The
Verification section predicts "the assertion count grows by exactly the
golden-tree line this slice adds (94 → 95) from commit 2 onward". It does not.
The golden tree is compared by `assert_files_identical` in `test/installer.sh`
— once in the `init` group and once in the `boilerplate` group — which is ONE
assertion per comparison whatever the fixture's length; nothing in the suite
asserts per line. The expected result after every one of the three commits is
**9 scenarios, 94 assertions, 0 failed — unchanged from baseline**, and that
is the whole point of routing the change through the fixture. Correct the
number before typing: a Mason that reaches commit 2, counts 94 and believes it
is one assertion short will go looking for it in `test/installer.sh`, which is
both outside this slice's files map and against the parent spec's Testing
Strategy given the eight-line headroom under the cap.

**Non-blocking, in descending order of consequence.**

1. *A false verification claim about `bin/chisel.sh`.* The design writes
   "verified: `grep -n "TASK_TEMPLATE_SRC" bin/chisel.sh` returns exactly the
   three lines above". It returns two — the constant and the `cp`. The third
   line, the manifest `printf`, carries the path as a literal and never reads
   the constant. The conclusion the claim supports is nevertheless true and was
   re-verified: no other function reads the constant, the manifest line or the
   `cp`. Name the grep that actually returns three (`000-task-file-template` in
   `bin/chisel.sh`) so the record is true.
2. *The spec template inherits a broken sentence from the old one.* In "File
   Naming Conventions", the persisted text carries the current template's
   dangling fragment forward verbatim with only the suffix changed: "the task
   workspace declared in `.agents/project.md` (default
   `/project-management/tasks/`), as `<…>.spec.md`." — no subject and no verb;
   in the source it is a paragraph that lost its opening clause. This slice is
   what gives the spec document its shape, and the fix is one clause ("Place it
   in the task workspace declared in …"). Carrying a known-broken sentence into
   a brand-new file is the kind of thing nobody comes back for.
3. *The `methodology.md` edit leaves an ungrammatical seam.* The replacement
   begins "spec and work templates declared in §A", and the unchanged line
   above it ends "The **what/where** is the" — giving "The what/where is the
   spec and work templates declared in §A". Extend the edit one line up so the
   verb agrees; the slice's map already owns that opening paragraph. (The
   callout says "lines 4–8"; the fragment quoted starts at line 5. Working
   note, no consequence.)
4. *A self-contradicting sentence in the spec template's Architecture
   guidance.* "The indicative files-to-modify / files-to-avoid map for each
   slice lives here too, in "Slices & Dependencies" below." — "here too" and
   "below" cannot both be true. The parent spec settles the substance (the map
   belongs to the system design, and is written per slice); say that instead,
   in one sentence, so a reader of the shipped template is not left choosing.
5. *The slice restates one criterion short.* The parent spec's
   **the-spec-keeps-a-notes-section-for-pre-plan-writers** has a second half —
   "And Given `socle/agents/profiles/checker.md`, When read, Then its
   instruction to write findings into the Notes of the spec still resolves to a
   real section" — which this file drops while claiming the criterion outright.
   Substantively it holds and was checked: `checker.md` names "the Notes of the
   spec" twice, in its `description` frontmatter and in the Verdict line of its
   Mission, it is untouched by this slice, and the new spec template carries a
   `## Notes` section. Cite the criterion whole, so what is verified at `close`
   is the parent's version and not a shortened one.
6. *Two live citers of the old filename sit outside the criterion's scope, and
   the Notes above read as if none existed.* Both are correctly out of this
   slice's map; naming them costs a line and stops a later reader thinking they
   were missed. `project-management/tasks/20260826-2302-chisel-dogfoods-itself.md`
   (open, 🟠) carries an unchecked deliverable "`project-management/000-task-file-template.md`
   pointers repaired" — the very pointer decision 9 repairs, so shipping the
   derived copies satisfies it; that file is slice 5's. And
   `project-management/vendored-skills-audit.md`, an untracked working document
   of the audit chantier, cites `socle/templates/000-task-file-template.md`
   three times.

**Round 1 of two.** Only the first finding blocks. The rest are corrections to
text that is about to be transcribed literally, which is why they are recorded
here rather than left to the diff.

**Architect verdict — `plan-review`, round 2, 2026-08-28: VALIDATED.** All
seven corrections applied, none refuted, nothing new opened. Re-verified: the
Verification section now expects 94 assertions at every commit and warns a
future Mason off `test/installer.sh`; the `bin/chisel.sh` section cites the
grep that returns three and says the constant is read in two of them; the
spec template's naming paragraph is a sentence again and its Architecture
guidance no longer contradicts itself; the criterion is restated whole with
its `checker.md` half; the `methodology.md` edit extends one line up and
carries "is" → "are" in both quote blocks, matching the repo's line 4
exactly. The Mason's count of `project-management/vendored-skills-audit.md`
is right and mine was wrong: **four** occurrences, not three — the round-1
block above keeps my figure as written, since it is a dated record and this
line is the correction. Two of the seven fixes landed inside the persisted
spec template text, so the round-1 conclusion about later slices was
re-established rather than assumed: every criterion grep was re-run against
the revised template texts and all remain clean — no `AGENT ZONE` and no
`Criterion 1` in the spec template, no `🧑` in the work template, no
`000-task-file-template`, and neither `the spec file` nor `Design section`
anywhere in either, so nothing this slice ships can block slices 2 to 4. The
work template text is unchanged. Two rounds spent; this design is ready for
the Owner's gate.

## Worklog

(Empty at `plan`. Filled in, one dated entry per commit, as the three
commits above land during `type`.)
