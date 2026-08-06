# 04 — Setup questionnaire skill

**Status:** 🟢 Complete
**Blocked by:** 02 (✅), 03 (✅)

**What to build:** The prompt-driven setup skill (`chisel-setup`), run once
after `init`: explores the repo (boilerplate? package.json? existing docs?),
prefill sections A–G, presents them ONE at a time with a recommended answer,
writes `.agents/project.md`. Brownfield: scans and assists building the
minimal reading list instead of just asking.

## Acceptance criteria

- [x] On the boilerplate fixture: A–G prefilled correctly (tasks root,
      `apps/documentation` reading list + glossary/decisions), user can accept
      each section in one word
- [x] On the brownfield fixture: scan proposes a reading list draft and the
      skill assists refining it
- [x] Re-running the skill updates `project.md` in place without losing
      manual edits outside its sections

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-06 · planner: Fable · typist: Sonnet sub-agent)

### Decisions locked

1. **`socle/agents/skills/chisel-setup/SKILL.md`** — OUR skill (no
   `x-upstream` block), `disable-model-invocation: true`, run once after
   `chisel init` (and re-runnable later to revisit sections). Pure protocol —
   no supporting script; the agent running the skill does the exploring.
2. **Step 0 — precondition.** Verify `chisel init` already ran
   (`.agents/.chisel.json` exists). If not: stop and point the user at
   `npx @lonestone/chisel init` — the skill configures the glue, it never
   installs the socle.
3. **Step 1 — silent exploration, before any question.** Detect and note:
   - boilerplate marker: `apps/documentation/` present → boilerplate mode
   - `package.json` scripts (lint / test / typecheck / build / dev) → §F
     prefills
   - existing docs: `README.md`, `doc/`, `docs/`, `CONTEXT.md`, `docs/adr/`
   - an existing task workspace from a previous methodology (e.g.
     `doc/project-management/`) → flag it for §A instead of assuming the
     default root
   **Fact vs decision** (grilling discipline): what the scan established is
   STATED to the user, not asked; only genuine decisions get questions.
4. **Step 2 — sections A→G, ONE at a time**, grilling-style: recommendation
   first, prefilled from the scan + the D5 defaults, acceptable in one word.
   Never batch two sections in one message. Per-mode prefills:
   - boilerplate → §D and §G point into `apps/documentation`; §C prefilled
     from the boilerplate's known layout
   - brownfield → §C becomes a mini-workshop: present the scanned candidates
     (README, existing doc entry points), propose a DRAFT reading list, refine
     it with the user instead of just asking an open question
5. **Step 3 — surgical writes to `.agents/project.md`** (this is AC-3): the
   skill NEVER rewrites the whole file. After each accepted section, replace
   only the content between that section's `## <letter> ·` heading and the
   next `## ` heading (or EOF). Anything else in the file — user-added
   sections, notes above/below — survives a re-run untouched. On re-run,
   the current value of each section is presented as the new recommendation
   (accept-in-one-word keeps working).
6. **§E (Adapters) is not asked** — it is init-written inventory; the skill
   only reads it back to the user as fact (and flags missing adapters as a
   `chisel check` matter).
7. **Closing step**: after §G, print a one-screen summary of the written
   glue and suggest the natural next move (create a first task, or run
   `chisel check`).

### Verification (prompt-driven skill — verified by execution, not asserts)

- On a temp copy of `test/fixtures/boilerplate/` after a real
  `bin/chisel.sh init`: walk the skill's protocol accepting every
  recommendation → resulting `project.md` has §D/§G pointing into
  `apps/documentation`, §F filled from the fixture's `package.json` scripts,
  §A at the default root
- Same on `test/fixtures/brownfield/`: §C contains a scan-derived reading
  list (its README at minimum), not the untouched template default
- AC-3 proof: hand-add a custom `## H · Local notes` section + a line above
  §A to the generated `project.md`, re-run the section-A write → both
  additions byte-identical afterwards
- The SKILL.md contains: the Step-0 gate, the fact-vs-decision line, the
  one-section-at-a-time rule, the surgical-write rule, and no `x-upstream`

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-06, typist: Sonnet sub-agent)

- Wrote `socle/agents/skills/chisel-setup/SKILL.md` — pure protocol, no
  supporting script (the agent running the skill does the exploring, per
  Decision 1). Frontmatter: `name: chisel-setup`, `description`,
  `disable-model-invocation: true`. No `x-upstream` block — this is OUR
  skill, same pattern as `sync-upstream/SKILL.md` (checked its frontmatter
  as the house-style reference for a non-forked skill).
- Structure mirrors the locked decisions one-to-one:
  - **Step 0** — precondition gate on `.agents/.chisel.json`; stop and point
    at `npx @lonestone/chisel init` if absent, never bootstrap `.agents/`
    itself.
  - **Step 1** — silent exploration before any question: boilerplate marker
    (`apps/documentation/`), `package.json` scripts, existing docs
    (`README.md`, `doc/`, `docs/`, `CONTEXT.md`, `docs/adr/`), a prior
    methodology's task workspace. States the `grilling`-borrowed fact-vs-
    decision line verbatim in spirit ("what the scan established is
    *stated*... only genuine decisions... get a question").
  - **Step 2** — walks A→G one at a time, recommendation first, prefilled
    from the scan + the parent task's D5 defaults spelled out inline (root
    `/project-management/`; local-markdown tracker; boilerplate reading
    list into `apps/documentation`; living docs `apps/documentation` vs
    `doc/**`; gate commands from `package.json`; glossary/ADRs into
    `apps/documentation` vs root `CONTEXT.md` + `docs/adr/`). Explicit
    "never present two sections in the same message" rule. Per-mode
    prefill split for boilerplate vs brownfield, brownfield's §C called out
    as a mini-workshop (present scanned candidates, draft, refine — not a
    blind open question).
  - **Step 3** — §E called out separately as read-back-only: never asked,
    current adapter state stated as fact, missing adapters flagged as a
    `chisel check` matter, not fixed here.
  - **Step 4** — the surgical-write contract: locate the section's
    `## <letter> · ...` heading, replace only up to the next `## ` heading
    or EOF, leave every other byte untouched (explicitly calls out
    hand-added sections like a `## H · ...` surviving). States the
    re-run behavior: current `project.md` content becomes the next
    recommendation, not the template default.
  - **Step 5** — closing summary (one line per A–G) + suggest next move
    (first task, or `chisel check`).
- Read `socle/agents/project.md.tpl` (the A–G heading structure the skill
  fills), `socle/agents/skills/sync-upstream/SKILL.md` and
  `grilling/SKILL.md` (house style + the interview discipline being reused),
  `bin/chisel.sh` (confirmed the Step-0 gate file is
  `.agents/.chisel.json`, written by `write_manifest` in `cmd_init`), and
  both committed fixtures (`test/fixtures/boilerplate/`,
  `test/fixtures/brownfield/`) to ground the prefills in what a real scan
  would actually find.

### Verification output (real execution, not asserts)

All work done on temp copies under the session scratchpad — the chisel repo
itself was never touched beyond the two intended file changes (`git status`
before/after: only this slice file + the new skill directory).

1. **Real `bin/chisel.sh init`** on temp copies of both fixtures — both
   succeeded (`chisel init: ... ready (.agents/, AGENTS.md, CLAUDE.md,
   .claude/skills, project-management/, scripts/task-id.sh)`). Confirmed
   `.agents/.chisel.json` present on both (Step-0 gate would pass) and all
   three adapters live on both (`AGENTS.md`, `CLAUDE.md`'s `@AGENTS.md`
   line, `.claude/skills → ../.agents/skills`).
2. **Boilerplate walkthrough** (accept-every-recommendation mode, executed
   as the agent, surgical section-by-section edits): §A/§B left at scan-
   confirmed defaults (no prior task workspace found, so the template
   default stands — untouched, not rewritten pointlessly); §C added
   `apps/documentation/README.md` as the doc entry point; §D changed the
   living-docs root from `doc/**` to `apps/documentation` (boilerplate
   marker detected); §E checked all three adapter boxes (fact, not asked);
   §F filled from the fixture's real `package.json`
   (`lint`→`eslint .`, `test`→`vitest run`, `build`→`vite build`, browser
   check correctly left unconfigured — no dev/preview script exists); §G
   moved glossary/ADRs into `apps/documentation`. **PASS** — diffed against
   `project.md.tpl`: exactly §C/§D/§E/§F/§G touched, §A/§B untouched, §D
   and §G point into `apps/documentation`, §F matches the fixture's
   scripts, §A at the default root — matches the Design's verification
   text exactly.
3. **Brownfield walkthrough** (same mode): scanned facts — no `package.json`,
   no `doc/`/`docs/`/`CONTEXT.md`/`docs/adr/`, no `apps/documentation`
   marker; existing `AGENTS.md` (historical notes, preserved above the
   managed block) and `CLAUDE.md` (Ruby/Sidekiq note, `bundle exec rspec`)
   with real user content. §C became the mini-workshop the Design specifies:
   presented the scan (README only, nothing else) as a draft, added an
   explicit note recording that the user confirmed the minimal list is
   enough for now — a genuine scan-derived addition, not the untouched
   template text. §F picked up the one concrete fact available
   (`bundle exec rspec` from `CLAUDE.md`) instead of leaving Test blank,
   demonstrating the fact-vs-decision discipline reaches beyond
   `package.json` when a fact is sitting right there. §E same read-back-
   only treatment. §A/§B/§D/§G left at defaults (scan confirms the
   defaults are still correct — nothing found to override them). **PASS**
   — diffed against the template: §C/§E/§F touched only; confirmed
   byte-for-byte that `README.md`, `AGENTS.md`'s pre-block user preamble,
   and `CLAUDE.md`'s Ruby/Sidekiq line are all untouched.
4. **AC-3 surgical-write proof**: on the boilerplate result, hand-added a
   `<!-- LOCAL NOTE -->` line immediately above the `## A ·` heading and a
   whole `## H · Local notes` section at EOF, snapshotted that state
   (`sha256 287cfdd2...`), then re-ran only §A's write using the exact
   algorithm Step 4 specifies (locate `## A · Task workspace`, replace up
   to the next `## ` heading, leave everything else alone). Re-hashed:
   **identical** (`287cfdd2...` both before and after), `/usr/bin/diff -u`
   exit 0, zero output. Both additions survived byte-identical. **PASS**.
   (First attempt at this proof used a stale snapshot taken before the
   hand-add and got a false failure signal from this shell's `diff`
   function, which is RTK's `git diff` wrapper and doesn't behave like
   plain `diff` on two arbitrary files — redid the snapshot at the correct
   point and re-verified with `/usr/bin/diff` directly and `shasum -a 256`
   for an unambiguous byte-identity check.)
5. **SKILL.md content check**: contains the Step-0 gate (`.agents/.chisel.json`),
   the fact-vs-decision line, the one-section-at-a-time rule ("Never present
   two sections in the same message"), the surgical-write rule ("Never
   rewrite the whole file"), and no `x-upstream` block — confirmed by
   reading the written file back.

### Deviations from Design

- **§F on the brownfield fixture pulled a fact from `CLAUDE.md` (`bundle
  exec rspec`) rather than leaving Test unconfigured.** Decision 3's Step-1
  list names `package.json` scripts as the source for §F prefills and
  doesn't mention scanning other files for command facts. Conservatively
  read this as an example of exploration, not an exhaustive restriction —
  the fact-vs-decision discipline (Decision 3, borrowed from `grilling`)
  says facts findable by exploring the environment should be stated, not
  left blank when a concrete one is sitting in `CLAUDE.md`. Encoded in the
  SKILL.md's Step 1 only as "package.json scripts" per the Design's literal
  list, to stay conservative on the instruction text itself; the
  brownfield verification run is the one place this judgment call is
  visible, and it's called out here rather than folded silently into the
  skill's protocol.
- **No script was added, per Decision 1** ("Pure protocol — no supporting
  script"). This means Step 2 through Step 5 have no machine-checkable
  enforcement of "one section at a time" or the surgical-write boundary —
  both rest entirely on the executing agent following the written
  protocol, same as the `grilling` and `sync-upstream` skills' own
  step-by-step discipline. Verification in this slice is by execution
  (walking the protocol as the agent), matching the slice file's own
  "Verification (prompt-driven skill — verified by execution, not asserts)"
  framing — not a gap, just naming the tradeoff Decision 1 already made.

### Planner review (2026-08-06, Fable)

Commit `4e57a5b` reviewed green — first slice needing zero planner fixup.
Scope exactly the 3 intended files. SKILL.md maps one-to-one onto the 7
locked decisions, plus one genuine improvement from the typist: "write it
immediately — do not batch writes" (a batched write at the end would
reintroduce the full-file-rewrite risk Step 4 exists to prevent). The AC-3
surgical-write proof was replayed independently by the planner (fresh tpl
copy + hand edits above §A and a custom `## H`, §A-only rewrite): prefix,
§B–§G and §H byte-identical, both hand edits survived. Both deviations
accepted — the CLAUDE.md gate-command fact on brownfield is exactly the
fact-vs-decision discipline working as intended.
