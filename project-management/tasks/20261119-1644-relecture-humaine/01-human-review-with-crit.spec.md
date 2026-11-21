# 01 — Human review with crit

**Status:** draft — group A, can start
**Blocked by:** None — can start immediately

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** after the close and the pull request, an agent following
the workflow reaches a *Human review* step. The review opens on the
**strategic reading**: a synthesis of what was done and why for the
critical decisions, with the data schema before → after and any large
architecture change, and nothing less critical. The task's Mason writes it
at the close, on a strong model (never the light tier), as a trial. It reads like a good
article, one page at most, never one sentence. Pierrick reads it first:
if it gives him confidence, he goes down to the proofs and the reading
guide, or approves; otherwise he stops there and comments, and the review
goes no further.

Below it come the two other readings: the proofs (slice 04) and the reading
guide, which for now is the crit story on the pull request's diff, written
with the project's story guide. The spec's depth line says how far down the
human goes: `strategic` stops at the synthesis, plus the proofs the floor
demands; `full` goes to the guide. The agent waits for the human and
answers every comment; no question goes into crit.

A freshly equipped repo has a §J · Review section declaring its default
depth (`full` or `strategic`). The socle ships a synthesis template. The
review skills (parent spec, decision 8) wait on the review tool; until
then the step calls crit directly. Parent spec: decisions 1, 2, 3, 4, 7, 9,
21, 22, 25.

## Acceptance criteria

- [ ] **workflow-has-human-review** — `workflow.md` has the step, and its
  "Where the work stops" table lists it.
- [ ] **strategic-reading-written** — the step opens on the synthesis,
  names what it carries and its length (one article page at most), and
  says the human may stop there with comments.
- [ ] **synthesis-template** — a synthesis template ships in the socle, is
  listed in `src/socle-files.ts`, and has a place for the data schema
  before → after and for a large architecture change.
- [ ] **three-readings-ordered** — the step names the three readings in
  order (strategic, proofs, reading guide) and maps the depth line onto
  them.
- [ ] **project-review-section** — the project template and this repo's
  `project.md` have §J with the depth.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Who writes the synthesis: the Mason, on a strong model, as a trial
  (parent spec, decision 25). Where Pierrick reads it while crit is the
  tool is the plan's to propose: a markdown file in the task folder,
  committed in the pull request, which the crit story opens on.
- Sources: the page « Relecture, parcours et fonctionnalités », step 7
  « Relire » and notes 7, 8, 11 of 21/11.
