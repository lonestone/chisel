# 02 — Agent profiles + generated per-tool definitions

**Status:** 🔴 Not Started
**Blocked by:** 01

**What to build:** The roster becomes installable. Canonical markdown profiles
in `.agents/profiles/` — `architect.md`, `mason.md`, `inspector.md` — each
carrying the role CONTRACT: mission, tier (frontier/mid/cheap), prohibitions
(Architect never types what it planned; Inspector never the author of the
plan nor the diff; separation of powers), escalation rules, brief format
(brief = artifacts only, never the conversation). No Foreman profile in v1: a
`foreman.md` doc page instead (human in Controlled; cron/hook around
`bd ready` / `bd gate check` in Auto × beads). Because most tools cannot
import a shared definition (state of the art:
`../factory-bench/research/sous-agents-par-outil.md`), the installer
GENERATES the per-tool definitions from the profiles — `.claude/agents/*.md`
(covers Cursor ≥2.4 for free via native cross-read), `.codex/agents/*.toml`;
universal fallback documented as profile-inlined-at-spawn or fresh session +
brief. Generated files are managed (D2/D7 pattern: re-rendered by `update`,
tracked in `.chisel.json`, drift caught by `check`). The socle prescribes the
delegation contract; the per-tool spawn gesture lives in the adapter — no
vendor wording in the profiles. Roles sign their beads acts via `--actor`
(convention text lands here, wiring in slice 05).

## Acceptance criteria

- [ ] `init` on a fixture installs the 3 profiles + generates
      `.claude/agents/` and `.codex/agents/` definitions from them; `update`
      re-renders them; a hand-edit is flagged by `check` (manifest-tracked)
- [ ] Each profile contains the five contract sections (mission, tier,
      prohibitions, escalation, brief format) and no vendor/model name —
      tiers only
- [ ] The formulas' role mentions (slice 01) resolve to these profiles by
      name; `foreman.md` exists as doc, not as a profile
- [ ] Fixture assert: no `foreman` definition is generated for any tool

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
