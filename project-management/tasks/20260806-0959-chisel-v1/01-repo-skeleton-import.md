# 01 — Repo skeleton + socle import

**Status:** 🔴 Not Started
**Blocked by:** None — can start immediately

**What to build:** The chisel repo takes its target shape and becomes the
canonical source of the socle: everything methodology-related from
music-downloader's `doc/agents/` (skills, rules content, workflows.md,
methodology.md), the task template, and `task-id.sh` moved into `socle/`
under the `.agents/` shape, each forked skill carrying its `x-upstream`
frontmatter.

## Acceptance criteria

- [ ] `socle/agents/{skills,rules}/`, `socle/templates/`, `socle/scripts/`
      populated; nothing methodology-related remains only in music-downloader
- [ ] Every Pocock-forked skill has `x-upstream: {repo, path, sha, changes}`
      frontmatter; `upstream.lock.json` lists the same SHAs
- [ ] The 3 task rules exist as tool-agnostic `socle/agents/rules/*.md`
      (content still with hardcoded paths — slice 02's job)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Wiring, worklog — filled during implementation._
