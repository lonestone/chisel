# 02 — Who fixes the comments

**Status:** draft
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when the human review leaves comments, the workflow says
who fixes them: the same Mason when no spec decision changed and the close
is under an hour old; a fresh Mason past an hour; the Architect first,
then a fresh Mason, when a spec decision changed. At its close, the Mason
leaves a resume summary in the work document (decisions, key files,
pitfalls, commands that work) that the fixer starts from. Parent spec:
decisions 11 and 12.

## Acceptance criteria

- [ ] **who-fixes-written** — `workflow.md` gives the three cases.
- [ ] **resume-summary-in-template** — the work-document template has the
  resume-summary section, and the close step asks for it.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
