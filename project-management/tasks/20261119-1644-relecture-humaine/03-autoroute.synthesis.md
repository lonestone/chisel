# Synthesis — One shot (slice 03)

## What changed and why

Every task went through every human stop of the workflow, however small it
was: you read the spec when it carried a decision of its own, you were
asked about a plan that departed from your decisions, and you read the pull
request at the end. Your words were « En oneshot je n'interviens que pour
la review finale. Et encore. » `workflow.md` now has a section, **The one
shot**, that gives a task exactly that lane.

The Architect takes the one shot when it writes the spec, if it judges the
task small or if you ask for it. It writes one line in the spec, under the
status line:

    **One shot:** <why>; final review kept

or `final review skipped`. The pull request description opens with the
same line, copied as is, so you see the lane before anything else. A human
who asks for the full lane always gets it, and no project setting switches
the one shot on: the lane is chosen task by task, as ruling G10 asked.

What it removes: your reading of the spec, and your ruling on a plan that
departs from your decisions. What it keeps: the plan and the Architect's
reading of it, the Typist, the code review with its fresh reviewers, the
gates, the close and its synthesis, the pull request, and the final review
when the line keeps it. The "Where the work stops" table gains an "In one
shot" column that says this stop by stop. Step 2 also names the `wayfinder`
skill for a spec interview that tangles, and keeps "no interview" for a
clear need.

## Critical decisions

- **"One-shot" no longer means a quick fix.** The old glossary called work
  done without a task artifact "one-shot". That meaning is now **quick
  fix**, in `reference.md`, `discipline.md`, `methodology.md` and
  `PHILOSOPHY.md`, so that one word does not name two things. The
  alternative was to call the lane something else, but « one shot » is your
  word. A project whose own instructions still say "one-shot" in the old
  sense must reconcile them itself; the intention says so.
- **In one shot, the Architect rules on a plan that departs from your
  decisions.** It writes the ruling on the work document's `**Plan:**` line,
  and the synthesis names it among the critical decisions, so you find it in
  your first reading if there is one. The alternative was to keep that stop,
  but then the one shot would no longer hold to "only the final review".
  This contradicts a Note in the spec ("nothing to remove there"), which sits
  in a 🧑 zone and is left to the Architect to amend.
- **Approving the final review is your word for the merge.** The Architect
  says so in so many words when it hands you the review, so the approval is
  never inferred. Without a final review, the merge follows the merge and
  publish section of `project.md`, by default your explicit word. Discipline
  rule 9 is unchanged: the word is still explicit, it is just given in the
  review.
- **The decisions in a one-shot spec belong to the Architect.** The
  zone-ownership rule and discipline rule 3 now say that a 🧑 zone belongs to
  whoever approved it, and in one shot that is the Architect, even when the
  spec carries decisions of its own.
- **No template change.** The `**One shot:**` line is described in
  `workflow.md` only. Adding it to the spec template would put it in front of
  every task, most of which run in the full lane.

## Data schema, before → after

No data schema change. A spec in one shot gains one line, `**One shot:**
<why>; final review kept|skipped`, under `**Status:**`, or under `**Review
depth:**` when the spec has one. The pull request description opens with
it.

## Architecture change

None.
