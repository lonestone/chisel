# 03 — Autoroute

**Status:** draft
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a task can run on the autoroute: the code review and the
gates still run, the pull request is still opened, the stops that only
serve the human (reading the spec, reading the plan, the human review) are
skipped. The Architect takes it when it judges the task small at step 2, or
when the human asks for it explicitly, and writes the choice and its reason
in one line of the spec; there is no project switch (ruling G10). Parent
spec: decisions 2 and 14.

## Acceptance criteria

- [ ] **autoroute-written** — `workflow.md` names the autoroute, what it
  skips, what it keeps, and the two ways it is taken.
- [ ] **autoroute-visible** — a task on the autoroute says so in its spec
  and in its pull request.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
