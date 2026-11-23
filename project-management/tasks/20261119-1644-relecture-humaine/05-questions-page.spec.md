# 05 — Questions page

**Status:** draft
**Blocked by:** the review tool chosen after the task `relecture-analyse`

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when the Architect or a Mason has questions for the
human, they leave the chat. The agent writes a questions page (each
question with its options, a recommendation, and a mockup or diagram when
it helps), Chisel serves it and gives the agent a link for the human, and
the answers come back to the agent that asked. All of it works outside the
Harness. Which tool serves the page is the one chosen after
`relecture-analyse`; this slice wires it into Chisel. Parent spec:
decisions 4, 6, 16, and "The pages, as needs".

## Acceptance criteria

- [ ] **questions-leave-chat** — `workflow.md`, "Blockers and questions",
  sends questions to the page.
- [ ] **pages-without-harness** — Chisel serves the page, and an answer
  given on it reaches the agent, with no Harness command involved.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Apollon's `outils/formulaire.mjs` (31 lines of Node) is one input for the
  tool.
