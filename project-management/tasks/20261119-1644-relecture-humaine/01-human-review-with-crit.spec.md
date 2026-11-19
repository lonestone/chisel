# 01 — Human review with crit

**Status:** draft
**Blocked by:** None — can start immediately

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** after the close and the pull request, an agent following
the workflow reaches a *Human review* step: it writes the crit story with
the project's story guide, launches crit on the pull request's diff, waits
for the human, and answers every comment. A freshly equipped repo has a
§J · Review section declaring its default depth (`full` or `strategic`).
The review skills (parent spec, decision 8) wait on the review tool; until
then the step calls crit directly. Parent spec: decisions 1, 2, 3, 4, 7, 9.

## Acceptance criteria

- [ ] **workflow-has-human-review** — `workflow.md` has the step, and its
  "Where the work stops" table lists it.
- [ ] **project-review-section** — the project template and this repo's
  `project.md` have §J with the depth.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
