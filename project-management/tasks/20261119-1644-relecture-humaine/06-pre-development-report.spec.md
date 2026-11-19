# 06 — Pre-development report

**Status:** draft
**Blocked by:** 01 — Human review with crit; 05 — Questions page; the parent spec's question 3

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** once the questions are answered, the human reads in the
browser what will be done, « une sorte de .spec mais chargé dans le
browser ». Its shape follows question 3: if the plan fills the review's
template, the human review then shows planned → done side by side. Parent
spec: decisions 6 and 15.

## Acceptance criteria

- [ ] **report-template** — the report template ships in
  `socle/templates/` and opens as a plain file without a server.
- [ ] **plan-step-writes-report** — the plan step of `workflow.md` asks for
  the report.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
