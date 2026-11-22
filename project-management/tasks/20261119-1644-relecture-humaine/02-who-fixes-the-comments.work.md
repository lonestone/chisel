# 02 — Who fixes the comments — work

Created by the Mason at the plan step, 2026-11-22. Spec:
`project-management/tasks/20261119-1644-relecture-humaine/02-who-fixes-the-comments.spec.md`.

**Plan:** approved by the Architect, 2026-11-22, with these rulings on the
Mason's questions: (1a) step 4 writes the Mason's handle on the `**Plan:**`
line; (2a) `code-review` always runs again, fresh reviewers, on the fix's
diff; (3a) the status stays `done`; (4a) amend the Mason-reuse line of this
repo's `AGENTS.md` (outside the chisel markers), citing parent decision 11 —
the G16 entry of `review-360-decisions.md` is left to the human; (5) a
Typist on the mid tier. The three calls made without asking stand.
Mason handle: a922d3d1d9042bc18.

## Program Design

The rule of parent decision 11 (the Mason who did the work fixes the
comments): the task's Mason fixes the human review's comments, however long
ago it closed; a fresh Mason only when its session is lost; a comment that
changes a spec decision is written into the spec by the Architect first,
then the same Mason is woken. Today `workflow.md` contradicts it in two
places: the "Sub-agents" section says "a resumed task starts fresh", and
nothing says the Mason's session outlives step 7's "Stop everything".

### Files touched

| File | Change |
|---|---|
| `socle/agents/workflow.md` and `.agents/workflow.md` | Six edits, below. Both copies byte-identical (checked with `diff`). |
| `socle/intentions/unreleased/mason-fixes-the-comments.md` (new) | Informational intention. |
| `src/socle-files.ts` | The intention's line, sorted (before `review-section.md`). |
| `AGENTS.md` (this repo, outside the chisel markers) | The Mason-reuse line (ruling 4a), exact text below. |

**The `AGENTS.md` line (ruling 4a).** In the bullet on the repo as memory,
the last sentence "Role reuse follows ruling G16: reviewers fresh, the
Mason (named the Crewmate in the record) reused within a live thread."
becomes: `Role reuse follows ruling G16, widened by decision 11 of the
human-review task (project-management/tasks/20261119-1644-relecture-humaine.spec.md):
reviewers fresh, the Mason (named the Crewmate in the record) kept for its
whole task, the human review's comments included; a fresh Mason only when
its session is lost.`

Untouched: `CHARTER.md` (it already says "The fixes after a review belong
to the Mason that wrote the code"), `methodology.md` ("Re-runs and crashes"
stays true for a lost session), `reference.md`, the work and spec
templates, the tests (TESTS.md: no test pins the socle's prose; the
criteria are checked at review). `AGENTS.md` is a question below.

### The six edits of workflow.md

Exact text, so the Typist decides nothing.

1. **The roles table, Mason row, "What it does" cell.** Append one
   sentence: `Woken again after the close, it fixes the human review's
   comments.`

2. **Step 4 (Read the plan), the approval sentence.** It becomes: `the
   approval is written on the work document's **Plan:** line, with who and
   when, and the Mason's handle: the id its harness resumes it by.`
   (Question 1 below; dropped if the Architect says no.)

3. **Step 7 (Close), after the "Stop everything you started … stops the
   work of others." sentence.** Add: `This does not end the Mason itself:
   its session is kept, for step 8 wakes it to fix the comments.`

4. **Step 8 (Human review), a new paragraph before "The review ends when
   …".**

   > **Who fixes the comments.** A comment that asks for a change goes to
   > the task's Mason, the one that planned, coded and closed it. The
   > Architect wakes it in its own session, however long ago it closed:
   > waking it costs as much as a fresh one, but it holds the whole
   > context. A fresh Mason only when that session is lost; it starts from
   > the spec, work and synthesis documents. A comment that changes a
   > decision of the spec: the Architect writes the new decision into the
   > spec first, then wakes the same Mason on it. The Mason fixes as it
   > fixes a review finding: through a Typist unless the fix is a retouch
   > of a few lines, the gate commands, `code-review` on the fix's diff,
   > each comment written in the work document with its fix or its answer,
   > the synthesis amended when a critical decision moved. It commits on
   > the pull request's branch and reports to the Architect, who answers
   > the comment in crit and waits again. The status stays `done`.

   The sentence on the status depends on question 3; the `code-review`
   clause on question 2.

5. **"Where the work stops", the Mason row, "When" cell.** It becomes:
   `After the plan; after the close, with its report; after fixing the
   human review's comments; on a blocker it cannot rule on`.

6. **"Sub-agents", the last paragraph.** It becomes:

   > A brief is artifacts and paths, never the conversation: whatever the
   > sub-agent needs must already be in the repo. Reviewers are always
   > fresh. A Mason is kept for its whole task: the one that wrote the plan
   > launches its Typist, runs the review, closes, and is woken to fix the
   > human review's comments, however long after the close. A fresh Mason
   > starts from the spec, work and synthesis documents only when that
   > session is lost.

   And **"The Mason brief"**: the steps bullet ends `…; close; then, when
   woken, the human review's comments`; the reports bullet adds `after the
   comments, the commits and how each comment was fixed or answered`.

### The intention

`unreleased/mason-fixes-the-comments`, `informational`, the nine sections
in order, modelled on `unreleased/human-review-step`:

- **Goal:** the human knows the task's Mason fixes the human review's
  comments, and that its session is kept after the close.
- **Why:** waking the same Mason costs as much as a fresh one but carries
  the whole context; a team that discards its Masons at the close, or
  starts a fresh one on the comments, loses it.
- **Applies When:** the repo is updated from a version whose
  `.agents/workflow.md` step 8 has no "Who fixes the comments" paragraph.
- **Do Not Apply When:** `Never: the copy chisel update makes carries the
  change.`
- **Observable Gaps:** one, "What the human knows", done when read.
- **Out of Scope:** the project's own instructions outside the chisel
  markers of `AGENTS.md` (a project that says otherwise reconciles itself).
- **Reference Paths:** `.agents/workflow.md` — copy.
- **Validation / Record Result:** as `human-review-step`.

### Decisions the spec left open (my calls, unless the Architect rules)

- **Where the comments are recorded:** in the work document, the same way
  as the code-review findings, under a dated heading of its own. No
  template change.
- **The synthesis is amended** when a fix moves a critical decision: it is
  the human's first reading and must stay true.
- **A lost session** is named by its effect (the Architect cannot resume
  it), not by a harness: the socle stays harness-neutral.

### Order

No test applies (no behaviour changes; the integrity test already lists
every socle file and will catch a missing `socle-files.ts` line).

1. The six edits in `socle/agents/workflow.md`, copied to
   `.agents/workflow.md`; `diff` shows nothing.
2. The intention and its `socle-files.ts` line.
3. `deno task check`, `deno task test`,
   `deno task release-check gate origin/main`. One commit.

### Questions for the Architect

1. **How the Architect finds the Mason again after a compaction or a long
   pause.**
   - (a) Step 4 writes the Mason's handle on the `**Plan:**` line (edit 2).
   - (b) Nothing written; whatever the Architect cannot resume counts as
     lost.
   - Recommendation: (a). "However long ago it closed" fails silently if
     the handle lives only in a thread that compacts; one clause on a line
     that already exists, no template change.
2. **Does `code-review` run again on the fix's diff?**
   - (a) Yes, always, fresh reviewers on the fix's diff only.
   - (b) Only when the fix is more than a retouch.
   - Recommendation: (a). Step 6 already says "never skip this step, even
     for a small retouch"; a different rule after the human review would
     be a second rule to remember.
3. **The status while the comments are fixed.**
   - (a) It stays `done`, said in one sentence of step 8.
   - (b) It goes back to `in-progress`, and the Mason leaves `done` again.
   - Recommendation: (a). Slice 01 settled that the review is of a pull
     request, not a status; the documents are already archived.
4. **This repo's `AGENTS.md`** says "the Mason … reused within a live
   thread" (ruling G16). Decision 11 widens it.
   - (a) Amend that line in this slice: "reused for its whole task, the
     human review's comments included (parent decision 11 of the
     human-review task)".
   - (b) Leave it; the Architect records the widening of G16 in
     `review-360-decisions.md` itself.
   - Recommendation: (a), one line, and a dated note under G16 is yours.
5. **Typist or retouch.** About twenty lines of prose in two mirrored
   files, plus a fifty-line intention, all with exact text above.
   Recommendation: a Typist (the default), since this is more than a few
   lines.

## Worklog

- 2026-11-22: plan written. Read the slice and parent specs, slice 01's
  work document and synthesis, `workflow.md` (both copies identical),
  `CHARTER.md`, `methodology.md` (session and Typist sections), ruling G16
  in `review-360-decisions.md`, the intention template and
  `unreleased/human-review-step`, `release-check.ts`'s gate.

## Implementation Checkboxes

- [ ] workflow.md: the six edits in `socle/agents/`, mirrored to `.agents/`
- [ ] Intention `mason-fixes-the-comments`, listed in `socle-files.ts`
- [ ] `AGENTS.md` Mason-reuse line (ruling 4a)
- [ ] `deno task check`, `deno task test`, intention gate green

## Notes & Snippets

- The Intention gate compares the branch to `origin/main`; slice 01's
  intentions already satisfy it, so it passes either way. The new
  intention is written because the change deserves its own, not for the
  gate.
- `deno fmt` does not cover `socle/` or `project-management/`.

## Diff-Review Findings

_At step 6._
