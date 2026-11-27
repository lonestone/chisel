# Working rules from the field: branches, commits, gates, docs and the retro — work

Created by the Mason at the plan step, 2026-11-27. Spec:
`project-management/tasks/20261122-0002-working-rules-from-the-field.spec.md`.

**Plan:** approved by the Architect, 2026-11-27, with the corrections below.

Corrections (Architect, 2026-11-27, on the six questions):

1. **Merge, don't rebase.** Bring `origin/main` in with `git merge
   origin/main`, after a fetch, each command alone; the same once `lead-ux`
   merges. No forced push in this task: the session that launched the
   Architect forbids it. The pull request is squash-merged, and commit-lint
   skips merge commits, so the merge commit does not last. This is about
   this task's branch only: rule 6 still ships as planned, rebase of one's
   own branch with `--force-with-lease` allowed (the Owner, 22/11, Q4).
2. **Chapters 1, 2, 4, 3:** accepted. Recorded in the spec's Notes.
3. **Rule 2 and the renumbering:** accepted. `retro` cites the rule by its
   title, "The repo is the only memory" in `.agents/discipline.md`, not by
   a number, in both places, the `x-upstream` `changes` line included. The
   writing rule asks to cite by file and title, and a number breaks at the
   next renumbering.
4. **The CONTRIBUTING template in the chisel-setup skill:** accepted. The
   spec's rule 7 now names that path, and its Notes record why.
5. **The E2E command stays in §J:** accepted.
6. **Reword the `captures.ts` comment, with an `automatic` intention:**
   accepted.

**Depth:** written at the close.

## Program Design

### The base this plan is written against

This branch forked from 0.4.0 (`c904524`). `origin/main` is now 0.5.0
(`6038b2f`). It already holds pull requests #7 (the runtime rules every brief
carries), #8 (the model named at launch) and #9 (`relecture-humaine`: step 8,
§J · Review, the one shot, `visual-proof`, `synthesis.md.tpl`). `lead-ux` is
not merged: its branch holds only its spec and work document. Its plan edits
step 2, "Where the work stops", "Sub-agents" and "After the close" of
`workflow.md`, and one row of discipline's side lanes.

So this plan targets `origin/main`, not the branch as it stands:

- **Merge first.** Before the Typist starts, `origin/main` is merged into
  the branch (Question 1, as corrected). Every file and section named below
  is the one on `origin/main`.
- **§J exists.** The new sections take the letters K, L and M, as the spec
  says.
- **Chapter 3 is blocked only by `lead-ux`** (#7 and #8 are merged). Its
  rules 10 (step 2) and 12 ("After the close") touch the paragraphs
  `lead-ux` edits.

### Commit order

There is one commit per rule, with the rule's intention in the same commit.
Chapters 1, 2 and 4 are typed now; chapter 3 waits for `lead-ux`, so the
pull request reads chapters 1, 2, 4, 3 (Question 2).

Every commit that changes `socle/agents/X` also writes `.agents/X`, byte for
byte, and adds its intention to `src/socle-files.ts` in sorted order. Each
intention lives at `socle/intentions/unreleased/<slug>.md`, with frontmatter
`id: unreleased/<slug>` and the nine sections of `socle/intentions/TEMPLATE.md`.
The intentions follow 0.5.0's style: `informational` for prose in a managed
file, `migration` when an agent must write into the project's own files.

Commit headers follow `CONTRIBUTING.md`, "Commits and pull request titles":
- scope `socle` for doctrine and templates;
- scope `skills` when the commit is mostly a skill;
- scope `tooling` for a test alone.

#### Chapter 1 — Ambient rules

1. **proof-before-cause** — `docs(socle): cite the proof before a cause`
   - `socle/agents/discipline.md` gets a new rule 2, **Proof before cause**,
     right after "Read before acting". Rules 2 to 10 become 3 to 11.
   - `socle/agents/skills/retro/SKILL.md` stops citing "rule 8" by number:
     both the body sentence and the `x-upstream` `changes` line cite the
     rule by its title, "The repo is the only memory" in
     `.agents/discipline.md` (correction 3). No `changes` entry is added:
     this keeps a chisel-made reference current, it does not change
     upstream behaviour.
   - The rule's text: before you give a cause to the human, or ask them to
     act, cite in one line the proof you read (the command and its message,
     the output, their words). Without a proof, write "not verified". When
     one read gives the proof, read first.
   - Intention `proof-before-cause`, `informational`.
   - Question 3 covers the renumbering.
2. **readme-presents-and-points** — `docs(socle): the readme presents the repo and points to the docs`
   - `discipline.md` gets a new rule 12, **Docs present and point**, after
     the writing rule. The README presents the repo and points to the docs.
     A feature adds a line and a link to it, never its reference doc, which
     goes in the living docs root of §D.
   - `socle/agents/skills/code-review/SKILL.md`, Standards axis (step 3 and
     the Standards sub-agent's prompt), gets a new criterion. A doc that
     existed before the diff and grows by more than the threshold is flagged
     as a judgement call, never a hard violation. The threshold is 10 %,
     with no floor in characters, unless §D sets another.
   - `x-upstream.changes` of `code-review` gets: "flags, as a judgement
     call, an existing doc the diff grows beyond a threshold (10 % unless
     §D of .agents/project.md sets another)".
   - `socle/agents/project.md.tpl`, §D, gets one optional line:
     `- **Docs growth flagged above:** 10 %`, and its comment says that
     `code-review` reads it. `.agents/project.md` (this repo) gets the same
     line.
   - Intention `readme-presents-and-points`, `informational`. A repo
     without the line keeps 10 %: the skill reads the line when it is there
     and falls back to 10 % otherwise, so `update` has nothing to write.
3. **agent-docs-say-what-and-why** — `docs(socle): a doc an agent writes says what and why`
   - `discipline.md`, rule 12, gets a second paragraph: a doc an agent writes
     is concise. It says what and why, the overall architecture and the
     delicate points, diagrams welcome, never a text version of the code.
   - `socle/agents/workflow.md`, step 7, where it promotes material into the
     living docs, points to rule 12 by its title. `lead-ux` does not touch
     step 7.
   - Intention `agent-docs-say-what-and-why`, `informational`.
4. **actions-carry-a-verb** — `docs(socle): a name that acts carries a verb`
   - `discipline.md`, the writing rule (rule 11 after the renumbering), gets
     one sentence: a command or a function that acts is named with a verb
     (`library retag-artists-from-tidal`, not `library artists`).
   - Intention `actions-carry-a-verb`, `informational`.

The commit with the no-harness-word test goes at the end of chapter 1 (see
"Test order").

#### Chapter 2 — The glue: branches, commits, commands

5. **a-branch-per-task** — `docs(socle): a branch per task, in a worktree by default`
   - `discipline.md` gets a new rule 13, **A branch per task**. Each task
     works on its own branch, named and based as §K · Branches says, in a
     worktree when §K says so. In a fresh worktree, install the dependencies
     first, before any other command. A dev stack started there picks free
     ports.
   - `project.md.tpl` gets a new section after §J:

     ```
     ## K · Branches

     <!-- Each task works on its own branch: named after the task's slug,
     cut from the freshly fetched main branch (from the parent's branch
     when stacked). The worktree line is the project's choice; the setup
     skill asks it. The agent removes the worktree once the branch is
     merged. Rule 13 of `.agents/discipline.md` reads this section. -->

     - **Branch:** the task's slug, from the freshly fetched main branch
     - **Worktree:** yes, in `.worktrees/<branch>`
     ```

     The header comment's "A–J" becomes "A–K".
   - `.agents/project.md` (this repo) gets §K, with "Worktree: yes, in
     `.worktrees/<branch>`", which is the habit already in use here.
   - `socle/agents/skills/chisel-setup/SKILL.md`:
     - step 1 notes an existing `.worktrees/` folder (or a team habit) as
       §K's answer;
     - step 2 walks A through K, and gets a new subsection "§K — ask this,
       verbatim", with the question of decision `branches-each-project-chooses`
       copied word for word from the spec. Branch name, base and cleanup are
       stated, not asked;
     - step 4 says "after §K" where it now says "after §J";
     - step 7 runs once §K is written;
     - step 8's summary goes up to K.

     Chapter 2's later commits move K to L, then to M.
   - Intention `glue-branches`, `migration`. It applies when `project.md`
     has no "K · Branches" heading. The gap: ask the setup skill's worktree
     question, then add §K at the end of the glue. Without an answer, write
     the template's default. Its Reference Paths: `.agents/project.md`
     **adapt**, `.agents/skills/chisel-setup/SKILL.md` **copy** (the
     question). The model is `0.5.0/review-section`.
6. **an-agent-rebases-only-its-own-branch** — `docs(socle): an agent rebases only its own branch`
   - `discipline.md`, rule 13, gets a second paragraph. The agent may
     rebase its own branch onto the main branch and push it with
     `--force-with-lease`. It never does this to a branch that is not its
     own: another session's, a parent pull request's branch that others
     build on, or the main branch. The forced push runs alone in its call,
     as the "Sub-agents" list of `workflow.md` says of every command that
     can erase. §K may forbid it.
   - `project.md.tpl` §K gets a third line:
     `- **Rebase own branch:** allowed (pushed with --force-with-lease)`,
     and its comment says a project may write `forbidden`. This repo's §K
     gets the same line.
   - `chisel-setup` step 2, at §K: when `git symbolic-ref
     refs/remotes/origin/HEAD` fails, the skill runs `git remote set-head
     origin -a` and says so in one line. This is stated, not asked, as the
     spec says.
   - Intention `origin-head-and-own-rebase`, `migration`. Two gaps:
     - `origin/HEAD` is missing → run `git remote set-head origin -a`;
     - §K has no "Rebase own branch" line → add it with `allowed`.

     Applies when either signal shows. A repo with no `origin` remote skips
     the first gap.
7. **the-commit-rule-is-in-the-glue** — `docs(socle): the commit rule lives in contributing.md`
   - A new file, `socle/agents/skills/chisel-setup/CONTRIBUTING.md.tpl`.
     The spec names `socle/templates/CONTRIBUTING.md.tpl`: this is a
     departure, see Question 4. The file is a `# Contributing` title and a
     single `## Commits` section, with placeholders:
     - the format;
     - the accepted types and scopes;
     - the scope for the task files;
     - the body's line length;
     - where the linter lives, when there is one.
   - `project.md.tpl` gets a new section:

     ```
     ## L · Commits

     <!-- Where the repo's commit rule is written: format, scopes, the scope
     for the task files, the body's line length. The rule lives there
     once; this section only points to it. The setup skill writes a
     CONTRIBUTING.md when the repo has none. -->

     - **Commit rule:** `CONTRIBUTING.md`, section "Commits"
     ```

     Header "A–L". This repo's §L reads `CONTRIBUTING.md`, section "Commits
     and pull request titles".
   - `chisel-setup`:
     - step 1 explores the commit linter (commitlint config, a commit-msg
       hook, a lint script) and, without one, reads `git log` to see the
       shape of recent headers. It also notes an existing `CONTRIBUTING.md`
       and whether it has a commit rule, and whether the rule lives in a
       docs page;
     - step 2 states §L's answer (a fact, not a question): which file, which
       section;
     - step 4's writes:
       - no `CONTRIBUTING.md` → copy the template, filled;
       - a `CONTRIBUTING.md` with no commit rule → add the Commits section
         only;
       - the rule lives elsewhere → write no file, and §L points there;
     - the walk, step 4, step 7 and step 8 go up to L.

     "The file is then the repo's own" goes into the chisel-setup text.
     `chisel-update`'s "What is never touched" gains `CONTRIBUTING.md`.
   - `socle/agents/workflow.md`, "The Mason brief" and "The Typist brief":
     "the commit rule" becomes "the commit rule, read where §L · Commits of
     `.agents/project.md` points". These two paragraphs are not in
     `lead-ux`'s list (it edits "Sub-agents", not the briefs), so this goes
     in chapter 2.
   - Intention `glue-commits`, `migration`. Gaps:
     - no "L · Commits" heading → add it, pointing where the rule lives;
     - no commit rule found anywhere → write `CONTRIBUTING.md` from the
       template, or add its Commits section, filled as the setup skill
       fills it.

     Reference Paths: `.agents/skills/chisel-setup/CONTRIBUTING.md.tpl`
     **adapt**.
8. **the-commands-are-in-agents-md** — `docs(socle): the project's commands are listed in agents.md`
   - `project.md.tpl` gets a new section:

     ```
     ## M · Other commands

     <!-- The commands an agent needs beyond the gates of §F — regenerate
     a generated client, create a migration, start and stop the dev stack
     — are listed in the repo's AGENTS.md, outside chisel's block, one
     per line. A command that is a real procedure becomes a skill of the
     project, and its line names that skill. This section only points to
     the list. -->

     - **Other commands:** `AGENTS.md`, section "Commands", outside chisel's block
     ```

     Header "A–M".
   - `chisel-setup`:
     - step 1 looks for commands as it looks for gates: package.json
       scripts, deno.json tasks, Makefile/justfile targets, docker compose,
       `scripts/`; whatever is not a gate is a candidate;
     - step 2 states §M and puts the candidate list to the user once, to
       confirm;
     - step 4 writes the list into `AGENTS.md`, outside the markers: under
       an existing commands heading when there is one, otherwise a new
       `## Commands` section right after `<!-- chisel:end -->`. One line per
       command: `` `<command>` — <what it does> ``;
     - step 7 (one voice) gets one sentence: the commands list is the
       project's own and stays out of the piles;
     - step 8's summary goes up to M.
   - This repo's `AGENTS.md` gets a `## Commands` section after the block:
     `deno task hooks`, `deno task commit-lint`, `deno task promote-intentions
     <version>`, `deno task release-check`, `scripts/task-id.sh <intention>`,
     `scripts/configure-github-repo.sh`. The gates stay in §F only.
   - This repo's `.agents/project.md` gets §M.
   - Intention `glue-commands`, `migration`. Gaps:
     - no "M · Other commands" heading → add it;
     - `AGENTS.md` has no commands list outside the markers → explore as the
       setup skill does, put the list to the human, write it after the
       block.

     It says that `update` never writes outside the markers, which is why
     this is a migration.
   - The end-to-end command is settled in Question 5.

#### Chapter 4 — The retro written down (typed before chapter 3)

14. **the-retro-is-written-down** — `docs(socle): the retro is written beside the spec`
    - `socle/agents/skills/retro/SKILL.md`, steps 4 and 5:
      - the proposals are written to a document beside the spec, named by
        replacing `.spec.md` with `.retro.md` (a slice's retro sits beside
        the slice), and also put in the close report;
      - a proposal whose target is chisel's socle (`.agents/`, its skills)
        names chisel's maintainers as its owner, because `update`
        overwrites a local edit there.

      `x-upstream.changes` gets: "writes its proposals to a retro document
      beside the spec and the work document; a proposal targeting the
      installed socle names chisel's maintainers as owner".
    - `workflow.md`, step 7: the `retro` skill writes the retro document,
      and the archive moves spec, work, synthesis and retro together.
      `lead-ux` does not edit step 7.
    - `socle/templates/000-template.spec.md`:
      - the `## Retrospective` section is removed from the template block;
      - "Retrospective" goes from the zone table row;
      - "· Retrospective" goes from the "Notes (written before the plan)"
        cell of "The two documents";
      - "Archive | spec + work together" in "Where each kind of content
        lives" names the retro too.

      `project-management/000-template.spec.md` is the same file and is
      copied.
    - `socle/agents/reference.md`:
      - the Task entry names the retro document among a task's documents;
      - the Spec document entry no longer carries a retrospective;
      - a new **Retro document** entry is added.

      I read the entries at typing time; on main they may name the
      synthesis already.
    - Intention `retro-is-written-down`, `informational`. Archived
      Retrospective sections stay as they are.

#### Chapter 3 — The workflow steps (blocked by `lead-ux`)

Merge `origin/main` once `lead-ux` merges, then type in this order:

9. **the-typist-sees-red-first** — `workflow.md`, "The Typist brief", one
   bullet: write the test, run it, see it fail, then write the code.
   Intention `typist-sees-red-first`, `informational`.
10. **small-feedback-is-one-pass** — `workflow.md`, step 2: the sizing
    check first asks "one pass?". A list of small feedback is one task, one
    pull request, one commit per item. A task is sized in agent time.
    `socle/agents/skills/slice-task/SKILL.md` gets one line: never slice a
    list of small feedback, plus its `x-upstream.changes` entry. Intention
    `small-feedback-is-one-pass`, `informational`.
11. **the-full-suite-runs-once** — `workflow.md`:
    - step 5: the fast checks at each change, the tests of what changed at
      each green step;
    - step 6: the full suite once, before the review.

    Intention `full-suite-runs-once`, `informational`.
12. **ci-is-read-by-its-verdict** — `workflow.md`, "After the close": a wait
    on CI reads only the final state and the failing jobs' logs. How to
    wait points to "Sub-agents". Intention `ci-read-by-its-verdict`,
    `informational`.
13. **a-deferral-has-a-home** — `workflow.md`:
    - "Blockers and questions": a "later" becomes a tracker task, `deferred`
      or `draft`, written by the role that defers;
    - step 7: check that no "later" is left orphaned in the Notes.

    Intention `deferral-has-a-home`, `informational`.
15. **skills-go-through-the-writing-guide** — `workflow.md`, step 5 and "The
    Typist brief": an agent that writes or edits a skill reads
    `.agents/skills/writing-great-skills/SKILL.md` and follows it before its
    commit. `code-review`, Standards axis: a skill the diff touches is
    checked against that guide. Its `x-upstream.changes` entry is added.
    Intention `skills-through-the-writing-guide`, `informational`.

### Test order

1. **Integrity first, at every commit.** Each new socle file is listed in
   `src/socle-files.ts`, so `integrity: the shipped socle list matches the
   socle tree` stays green. The new template in the chisel-setup folder is
   also added to `test/fixtures/golden-tree.txt`, at commit 7.
2. **Render test, written red before commit 5, extended at 6, 7 and 8.**
   The test goes in `test/init.test.ts`, on the model of "init: the review
   section and the synthesis template are installed". It runs `init` on
   the empty/boilerplate fixture, parses the glue with
   `parseGlue`/`glueSection`/`glueItem`, and checks parsed lines, never
   sentences:
   - §K has a `Worktree` item whose value starts with `yes`;
   - §K has a `Rebase own branch` item (added at commit 6);
   - §L's `Commit rule` names `CONTRIBUTING.md` (commit 7);
   - §M's `Other commands` names `AGENTS.md` (commit 8).

   Each part is seen red before its commit's template change.
3. **No-harness-word test, at the end of chapter 1.**
   `test/integrity.test.ts` gets "integrity: the installed socle names no
   private setup". It is a deny-list regex over every file of the installed
   `.agents/` tree, plus `socle/intentions/unreleased/` read from the repo:
   - `\bHarness\b` (case-sensitive: the generic lowercase "harness" in
     discipline and workflow is a legitimate word);
   - `crit-review`;
   - `secondmate`;
   - the names of our projects and agents.

   A mutant plants one word and is caught, as the first integrity test
   does. One existing hit must be cleared first (Question 6).
4. **Gates** after each commit: `deno task check`, `deno task test`. The full
   suite at the end, before `code-review` (the task's own rule 11).

Never `deno fmt` on markdown. `deno fmt --check` covers the `.ts` files only;
the markdown follows the repo's existing wrap by hand.

### Decisions the spec left to the implementation

- **Letters:** K · Branches, L · Commits, M · Other commands. §J is taken.
- **End-to-end command (Question 5):** §J · Review keeps it, on its
  `E2E command` line. `visual-proof` and step 8 already read it there, and a
  test checks the line. The `AGENTS.md` list does not repeat it. When a
  project has one, the list carries a pointer line ("end-to-end tests: the
  E2E command of §J · Review in `.agents/project.md`"). §M's comment says
  that the gates of §F and the commands of §J live there, not in the list.
- **CONTRIBUTING template's place:** inside the chisel-setup skill (Question 4).
- **Discipline numbering:** new rule 2, renumber, cite the rule by title in
  `retro` (Question 3). The other two new rules, docs and branches, go at
  the end (12, 13), so that only one renumbering happens.
- **Intentions:**
  - one per rule, so 15;
  - four of them are migrations: `glue-branches`,
    `origin-head-and-own-rebase`, `glue-commits`, `glue-commands`;
  - the rest are informational;
  - plus one possible `automatic` intention for the comment of Question 6.
- **Commands list format in `AGENTS.md`:** a `## Commands` heading after the
  block, one line per command, `` `cmd` — what it does ``.
- **Runtime tools** are named as examples only, as "Sub-agents" does.
- **Skill-writing guide:** this repo's `CONTRIBUTING.md` asks that content
  written for agents goes through `writing-for-agents`. The Typist and I
  read `.agents/skills/writing-great-skills/SKILL.md` before editing a skill.

### Plan report (sent to the Architect, 2026-11-27)

The plan, the commit order and the questions are in this document. Questions:

1. **Rebase.** `chisel-workflow` is forked from 0.4.0 and pushed at
   `5dd9f18`; `origin/main` is 0.5.0. Recommended: the Mason rebases it onto
   `origin/main` before the Typist starts, as a lone command. The Architect
   pushes it with `--force-with-lease` when it opens the pull request.
   Alternative: merge `origin/main`, which needs no forced push but leaves a
   merge commit in a one-commit-per-rule history.
2. **Chapter order.** Chapter 3 waits for `lead-ux`, while 4 can be typed
   now. Recommended: type 4 before 3, so the pull request reads 1, 2, 4, 3.
   Alternative: hold chapter 4 until chapter 3 is typed. This departs from
   the Deliverables line "in chapter order".
3. **Discipline numbering.** Recommended: proof-before-cause becomes rule 2,
   "beside Read before acting" as the spec says, and the rules after it are
   renumbered. The only references by number are retro's "rule 8" (twice),
   which are fixed in the same commit. Alternative: append it as rule 11,
   with no renumbering but not beside rule 1.
4. **CONTRIBUTING template's place (departure).** The spec names
   `socle/templates/CONTRIBUTING.md.tpl`. `init` does not install that
   folder, and the spec rules out any CLI change, so chisel-setup in an
   equipped repo could not read it. Recommended:
   `socle/agents/skills/chisel-setup/CONTRIBUTING.md.tpl`, which ships with
   the skill and is linked from its SKILL.md. Alternative: keep the spec's
   path and change `src/install.ts` to copy it, which is a CLI change.
5. **End-to-end command.** Recommended: §J's `E2E command` line keeps it,
   and the `AGENTS.md` list points there. Alternative: the list keeps it and
   §J points to the list. That would change `visual-proof`, step 8 and the
   §J test.
6. **One existing hit for the no-harness test.**
   `socle/agents/skills/visual-proof/scripts/captures.ts`, line 3, has a
   comment naming the Harness and an agent. It came in with 0.5.0.
   Recommended: reword it to a neutral origin in the commit that adds the
   test, with a one-line `automatic` intention. Alternative: scope the test
   to markdown and templates, which leaves the comment shipped.

## Worklog

- 2026-11-27 — Mason. Read the spec, the research on commands, and the socle
  on the branch and on `origin/main`. Found the branch two releases behind
  `origin/main`, so the plan targets `origin/main`. Wrote this plan. No code.
- 2026-11-27 — Mason. Plan approved with corrections (the `**Plan:**` line).
  Fetched and merged `origin/main` (0.5.0). Both gates green on the merged
  base: `deno task check` checked 35 files, `deno task test` 80 passed, 0
  failed, 1 ignored. The plan text follows the corrections (merge, retro
  cites the rule by title). Next: a Typist for chapters 1, 2 and 4.

## Implementation Checkboxes

- [x] Merge `origin/main` (Question 1, as corrected)
- [ ] 1 proof-before-cause
- [ ] 2 readme-presents-and-points (+ docs growth in code-review, §D line)
- [ ] 3 agent-docs-say-what-and-why
- [ ] 4 actions-carry-a-verb
- [ ] no-harness-word test (+ captures.ts comment, per Question 6)
- [ ] render test red for §K
- [ ] 5 a-branch-per-task
- [ ] 6 an-agent-rebases-only-its-own-branch
- [ ] 7 the-commit-rule-is-in-the-glue
- [ ] 8 the-commands-are-in-agents-md
- [ ] 14 the-retro-is-written-down
- [ ] Merge `origin/main` after `lead-ux` merges
- [ ] 9 the-typist-sees-red-first
- [ ] 10 small-feedback-is-one-pass
- [ ] 11 the-full-suite-runs-once
- [ ] 12 ci-is-read-by-its-verdict
- [ ] 13 a-deferral-has-a-home
- [ ] 15 skills-go-through-the-writing-guide
- [ ] Full suite, then `code-review`
- [ ] Close

## Notes & Snippets

- `lead-ux` (`origin/chisel-lead-ux`, `593287f`) has only task documents. Its
  plan lists the `workflow.md` paragraphs it edits: step 2, "Where the work
  stops", "Sub-agents", "After the close". Steps 5 and 7 and the two briefs
  are not on its list, which is why rules 3, 7 and 14 can touch them before
  it merges.
- The release-check gate only asks that a pull request changing `socle/` adds
  at least one unreleased intention. One per rule is the spec's own
  criterion `intention-per-change`.

## Diff-Review Findings

_Written at step 6._
