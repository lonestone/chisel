# 03 — One shot

**Status:** done — group A, approved by Pierrick on 22/11 (ffaf5ec); closed 22/11
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a task can run in **one shot**, the lane first called
the autoroute. Pierrick (21/11): « En oneshot je n'interviens que pour la
review finale. Et encore. » In one shot there is no spec reading by the
human and no fixing round driven by him; the only human stop left is the
final review, and it may be skipped too. The Architect's one-shot line in
the spec says whether the final review happens. The code review, the gates
and the pull request still run.

The merge: when the final review happens, Pierrick's approval there is his
word for the merge; when it is skipped, the merge follows the merge and
publish section of `project.md`, by default his explicit word (proposed,
parent spec decision 18).

The Architect takes the one shot when it judges the task small at step 2,
or when the human asks for it explicitly. It writes the choice, its reason
and whether the final review happens in one line of the spec, and the pull
request repeats it. A human who asks for the full lane always gets it.
There is no project switch (ruling G10).

Before the spec, step 2's interview is clarified: when the need is clear
the Architect does not interview (as `workflow.md` already says); when the
`grilling` interview gets tangled, it switches to the `wayfinder` skill, a
map of decision tickets. Parent spec: decisions 2, 14, 18, 19.

## Acceptance criteria

- [x] **autoroute-written** — `workflow.md` names the one shot, what it
  skips (the spec reading, the stops of the full lane after it), what it
  keeps (the code review, the gates, the pull request, the final review
  when the spec line asks for it), and the two ways it is taken.
- [x] **autoroute-visible** — a task in one shot says so in its spec and in
  its pull request, with whether the final review happens.
- [x] **stops-table-one-shot** — the "Where the work stops" table says
  which stops the one shot removes, and how the merge goes with and
  without the final review.
- [x] **wayfinder-named** — step 2 names `wayfinder` for an interview that
  tangles, and keeps « no interview » for a clear need.
- [x] **intention-per-change** — the Intention gate passes.
- [x] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- The file keeps its name `03-autoroute` so links don't break; the text
  says « one shot », Pierrick's word.
- Pierrick never reads the plan today (step 4 is the Architect's; a plan
  that departs from his decisions goes to him), so the one shot has
  nothing to remove there.
- A spec that carries decisions the task did not state still goes to the
  human today (step 2). In one shot it does not: the one shot overrides
  that stop, on Pierrick's « non » of 21/11.
