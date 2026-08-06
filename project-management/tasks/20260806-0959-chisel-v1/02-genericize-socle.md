# 02 — Genericize the socle (project.md indirection)

**Status:** 🔴 Not Started
**Blocked by:** 01

**What to build:** No hardcoded project path anywhere in the socle. Rules and
skills resolve task workspace, changelog, template, reading list, glossary,
decisions and gate commands through `.agents/project.md` (the glue). Write
`project.md.tpl` with the section structure the questionnaire fills.

## Acceptance criteria

- [ ] `grep -r "doc/project-management\|apps/documentation\|CONTEXT.md" socle/`
      returns only `project.md.tpl` and documentation examples
- [ ] Rules read "the paths declared in project.md" wording; skills
      (slice-task, code-review, domain-modeling, tdd, diagnosing-bugs) resolve
      glossary/tasks/prior-art through the glue
- [ ] `project.md.tpl` covers questionnaire sections A–G with defaults

<!-- 🧑 REVIEW IF RELEVANT — design, persisted from the approved plan -->

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

<!-- 🤖 AGENT ZONE -->

## Notes

_Filled during implementation._
