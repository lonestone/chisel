# 03 — Installer CLI (npx @lonestone/chisel)

**Status:** 🔴 Not Started
**Blocked by:** 01

**What to build:** `package.json` (`@lonestone/chisel`, bin) + `bin/chisel.sh`
with three commands. `init`: copy socle → `.agents/`, pose adapters
(AGENTS.md managed block, CLAUDE.md `@AGENTS.md`, `.claude/skills` symlink,
`scripts/task-id.sh`, `/project-management/` skeleton). `update`: re-render
managed parts only. `check`: report version + local divergences. Tested on
committed fixture repos.

## Acceptance criteria

- [ ] `npx` run from a fixture repo produces the full target layout of the
      parent Architecture diagram
- [ ] `init` is idempotent (second run = no diff); `update` never touches
      `project.md` nor files outside managed markers
- [ ] Existing CLAUDE.md/AGENTS.md content is merged (managed block), never
      overwritten
- [ ] Works on macOS + Linux sh (no bashisms beyond `#!/usr/bin/env bash`)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
