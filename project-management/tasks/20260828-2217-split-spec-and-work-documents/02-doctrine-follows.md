# 02 — Doctrine follows

**Status:** 🔴 Not Started
**Blocked by:** 01 — templates and installer (complete). This slice writes the
doctrine that names the two documents defined there; it unblocks slices 03 and
04.

**What to build:** the ambient methodology, discipline, glue, and role
contracts consistently teach the two-document task model: the spec document is
the approved review surface; the work document is the Mason's working space;
and neither the Mason's ownership nor escalation reporting contradicts that
boundary.

## Acceptance criteria

This slice closes the following parent criteria from
`project-management/tasks/20260828-2217-split-spec-and-work-documents.md`,
§Acceptance Criteria; their full wording and the governing system design stay
there.

- [ ] **no-file-says-the-spec-file** — `grep -rn "the spec file" socle/`
  returns nothing. In this slice's owned files, every occurrence becomes the
  precise document it means.
- [ ] **the-roles-name-the-work-document** — `grep -rl "work document"
  socle/agents/profiles/` lists `mason.md`, `architect.md`, `inspector.md` and
  `foreman.md`; their contracts assign creation, evidence, findings, and
  archival consistently with the parent spec.
- [ ] **the-program-design-has-left-the-spec** (doctrine share) — `grep -rn
  "Design section" socle/` returns nothing. The methodology and Mason profile
  put program design and implementation checkboxes in the work document; the
  spec document retains system design, intent, criteria, seams, and status.
- [ ] **suite-green** (slice share) —
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passes with zero failures.

## System design

The parent spec's Architecture and Implementation Decisions are settled input,
not a decision surface for this slice. Apply its document boundary exactly:

| Spec document | Work document |
|---|---|
| intent, acceptance criteria, seams, system design, decisions, pre-`plan` Notes, status | program design and pseudo-code, worklog, implementation checkboxes, Notes & Snippets, Inspector findings |

- The Mason creates the matching work document at `plan`, never edits the spec
  document, and resumes from implementation checkboxes in the work document.
- The thread owner maintains the sole status in the spec document, and at
  `close` archives both documents together.
- A blocker uses the methodology's shared dated journal/coordination report as
  the project-level signal, while its detailed task-specific record belongs in
  the active work document. Before a work document exists, only the shared
  report exists; under this legacy slice's parent decisions 9–10, this combined
  plain `.md` artifact temporarily serves as that work record. Neither record
  substitutes for the other, and the profiles, discipline rule 6, and AGENTS
  block must agree.
- The Inspector judges the diff against the whole spec document, reads the
  work document as evidence, and writes findings there without becoming its
  owner.

## Files map

**Modify:** `socle/agents/methodology.md`, `socle/agents/discipline.md`,
`socle/templates/AGENTS-block.md`, `socle/agents/profiles/mason.md`,
`socle/agents/profiles/architect.md`, `socle/agents/profiles/inspector.md`,
and `socle/agents/profiles/foreman.md`.

**Avoid:** `bin/chisel.sh`; both templates; formulas; skills; `test/`; and
`socle/agents/profiles/checker.md`. The Checker still writes pre-`plan`
findings to the spec document's Notes, so its existing wording remains true.

## Verification

- Socle text seam: run the three named grep criteria above, then read the
  changed carriers together for cross-file consistency.
- Installer seam: run the exact project gate named above. No test change is
  expected in this slice.

## References

- Parent system design and decisions:
  `project-management/tasks/20260828-2217-split-spec-and-work-documents.md`,
  §Architecture and §Implementation Decisions.
- Owner rulings:
  `project-management/review-360-decisions.md`, entry “G14 — Le split spec /
  travail, tranché en interview le 2026-08-28”.
- Slice-01 precedent:
  `project-management/tasks/20260828-2217-split-spec-and-work-documents/01-templates-and-installer.md`.

---

---

> 🧑 **REVIEW IF RELEVANT** — program design, persisted at plan time.

## Design — persisted at plan time

Persisted 2026-08-31 at this slice's `plan` step. This is the temporary
legacy location ruled by the parent spec's §Implementation Decisions,
decision 10: implementation changes no task artifact convention; slice 05
migrates these plain `.md` files. The changes below apply the parent
Architecture, Implementation Decisions 1–7 and 10–12, and G14; none reopens
their document boundary, naming, ownership, or lifecycle.

Plan revision 2026-08-31 after Owner arbitration (Option A): the shared dated
journal/coordination report remains the project-level blocker signal, while
the active work document carries the detailed task-specific blocker record.
Before a work document exists, only the shared report exists; this legacy
combined slice artifact is the temporary work record under parent decisions
9–10. This revision is awaiting fresh Architect validation before typing
resumes.

### Program design

The seven owned doctrine carriers will describe one paired task artifact:
`<name>.spec.md` is the approved review surface and source of the sole task
status; `<name>.work.md` is the Mason-owned working material, created at
`plan` beside the spec by replacing `.spec.md` with `.work.md`. A parent spec
for sliced work has no work document; each typed slice does. The work document
is committed, regenerable while work remains live, then archived alongside its
spec at `close`.

The spec document owns intent, named acceptance criteria, seams, system
design, decisions, testing strategy, slices, deliverables, references,
pre-`plan` Notes and retrospective, plus the sole task status. The work
document owns program design and pseudo-code, worklog, implementation
checklists, Notes & Snippets, and Inspector findings. The Mason never edits the
spec document or a 🧑 zone; the work document has no zone marker. The Architect
validates the work document's program design but never edits it. The Inspector
judges the diff against the whole spec document, reads the work document only
as evidence, and writes its findings there without becoming its owner. The
Foreman/thread owner alone maintains status in the spec document and archives
both documents at close.

Owner ruling after diff-review (Option A): a blocker has two records. The
shared dated journal entry and, where configured, the blocking `escalation`
coordination item defined in methodology are the project-level signal. The
active task's work document carries the detailed task-specific blocker record;
before a work document exists, only the shared report exists. Under this
legacy slice's parent decisions 9–10, the combined plain `.md` slice artifact
temporarily serves as that task-specific work record. A blocker is therefore
never silently swallowed, and neither record authorizes a scope change. A
non-blocking Mason refactor proposal remains proposed work in coordination
state and is also recorded in the work document's Notes & Snippets; it never
authorizes the change. The existing Checker wording remains deliberately
untouched: before `plan`, its findings belong in the spec document's Notes.

### Target edits, by carrier

1. **`socle/agents/methodology.md`** — replace the single-file Glossary terms
   (Task, Slice, Reading gradient, One-shot) with the two-document names,
   `.spec.md` / `.work.md` convention, and spec-directory slice layout. Make
   the reading gradient a property of the spec document's two 🧑 review zones;
   state separately that the work document has no zone and is Mason-owned.
   Recast Zone ownership so approval governs the spec document while work
   document ownership stays with its Mason; preserve each preset's review/gate
   facts without inventing a reviewer ownership claim. In “The two designs”,
   the phase table, artifact/reference rationale, interview, and two-axis
   review, move program design, pseudo-code, worklog and checkboxes to the
   work document; say the Spec axis judges the whole spec document and uses
   the work document as evidence. Keep seams as spec-side, human-agreed system
   design. Remove remaining bottom-of-spec agent-space and single-document
   descriptions, and update task/slice and artifact-ladder vocabulary
   precisely; no `Design section` or `the spec file` remains. In the
   blocked-task-report section, define the required shared project-level
   signal and the detailed task-specific blocker record in the active work
   document; before `plan`/before a work document exists, only the shared
   report exists.
2. **`socle/agents/discipline.md`** — distinguish spec document from work
   document in rules 2, 3, 5, 7 and the pipeline/side-lane language. Rule 2
   persists an approved program design into the work document; rule 3 protects
   🧑 zones of the spec document; the pipeline assigns sole status to the spec
   document and implementation progress/checkpoints to the work document.
   Rule 6 points to methodology's shared blocked-task report and records the
   detailed blocker in the active work document (or, before it exists, only in
   that shared report). Replace the ambiguous pipeline instruction to build
   "from the file" with an explicit spec/work pair.
3. **`socle/templates/AGENTS-block.md`** — route real work through the two
   documents: the spec document is the status and requirements surface, the
   matching work document holds the Mason’s program design, worklog and
   implementation checkboxes. Keep the formula as owner of order/gates and
   the Foreman as the close owner; do not claim that a single spec file owns
   all progress.
4. **`socle/agents/profiles/mason.md`** — at `plan`, create and own the
   matching work document, persist the program design there, and at `type`
   tick its implementation checkboxes and maintain its worklog. Replace every
   old spec-file/design-section destination, including revision and proposal
   notes, with the correct work-document destination. Inputs become the spec
   document plus the derived/created work document and referenced artifacts;
   acceptance criteria and seams remain read-only spec input. Its five inputs
   are the spec document, matching work document, referenced artifacts,
   ambient layer, and workspace/acceptance. Preserve TDD, files-map,
   proposal-door, and stop/escalate rules, but send blockers through the shared
   report, with detailed task-specific records in the active work document (or
   only the shared report before it exists).
5. **`socle/agents/profiles/architect.md`** — author the spec document from
   the spec template; at `plan-review`, read and return a verdict on the
   Mason’s work document without editing it. Preserve the system-design/files
   map boundary and the pre-`plan` spec Notes exception for assumptions. Route
   blockers through the shared report and, once present, the work document's
   detailed task-specific record; never write a blocker into the spec document.
6. **`socle/agents/profiles/inspector.md`** — update frontmatter so its
   description names the whole spec document as requirements, then define the
   Spec axis as the whole spec document (including its system design), name the work document
   as evidence rather than a requirement, and add the Inspector’s finding
   write to the work document. Its inputs explicitly include both document
   pointers; remove the old 🤖-zone distinction.
7. **`socle/agents/profiles/foreman.md`** — make its Mason handoff name the
   spec/work pair, explicitly assign sole spec-document status maintenance to
   the Foreman/thread owner, and state that `close`
   archives both documents together after the work material needed for
   evergreen documentation is promoted. Its ruling/escalation responsibilities
   remain unchanged except that blockers use the common blocked-task report
   plus the active work document's detailed record.

`bin/chisel.sh`, both templates, formulas, skills, tests, and Checker remain
untouched. Any needed change outside this map is logged in the worklog and
reported under the proposal door; a conflict with the settled boundary is a
blocker for the spawner, not an implementation decision.

### Implementation order and resume point

- [x] Read the seven changed carriers together, then revise methodology first
  so its vocabulary and ownership rules are the reference point.
- [x] Revise discipline rule 6 and the remaining ambient rules; revise the
  AGENTS block to route status and implementation progress to different
  documents.
- [x] Revise Mason and Architect together for creation, validation, inputs,
  pre-plan Notes, proposal, and escalation consistency.
- [x] Revise Inspector and Foreman for requirement/evidence/findings and
  archive-both consistency.
- [x] Run the three text criteria while reading all seven changed carriers as
  one doctrine surface; correct only within this slice’s files map.
- [x] Run `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`; if the same cause
  is red twice, record the blocked-task report and escalate rather than loop.

### Post-review correction/resume checklist

Fresh Architect validation is required before typing resumes. These are new
corrections, separate from the historical implementation checklist above:

- [x] Update Inspector frontmatter so its description names the whole spec
  document as requirements.
- [x] Remove methodology's remaining bottom-of-spec agent-space and
  single-document descriptions.
- [x] Replace discipline's ambiguous "from the file" wording with the
  explicit spec/work pair.
- [x] Correct Mason's enumerated Inputs count to five.
- [x] Explicitly assign sole spec-document status maintenance to the
  Foreman/thread owner.
- [x] Update methodology and every affected profile/glue carrier so blockers
  require the shared project-level signal plus detailed task-specific detail
  in the active work document, with only the shared report before a work
  document exists.

Resume point: the Architect returned VALIDATED on this revised plan; the six
corrections are now applied. Re-run the text criteria, cross-file read-through,
and exact suite, then continue the existing implementation workflow.

#### Implementation worklog

- 2026-08-31 — **mason** — Methodology: replaced single-file task vocabulary
  with the symmetric spec/work document model; assigned status and review
  requirements to the spec document, and program design, worklog and
  implementation checkboxes to the Mason-owned work document. Verified the
  changed carrier with `rg -n -i 'spec file|design section'` (no matches in
  owned files) and `git diff --check` (clean). A commit was attempted but the
  sandbox denied `.git/index.lock` creation; the Foreman must commit the green
  step from an authorized session.
- 2026-08-31 — **mason** — Discipline and AGENTS block: routed plan material
  and implementation progress to the work document, preserved spec-document
  zones and sole status, and (SUPERSEDED by Owner arbitration Option A) had
  described blockers as routed only through the shared report.
- 2026-08-31 — **mason** — Mason and Architect: Mason creates/owns the work
  document at `plan`; Architect validates it without editing; inputs,
  pre-plan Notes and escalation language now name the correct document.
- 2026-08-31 — **mason** — Inspector and Foreman: Spec axis judges the whole
  spec document, work document is evidence/findings space, and `close`
  archives both after evergreen promotion.
- 2026-08-31 — **mason** — Text criteria run: the owned carriers contain no
  `the spec file` or `Design section`; profile list is exactly Mason,
  Architect, Inspector and Foreman. Later-slice formula matches remain
  outside this slice's files map as the design permits.
- 2026-08-31 — **mason** — Exact gate `PATH="/opt/homebrew/bin:$PATH"
  bash test/run.sh`: PASS (all reported tests green, zero failures).
- 2026-08-31 — **mason** — Architect plan-review round 1: revised the
  persisted plan for Owner arbitration Option A, added methodology's explicit
  two-record blocker-report target, and added a fresh six-item unchecked
  correction/resume checklist. No doctrine source was edited and no commit was
  created; fresh Architect validation is required before typing resumes.
- 2026-08-31 — **mason** — Architect round 2 VALIDATED: applied all six
  correction/resume items. Methodology now defines the mandatory shared
  project-level signal and active-work-document detail record (only the shared
  report before a work document exists); all affected role carriers follow
  that invariant. The superseded shared-report-only wording remains marked as
  historical above.
- 2026-08-31 — **mason** — Correction evidence: owned-carrier greps return no
  `the spec file`, `Design section`, or ambiguous `from the file` matches;
  profile listing is exactly Mason, Architect, Inspector and Foreman;
  Inspector frontmatter names the whole spec document as requirements; Mason
  Inputs says five; Foreman explicitly owns sole spec status. Cross-file
  read-through confirms the shared blocker signal plus active-work-document
  detail invariant, with no implementation blocker detail in the spec.
- 2026-08-31 — **mason** — `git diff --check`: PASS. Exact gate
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`: PASS — 9 scenarios, 94
  assertions passed, 0 failed.

The implementation worklog records each completed checkbox with the affected
carrier(s), the precise vocabulary/ownership invariant checked, and the
command/result when one ran. It records any outside-map touch as a proposal
with size, risk and whether clean delivery can proceed. No test changes are
planned: the observable seams are doctrine text and the existing installer
gate.

### Verification sequence

1. Confirm the slice-level red/green text surface with:
   `grep -rn "the spec file" socle/`,
   `grep -rl "work document" socle/agents/profiles/`, and
   `grep -rn "Design section" socle/` — the first and third are task-closing
   greps and may retain matches owned by later slices; this slice must remove
   all matches from its seven carriers and make the profiles list exactly
   Mason, Architect, Inspector and Foreman.
2. Read the seven modified files in one pass against the ownership invariants
   above: no Mason spec write, Inspector findings in work, Checker’s pre-plan
   Notes exception intact, sole spec status, archive-both at close, mandatory
   shared blocker signal, and detailed blocker record in the active work
   document (never the spec document).
3. Run the exact installer seam:
   `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`.

## Notes

Created at the start of slice 02 in accordance with the parent spec's
intermediate-convention decision.
