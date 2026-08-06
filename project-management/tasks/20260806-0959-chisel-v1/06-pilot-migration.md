# 06 — Pilot migration + Cursor reliability test

**Status:** 🔴 Not Started
**Blocked by:** 04

**What to build:** Migrate music-downloader and evea-ai to the installed
layout (`chisel init` + questionnaire + removal of the old `doc/agents/` /
`.cursor/rules` socle copies; existing tasks/changelog untouched). Then the
gating test: verify in real Cursor sessions that the task rules fire from
`AGENTS.md` alone; if unreliable, activate the documented fallback (thin
`.mdc` shims posed by `init`).

## Acceptance criteria

- [ ] Both pilots equipped via the real `npx` flow; old socle copies removed;
      existing tasks/changelog/archive intact
- [ ] Fresh-session routing test passes on each pilot (ambient → propose task
      → create → work) in Claude Code AND Cursor
- [ ] Cursor verdict documented in the chisel README (AGENTS.md-only, or shim
      fallback shipped and enabled)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
