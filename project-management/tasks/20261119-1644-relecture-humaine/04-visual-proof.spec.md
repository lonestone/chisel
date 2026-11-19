# 04 — Visual proof

**Status:** draft
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when a task touches a screen, the agent checks it itself
(a recorded Playwright e2e test, or at least a browser or Playwright check)
and the human review shows at least a screenshot of it, with a before →
after comparison when the screen existed. A `visual-proof` skill, made
generic from music-downloader's `review-videos`, does this from the commands
§J declares. The depth is the Architect's line in the spec; the diff only
adds a floor (a screen touched means captures). The
proofs are shown in a page Chisel serves, built at slice 06; until then
they are files in the folder §J names. The close records the depth chosen
and the floor the diff computed, and `retro` compares them, so an agent
that always asks more than the floor shows. Parent spec: decisions 5, 10,
13, 17.

## Acceptance criteria

- [ ] **visual-proof-skill** — the skill exists, reads its commands from
  §J, and names no command of one project.
- [ ] **review-section-commands** — §J declares the e2e, recording and
  screenshot commands, each optional.
- [ ] **spec-line-read** — the skill reads the depth line of the spec and
  adds captures when the diff touches a screen the line left out.
- [ ] **depth-against-floor** — the work-document template records the
  depth chosen and the floor computed, and `retro` compares them.
- [ ] **no-screen-no-capture** — a dry run on a repo with no front touched
  produces no capture.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Dry run on music-downloader before shipping (screens, e2e, recording).
