# 02 — Doctrine follows

**Status:** 🟢 Complete (2026-09-02)
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
`project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
§Acceptance Criteria; their full wording and the governing system design stay
there.

- [ ] **no-file-says-the-spec-file** (the parent task's closing check — this
  slice contributes to it, never closes it) — `grep -rn "the spec file"
  socle/` returns nothing at task close. In this slice's owned files, every
  occurrence becomes the precise document it means.
- [x] **the-roles-name-the-work-document** — `grep -rl "work document"
  socle/agents/profiles/` lists `mason.md`, `architect.md`, `inspector.md` and
  `foreman.md`; their contracts assign creation, evidence, findings, and
  archival consistently with the parent spec.
- [ ] **the-program-design-has-left-the-spec** (doctrine share of the parent
  task's closing check — this slice contributes to it, never closes it) —
  `grep -rn "Design section" socle/` returns nothing at task close. The
  methodology and Mason profile put program design and implementation
  checkboxes in the work document; the
  spec document retains system design, intent, criteria, seams, and status.
- [x] **suite-green** (slice share) —
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
- A blocker leaves a written trace in the task's documents (G15, superseding
  the 2026-08-31 Option A revision kept below as history): implementation
  blockers in the active work document, pre-`plan` blockers in the spec
  document's Notes; each entry signed with the author's role plus date and
  time, and whoever rules on the block records the ruling in the same place.
  No shared journal line, no separate escalation bead — in beads mode the
  task's own bead takes the native blocked status; in auto without beads the
  session reports the block directly to the human. Under this legacy slice's
  parent decisions 9–10, this combined plain `.md` artifact temporarily
  serves as the work record. The profiles, discipline rule 6, and AGENTS
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
  `project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
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
`plan` beside the spec by replacing `.spec.md` with `.work.md`. At that same
`plan` step, the Mason persists a draft program design in the work document;
the Architect validates that persisted design at `plan-review`. There is no
"once validated, persist" cycle. A parent spec for sliced work has no work
document; each typed slice does. The work document is committed, regenerable
while work remains live, then archived alongside its spec at `close`.

The spec document owns intent, named acceptance criteria, seams, system
design, decisions, testing strategy, slices, deliverables, references,
pre-`plan` Notes and retrospective, plus the sole task status. The work
document owns program design and pseudo-code, worklog, implementation
checklists, Notes & Snippets, and Inspector findings. The Mason never edits the
spec document or a 🧑 zone; the work document has no zone marker. The Architect
validates the work document's program design but never edits it. The Inspector
judges the diff against the whole spec document, reads the work document only
as evidence, and writes its findings there without becoming its owner. The
work-document owner/thread owner rules on those findings; any typing still goes
through the Mason. The Foreman/thread owner alone maintains status in the spec
document. A typed standalone task or slice archives its spec/work pair at
close; a sliced parent has no own work document and archives its parent spec
with the slice-folder contents.

Owner ruling after diff-review (Option A): a blocker has two records. The
shared dated journal entry and, where configured, the blocking `escalation`
coordination item defined in methodology are the project-level signal. The
active task's work document carries the detailed task-specific blocker record;
before a work document exists, only the shared report exists. Under this
legacy slice's parent decisions 9–10, the combined plain `.md` slice artifact
temporarily serves as that task-specific work record. A blocker is therefore
never silently swallowed, interactive availability never waives either record,
and neither record authorizes a scope change. A
non-blocking Mason refactor proposal remains proposed work in coordination
state and is also recorded in the work document's Notes & Snippets; it never
authorizes the change. The existing Checker wording remains deliberately
untouched: before `plan`, its findings belong in the spec document's Notes.

### Target edits, by carrier

1. **`socle/agents/methodology.md`** — replace the single-file Glossary terms
   (Task, Slice, Reading gradient, One-shot) with the two-document names,
   `.spec.md` / `.work.md` convention, and spec-directory slice layout. Make
   the reading gradient a property of the spec document's two 🧑 review zones,
   with system design in REVIEW CAREFULLY rather than REVIEW IF RELEVANT;
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
   program-design lifecycle, the Mason creates the work document and persists
   its draft at `plan`, then the Architect validates that persisted design at
   `plan-review`; do not describe persistence as happening after validation.
   Only program-design Mermaid diagrams and work material start in the work
   document; system-design/architecture diagrams remain in the spec document
   and are promoted from that source at `close`. In the
   blocked-task-report section, define the required shared project-level
   signal and the detailed task-specific blocker record in the active work
   document; before `plan`/before a work document exists, only the shared
   report exists; interactive availability never waives the shared signal or
   the active-work-document detail record.
2. **`socle/agents/discipline.md`** — distinguish spec document from work
   document in rules 2, 3, 5, 7 and the pipeline/side-lane language. Rule 2
   persists an approved program design into the work document; rule 3 protects
   🧑 zones of the spec document; the pipeline assigns sole status to the spec
   document and implementation progress/checkpoints to the work document.
   Rule 6 is unconditional for every blocker, regardless of human-gate or
   interactive availability: it requires methodology's shared blocked-task
   report and records detailed information in the active work document (or,
   before it exists, only in that shared report), never the spec document.
   Replace the
   ambiguous pipeline instruction to build "from the file" with an explicit
   spec/work pair.
3. **`socle/templates/AGENTS-block.md`** — route real work through the two
   documents: the spec document is the status and requirements surface, the
   matching work document holds the Mason’s program design, worklog and
   implementation checkboxes. Keep the formula as owner of order/gates and
   the Foreman as the close owner; do not claim that a single spec file owns
   all progress. Route blocker reporting consistently: the shared project
   signal is mandatory, active-work-document detail is required when present,
   and implementation blocker detail never goes in the spec document.
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
   only the shared report before it exists), regardless of interactive
   availability.
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
   pointers; remove the old 🤖-zone distinction. Remove language allowing the
   Inspector to apply its own findings when no human arbitrates: it reports
   findings into the work document, while the work-document/thread owner rules
   and any typing goes through the Mason; preserve auto/gateless escalation
   semantics without self-review mutation.
7. **`socle/agents/profiles/foreman.md`** — make its Mason handoff name the
   spec/work pair, explicitly assign sole spec-document status maintenance to
   the Foreman/thread owner, and state that `close`
   archives both documents together after the work material needed for
   evergreen documentation is promoted. Distinguish a typed standalone or
   slice spec/work pair from a sliced parent: the former archives both files;
   the latter has no own work document and archives the parent spec plus slice
   folder contents. Its ruling/escalation responsibilities remain unchanged
   except that blockers use the common blocked-task report plus the active work
   document's detailed record.

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

### Post-review correction/resume checklist — round 3

Fresh Architect validation is required before typing resumes. These are new
corrections from the post-correction Inspector report; the completed
checklists above remain historical and are not reused:

- [x] Make `discipline.md`, `architect.md`, `inspector.md`, and
  `AGENTS-block.md` consistently require the mandatory shared project-level
  blocker signal and, when an active work document exists, detailed
  task-specific blocker detail there; before it exists, shared report only;
  never the spec document. Interactive availability does not waive either
  record.
- [x] Remove `inspector.md` language allowing the Inspector to apply its own
  findings when no human arbitrates. The Inspector reports findings into the
  work document; the work-document owner/thread owner rules, and any typing,
  goes through the Mason. Preserve auto/gateless escalation semantics without
  self-review mutation.
- [x] Update `foreman.md` close topology: a typed standalone task or slice
  archives its spec/work pair; a sliced parent has no own work document and
  archives its parent spec plus slice-folder contents.

Resume point: the Architect returned VALIDATED on this round-3 plan; all three
corrections are now applied. Re-run the owned-carrier checks, cross-file
read-through, `git diff --check`, and the exact suite, then commit the green
correction.

### Post-review correction/resume checklist — final Inspector report

Fresh Architect validation is required before typing resumes. These four new
corrections are separate from the completed historical checklists above and
must be audited across carriers, not only as isolated line edits:

- [x] Make Discipline rule 6 unconditional for every blocker, regardless of
  human-gate availability: always emit the mandatory shared project-level
  signal; when an active work document exists, also record detailed
  task-specific information there; before it exists, shared report only; never
  the spec document.
- [x] Place system design in the methodology reading-gradient glossary's
  REVIEW CAREFULLY zone, not REVIEW IF RELEVANT.
- [x] Make the methodology lifecycle say the Mason creates and persists a
  draft program design in the work document at `plan`, then the Architect
  validates that persisted design at `plan-review`; remove any post-validation
  persistence cycle.
- [x] Make the methodology artifact ladder distinguish sources: only
  program-design Mermaid diagrams/work material start in the work document;
  system-design/architecture diagrams stay in the spec document and are
  promoted from that source at `close`.

Resume point: the Architect returned VALIDATED on this final plan; all four
corrections are now applied. Run the focused cross-carrier audits and full
owned verification sequence, then commit the green correction.

### Post-review correction/resume checklist — round 5 (fresh Inspector + G15)

Persisted 2026-09-02 by the thread owner after Owner arbitration of the fresh
Inspector's report on `9e26b29...HEAD` (findings ST1–ST4, S1–S5). The S1
ruling is recorded as G15, Addendum 3 of
`project-management/review-360-decisions.md`; S5 stays parked for chantier 3
(template on this slice's avoid list). Revised 2026-09-02 after a first
Architect pass returned NOT VALIDATED (three blocking defects, eight
non-blocking remarks — all folded in below). As in round 3: the completed
historical checklists above are history, never reused — several of their
checked items assert the very rule G15 deletes, and they stay below as
history, never erased. Fresh Architect validation is required before typing
resumes.

Dispositions of the remaining findings, ruled 2026-09-02 by the thread owner
(foreman):

- **ST3 (ragged wraps)** — fix folded into the Mason items below: every
  paragraph the round touches is rewrapped to the file's prevailing ~79
  columns.
- **ST4 (lost rationale)** — split ruling: the auto bullet's deleted
  rationale "(the Checker reviews it, it does not author it)" is restored
  (folded into the Mason items below); the deleted escalation-terminates
  clause STAYS deleted — that deletion is ratified by G15 point 3, no action.

Items. Each names its actor; the Mason types only socle carriers and
work-side material, never this document's spec-side sections:

- [x] **(Mason) G15 rewrite** across the seven carriers (methodology,
  discipline rule 6, AGENTS block, Mason, Architect, Inspector, Foreman):
  every blocker leaves a written trace in the task's documents —
  implementation blockers in the active work document, pre-`plan` blockers in
  the spec document's Notes; each entry signed with the author's role plus
  date and time; whoever rules on the block — the Owner, or the Foreman in
  auto — the ruling is recorded in the same place, signed the same way
  (G15 point 7, ruled 2026-09-02). The mandatory shared journal ⚠️ line and the
  separate blocking `escalation` bead are removed: in beads mode the task's
  own bead takes the native blocked status; in auto without beads the session
  reports the block directly to the human. Escalation itself is unchanged —
  one rung up, above the Foreman the human — and oral availability waives no
  record. Where methodology's blocked-task-report passage is rewritten, name
  B3(b) (`review-360-decisions.md`) as retired by G15, so the deletion traces
  to a ruling. Two ripples outside the carriers go to the worklog as
  proposals, not fixes: `socle/agents/skills/retro/SKILL.md:42` becomes a
  re-pointing (not a rename) for slice 4; the beads skill documents no
  blocked-status write yet, so this item's "native blocked status" is a
  proposal against `socle/agents/skills/chisel-beads/CHANGING-CASE.md:123-149`,
  which
  documents `--status in_progress` and no blocked-status write.
- [x] **(Mason) Deduplicate the blocker rule (ST2)**: its full form is
  defined once in methodology ("Escalation, and the blocked-task report");
  the other six carriers state the duty in one line and point there. The
  Architect's one line must keep its pre-`plan` case: its blockers land in
  the spec document's Notes, the exclusion stays "implementation blocker
  detail" (never a flat "never the spec document"), joined with its existing
  assumption rule.
- [x] **(Mason) ST1**: discipline's invocation becomes `work on slice
  <spec-document>`.
- [x] **(Mason) Invariant-6 residuals (S3)**: methodology's lifecycle line
  persists the draft at `plan` (not "at plan validation"); discipline stops
  calling the persisted design "approved" — draft persisted at `plan`,
  validated at `plan-review`.
- [x] **(Mason) S2**: foreman's Mason-revision passage names the work
  document as the revision's destination.
- [x] **(Mason) ST4 share**: restore the auto bullet's "(the Checker reviews
  it, it does not author it)" rationale in methodology's Zone ownership.
- [x] **(Thread owner) S4**: this document's acceptance-criteria block
  qualifies `no-file-says-the-spec-file` and
  `the-program-design-has-left-the-spec` as the parent task's closing checks,
  contributed to — never closed — by this slice.
- [x] **(Thread owner, wording approved by the Owner before it lands) Parent
  spec amendment**: strike and date the rule-6 Deliverable line in the parent
  spec, pointing at G15. The line sits under the parent's 🤖 AGENT ZONE (the
  zone the convention retires, parent decisions 1 and 10 — the accepted
  intermediate state), and
  the amendment rule invoked lives in the parent spec's §Acceptance Criteria
  ("An amended criterion is never erased: strike the original, date the new
  version below it") — written for acceptance criteria, applied here by
  analogy, said so in place. The parent spec is outside both maps of this
  slice: the touch is logged in the worklog and reported under the proposal
  door.
- [x] **(Thread owner) This document's own System design**: its blocker
  bullet is rewritten to state G15 (trace in the task's documents, role plus
  date and time, Owner ruling recorded, no shared journal line, native beads
  status), superseding the 2026-08-31 Option A revision — which stays below
  as history, never erased.
- [x] **(Thread owner) This document's Verification sequence**: steps 2 and 4
  are rewritten against G15 — the "mandatory shared blocker signal" and "the
  shared project-level signal is unconditional" audits become their G15
  equivalents (trace in the task's documents, signed role + date and time,
  Owner ruling recorded, no journal line, native beads status, one rung up).
- [x] **(Mason) Rewrap (ST3)**: the ragged wraps this slice introduced in
  the seven carriers — `methodology.md:291`, `methodology.md:412`,
  `mason.md:167`, `architect.md:52`, plus discipline rule 6 already reopened
  above — to the prevailing ~79 columns, and every paragraph the Mason's own
  items rewrite. The thread owner rewraps what it writes on the spec side.
- [x] **(Mason)** Re-run the verification sequence (as rewritten): the
  three greps, the cross-carrier blocker audit against G15,
  `git diff --check`, and the exact suite.

Verified no-change findings, recorded so round 6 does not reopen them (first
Architect pass): G15 point 4 (Foreman by mode) is already carried by
`methodology.md:53`, `AGENTS-block.md:37` and `foreman.md:63-64`; G15 point 6
by `architect.md:3`; the methodology Glossary rows (`methodology.md:23-24`)
enumerate sections, not content, so the blocker trace needs no glossary edit.
The Checker exception holds under G15 and gets more true, not less:
pre-`plan` blockers land exactly where `checker.md:3` and `:27` already send
its findings (the spec document's Notes), `000-template.spec.md:136-138`
scopes Notes generically, and checker.md carries no record duty of its own
because discipline rule 6 is ambient — checker.md and the templates
legitimately stay on the avoid list.

Resume point: the Architect returned VALIDATED on this revised round-5 plan
(second pass, 2026-09-02), the Owner approved it, and all items are applied —
thread-owner items by the thread owner, (Mason) items by a fresh Mason. The
round-6 Inspector reviewed the uncommitted diff; its two escalations (the
socle-internal `review-360-decisions.md` reference, and G15 point 4's auto
half) await the Owner's ruling before commit.

### Post-review dispositions — round 6 (Inspector on the uncommitted diff)

Ruled 2026-09-02 by the thread owner (foreman), Owner arbitration on the two
escalations:

- **ST-A / SP4 (Owner, 2026-09-02)** — the socle must not name
  `review-360-decisions.md`: methodology's retirement sentence quotes and
  dates the Owner ruling inline instead, per the file's own precedent. Full
  traceability stays in chisel's records. → Mason.
- **SP3 (Owner, 2026-09-02)** — G15 point 4's auto half becomes doctrine:
  foreman.md gains one sentence (in auto, the Foreman orchestrates, decides
  within what it owns — rarely — and sends the rest up) and its
  business-context claim is qualified by mode. → Mason.
- **ST-D** — one-word disambiguation in inspector.md ("blocking-report
  semantics", not the retired `escalation` item). → Mason.
- **ST-B, ST-C, SP1, ST-E** — fixed by the thread owner: spec-side rewraps,
  the stale resume point, the missing outside-map worklog entry, and the
  status line (🔴 → 🟡).

#### Implementation worklog

- 2026-09-02 17:12 — **foreman** — Slice closed at commit `863094c`. Slice
  shares verified green: zero "the spec file" / "Design section" matches in
  the seven carriers (remaining matches owned by slices 03–04), profiles
  grep lists exactly mason/architect/inspector/foreman, suite 94/94. The two
  parent-closing criteria stay unticked by design — this slice contributes,
  the task closes them. Round-5/6 corrections and the G15 arbitration are
  recorded above; archival of the pair happens at task `close`.

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
- 2026-09-01 — **mason** — Post-correction Inspector report: Standards PASS;
  three Spec findings were ruled in scope by the Foreman under approved Owner
  decisions. Plan-only revision records the required cross-carrier blocker
  completeness, Inspector separation, and standalone/slice-versus-parent close
  topology. No source was edited and no commit was created; fresh Architect
  validation is required before resuming type.
- 2026-09-01 — **mason** — Architect round-3 VALIDATED: applied all three new
  corrections. The four blocker-contract carriers now require the mandatory
  shared signal plus active-work-document detail, with interactive availability
  unable to waive either record; Inspector reports without self-applying, and
  Foreman close distinguishes typed pairs from sliced parents.
- 2026-09-01 — **mason** — Round-3 evidence: targeted blocker-contract,
  Inspector-separation, parent/slice-topology, and owned forbidden-phrase
  searches passed; cross-file read-through passed; `git diff --check` passed;
  exact `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passed — 9 scenarios,
  94 assertions, 0 failures.
- 2026-09-01 — **mason** — Final Inspector report: Standards had two hard
  violations and Spec had four findings, all ruled in scope by the Foreman.
  Plan-only revision adds a fresh unchecked correction block for unconditional
  blocker records, the spec reading-gradient placement, plan-time draft
  persistence/plan-review validation ordering, and the artifact-ladder source
  distinction. Prior evidence remains unchanged; fresh Architect validation is
  required before typing.
- 2026-09-01 — **mason** — Final Architect validation was VALIDATED; all four
  final corrections are applied. Focused cross-carrier audit confirms blocker
  signals are unconditional and records are complete; persist-before-validate
  ordering is consistent; artifact-ladder sources are separated; owned
  forbidden-phrase checks and cross-file read-through pass.
- 2026-09-01 — **mason** — `git diff --check`: PASS. Exact gate
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`: PASS — 9 scenarios, 94
  assertions passed, 0 failed.

- 2026-09-02 14:55 — **foreman** — Outside-map touch, logged per the round-5
  item and reported under the proposal door: the parent spec's rule-6
  Deliverable line received its strike-through + dated G15 amendment (parent
  spec is in neither map of this slice; wording approved by the Owner before
  landing). Same door, lower weight: `project-management/review-360-decisions.md`
  received the Owner's G15 entry, points 1–7 (the Owner's own decision record,
  written by the thread owner as scribe).
- 2026-09-02 15:34 — **mason** — Round-5 G15 rewrite, carrier by carrier.
  `methodology.md` ("Escalation, and the blocked-task report"): the two-record
  rule is replaced by the single reference definition — the trace lives in the
  task's own documents (implementation blockers in the active work document,
  pre-`plan` blockers in the spec document's Notes), every entry signed with
  its author's role plus the date and the time, whoever rules on the block
  (the Owner, or the Foreman in auto within what it owns) records the ruling
  in the same place and the same way, oral availability waives no record, and
  discovery follows §B1 · Where task statuses live — the task's own bead takes
  beads' native blocked status, auto without beads reports directly to the
  human. The retired form is named as retired: no mandatory dated ⚠️ journal
  line and no separate blocking `escalation` item, with G15 retiring what
  decision B3(b) had let survive, so the deletion traces to a ruling.
- 2026-09-02 15:34 — **mason** — ST2 deduplication: the full form is defined
  once in methodology; the six other carriers now state the duty in one line
  and point at that section. `discipline.md` rule 6, `AGENTS-block.md`,
  `mason.md`, `inspector.md` and `foreman.md` each carry the one-line duty
  with the signature rule and the pointer. `architect.md` keeps its pre-`plan`
  case in that one line — its blocker notes land in the spec document's Notes,
  signed `architect` plus date and time, and the exclusion stays
  "implementation blocker detail never goes there" rather than a flat "never
  the spec document" — joined with its existing assumption rule, which writes
  to the same Notes.
- 2026-09-02 15:34 — **mason** — ST1, S3, S2 and the ST4 share: discipline's
  step invocation becomes `work on slice <spec-document>` (rule 10);
  methodology's lifecycle line persists the draft at `plan` and names
  `plan-review` as where it is validated; discipline rule 2 stops calling the
  persisted design "approved" (draft at `plan`, validated at `plan-review`);
  `foreman.md`'s Mason-revision verdict names the work document as the
  revision's destination; methodology's Zone ownership auto bullet regains
  "(the Checker reviews it, it does not author it)". The deleted
  escalation-terminates clause was left deleted, per G15 point 3.
- 2026-09-02 15:34 — **mason** — ST3 rewraps: the four named ragged wraps
  (methodology's Mason-brief paragraph, its artifact-ladder paragraph,
  `mason.md`'s third Input, `architect.md`'s plan-review bullet) plus every
  paragraph these items rewrote. One extra in-carrier rewrap, reported rather
  than silent: the cost-gradient paragraph of `methodology.md` carried an
  88-column line this slice had introduced (`work on slice <spec-document>`),
  outside the four the plan names; it is rewrapped with the paragraph, no
  wording changed. No other pre-existing over-wide line was touched.
- 2026-09-02 15:34 — **mason** — Verification, raw. `grep -rn "the spec file"
  socle/`: 10 matches, all in the five formulas plus
  `socle/agents/skills/retro/SKILL.md:42` — none in the seven carriers.
  `grep -rl "work document" socle/agents/profiles/`: exactly `mason.md`,
  `architect.md`, `inspector.md`, `foreman.md`. `grep -rn "Design section"
  socle/`: 5 matches, formulas only. Cross-carrier G15 audit over
  journal/bead/shared-signal/availability/"no human"/escalation language: the
  only surviving journal-plus-bead blocker mention is methodology's own
  retirement sentence; the other `journal` hits are the narrative-memory
  section, the reading list, the paths line and the Mason's worklog-shape
  line; the `no human` hits are zone ownership and arbitration semantics, not
  records. Persistence-ordering audit over methodology, Mason, Architect and
  discipline: draft persisted at `plan`, validated at `plan-review`, no
  post-validation persistence cycle. `git diff --check`: clean. Exact gate
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`: PASS — 9 scenarios, 94
  assertions passed, 0 failed.
- 2026-09-02 15:34 — **mason** — Two ripple proposals, under the proposal
  door: reported, not acted on, both outside this slice's files map.
  (1) `socle/agents/skills/retro/SKILL.md:42` ("Any blocker or escalation
  written into the spec file") needs a **re-pointing**, not a rename: under
  G15 a retro reads implementation blockers in the work document and
  pre-`plan` blockers in the spec document's Notes. Size: one line, plus
  possibly line 38's "spec file's persisted Design". Risk: low — a skill, no
  code; but it is slice 4's territory (`the spec file` is a task-closing
  grep). Clean delivery of this slice does not depend on it.
  (2) `socle/agents/skills/chisel-beads/CHANGING-CASE.md:123-149` documents
  `bd create` plus `bd update --status in_progress` and no blocked-status
  write at all, so the "native blocked status" this doctrine now names has no
  documented procedure behind it. Size: a passage in one skill, plus whatever
  `bd` actually offers for a blocked status. Risk: medium — it asserts a tool
  capability nobody has verified here. Clean delivery of this slice does not
  depend on it either; the doctrine states the intent, the skill would state
  the mechanics.

- 2026-09-02 16:05 — **mason** — Round-6 dispositions applied, three carrier
  edits. ST-A/SP4: `methodology.md:154-157` no longer names a chisel-internal
  file — the retirement sentence now quotes and dates the ruling inline
  ("Ruled by the Owner on 2026-09-02: \"c'est pas dans le journal du projet,
  c'est dans les documents de travail\" — which retires the report form an
  earlier ruling had let survive"), following the precedent of the same file's
  `chisel-auto-light` bullet at :118-121. Substance kept: no mandatory dated
  ⚠️ journal line, no separate blocking `escalation` item; the internal path
  and the `G15`/`B3(b)` labels are gone, date and substance only, with full
  traceability staying in chisel's own records. SP3: `foreman.md:3` and
  `:11-16` — the business-context claim is qualified ("as much of it as its
  mode gives it") and the auto half is stated in one sentence (in auto the
  Foreman orchestrates, decides within what it owns — rarely, its knowledge of
  the project being thin — and sends everything else one rung up); the default
  half was deliberately left to the paragraph that already carries it at
  `:18-19`, so the addition introduces no repetition. ST-D:
  `inspector.md:39` — "that blocking escalation semantics" becomes "that
  blocking-report semantics", disambiguating from the retired `escalation`
  item.
- 2026-09-02 16:05 — **mason** — Round-6 evidence: `grep -rn
  "review-360-decisions" socle/` returns zero hits, and so does `grep -rnE
  "G15|B3\(b\)" socle/`; every touched paragraph re-wraps at or under 79
  columns (the remaining over-wide lines in the three files are pre-existing
  and untouched); `git diff --check`: clean; exact gate
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`: PASS — 9 scenarios, 94
  assertions passed, 0 failed. Nothing committed.

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
   Notes exception intact, sole spec status, archive-both at close, blocker
   trace in the task's documents per G15 (implementation blockers in the
   active work document, pre-`plan` blockers in the spec document's Notes,
   signed role plus date and time, rulings recorded in place, no shared
   journal line, no separate escalation bead), Inspector reports without
   applying its own findings, Mason owns typing, and close distinguishes
   typed pairs from a sliced parent with no own work document.
3. Run the exact installer seam:
   `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`.
4. Run a focused cross-carrier audit over methodology, discipline, AGENTS
   block, Architect, Inspector, Mason and Foreman: search every occurrence of
   human-gate/interactive-availability/"no human"/journal/bead blocker
   language and confirm the G15 shape everywhere — the trace lives in the
   task's documents, signed role plus date and time, whoever rules records
   the ruling in the same place, no shared journal line or separate
   escalation bead survives, beads mode uses the task bead's native blocked
   status, auto without beads reports directly to the human, escalation stays
   one rung up, oral availability waives no record, and the spec never holds
   implementation blocker detail.
5. Audit the persistence/validation ordering across methodology, Mason and
   Architect: the Mason creates and persists a draft at `plan`, the Architect
   validates that persisted design at `plan-review`, and no text introduces a
   post-validation persistence cycle. Read the artifact-ladder passages to
   confirm program-design Mermaid/work material starts in work, while
   system-design diagrams stay in the spec and promote from there.

## Notes

Created at the start of slice 02 in accordance with the parent spec's
intermediate-convention decision.
