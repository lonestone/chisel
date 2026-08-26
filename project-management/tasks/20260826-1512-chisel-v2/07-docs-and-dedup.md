# 07 — Docs rewrite + one-source-per-concept dedup

**Status:** 🔴 Not Started
**Blocked by:** 05, 06

**What to build:** The documentation catches up with v2 and the normative
duplication dies. PHILOSOPHY §4 rewritten in the mode vocabulary — the
W0/W1/W2 labels are RETIRED everywhere (they roughly map: W0 ≈
Controlled/Silent, W1+W2 ≈ Controlled/Active, W3 ≈ Auto — the modes describe
piloting postures, not work sizes). `methodology.md` refreshed: matrix,
roster vocabulary, tiers, ledger convention — doctrine only. README updated
(what/why/install/modes in plain english, under 5 min). Then the
**one-source-per-concept pass** over the whole socle (duplication inventory:
`../factory-bench/research/inventaire-socle-chisel.md` §4): artifact
structure → templates; doctrine → methodology; triggering → formula steps;
every other occurrence becomes a pointer (known v1 duplicates: artifact
structure ×3, typist delegation ×3, model policy ×3, sizing check ×3).

## Acceptance criteria

- [ ] `grep -rn "W0\|W1\|W2"` over `socle/`, `PHILOSOPHY.md`, `README.md`
      returns no mode-label hit
- [ ] PHILOSOPHY §4 and methodology.md present the matrix (piloting ×
      coordination), the invocation-posture principle, the Brief-stays-human
      invariant, and the roster — consistent with the shipped formulas and
      profiles
- [ ] For each duplicated concept of the v1 inventory, exactly one normative
      source remains and the other occurrences are links — mapping listed in
      this slice's Notes
- [ ] README covers the two setup-visible choices (coordination, auto) and
      the upgrade path, in plain language
- [ ] CLI test greps (slice 01/03) still green after the rewrite

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation._
