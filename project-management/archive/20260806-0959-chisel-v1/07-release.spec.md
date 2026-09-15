# 07 — Release

**Status:** done (2026-09-15) — delivered by the Deno port and the JSR publication of 0.1.0 (journal entries 27 and 28); criteria amended below, struck and dated
**Blocked by:** 06

**What to build:** README (what/why/install/update/sync — plain english, the
workflows.md tone), version tagging, first npm publish of
`@lonestone/chisel`, release discipline documented (bump → tag → publish →
pilots run `update`).

## Acceptance criteria

- [x] ~~`npx @lonestone/chisel init`~~ `deno x jsr:@lonestone/chisel init` (amended 2026-09-15: npm gave way to JSR) works from the PUBLISHED package on a
      clean machine
- [x] README covers init/update/check/sync + the questionnaire in under 5 min
      of reading
- [x] Release process documented (README, "Releasing") and CHANGELOG discipline in place (§A of the glue)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
