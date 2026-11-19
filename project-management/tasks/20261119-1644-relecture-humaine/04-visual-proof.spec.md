# 04 — Visual proof

**Status:** draft
**Blocked by:** 01 — Human review with crit; the parent spec's questions 1 and 5

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when a task touches a screen, the agent checks it itself
(a recorded Playwright e2e test, or at least a browser or Playwright check)
and the human review shows at least a screenshot of it, with a before →
after comparison when the screen existed. A `visual-proof` skill, made
generic from music-downloader's `review-videos`, does this from the commands
§J declares; the trigger follows question 1. Parent spec: decisions 5, 10,
13, 17.

## Acceptance criteria

- [ ] **visual-proof-skill** — the skill exists, reads its commands from
  §J, and names no command of one project.
- [ ] **review-section-commands** — §J declares the e2e, recording and
  screenshot commands, each optional.
- [ ] **no-screen-no-capture** — a dry run on a repo with no front touched
  produces no capture.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Dry run on music-downloader before shipping (screens, e2e, recording).
