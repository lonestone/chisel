# 05 — Questions page

**Status:** draft
**Blocked by:** None — can start immediately; the parent spec's question 4

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when the Architect or a Mason has questions for the
human, they leave the chat: the agent writes a questions page (each question
with its options, a recommendation, and a mockup or diagram when it helps)
from a Chisel template. The page opens as a plain file; where the Harness
is present, it serves the page, opens the tab and carries the answers back.
Parent spec: decisions 4, 6, 16.

## Acceptance criteria

- [ ] **questions-page-template** — the template ships in
  `socle/templates/` and opens as a plain file without a server.
- [ ] **questions-leave-chat** — `workflow.md`, "Blockers and questions",
  sends questions to the page.
- [ ] **works-without-harness** — the template and the rule name no Harness
  command.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Apollon's `outils/formulaire.mjs` is the model for the served side, which
  is the Harness's (Dédale's shared page tool).
