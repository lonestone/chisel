# 02 — Who fixes the comments

**Status:** ready — group A, approved by Pierrick on 22/11 (ffaf5ec)
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when the human review leaves comments, the Mason who did
the work is woken to fix them, however long ago it closed; a fresh Mason
only when its session is lost. When a comment changes a spec decision, the
Architect fixes the spec first, then wakes the same Mason. Pierrick:
« toujours le macon qui a bossé ! Toujours. » Parent spec: decision 11;
decision 12, the resume summary, is withdrawn.

## Acceptance criteria

- [ ] **who-fixes-written** — `workflow.md` says the task's Mason fixes the
  comments, names the lost-session exception, and the spec-first case.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
