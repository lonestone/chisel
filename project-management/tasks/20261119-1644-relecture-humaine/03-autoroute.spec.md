# 03 — Autoroute

**Status:** draft
**Blocked by:** 01 — Human review with crit; the parent spec's question 2

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a task can run on the autoroute: the code review and the
gates still run, the pull request is still opened, the stops that only
serve the human (reading the spec, reading the plan, the human review) are
skipped. Where the choice is written follows the parent spec's question 2,
within ruling G10 (« je ne veux pas d'interrupteur »). Parent spec:
decisions 2 and 14.

## Acceptance criteria

- [ ] **autoroute-written** — `workflow.md` names the autoroute, what it
  skips, what it keeps, and where the choice is written.
- [ ] **autoroute-visible** — a task on the autoroute says so in its spec
  and in its pull request.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
