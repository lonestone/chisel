# 03 — One shot — work

Created by the Mason at the plan step, 2026-11-22. Spec:
`project-management/tasks/20261119-1644-relecture-humaine/03-autoroute.spec.md`.

**Plan:** approved by the Architect, 2026-11-22, with these rulings on the
Mason's questions: (1a) the lane is « One shot », Pierrick's word; the old
meaning (work without a task artifact) becomes « quick fix » in
`reference.md`, `discipline.md`, `methodology.md` and `PHILOSOPHY.md`, both
copies where one exists; flagged to the human in the PR report. (2a) in one
shot the Architect rules on a plan that departs from the human's decisions,
writes it on the `**Plan:**` line, and the synthesis names it. (3a) when the
Architect hands the final review, it says in so many words that approving
it is the word for the merge; discipline rule 9 is untouched. (4a) no
template change. (5) a Typist on the mid tier, not cheap: four mirrored
files and a table. The four calls made without asking stand.
Mason handle: aea639ed84342cb55.

## Program Design

The lane of parent decisions *The one shot* and *When the autoroute is
taken*, and the clarified interview of *Clarifying only when needed*. A task
in one shot has no spec reading by the human and no stop for a human
reading after it; the final review is the only human stop left, and the
spec's one-shot line says whether it happens. The code review, the gates,
the close and the pull request run as in the full lane. No project switch
(ruling G10, the switch "Autonomous runs" removed: the lane is the
launcher's choice, task by task).

Found while reading, and shaping the plan:

- **`wayfinder` exists**: `socle/agents/skills/wayfinder/SKILL.md`, copied
  in `.agents/skills/wayfinder/`, already named by the side lanes of
  `discipline.md`. It is user-invoked (`disable-model-invocation: true`),
  like `slice-task`, which step 2 already names as the Architect's tool;
  the Architect reads and follows the file. No skill change.
- **The word "One-shot" is taken.** The glossary of `reference.md` defines
  it as "work done without a task artifact", and `discipline.md` uses it
  three times in that sense ("a one-shot fix", "one-shot work"), as does
  one line of `methodology.md`. The new lane has a spec. Question 1.
- **Two rules make the human approve a spec with new decisions**: step 2
  of `workflow.md` and "Zone ownership" of `reference.md`, which rule 3 of
  `discipline.md` repeats. The one shot overrides that stop (slice spec
  Notes), so all three say so.
- **The merge rule against discipline rule 9** ("never inferred from a
  'go' given on another subject"). An approval of the final review counts
  as the word for the merge only if the human knows it when he approves;
  so the Architect says it when it hands the review. Question 3.

### Files touched

| File | Change |
|---|---|
| `socle/agents/workflow.md` and `.agents/workflow.md` | Step 2, a new section "The one shot", "After the close", the stops table. Edits 1 to 4 below. |
| `socle/agents/reference.md` and `.agents/reference.md` | Glossary: the old term renamed, the new one added; one sentence in "Zone ownership". Edits 5 and 6. |
| `socle/agents/discipline.md` and `.agents/discipline.md` | Rule 3's parenthesis; the three "one-shot" of the old sense. Edit 7. |
| `socle/agents/methodology.md` and `.agents/methodology.md` | One word of the old sense. Edit 8. |
| `PHILOSOPHY.md` (this repo only, no socle copy) | One word of the old sense (ruling 1a). Edit 10. |
| `socle/intentions/unreleased/one-shot.md` (new) | Informational intention. Edit 9. |
| `src/socle-files.ts` | `"intentions/unreleased/one-shot.md",` after the `mason-fixes-the-comments.md` line. |

Each socle file and its `.agents/` copy end byte-identical: check with
`cmp`. Untouched: the spec and work templates (question 4), `CHARTER.md`,
`AGENTS.md`, every skill, the tests (no test pins the socle's prose; the
integrity test catches a missing `socle-files.ts` line).

### The spec's one-shot line

Written by the Architect at step 2, directly under the `**Status:**` line
(under `**Review depth:**` when the spec has one):

    **One shot:** <why>; final review kept

`<why>`: the task is small, or the human asked for it; or the same line
ending in `final review skipped`. When it is kept, the review
runs at the spec's depth as step 8 says. The pull request's description
opens with the line, copied as is.

### Writing rules for the Typist

Copy the text below exactly. Prose lines are 80 columns at most; every
paragraph touched is reflowed, and the blocks below already are. Shipped
text names a decision by its title, never by its number.

### Edit 1 — `workflow.md`, step 2

Replace the whole paragraph "**2. Write or sharpen the spec — Architect.**
… Status: `draft`, then `ready`." with:

```markdown
**2. Write or sharpen the spec — Architect.** When the task arrives clear —
a well-written issue, a clear request — write the spec document from it,
with no interview: from the spec template declared in `.agents/project.md`,
named with the task id script, short, linking the issue rather than copying
it. When the intent is unclear, interview the human first with the
`grilling` skill, one question at a time, a recommended answer with each,
with `domain-modeling` underneath: new domain terms land in the glossary
and hard-to-reverse decisions in an ADR, where the glossary and decisions
section of `.agents/project.md` puts them. When the interview tangles —
each answer opens more questions than it settles — switch to the
`wayfinder` skill: a map of decision tickets, resolved one at a time, whose
destination is the spec. Either way the seams are named, and the sizing
check is said out loud: the task fits one pass, or it is cut into slices
with the `slice-task` skill. The spec carries a `**Review depth:**` line,
`full` or `strategic`, when the task departs from the default of §J ·
Review of `.agents/project.md`, and a `**One shot:**` line when the
Architect takes the one shot ("The one shot", below). The human approves
the spec when it carries decisions the task did not state, except in one
shot; otherwise the Architect moves it to `ready` itself. Commit the spec.
Status: `draft`, then `ready`.
```

### Edit 2 — `workflow.md`, the "After the close" paragraph

Replace the paragraph "**After the close — Architect.** … the only go."
with:

```markdown
**After the close — Architect.** Read the close report and rule on anything
left. Open the pull request; in one shot, its description opens with the
spec's `**One shot:**` line, copied as is. Run the human review (step 8) on
it, unless that line skips the final review. Once the review is done or
skipped, merge and publish as the merge and publish section of
`.agents/project.md` says; by default, ask the human, whose explicit word
on that very action is the only go. In one shot with the final review, the
Architect says in so many words, as it hands the review, that approving it
is the word for the merge; the approval is then that word.
```

### Edit 3 — `workflow.md`, a new section "The one shot"

Insert after the last paragraph of "The steps" ("The review ends when …
follows `.agents/project.md`.") and before "## Where the work stops":

```markdown
## The one shot

A task can run in **one shot**: the human's only possible stop is the final
review, and the spec says whether it happens. The Architect takes the one
shot at step 2 when it judges the task small, or when the human asks for
it. A human who asks for the full lane always gets it. There is no project
switch: the lane is chosen task by task.

The Architect writes the choice in one line of the spec, directly under its
`**Status:**` line, or under `**Review depth:**` when the spec has one:

    **One shot:** <why>; final review kept

`<why>` is the reason: the task is small, or the human asked for it. The
line ends in `final review skipped` when there is no final review. The
pull request repeats it.

What the one shot skips: the human's reading of the spec, which the
Architect approves itself even when it carries decisions the task did not
state, and every stop that only serves a human reading after it; "Where the
work stops" says which. What it keeps: the plan and the Architect's reading
of it, the Typist, the code review and its fresh reviewers, the gate
commands, the close and its synthesis, and the pull request. When the line
keeps the final review, it runs as step 8 says, at the spec's depth. A plan
that departs from the task's own decisions is the Architect's to rule on:
it writes the ruling on the `**Plan:**` line, and the synthesis names it
among the critical decisions.
```

### Edit 4 — `workflow.md`, the "Where the work stops" table

Replace the table (header, separator and five rows) with:

```markdown
| Who stops | For whom | When | In one shot |
|---|---|---|---|
| Mason | Architect | After the plan; after the close, with its report; after fixing the human review's comments; on a blocker it cannot rule on | Kept |
| Typist | Mason | After its part of the plan; on anything the plan does not answer | Kept |
| Architect | Human | On an unclear intent | Kept: the intent is settled before the lane is chosen |
| Architect | Human | On a spec that carries decisions the task did not state | Removed: the Architect approves the spec |
| Architect | Human | On a plan that departs from the human's decisions | Removed: the Architect rules, and the synthesis says so |
| Architect | Human | On a blocker above what it owns | Kept |
| Architect | Human | At the human review, waiting for the human's reading of the pull request | Only when the spec's one-shot line keeps the final review |
| Architect | Human | Before a merge or a publish, unless the project lets the agent do it | With the final review, its approval is the word for the merge; without it, kept |
```

The two sentences under the table stay as they are.

### Edit 5 — `reference.md`, the glossary

Replace the row `| **One-shot** | Work done without a task artifact. …
skipped. |` with these two rows, in this order:

```markdown
| **Quick fix** | Work done without a task artifact. The discipline still applies; only the file bookkeeping is skipped. |
| **One shot** | A task whose only possible human stop is the final review, and that one only when its spec's `**One shot:**` line keeps it ("The one shot" in `.agents/workflow.md`). |
```

### Edit 6 — `reference.md`, "Zone ownership"

Replace the paragraph with:

```markdown
A 🧑 zone belongs to whoever **approved** it. The human approves a spec that
carries decisions the task did not state; the Architect approves one written
from a clear task, and then the zones carry the task's own decisions, which
are the human's. In one shot the Architect approves the spec even when it
carries decisions of its own, and those decisions are then its own. The
work document has no zone: it belongs to the Mason that wrote it. A 🧑 zone
is never overridden silently — a conflict with one is surfaced, never
edited sideways.
```

### Edit 7 — `discipline.md`

- Opening paragraph: "A one-shot fix runs under the same discipline as a
  sliced feature" becomes "A quick fix runs under the same discipline as a
  sliced feature". Reflow:

  ```markdown
  These rules apply to **every** conversation in this repo, with or without a
  task artifact. A quick fix runs under the same discipline as a sliced
  feature; the only difference is the paperwork.
  ```

- Rule 2, first sentence: "Even for a one-shot fix:" becomes "Even for a
  quick fix:". The line stays under 80 columns; nothing else moves.

- Rule 3 becomes:

  ```markdown
  3. **🧑 zones are law.** Sections marked 🧑 in a spec document carry the
     decisions of whoever approved them — the human, unless the Architect
     approved the spec ("Zone ownership" in `.agents/reference.md`). Never
     contradict one silently: if the work reveals a conflict with a 🧑 zone,
     stop and surface it.
  ```

- Rule 5, first sentence: "No task artifact for casual conversation or
  one-shot work." becomes "No task artifact for casual conversation or a
  quick fix." Reflow:

  ```markdown
  5. **The bridge rule.** No task artifact for casual conversation or a
     quick fix. But when a conversation turns into real, scoped, multi-step
     work, recognize it and PROPOSE a task under `.agents/workflow.md` —
     inform, never force. Formality is opt-in; detection is not. Most work
     should stay small: if everything becomes a big feature, review gets
     diluted and the method has failed.
  ```

### Edit 8 — `methodology.md`

In the bullet "Real-world distribution (dex): ~40% of work is one-shot,
medium work gets a single spec/work pair, only large work gets the full
breakdown.", "one-shot" becomes "a quick fix". Reflow:

```markdown
- Real-world distribution (dex): ~40% of work is a quick fix, medium work
  gets a single spec/work pair, only large work gets the full breakdown.
```

### Edit 10 — `PHILOSOPHY.md` (ruling 1a)

In the bullet "**Ambient by default, ceremony on demand.**", the last
sentence "The one-shot fix stays cheap." becomes "The quick fix stays
cheap." Nothing else moves.

### Edit 9 — the intention `socle/intentions/unreleased/one-shot.md`

```markdown
---
id: unreleased/one-shot
classification: informational
---

# A task can run in one shot

## Goal

The human knows that a task can run in one shot, with the final review as
its only possible human stop, and that the word "one-shot" of the old
glossary is now "quick fix".

## Why

Small tasks went through every human stop of the workflow, the spec
reading first. The one shot lets the Architect take a small task, or one
the human asks for, from the spec to the pull request with no stop but
the final review, and that one only when the spec keeps it. The code
review, the gates and the pull request still run. A team that does not
know it keeps reading specs it did not need to read, and reads "one-shot"
in the old sense where the workflow now means the lane.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` has no
  section "The one shot".

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md`, `reference.md`,
  `discipline.md` and `methodology.md` are managed files and the copy
  `chisel update` makes carries the change; the session only reads it to
  the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences: the Architect takes the one shot at step 2
   when it judges the task small, or when the human asks, and writes a
   `**One shot:**` line in the spec, with its reason and whether the final
   review is kept or skipped; the pull request repeats it; a human who
   asks for the full lane always gets it, and no project setting switches
   it on. With the final review, approving it is the word for the merge,
   and the Architect says so when it hands the review; without it, the
   merge goes as the glue's merge and publish section says. Step 2 now
   switches from `grilling` to `wayfinder` when the interview tangles.
   Work done without a task artifact is now called a quick fix.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`, which may still say "one-shot" in the old sense: a project
  that does reconciles itself.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.
- `.agents/discipline.md` — **copy**, by the update.
- `.agents/methodology.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
```

### Decisions the spec left open (my calls, unless the Architect rules)

- **The line's place and form**: under `**Status:**` (or `**Review
  depth:**`), one line, reason then `final review kept | skipped`; the PR
  description opens with it, copied as is. One form, so it can be found
  with a grep.
- **The synthesis is still written in one shot**: it is part of the close,
  not a human stop, and it is the record the pull request carries even
  when the final review is skipped.
- **The blocker stop is kept in one shot**: parent decision *When the
  autoroute is taken* skips "the stops that only serve the human"; a
  blocker above what the Architect owns is not a reading, and discipline
  rule 6 forbids forcing it.
- **The unclear-intent stop is kept**: the slice spec skips "the stops of
  the full lane after" the spec reading; the interview comes before the
  lane is chosen.
- **`wayfinder` is named "switch to"**, like `slice-task`, though both are
  user-invoked: the Architect reads and follows the skill file. The flag
  stays.

### Order

No test applies (no behaviour changes; TESTS.md has no prose tests; the
integrity test catches a socle file missing from `socle-files.ts`).

1. Edits 1 to 4 in `socle/agents/workflow.md`, copied to
   `.agents/workflow.md`; `cmp` silent.
2. Edits 5 to 8 in `socle/agents/`, copied to `.agents/`; `cmp` silent on
   each pair. Edit 10 in `PHILOSOPHY.md`.
3. The intention and its `socle-files.ts` line.
4. `deno task check`, `deno task test`,
   `deno task release-check gate origin/main`. One commit.

### Questions for the Architect

1. **The word "one-shot" already means work with no task artifact** (the
   glossary of `reference.md`, three uses in `discipline.md`, one in
   `methodology.md`); the new lane has a spec.
   - (a) Rename the old term "quick fix" in those four places and give
     "One shot" to the lane (edits 5, 7, 8 as written).
   - (b) Keep the old term; name the lane "one-shot lane" in the glossary
     and the text.
   - (c) Keep both under one word, the glossary telling them apart.
   - Recommendation: (a). Pierrick named the lane; (b) and (c) leave two
     meanings one hyphen apart in the ambient core. It renames a term of
     the ambient core, so it may be the human's to say.
2. **The stop "a plan that departs from the human's decisions" in one
   shot.**
   - (a) Removed: the Architect rules, writes it on the `**Plan:**` line,
     and the synthesis names it (edits 3 and 4 as written).
   - (b) Kept: it goes to the human even in one shot.
   - Recommendation: (a). Pierrick: « En oneshot je n'interviens que pour
     la review finale. Et encore. »; and parent decision *When the
     autoroute is taken* lists reading the plan among the skipped stops.
     In one shot the human made no decision beyond the task itself.
3. **The merge with the final review** (the slice spec, approved on 22/11,
   still marks it "proposed", after parent decision *The one shot*), read
   against discipline rule 9.
   - (a) As written: the Architect says, as it hands the review, that
     approving it is the word for the merge; rule 9 is untouched, since the
     human then gives his word knowing what it covers.
   - (b) Keep the merge question separate even after the final review.
   - Recommendation: (a), if the approval on 22/11 settled the "proposed".
4. **The spec template.**
   - (a) No change: the line's form lives once, in "The one shot" of
     `workflow.md`, and most specs run the full lane.
   - (b) A `**One shot:**` line in the template's header, deleted for the
     full lane, as `**Review depth:**` is.
   - Recommendation: (a). A line to delete in nearly every spec is noise,
     and the Architect who takes the one shot is reading the workflow.
5. **Typist or retouch.** About sixty lines of prose across four mirrored
   files, a table and a sixty-line intention, all with exact text above.
   Recommendation: a Typist on the cheap tier (the plan is mechanical).

## Worklog

- 2026-11-22: plan written. Read `CHARTER.md`, `discipline.md`,
  `workflow.md`, the slice and parent specs, slice 02's work document and
  synthesis, ruling G10 in `review-360-decisions.md`, `reference.md`
  (glossary, zone ownership), the spec and work templates, the intention
  template and the unreleased intentions, the `wayfinder` skill.

- 2026-11-22, Typist: typed the plan as written. Edits 1 to 4 in
  `socle/agents/workflow.md`; edits 5 to 8 in `reference.md`,
  `discipline.md`, `methodology.md`; edit 10 in `PHILOSOPHY.md`; the
  intention `one-shot.md` and its `src/socle-files.ts` line. The `.agents/`
  copies were byte-identical to the socle files before the edits, so each
  was made by copying the edited socle file; `cmp` silent on the four
  pairs. Deviation: none. Note: in `discipline.md` rule 3 the text in the
  repo differed from the plan's "before" (it spoke of a spec "that carried
  no new decision"); replaced by the plan's new text as given. Gates:
  `deno task check` exit 0; `deno task test` 77 passed, 0 failed;
  `deno task release-check gate origin/main` exit 0 ("The socle change adds
  an intention.").

- 2026-11-22: `code-review` from 45fd8c1; ten findings fixed by a retouch,
  six answered (Diff-Review Findings). `cmp` silent on the four pairs;
  `deno task check` exit 0; `deno task test` 77 passed; Intention gate
  exit 0.

## Implementation Checkboxes

- [x] workflow.md: edits 1 to 4, in `socle/agents/` and `.agents/`
- [x] reference.md, discipline.md, methodology.md: edits 5 to 8, mirrored;
  PHILOSOPHY.md: edit 10
- [x] Intention `one-shot`, listed in `socle-files.ts`
- [x] `deno task check`, `deno task test`, Intention gate green

## Notes & Snippets

- The Intention gate compares the branch to `origin/main`; slices 01 and
  02 already satisfy it. The new intention is written because the change
  deserves its own.

## Diff-Review Findings

`code-review` on the diff from 45fd8c1 (the Typist's commit), Standards
and Spec side by side. Fixed by a Mason retouch, in the socle files and
their `.agents/` copies:

- **Glossary "One shot" named a task, the workflow a lane.** The row now
  defines the lane, and says the other one is the full lane.
- **"one-shot line" hyphenated in the stops table.** Now the
  `**One shot:**` line, in backticks.
- **Rule 3 lost the case of a spec with no new decision.** The Typist
  replaced the rule's text with the plan's, which had missed it. The rule
  now names both cases in which the Architect approved, and points at
  "Zone ownership" in `reference.md`.
- **The roles paragraph and the plan step had no one-shot exception.** A
  question still goes to the human "except in one shot", in both.
- **"The task's own decisions" against "the human's decisions".** The
  one-shot section now says "the human's decisions", as the Architect's
  ruling on departures from them does.
- **Step 2's "otherwise" was ambiguous.** Rewritten: the human approves a
  spec with new decisions unless the task runs in one shot; in every other
  case the Architect moves it to `ready`.
- **The final step's merge sentence ignored the one shot.** It now points
  at "After the close", which holds both cases.
- **The Mason row said "Kept" even with no final review.** Now "Kept; no
  comments to fix when the final review is skipped".
- **The side lanes and the workflow named different `wayfinder`
  triggers.** The side lanes row now adds "a spec interview that tangles".
- **The intention cited bare step numbers.** Now it says what happens:
  the Architect takes the one shot when it writes the spec.

Answered, not fixed:

- **The same rule told in several places.** The stops table, the one-shot
  section, step 2 and "After the close" each list what applies where they
  are read; the table is a summary by design, and the actions live in the
  steps.
- **"step 2" inside `workflow.md`.** The house convention: a step is cited
  by its name within the file that numbers it; every new mention names the
  step.
- **Scope creep: the quick-fix rename and rule 9.** Covered by rulings 1a
  and 3a on the `**Plan:**` line.
- **The spec's Note says "nothing to remove there", ruling 2a removes a
  stop.** The Note sits in a 🧑 zone, which the Mason does not edit: left
  to the Architect to amend.
- **The merge rule still "proposed" in the spec.** Ruling 3a settled it;
  same 🧑 zone, same answer.
- **No `**One shot:**` line in the spec template.** Ruling 4a.
