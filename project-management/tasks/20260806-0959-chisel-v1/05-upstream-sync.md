# 05 — Upstream sync (Pocock forks)

**Status:** 🔴 Not Started
**Blocked by:** 01

**What to build:** The `sync-upstream` skill + supporting script. `--check`
lists which forked skills drifted upstream (SHA compare) without writing. Full
run: fetch upstream, diff each skill since its recorded SHA, present per-skill
proposed merges preserving our documented adaptations — agent proposes, human
validates, nothing auto-applied. Updates frontmatter SHAs + lock + CHANGELOG.

## Acceptance criteria

- [ ] `--check` output lists drifted skills with commit counts, zero writes
- [ ] A full run on a deliberately outdated SHA produces a reviewable diff and
      applies ONLY after explicit approval, preserving `changes:` adaptations
- [ ] A skill marked `upstream: none` is skipped and reported as unplugged

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
