# The task status model: one ladder, thirteen values, the human's wait named — work

Created by the implementing session at `plan`, 2026-09-15. Spec:
`project-management/tasks/20260914-2230-task-status-model.spec.md`.

## Program Design

The chantier writes prose, not code: no module, no schema, no API. The
design is therefore a set of decisions about *what text goes where*, plus
the derivation that produces the status line of every formula step.

### The thirteen values, and the one place they live

The vocabulary is written once, in the "Statuses" section of the spec
template (both copies), as one table of thirteen rows. Nine on the path, in
ladder order, then four off-path. Each value in backticks; each row carries
its meaning and, for the nine, the pipeline moment that leaves a task
there. Everything else in the socle points at that table rather than
restating the list — the glue's §B1 · Where task statuses live, the
glossary row of `reference.md`, and the reasoning section of
`methodology.md`.

Table as it will be written (column three empty for the four off-path
values, which are reached by a human decision, not by a step):

| Status | Meaning | Left there by |
|---|---|---|
| `creating` | the spec is being written, its review included | `interview`, `spec`, `spec-review` |
| `waiting-business-approval` | a human must validate the need | spec-approval gate, business side |
| `waiting-design-approval` | a human must validate the spec's system design — seams, architecture, decisions | spec-approval gate, design side |
| `ready` | approved, nothing retains it, waiting for a Mason | end of the create phase — the frontier |
| `planning` | the Mason is writing its program design | `plan`, `plan-review` |
| `waiting-plan-approval` | a human must green-light the program design | plan-approval gate |
| `in-progress` | the Mason is typing, verifying, or the diff is under review | `type`, `verify`, `diff-review` |
| `waiting-diff-approval` | a human must arbitrate the review findings | review-arbitration gate |
| `done` | acceptance criteria ticked, both documents archived | `close` |
| `blocked` | held by a named dependency, named beside the value | — |
| `stalled` | nobody is advancing it and nothing named is awaited | — |
| `deferred` | postponed by a human decision | — |
| `cancelled` | no longer wanted | — |

Four sentences follow the table, one each: the value is written alone on the
`**Status:**` line, no emoji; the thread owner alone writes it, at step
boundaries, as each formula step's last line says; `stalled` is a human's
call on a written criterion (nobody is advancing it, nothing named is
awaited, nobody intends to resume soon) and no formula step writes it; the
four off-path values replace the on-path one rather than sitting beside it,
and the maturity the task had is read from the file itself — criteria
ticked, work document present — not from the status.

Then the migration table for repos updating by hand, at the end of the
section. **It names the old six statuses by their words only** — Not
Started, In Progress, Blocked, Complete / Done / Delivered, Deferred,
Cancelled — because the acceptance criterion `emoji-gone` forbids the six
emoji anywhere under `socle/` or in either template, and the migration table
lives in the template. The words are what the old lines carried after the
emoji, so nothing is lost for a reader holding an old file.

### How each formula step's status is derived

One rule, applied to the five presets. In these TOML files a
`[steps.gate]` block attached to a step reads "stop and ask the human
before starting *this* step", so a gate sits BETWEEN the step that precedes
it and the step that carries it. Therefore:

1. If the NEXT step carries a human gate, this step ends at that gate and
   leaves the task in that gate's `waiting-…` value.
2. Otherwise it leaves the task in the active value that covers the next
   step to run — `creating` covers `interview`/`spec`/`spec-review`,
   `planning` covers `plan`/`plan-review`, `in-progress` covers
   `type`/`verify`/`diff-review`.
3. `done` is written by `close` alone. A step that hands over to `close`
   with no gate in between leaves the task `in-progress`: the task is not
   done until `close` has run.
4. The boundary between the create phase and the work phase is `ready` in
   every preset. Where a gate stands there, the step leaves the task in
   `waiting-business-approval` and the step body says the human then writes
   `waiting-design-approval` and then `ready` by hand as each approval
   lands. Where no gate stands there — the two gateless presets — the step
   writes `ready` itself: the spec is finished and committed, the create
   session stops, and the task sits approved and unclaimed until the
   Foreman spawns a Mason. This keeps `ready` reachable, and the frontier
   searchable, under all five presets.

Applied to the default preset this reproduces, value for value, the list
the spec's Scope section already fixes — which is the check that the rule
is the intended one.

**Default**, nine steps, three gates (before `plan`, `type`, `close`):

| Step | Status after it |
|---|---|
| `interview` | `creating` |
| `spec` | `creating` |
| `spec-review` | `waiting-business-approval` |
| `plan` | `planning` |
| `plan-review` | `waiting-plan-approval` |
| `type` | `in-progress` |
| `verify` | `in-progress` |
| `diff-review` | `waiting-diff-approval` |
| `close` | `done` |

**Supervised**, nine steps, one gate (before `plan`):

| Step | Status after it |
|---|---|
| `interview` | `creating` |
| `spec` | `creating` |
| `spec-review` | `waiting-business-approval` |
| `plan` | `planning` |
| `plan-review` | `in-progress` |
| `type` | `in-progress` |
| `verify` | `in-progress` |
| `diff-review` | `in-progress` |
| `close` | `done` |

**Auto**, nine steps, no gate:

| Step | Status after it |
|---|---|
| `interview` | `creating` |
| `spec` | `creating` |
| `spec-review` | `ready` |
| `plan` | `planning` |
| `plan-review` | `in-progress` |
| `type` | `in-progress` |
| `verify` | `in-progress` |
| `diff-review` | `in-progress` |
| `close` | `done` |

**Light**, seven steps (no `spec-review`, no `plan-review`), two gates
(before `plan`, before `diff-review`):

| Step | Status after it |
|---|---|
| `interview` | `creating` |
| `spec` | `waiting-business-approval` |
| `plan` | `in-progress` |
| `type` | `in-progress` |
| `verify` | `waiting-diff-approval` |
| `diff-review` | `in-progress` |
| `close` | `done` |

**Auto-light**, six steps (no review of either kind), no gate:

| Step | Status after it |
|---|---|
| `interview` | `creating` |
| `spec` | `ready` |
| `plan` | `in-progress` |
| `type` | `in-progress` |
| `verify` | `in-progress` |
| `close` | `done` |

Two values are written by no step of the two lightest presets — `planning`
in auto-light (the same session plans and types, so the boundary is not a
step boundary) and `waiting-plan-approval` wherever no plan gate exists.
That is the intended shape: the values live once, each preset picks its path
through them.

The fixed sentence is the LAST line of each step's description body, in one
form, `Status after this step: \`<value>\`.` — a TOML multi-line string, so
the line goes inside the closing `"""`. The supervised preset's header
comment loses `awaiting approval` for `waiting-business-approval`.

### The other shipped surfaces

- **Glue**, `socle/agents/project.md.tpl`, §B1 · Where task statuses live:
  the `**Status:**` bullet drops the six emoji and points at the spec
  template's status table; the frontier bullet says a task is on the
  frontier when its status is `ready`.
- **Beads skill**, `SKILL.md`: a section saying the database carries the
  same thirteen values natively, that `bd ready` is the Mason's frontier
  command (open, and nothing open upstream), that `bd list --status
  <value>` answers for every other value, and naming the two spelling
  translations — `ready` in the file is `open` in the database,
  `in-progress` is `in_progress` — with `blocked` and `deferred` being
  built-ins of the same name.
- **Beads skill**, `CHANGING-CASE.md`: a new numbered step of Entering
  declares the custom statuses with the verbatim `bd config set
  status.custom "…"` string the spec fixes, placed before Pass 1; Pass 1's
  status reading is rewritten to the new values (`done` and `cancelled`
  left alone; every other value creates a bead and is handed over as
  itself, `ready` as `open`, `in-progress` as `in_progress`); Leaving
  restores the fine value with the two translations reversed. The sentence
  "This is now the one and only place that file's status lives" stays.
- **Slice template**, `socle/agents/skills/slice-task/SKILL.md`:
  `**Status:** creating`.
- **Setup questionnaire**, `socle/agents/skills/chisel-setup/SKILL.md`: the
  cost of keeping statuses in the files is no longer "nothing can tell an
  agent which tasks are ready without reading them all" — a search for
  `ready` now answers that. The true remaining cost is that the blocking
  edges are not searchable: they are read from the files one by one, and a
  search answers only what a status line says.
- **Reasoning**, `socle/agents/methodology.md`: a new section "The status of
  a task" — why one ladder rather than two axes, why each human wait is
  named by the human's act, why the thread owner alone writes it, why no
  emoji. One sentence notes the two-pass spec variant as a future
  extension, one that a tracker adapter maps the thirteen values to its own
  states.
- **Glossary**, `socle/agents/reference.md`: a **Status** row pointing at
  the template's table.

### The workspace migration

44 `**Status:**` lines exist today under `project-management/tasks/` and
`project-management/archive/`, not 43: the count in the spec was taken
before this task's own spec file was committed with
`**Status:** in-progress` at `Start the status model chantier`. That line
already conforms and is the Foreman's, not mine — 43 lines to rewrite,
free text kept.

Three of the 43 are not a file's own status but quoted template excerpts
inside one archived task file about templates,
`archive/20260828-2217-split-spec-and-work-documents/01-templates-and-installer.md`
— two quoting a finished task's line, one quoting the old template
skeleton's placeholder. The acceptance criterion is mechanical (no
non-conforming `**Status:**` line anywhere under the two trees), so they
are rewritten too: the two finished ones to `done`, the skeleton
placeholder to `creating`, which is what the new skeleton carries.

The full list, with the value each line gets:

| File (under `project-management/`) | Today | New |
|---|---|---|
| `tasks/20260806-0959-chisel-v1.spec.md` | Not Started | `in-progress` |
| `tasks/20260806-0959-chisel-v1/01-repo-skeleton-import.md` | Complete | `done` |
| `tasks/20260806-0959-chisel-v1/02-genericize-socle.md` | Complete | `done` |
| `tasks/20260806-0959-chisel-v1/03-installer-cli.md` | Complete | `done` |
| `tasks/20260806-0959-chisel-v1/04-setup-questionnaire.md` | Complete | `done` |
| `tasks/20260806-0959-chisel-v1/05-upstream-sync.md` | Complete | `done` |
| `tasks/20260806-0959-chisel-v1/06-pilot-migration.spec.md` | Not Started | `ready` |
| `tasks/20260806-0959-chisel-v1/07-release.spec.md` | Not Started | `blocked` |
| `tasks/20260810-1037-field-test-fixes.md` | Complete | `done` |
| `tasks/20260825-1046-philosophy-doc.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2.spec.md` | Not Started | `in-progress` |
| `tasks/20260826-1512-chisel-v2/01-recomposition-discipline-formulas.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2/02-agent-profiles.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2/03-model-tiers-user-md.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2/04-setup-b-and-glue-v2.md` | Done | `done` |
| `tasks/20260826-1512-chisel-v2/05-chisel-beads-convention.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2/06-upgrade-v2-and-log-md.spec.md` | Blocked | `blocked` |
| `tasks/20260826-1512-chisel-v2/07-docs-and-dedup.md` | Complete | `done` |
| `tasks/20260826-1512-chisel-v2/08-post-audit-hardening.md` | Done | `done` |
| `tasks/20260826-1512-chisel-v2/09-test-suite-rebuild.md` | Delivered | `done` |
| `tasks/20260826-1512-chisel-v2/10-review-loops-in-workflows.md` | Done | `done` |
| `tasks/20260826-1512-chisel-v2/11-owner-review-fixes.md` | Complete | `done` |
| `tasks/20260826-2302-chisel-dogfoods-itself.spec.md` | Blocked | `blocked` |
| `tasks/20260914-2230-task-status-model.spec.md` | `in-progress` | untouched — the Foreman's |
| `archive/20260827-1459-remodel-roles-and-formulas.md` | Complete | `done` |
| `archive/…-remodel-roles-and-formulas/01-roles-remodel.md` | Complete | `done` |
| `archive/…-remodel-roles-and-formulas/02-formulas-rewrite.md` | Complete | `done` |
| `archive/…-remodel-roles-and-formulas/03-doctrine-alignment.md` | Complete | `done` |
| `archive/…-remodel-roles-and-formulas/04-switch-removal.md` | Complete | `done` |
| `archive/20260828-2217-split-spec-and-work-documents.spec.md` | Complete | `done` |
| `archive/…-split-spec-and-work-documents/01-templates-and-installer.md` (own line) | Complete | `done` |
| `archive/…/01-templates-and-installer.md` (quoted, mid-file) | Complete | `done` |
| `archive/…/01-templates-and-installer.md` (quoted skeleton placeholder) | placeholder | `creating` |
| `archive/…/01-templates-and-installer.md` (quoted, later) | Complete | `done` |
| `archive/…-split-spec-and-work-documents/02-doctrine-follows.md` | Complete | `done` |
| `archive/…-split-spec-and-work-documents/03-formulas-follow.md` | Complete | `done` |
| `archive/…-split-spec-and-work-documents/04-skills-follow.md` | Complete | `done` |
| `archive/…-split-spec-and-work-documents/05-rename-the-tasks-to-do.spec.md` | Complete | `done` |
| `archive/20260908-1149-joints-and-minors.spec.md` | Complete | `done` |
| `archive/…-joints-and-minors/01-doctrine-and-glue-text.spec.md` | Complete | `done` |
| `archive/…-joints-and-minors/02-templates-front-door-and-skills.spec.md` | Complete | `done` |
| `archive/…-joints-and-minors/03-the-shipped-set-shrinks.spec.md` | Complete | `done` |
| `archive/20260910-1447-normative-reference-and-writing-rules.spec.md` | Complete | `done` |
| `archive/20260910-1535-deno-port.spec.md` | Complete | `done` |

### The six open files, judged one by one

| File | New value | Reason |
|---|---|---|
| `tasks/20260806-0959-chisel-v1.spec.md` | `in-progress` | Parent whose slices are partly done: 01–05 finished, 06 and 07 not — the mapping's own case for a partly-done parent. |
| `tasks/20260806-0959-chisel-v1/06-pilot-migration.spec.md` | `ready` | Spec fully written with criteria, and its only declared blocker, slice 04, is finished — approved, nothing retains it, waiting for a Mason. |
| `tasks/20260806-0959-chisel-v1/07-release.spec.md` | `blocked` | Spec fully written, but its declared blocker, slice 06, is not done: a named dependency holds it, which is what `blocked` means. Calling it `ready` would put it on a frontier it cannot be picked up from. |
| `tasks/20260826-1512-chisel-v2.spec.md` | `in-progress` | Parent whose slices are partly done: ten of eleven finished, slice 06 blocked. |
| `tasks/20260826-1512-chisel-v2/06-upgrade-v2-and-log-md.spec.md` | `blocked` | Already Blocked, and the free text names what it waits on — the Owner's real pilots for two of its criteria. Value changes, free text kept. |
| `tasks/20260826-2302-chisel-dogfoods-itself.spec.md` | `blocked` | Already Blocked on a named dependency, the chisel v2 task, named in its own free text. Value changes, free text kept. |

The judgment for slice 07 of chisel v1 leaves the letter of the migration
mapping, which offers `creating`, `ready` or `in-progress` for a Not Started
line; it is recorded here rather than made silently, and the reason is in
the table above. Findings below says it again for the Foreman.

## Worklog

**2026-09-15, session 2 — typing.** Seven commits in the order the spec's
Verification section gives: the work document alone, then both template
copies, the five formulas, the glue with the reasoning and the glossary, the
two beads skill pages, the slice and setup skills, and the workspace
migration. `deno task test`, `deno task check` and `git diff --check` after
each. All twelve acceptance-criterion commands re-run at the end, their
after-values written beside the before-values above; findings below.

**2026-09-15, session 1 — plan.** Read the repo instructions, the writing
rules, the spec in full, the work template, the reasoning behind the eight
decisions of the interview, and every file the spec lists under Modify. Ran
all acceptance-criterion commands at `06de3f1` and recorded the
before-values below. Derived the status of every step of the five presets
from the spec's rule and checked the derivation against the default
preset's list, which the spec fixes. Listed the 44 status lines and the
value each gets, and judged the six open files. Committed this document
alone.

## Implementation Checkboxes

- [x] Templates: the "Statuses" section and the skeleton line, in both
      copies, still differing only by their one link-path line
- [x] Formulas: the fixed status sentence on all 40 steps of the five
      presets, and `awaiting approval` out of the supervised header
- [x] Glue §B1, `methodology.md`'s new section, `reference.md`'s glossary row
- [x] Beads skill: `SKILL.md` and `CHANGING-CASE.md`
- [x] Other skills: slice-task template line, chisel-setup cost sentence
- [x] Workspace migration: the 43 status lines
- [x] Criterion commands re-run, after-values written beside before-values,
      findings written

## Notes & Snippets

### Before-values, at `06de3f1`

| Criterion | Command's answer before | After |
|---|---|---|
| `emoji-gone` | 18 lines in 5 files (`project.md.tpl`, beads `CHANGING-CASE.md`, slice-task `SKILL.md`, both template copies) | 0 — met |
| `vocabulary-once` | no "Statuses" table; `waiting-` count 0 in the shipped template; the two copies differ by exactly one line, the `reference.md` link path | 13 value rows, each value in backticks; `waiting-` count 6; the two copies still differ by that one line only — met |
| `formulas-name-status` | 0 status lines against 9 / 9 / 9 / 7 / 6 steps (default, supervised, auto, light, auto-light); `awaiting approval` 1 | 9 / 9 / 9 / 7 / 6, equal to the step count in each file; all 40 values among the thirteen; `awaiting approval` 0 — met |
| `glue-b1` | §B1's `**Status:**` bullet carries the six emoji; frontier bullet says "whose blockers are all done", no `ready` | no emoji; the bullet names the spec template's status table; the frontier bullet says the status is `ready` — met |
| `beads-native` | `status.custom` 0; `in_progress` 1 in `CHANGING-CASE.md` (a `bd update --status` command), 0 in `SKILL.md`; `bd ready` 0 in `SKILL.md`; `bd list --status` 0 | `status.custom` 2 with the verbatim string once; all four `in_progress` mentions sit beside `in-progress` as the translation; `bd ready` 4 and `bd list --status` 4 in `SKILL.md` — met |
| `slice-template` | 0 | 1 — met |
| `questionnaire-true` | 0 — the sentence is there but wraps across two lines, so the one-line grep never matched it; checked again unwrapped | 0 one-line and 0 unwrapped: the claim is gone, replaced by the true cost — met |
| `reasoning-placed` | 0 headings containing "status" in `methodology.md`; 0 **Status** glossary rows in `reference.md` | 1 heading, "The status of a task"; 1 glossary row — met |
| `workspace-migrated` | 44 status lines, 43 of them non-conforming | 44 status lines, 0 non-conforming — met on the substance; the expected count of 43 in the spec predates this task's own spec file (see findings) |
| `no-code-in-shipped-text` | 0 | 0 — met |
| `suite-green` | 25 passed, 0 failed; `deno task check` clean; `git diff --check` clean | 25 passed, 0 failed; check clean; `git diff --check` clean — met |
| `nothing-else-moved` | — (judged at the end) | 55 files: the 14 the spec lists under Modify, 40 files whose only change is a `**Status:**` line under `tasks/` and `archive/`, and this task's own pair — met |

### Gate placement read off the five presets

Default: gates on `plan`, `type`, `close`. Supervised: `plan`.
Auto: none. Light: `plan`, `diff-review`. Auto-light: none. A gate attached
to a step means the human is asked BEFORE that step runs, which is why the
status a step leaves behind is read from the NEXT step's gate, not its own.

### Things to keep out of shipped text

No ruling code, no plain-name-plus-code pair, no "chantier", no decisions
record file name, in anything under `socle/` or in either template copy.
Pointers use the installed form `.agents/…`. The five formula bodies are
TOML multi-line strings: the fixed sentence goes before the closing `"""`,
and the test suite parsing the five presets is the proof they still parse.

## Findings

Written at the end of the typing, for the reviewer. Nothing here changes
what was built; each point is either something the spec did not foresee or a
judgement made in the open.

**One status line more than the spec counted, and it is the spec's own.**
The workspace holds 44 `**Status:**` lines, not 43: the inventory was taken
before this task's spec file was committed with `**Status:** in-progress`.
43 were rewritten; that one was left alone, being the Foreman's. The
`workspace-migrated` criterion's second half — no non-conforming line — is
met exactly; its first half reads 44 where it expects 43. The substance is
what it asks for.

**The migration table cannot show the emoji it maps from.** The spec asks
for the old-six-to-new table inside the template's status section, and
`emoji-gone` forbids those six characters anywhere under `socle/` or in
either template copy. Both cannot hold literally, so the table names the old
statuses by their words — Not Started, In Progress, Blocked, Complete /
Done / Delivered, Deferred, Cancelled — with one sentence saying the old
lines carried a coloured circle before those words. A reader holding an old
file matches on the word, which is what was always after the emoji.

**One migration judgement leaves the letter of the mapping.** Slice 07 of
the chisel v1 task was Not Started, and the mapping offers `creating`,
`ready` or `in-progress` for that. None is true: its spec is fully written
(so not `creating`), nobody is on it (so not `in-progress`), and its
declared blocker, slice 06, is not done — so `ready` would advertise it on a
frontier it cannot be taken from, and would be a false positive for the glue
rule and for `bd ready`. It is written `blocked`. The mapping's Not Started
row has no case for "written, unstarted, held by a named blocker"; that is
the gap, and it is worth one line in the published table if the Foreman
agrees.

**Three of the 43 lines are quoted template excerpts, not a task's own
status.** All three are in the archived task file about the templates,
`archive/20260828-2217-split-spec-and-work-documents/01-templates-and-installer.md`,
which quotes the old template skeleton and two finished status lines. The
spec puts archived content beyond the status line out of scope, but the
criterion greps every line beginning `**Status:**` under the two trees and
these are literally that. They were rewritten: the two finished ones to
`done`, the skeleton placeholder to `creating`, matching the new skeleton. A
mechanical criterion over a workspace that contains prose about itself will
keep catching quotations; worth knowing before the next such criterion is
written.

**Two values are written by no step of the lightest presets.** The
derivation leaves `planning` unwritten in auto-light — the same session
plans and types, so there is no boundary between them — and
`waiting-plan-approval` unwritten wherever no plan gate exists. Nothing is
missing; it is what "each formula picks its path through the values" means.
Recorded because a reader comparing the five tables will notice the holes
and should find them explained rather than suspicious.

**Two readings of "the next active value" had to be chosen between.** For a
step that ends where the create phase ends with no gate after it — auto's
`spec-review`, auto-light's `spec` — the rule could mean the value covering
the next step (`planning`) or the next value up the ladder (`ready`).
`ready` was chosen, with the reasoning in the Program Design above: the
create session stops there in every preset, the task sits approved and
unclaimed until a Mason is spawned, and `ready` is the value the default
preset's human writes at that same boundary. It also keeps the frontier — and
`bd ready` — meaningful under the gateless presets. If the Foreman prefers
`planning` there, it is two lines to change in two files.

**`PHILOSOPHY.md` was not opened and nothing here contradicts it as far as
this work could tell.** The spec asks for a report only if a claim is
falsified; the file was left closed per the Avoid list, so this is a
non-finding rather than a clearance.

**The chore the spec set aside, stated for the record.** Seventeen files
whose status is now `done` still sleep in `project-management/tasks/`
instead of the archive: five slices of the chisel v1 task (01 to 05), ten of
the chisel v2 task (01 to 05 and 07 to 11), and the two standalone files
`20260810-1037-field-test-fixes.md` and `20260825-1046-philosophy-doc.md`.
Their statuses were rewritten like all the others; none was moved. Moving
them is not mechanical, exactly as the spec says: both parent folders hold
finished and unfinished slices together, and the archive rule moves a parent
with its whole folder — so either the rule needs a case for a partly-done
parent, or the finished slices move without their parent and the folder is
split across two trees. Now that the statuses are searchable, the chore is
one `grep done` away from being scoped.

**One observation, no action.** The word "chantier" appears five times under
`socle/` — in the writing rule of `discipline.md` and in the Foreman's
profile, both using it as the illustration of naming a thing by its meaning.
Those files are not this task's to touch and nothing was added to them; noted
only so the reviewer knows the occurrences predate this work.

## Diff-Review Findings

**Review, 2026-09-15 · `foreman`**, on both axes, fast track: no Inspector.
Every criterion command re-run by the reviewer; all met (the
`workspace-migrated` count amended in the spec to 44, struck and dated).
Every shipped change read in full.

**Fix 1 — the light preset stepped backwards.** `verify` left the task at
`waiting-diff-approval`, the human's `diff-review` left it at `in-progress`,
`close` at `done`: a ladder does not go down. The default preset keeps the
value at `waiting-diff-approval` between the arbitration and `close`; light
now does the same, with one sentence in the step body saying why the value
does not move there. Typed by the foreman.

**Fix 2 — the migration table lacked the `blocked` case.** The agent's
judgment on slice 07 of chisel v1 (written, unstarted, held by a named
blocker → `blocked`) was right and the published table had no row for it;
the "Not Started" row of both template copies now names it. Typed by the
foreman.

**Rulings on the other findings.** The quoted template excerpts rewritten in
the archived templates task: kept as rewritten — the archive is searched, and
a quotation of the old skeleton would be the one false hit. `ready` (not
`planning`) at the create/work boundary of the gateless presets: kept — the
frontier must mean the same thing under every preset. `planning` and
`waiting-plan-approval` written by no step of the lightest presets: as
intended, each formula picks its path. `PHILOSOPHY.md`: the reviewer grepped
it; its one mention of statuses ("a committed status database") stays true.
The seventeen done files sleeping in `tasks/` and the archive rule's missing
case for a partly-done parent: a separate chore, carried to the decisions
record's plan.

Verdict: PASS on Standards, PASS on Spec.
