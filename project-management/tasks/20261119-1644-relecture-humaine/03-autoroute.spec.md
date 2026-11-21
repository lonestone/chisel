# 03 — One shot

**Status:** draft — group A, can start after 01
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a task can run in **one shot**, the lane first called
the autoroute. In one shot the human's last stop is the spec: there is no
human review, no fixing round, and no stop before the merge (pending
question A2 of the 21/11 report). The code review, the gates and the
pull request still run. The Architect takes the one shot when it judges
the task small at step 2, or when the human asks for it explicitly. It
writes the choice and its reason in one line of the spec, and the pull
request repeats it. A human who asks for the full lane always gets it.
There is no project switch (ruling G10).

Before the spec, step 2's interview is clarified: when the need is clear
the Architect does not interview (as `workflow.md` already says); when the
`grilling` interview gets tangled, it switches to the `wayfinder` skill, a
map of decision tickets. Parent spec: decisions 2, 14, 18, 19.

## Acceptance criteria

- [ ] **autoroute-written** — `workflow.md` names the one shot, what it
  skips (the human review, the fixing round, the stop before the merge)
  and what it keeps (the spec stop, the code review, the gates, the pull
  request), and the two ways it is taken.
- [ ] **autoroute-visible** — a task in one shot says so in its spec and in
  its pull request.
- [ ] **stops-table-one-shot** — the "Where the work stops" table says
  which stops the one shot removes.
- [ ] **wayfinder-named** — step 2 names `wayfinder` for an interview that
  tangles, and keeps « no interview » for a clear need.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- The file keeps its name `03-autoroute` so links don't break; the text
  says « one shot », Pierrick's word.
- Pierrick never reads the plan today (step 4 is the Architect's; a plan
  that departs from his decisions goes to him), so the one shot has
  nothing to remove there.
- The merge without a stop runs into the merge and publish section of
  `project.md`: question A2 of the 21/11 report.
