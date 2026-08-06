# 04 — Setup questionnaire skill

**Status:** 🔴 Not Started
**Blocked by:** 02, 03

**What to build:** The prompt-driven setup skill (`chisel-setup`), run once
after `init`: explores the repo (boilerplate? package.json? existing docs?),
prefill sections A–G, presents them ONE at a time with a recommended answer,
writes `.agents/project.md`. Brownfield: scans and assists building the
minimal reading list instead of just asking.

## Acceptance criteria

- [ ] On the boilerplate fixture: A–G prefilled correctly (tasks root,
      `apps/documentation` reading list + glossary/decisions), user can accept
      each section in one word
- [ ] On the brownfield fixture: scan proposes a reading list draft and the
      skill assists refining it
- [ ] Re-running the skill updates `project.md` in place without losing
      manual edits outside its sections

<!-- 🧑 REVIEW IF RELEVANT — design, persisted from the approved plan -->

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

<!-- 🤖 AGENT ZONE -->

## Notes

_Filled during implementation._
