# Align the socle with the charter — work

Created by the Crewmate at plan time, 2026-10-29. Spec:
`project-management/tasks/20261029-1247-align-the-socle-with-the-charter.spec.md`.
Governing page: `CHARTER.md`.

**Plan:** approved by the Architect, 2026-10-29, with two corrections (see
"Corrections at approval" below). Answers to the five questions recorded
there too.

## Program Design

### Corrections at approval (Architect, 2026-10-29)

1. **Step 2 is conditional.** A task that arrives clear (a well-written
   issue, a clear request) gets its spec document written by the Architect
   from it, with no interview. `grilling` runs only when the intent is
   unclear. The human approves the spec when it carries decisions the task
   did not state; otherwise the Architect moves it to `ready` itself
   (charter objective 2, less load on the human).
2. **The Crewmate closes.** Step 7 is the Crewmate's: tick criteria, promote
   evergreen material, archive the pair, journal entry, `retro`, commit,
   tracker update. The Architect reads the close report, rules on anything
   left, and opens the pull request or asks the human for a merge. "Where it
   stops" and the statuses section follow: the thread doing a step writes
   the status it leaves. In this task too: the close comes after the review.

Answers: (1) model tiers kept, compact, in `reference.md`, §H and
`user.md.tpl` unchanged; (2) the spec and work documents always live in the
task workspace and the tracker item points at the spec; a spec written from
a clear issue stays short and links it; the plan always goes in the work
document; (3) the `stale:` report is extended to the two retired §E lines;
(4) the vendored GLOSSARY sentence stays, recorded as a deliberate mention;
(5) see correction 2. Re-copying this repo's two templates: approved.

### What the socle says after this task

One prose page, `.agents/workflow.md`, says how one task goes from intent
to commit and pull request. Four roles: Architect, Crewmate, an optional
Typist, and the reviewers inside `code-review`. Seven statuses. The tracker
is one section of the glue. Nothing is rendered into `.claude/agents/` or
`.codex/agents/` any more, and `chisel update` takes the 0.1.1 leftovers
away through the manifest mechanism it already has.

### The doctrine, file by file, against the 600-line budget

Today: `discipline.md` 114, `methodology.md` 453, `reference.md` 106, plus
1,157 lines of formulas and 747 of profiles.

| File | Today | Target | Keeps | Drops |
|---|---|---|---|---|
| `discipline.md` | 114 | ~85 | Read before acting; plan first (persisted, approved by the Architect); 🧑 zones are law; verify before done; the bridge rule (now proposes the workflow); escalate, don't improvise (short, points at the workflow); session hygiene; the repo is the only memory; the writing rule; the side-lanes table. | Rules 9 and 10 (read a profile before spawning; a session takes a step's role). Every preset, formula and profile pointer. |
| `workflow.md` | new | ~220 | See the outline below. | — |
| `methodology.md` | 453 | ~190 | Provenance; a new short "Why one task, and why prose"; why a reading gradient; why seams first; why the sizing check (one pass or slices, nothing else); the two designs and why the plan is persisted (Typist in place of Mason, the Architect's reading in place of `plan-review`); why the interview comes first; why the review runs in fresh sub-agents on two axes; why seven statuses (short); why the journal stays; the artifact ladder; why the time-id. | "A default, and two options" (presets, factory, invocation posture); the roster; zone ownership (one sentence moves to `reference.md`); escalation (moves to `workflow.md`); "The pipeline is nine steps"; the thirteen-status essay; the model-tier section; the dex phase table (one sentence survives in the two designs); the bridge rule (it lives in `discipline.md`). |
| `reference.md` | 106 | ~65 | The glossary (status now points at `workflow.md`); the "ticket" note, shorter; zone ownership as one paragraph (the human who approved a zone owns it; never overridden silently); model tiers as one table plus the three-level cascade. | Per-preset zone ownership; the tier table's Foreman, Checker, Inspector and Mason rows. |
| **Total** | 673 (+1,904) | **~560** | | |

`reference.md` survives: `code-review`, `codebase-audit`, the glue template
and `user.md.tpl` point at its "Model tiers" section, and folding the
glossary into `workflow.md` would make that page longer than it should be.
(Decision 1 left this to the Crewmate.)

### Outline of `.agents/workflow.md`

1. **What this page is** (~10 lines). Chisel processes one task, from
   intent to commit and pull request. It does not orchestrate: choosing the
   next task, watching a tracker, scheduling, belong to the layer above. This
   page is the whole workflow, in prose.
2. **The roles** (~25). Table: Architect, Crewmate, Typist (optional),
   Reviewers, and the human's part. The Architect is the default role of the
   agent a human or an orchestrator talks to. Its thread can be long and
   compacting, or one per piece of work; a long thread can run several
   Crewmates, one per task or slice.
3. **The steps** (~70). One short paragraph each, saying who, what, the
   status it leaves, and where it stops:
   1. *Read the task* — Architect, through the tracker named in the glue.
   2. *Interview and spec* — Architect with the human: `grilling`, seams
      agreed, spec document from the template, the sizing check out loud
      (one pass, or `slice-task`). The human approves the spec. Commit it.
      `draft` → `ready`.
   3. *Plan* — Crewmate, launched with the Crewmate brief: creates the work
      document, persists the program design, STOPS. `in-progress`.
   4. *Plan reading* — Architect: reads, corrects, approves; the approval is
      written in the work document. A plan that departs from a decision the
      human made goes back to the human, with the question stated.
   5. *Code* — Crewmate (or a Typist it launches): TDD at the seams, a commit
      at each green step, checkboxes ticked, the gate commands run.
   6. *Review* — Crewmate runs `code-review`; its reviewers are fresh.
      Findings go in the work document; the Crewmate fixes or answers them,
      and reports to the Architect.
   7. *Close* — Architect (it may hand the bookkeeping to the live Crewmate):
      rules on what is left, promotes evergreen material, ticks the criteria,
      archives the pair, writes the journal entry, runs `retro`, commits,
      updates the tracker to `done`, opens the pull request when asked.
      Merging and publishing wait for the human's explicit word on that very
      action.
4. **Where it stops** (~15). A short table: the Crewmate stops for the
   Architect after the plan and after the review; the Architect stops for
   the human on the spec's decisions, on a plan that departs from them, on a
   blocker above what it owns, and before a merge or a publish.
5. **The tracker** (~15). Read at step 1, updated at each status change and
   at close, through the skill or tool the glue's tracker section names. The
   spec and work documents live in the task workspace whatever the tracker.
6. **Statuses** (~20). The seven, one line each, with the step that leaves
   a task there. The Architect writes the status; the Crewmate never does.
   Plan approval is a line in the work document, not a status.
7. **Sub-agents** (~20). Launch one only for a context that must stay
   clean, for work that runs in parallel, or for a cheaper model. The three
   that earn it: the Crewmate (keeps the Architect's context clean for the
   reading), the Typist (cheaper model), the reviewers (fresh eyes). A brief
   is artifacts and paths, never the conversation. Reviewers are always
   fresh; a Crewmate is reused within a live thread. When the tool cannot
   launch a sub-agent, a fresh session opened with `work on task
   <spec-document>` (or `work on slice …`) plays the Crewmate.
8. **The Crewmate brief** (~12). What the Architect writes when it launches
   one: the spec document's path, the work template, the branch, the gate
   commands, the stop after the plan, code-review at the end, the report.
9. **The Typist brief** (~8). The approved work document, the slice of it to
   type, decide nothing, report anything the plan does not answer.
10. **Blockers and questions** (~20). Report to whoever launched you. A
    written trace in the task's own documents, signed with the role, the
    date and the time; the ruling recorded in the same place. How the
    Architect brings a question to the human: one report, fact / problem /
    options with a recommendation, each report standing on its own, never
    repeating what is settled (the field-tested part of the old Foreman
    page, kept short).

### Templates and managed block

- `socle/templates/000-template.spec.md` (235 → ~150). `creating` becomes
  `draft`. The zones table loses its per-preset owner rule. The "two
  documents" table names the reviewers' findings, not the Inspector's. The
  Statuses section keeps the format rule (value alone on the line, free
  text after) and points at `workflow.md` for the seven values. The
  six-old-status table moves to `chisel-upgrade`.
- `socle/templates/000-template.work.md` (122 → ~100). Mason becomes the
  Crewmate; `plan-review` becomes the Architect's reading; the Inspector
  becomes the reviewers of `code-review`. A `**Plan:**` line under the title
  records the approval (who, when), which is where decision 3 says plan
  approval shows.
- `socle/templates/AGENTS-block.md` (61 → ~30). Always `discipline.md`; real
  scoped work follows `.agents/workflow.md`; by default you are the
  Architect; launched as a Crewmate or a Typist, follow that brief; paths
  resolve through the glue; vocabulary and tiers in `reference.md`.
- This repo's own `project-management/000-template.spec.md` and
  `000-template.work.md` are re-copied from the socle templates (with the
  methodology link kept relative), so the repo dogfoods what it ships.

### The glue template (`socle/agents/project.md.tpl`, 207 → ~150)

- **§B · Tracker** replaces §B1 and §B2. Three lines: *Tasks live in*
  (default: the task files of §A); *Read and updated with* (default: the
  `**Status:**` line, edited by hand; beads → `.agents/skills/chisel-beads/SKILL.md`;
  Plane → its MCP, named here; anything else → the skill or tool, named
  here); *Link back* (where a tracker item points at its spec document). The
  tracker maps the seven statuses of `workflow.md`.
- §D's "the `close` step of every formula" becomes "the close step of the
  workflow".
- §E loses `.claude/agents` and `.codex/agents`; three adapters remain.
- §A, §C, §F, §G, §H are unchanged.

### Skills

- **`chisel-beads`** (501 lines across two files → ≤ 110, one file).
  `CHANGING-CASE.md` is deleted. `SKILL.md` keeps: when it applies (the
  glue's tracker section names beads); bead = status, claim, edges, and the
  documents keep everything else; read a task (`bd show`, `bd ready`); set a
  status, with the seven-value mapping (`ready` → `open`, `in-progress` →
  `in_progress`, `blocked` and `deferred` built in, `draft`, `done`,
  `cancelled` declared custom); comment; link (`--spec-id`, `bd dep add`);
  `--actor` is the role (`architect`, `crewmate`, `typist`); entering the
  case in a few commands (`bd init … --skip-agents --skip-hooks`, the
  `status.custom` line, the commit on exact paths); the session routine with
  the push check; the two guards (never `git push --mirror`; verify the
  assignee after a claim). Every `bd` command is checked against the
  installed `bd` before it is written.
- **`chisel-setup`** (454 → ~400). §B1 and §B2 merge into one §B question
  ("Where do your tasks live?": files / beads / Plane / another tool), with
  the adapter named on the answer; Step 6 points at `chisel-beads`'s entering
  section instead of `CHANGING-CASE.md` and no longer links formulas; §E
  read-back counts three adapters; Step 7's list of socle files gains
  `workflow.md`; the word "formula" leaves the plain-language rule.
- **`upgrade-v2` → `chisel-upgrade`** (225 → ~200). Two starting points,
  detected at Step 0: the first version's layout (`.agents/rules/`,
  `workflows.md`; today's procedure, kept) or a 0.1.x install
  (`.agents/formulas/` or `.agents/profiles/` present). The 0.1.x path: run
  `chisel update` (it removes the unchanged formulas, profiles and
  definitions; anything it names `orphaned:` is put to the human); rewrite
  the glue's §B into the tracker section and drop the two §E lines; rewrite
  the status line of each OPEN task file by the migration table (the archive
  is never touched); with beads, re-declare `status.custom`, move each open
  bead's status, remove the `.beads/formulas` symlink; a profile the project
  wrote itself in `.agents/profiles/` moves into its project instructions;
  list for the human any text outside the managed block that still names a
  retired piece. The migration tables (thirteen → seven, and the first
  version's six → seven) live here and only here.
- **`retro`**, **`slice-task`**: Mason → Crewmate, Inspector → the reviewers,
  "the `close` step of every formula" → "the close step of the workflow";
  their `changes:` frontmatter notes say so.
- **`code-review`**, **`codebase-audit`**: no change needed (their tier
  pointer into `reference.md` survives).

### CLI (`src/`)

- Delete `src/render.ts`.
- `init.ts`, `update.ts`: stop calling `renderAgentDefinitions`; the init
  message stops naming `.claude/agents` and `.codex/agents`.
- `install.ts`: `COPIED_TREES` keeps only `agents/skills/`; `COPIED_FILES`
  gains `workflow.md`; `MANAGED_ROOTS` loses `.agents/formulas`,
  `.agents/profiles`, `.claude/agents`, `.codex/agents`, so the directories
  a 0.1.1 cleanup empties go with their files (`.claude` stays while the
  skills link is in it; `.codex` goes when empty); the profiles comment goes;
  both messages that name `upgrade-v2` name `chisel-upgrade`.
- `manifest.ts`: no more scan of the definition directories; `.agents/workflow.md`
  is tracked. That alone is what cleans a 0.1.1 install: the old manifest
  lists the formulas, profiles and definitions, the new one does not, and
  `orphansOf` already removes an unchanged one and names a modified one.
- `markers.ts`: `GEN_MARKER` goes (nothing writes or reads it any more).
- `target.ts`: `hasGeneratedDefinitions` goes. `project-md.ts`: the two §E
  entries leave `tickAdapterInventory`.
- `paths.ts`: `SOCLE.workflow`. `socle-files.ts`: follows every add and
  removal. `main.ts`: `update`'s usage line says "refresh managed files"
  rather than "re-render".

### Tests (`test/`)

- Delete `test/render.test.ts` and `test/fixtures/render-golden/`. Its last
  test (no `to-lessons`, no invented limit) moves to `integrity.test.ts`
  unchanged. The retired-words criterion is checked by a grep at review, not
  by a committed test: `test/TESTS.md` rule 1 forbids pinning the socle's
  prose.
- `helpers.ts`: `splitFrontmatter` and `bodyAfterProvenance` go (render-only).
- `update.test.ts`: the refresh test uses `workflow.md` and a skill instead
  of a formula and two definitions; the retired-file tests use a retired
  `.agents/` page and a retired skill instead of a retired formula; the
  user's own definition in `.claude/agents/` still survives. **New test,
  the seam of this task:** "update: a 0.1.1 install is cleaned". It poses
  the 0.1.1 shape on an install (the five formulas, the six profiles, five
  definitions in `.claude/agents/` and five in `.codex/agents/` with the
  generated marker, all recorded in the manifest at their hash, manifest
  version `0.1.1`, plus a definition of the user's own), runs `update`, and
  checks: each one reported `removed:` and gone; `.agents/formulas`,
  `.agents/profiles` and `.codex` gone; `.claude/agents` holding only the
  user's file; the manifest naming none of them; `check` clean afterwards.
- `check.test.ts`: the drift-in-a-definition case becomes drift in
  `workflow.md`.
- `guards.test.ts`: expects `chisel-upgrade` in the refusal; "no formulas
  installed" becomes "no `workflow.md` installed".
- `init.test.ts`: the block assertion looks for `.agents/workflow.md`.
- `integrity.test.ts`: the waiver names `chisel-upgrade`; the retired layer
  grows the 0.1.x pointers (`.agents/formulas`, `.agents/profiles`), and
  only `chisel-upgrade` may name them; the definition directories leave the
  source roots.
- `test/fixtures/golden-tree.txt`: formulas, profiles, `.claude/agents`,
  `.codex` and `CHANGING-CASE.md` out; `workflow.md` and `chisel-upgrade`
  in; `upgrade-v2` out. Edited by hand, then compared by the suite.
- `test/fixtures/brownfield-v1/.agents/rules/task-*.md`: the two lines that
  say "formulas" and "Inspector" are reworded (the fixture only has to look
  like a first-version rule file).
- `test/TESTS.md`: the `render` group goes; `update`, `check`, `guards`,
  `integrity` descriptions follow.

### Repo pages

- `README.md`: what chisel is (one task, intent to commit and pull request,
  any tracker, no orchestration), the roles in a sentence each, setup's
  tracker question, the upgrade path (`chisel update` cleans a 0.1.1
  install; `chisel-upgrade` for the glue, the statuses and the first-version
  layout), and pinning a version (`deno x jsr:@lonestone/chisel@0.1.1 init`).
- `PHILOSOPHY.md`: §3 "Think and type" and "Humans own the gates" rewritten
  to the charter (the Typist is optional, the Architect reads the plan, the
  human owns the intent); §4's preset and beads paragraphs replaced by the
  prose workflow and "beads is one tracker among others"; the reference
  list names `workflow.md`. The field-validation line notes that the
  Crewmates typed their own work.
- This repo's `AGENTS.md`: the lifecycle line names the Architect and the
  Crewmate; "the Mason reused within a live thread" becomes the Crewmate;
  the Typist is named as optional.
- `project-management/CHANGELOG.md`: entry 37.

### Order of work, one commit each

1. **Add the workflow page.** `socle/agents/workflow.md`, its entry in
   `socle-files.ts`, `paths.ts`, `install.ts`, `manifest.ts`, the golden
   tree. Pure addition; the suite stays green.
2. **Point the socle at it.** `discipline.md`, `methodology.md`,
   `reference.md`, the three templates, the glue template, and the skills
   (`chisel-beads` with `CHANGING-CASE.md` deleted, `chisel-setup`, `retro`,
   `slice-task`, `upgrade-v2` renamed `chisel-upgrade`), with
   `socle-files.ts`, the golden tree, the two CLI messages, `guards.test.ts`
   and the integrity waiver following. The formulas and profiles still ship
   but nothing points at them except `chisel-upgrade`.
3. **Retire the formulas, the profiles and the renders.** Delete them and
   `render.ts`; the CLI and test changes above, the 0.1.1 cleanup test, the
   golden tree, `TESTS.md`.
4. **Say it in the repo's pages.** `README.md`, `PHILOSOPHY.md`, `AGENTS.md`,
   this repo's two templates.
5. **Record it.** Changelog entry 37; the worklog and checkboxes here.
6. **Review.** `code-review` from `cebb4fb`, fresh reviewers; fixes in their
   own commits; findings answered below; criteria ticked in the spec.

Each commit: `deno task test` and `deno task check` green before it lands;
`deno publish --dry-run --allow-dirty` at commits 3 and 5.

### Questions for the Architect

1. **Model tiers.** The charter does not retire them, and the Typist "worth
   it on a cheaper model" leans on them. I plan to keep them, compact, in
   `reference.md`, with `.agents/user.md.tpl` and the glue's §H unchanged.
   The other way is to drop the cascade, §H and `user.md.tpl` (more CLI and
   test churn). Recommended: keep.
2. **Where the documents live with another tracker.** I plan to say that
   the spec and work documents always live in the repo's task workspace,
   and that a Plane issue or a bead points at the spec document. The other
   way lets the spec live in the tracker item itself. Recommended: always in
   the repo — `code-review` and the archive read them there.
3. **A `stale:` line for the retired adapters.** After `update`, a 0.1.1
   glue still lists `.claude/agents` and `.codex/agents` in §E, ticked.
   `update` and `check` already report a retired glue subsection on a
   `stale:` line. I can extend that to the two §E lines (about 15 lines of
   code and two assertions), or leave the glue to `chisel-upgrade` alone.
   Recommended: extend it; it is the only hint a user gets without running
   the skill.
4. **"formula" in `writing-great-skills/GLOSSARY.md`.** One sentence of the
   vendored upstream text says "There is no formula for the right format".
   It is ordinary English, not the retired piece. Recommended: leave it and
   record it as a deliberate mention (editing it is drift against upstream).
   The other way is to reword it and note the adaptation.
5. **Who closes.** I plan to give the close to the Architect, which may hand
   the bookkeeping (archive, journal, criteria) to the live Crewmate. Say if
   you want the Crewmate to own the close instead.

## Worklog

- 2026-10-29 — Read the charter, the spec, the socle, the CLI and the tests;
  wrote this plan. No code yet.
- 2026-10-29 — Plan approved with two corrections (conditional spec step,
  the Crewmate closes). Commits, each with `deno task test` and
  `deno task check` green:
  - `4ae0df9` adds `workflow.md` (191 lines) and ships it.
  - `5050b35` points the socle at it: discipline 94,
    methodology 178, reference 69 lines (doctrine 532 in all); templates,
    managed block, glue §B · Tracker; `chisel-beads` 114 lines in one file;
    `chisel-upgrade` replaces `upgrade-v2`.
  - `9c1769c` retires the formulas, the profiles, `render.ts` and its tests;
    the 0.1.1 cleanup test; the `stale:` report for the two §E lines;
    `@std/toml` dropped from `deno.json` (only the render test used it).
    `deno publish --dry-run --allow-dirty` succeeds.
  - `7c0b49c` README, PHILOSOPHY, this repo's AGENTS.md and templates.
- Deviations from the plan: the integrity waiver also names `.agents/rules`
  (the directory, which `chisel-upgrade` names on its own); the user's own
  definition test now creates `.claude/agents` itself, since `init` no
  longer does; `chisel-setup` lost 92 lines rather than the 54 planned.
- Mutation check: putting `.codex/agents` back among the directories
  `update` keeps makes the 0.1.1 cleanup test fail.

## Implementation Checkboxes

- [x] 1. Workflow page added, shipped, in the golden tree
- [x] 2. Doctrine, templates, glue and skills point at it; `chisel-upgrade` replaces `upgrade-v2`
- [x] 3. Formulas, profiles and renders retired; 0.1.1 cleanup test green
- [x] 4. README, PHILOSOPHY, AGENTS.md, repo templates
- [x] 5. Changelog entry 37
- [ ] 6. Review run, findings answered, criteria ticked

## Notes & Snippets

- The 0.1.1 published tree (commit `9664484`) has the same formulas,
  profiles and render as `v2` today, so the cleanup test poses exactly that
  file list.
- The integrity test is why the order above matters: any `.agents/` pointer
  to a file that is not installed fails the suite, so the workflow page lands
  first and the retired files leave last.
- `bd` is installed (`/opt/homebrew/bin/bd`); its commands are checked
  before `chisel-beads` names them.

## Diff-Review Findings

_(after the review)_
