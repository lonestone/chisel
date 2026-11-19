# 01 — Human review with crit

**Status:** draft
**Blocked by:** None — can start immediately

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** after the close and the pull request, an agent following
the workflow reaches a *Human review* step: it writes the crit story with
the project's story guide, launches crit on the pull request's diff, waits
for the human, and answers every comment. A freshly equipped repo has the
story guide and a §J · Review section declaring its depth (`full` or
`strategic`). Parent spec: decisions 1, 2, 3, 4, 7, 8, 9.

## Acceptance criteria

- [ ] **workflow-has-human-review** — `workflow.md` has the step, and its
  "Where the work stops" table lists it.
- [ ] **crit-skill-ships** — `chisel-crit` exists, is listed in
  `src/socle-files.ts`, and copies none of crit's own skills.
- [ ] **story-guide-placed** — setup on an empty repo yields
  `.crit/prompts/on_story_generate.md`, and `crit story --guide` uses it
  with no manual trust step.
- [ ] **project-review-section** — the project template and this repo's
  `project.md` have §J with the depth.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
