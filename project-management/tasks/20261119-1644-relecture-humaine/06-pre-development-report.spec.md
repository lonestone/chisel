# 06 — Pre-development report and proofs page

**Status:** draft
**Blocked by:** 01 — Human review with crit; 05 — Questions page

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** once the questions are answered, the human reads in the
browser what will be done, « une sorte de .spec mais chargé dans le
browser ». Its look comes first: real variants of the report and of the
review, chosen by Pierrick, before any form or tool (« faut se concentrer
sur la UX »). The Mason fills it at the plan step with the same parts the
final review shows (what changes, the files touched, the data model before
→ after, the flows), so the gap between planned and done shows at once; how
the two sit side by side is the tool's. On the same tool, the proofs page
shows the screenshots, comparisons and videos of slice 04, linked from the
review. Parent spec: decisions 6, 15, 17.

## Acceptance criteria

- [ ] **plan-step-writes-report** — the plan step of `workflow.md` asks for
  the report, in the shared form.
- [ ] **report-served** — Chisel serves the report and gives the human its
  link, with no Harness command involved.
- [ ] **proofs-page-served** — Chisel serves the proofs page, and the human
  review links it.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

_None yet._
