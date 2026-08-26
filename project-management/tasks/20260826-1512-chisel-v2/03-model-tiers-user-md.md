# 03 — Abstract model tiers + user.md cascade

**Status:** 🔴 Not Started
**Blocked by:** 01

**What to build:** The vendor coupling leaves the socle. Everywhere the socle
speaks about models it speaks in **tiers** — frontier / mid / cheap —
homogeneous with the roster (Architect/Inspector = frontier, Mason =
cheap/mid, Watchmen = cheap). The tier → concrete model mapping resolves
through a cascade: `.agents/user.md` (personal, GITIGNORED) >
glue `project.md` (versioned team default) > socle default. `user.md` gets a
template/shape and a lightweight generation path so any dev can create theirs
at their first session (the setup poses it for the current dev — wired in
slice 04). The v1 model policy passages (Cursor/Grok/Composer hardcoded in
methodology.md, code-review, and the late workflows.md — inventory:
`../factory-bench/research/inventaire-socle-chisel.md` §4 "Couplage vendor")
are rewritten in tier terms with the mapping read from the cascade.

## Acceptance criteria

- [ ] `grep -ri "cursor\|grok\|composer\|opus\|sonnet"` over `socle/agents/`
      normative files and skills returns no model-policy hit (adapter/geste
      docs excepted, if any) — tiers only
- [ ] The cascade is documented in one normative place and read by the texts
      that need a model choice (delegation, review) — pointers elsewhere
- [ ] `user.md` is gitignored in equipped projects (init poses the ignore
      rule); `update` never touches it; a fixture proves both
- [ ] A dev without `user.md` still gets working defaults (glue, then socle)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
