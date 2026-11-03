# The Crewmate becomes the Mason, and the Typist ticks only what really ran — work

Created by the Crewmate at the plan step, 2026-11-03. Spec:
`project-management/tasks/20261103-2338-crewmate-becomes-mason.spec.md`.

**Plan:** approved by the Architect, 2026-11-03 23:55. Rulings: (1) PHILOSOPHY.md reads "eleven planning sub-agents"; (2) gap 3 stays, each rename on the human's word; (3) add the informational intention `typist-ticks-what-ran` in the Typist commit.

## Program Design

### The files to touch

The inventory is `git grep -il crewmate` minus the history the spec keeps.
Each socle file and its `.agents/` copy get the same edit, so
`diff -r .agents socle/agents` stays at its three known differences.

| File (socle source, then its copy) | Occurrences |
|---|---|
| `socle/agents/workflow.md`, `.agents/workflow.md` | 20 lines: roles table, steps 3 to 7 headings and bodies, "Where the work stops", "Statuses", "Sub-agents", "The Crewmate brief" heading and lead, "The Typist brief" lead |
| `socle/agents/methodology.md`, `.agents/methodology.md` | 3 |
| `socle/agents/reference.md`, `.agents/reference.md` | 4 (work document entry, roles line, zones line, model tiers table) |
| `socle/agents/skills/chisel-beads/SKILL.md`, `.agents/skills/…` | 1: `--actor <architect\|mason\|typist>` |
| `socle/agents/skills/retro/SKILL.md`, `.agents/skills/…` | 1 |
| `socle/agents/skills/slice-task/SKILL.md`, `.agents/skills/…` | 2 |
| `socle/templates/000-template.spec.md`, `project-management/000-template.spec.md` | 4 |
| `socle/templates/000-template.work.md`, `project-management/000-template.work.md` | 7, including the heading "When Creating a Work Document (the Mason)" |
| `socle/templates/AGENTS-block.md`, `AGENTS.md` | 2 in the block; `AGENTS.md` has a third, the G16 line |
| `CHARTER.md` | 6 |
| `README.md` | 9 |
| `PHILOSOPHY.md` | 5 |
| `src/socle-files.ts` | add `intentions/unreleased/crewmate-becomes-mason.md`; the 0.3.0 file name stays |
| new `socle/intentions/unreleased/crewmate-becomes-mason.md` | the intention |

Left as is, per "Not Included": `CHANGELOG.md`, `project-management/archive/`,
`JOURNAL.md`, `review-360-decisions.md`, `socle/intentions/0.2.0/` and
`0.3.0/`, their entries in `src/socle-files.ts`, and the id
`unreleased/crewmate-cleans-up` in `.agents/.chisel.json`. No test, fixture
or `.agents/project.md` names the role. `git grep -iw crew` outside history
finds only the spec.

### Sentences that need more than a word swap

The article and rhythm read the same with "Mason" ("a Mason", "the
Mason's", "Masons") in every line but these two, whose exact new text is
settled:

- **`PHILOSOPHY.md`, the field-validation paragraph.** Replace
  "eleven Crewmates each wrote a plan," with
  "eleven planning sub-agents each wrote a plan," (Architect's ruling 1:
  a past run, so no old word and no anachronistic "Masons").
- **`AGENTS.md`, the G16 line.** Replace
  "G16: reviewers fresh, the Crewmate reused within a live thread." with
  "G16: reviewers fresh, the Mason (named the Crewmate in the record)
  reused within a live thread." The ruling, in the decisions record, keeps
  its word; the parenthesis lets a reader following the citation find it.
  This one occurrence of "Crewmate" stays, on purpose.

Everything else is the swap, in every file of the table: `Crewmate` →
`Mason`, `Crewmates` → `Masons`, `Crewmate's` → `Mason's`, `crewmate` (the
beads actor) → `mason`. Re-wrap a paragraph only if a line passes 80
columns; markdown tables stay one row per line. No gloss on the name's
origin in `workflow.md`: the reason belongs to the intention's Why and the
journal.

### The Typist line

In "The Typist brief" of `socle/agents/workflow.md` and its copy
`.agents/workflow.md`, a fifth bullet after the one that ends "reported,
not guessed.":

```markdown
- tick a box only for what really ran, on the real target; a dry run, or
  a run on a copy or a test base, is written in the worklog and leaves
  its box open.
```

Step 5 keeps "Tick the work document's checkboxes as work lands" unchanged.

### The rename intention, exact text

`socle/intentions/unreleased/crewmate-becomes-mason.md`, listed in
`src/socle-files.ts` after `"intentions/0.3.0/03-typist-by-default.md",`
as `"intentions/unreleased/crewmate-becomes-mason.md",`. Gap 3 reaches
into what `chisel-update` lists as "never touched"; the intention names it
explicitly and puts each rename behind the human's word (Architect's
ruling 2).

````markdown
---
id: unreleased/crewmate-becomes-mason
classification: migration
---

# The Crewmate becomes the Mason

## Goal

The project's own files call the sub-agent the Architect launches to plan,
have a Typist code, review and close a task the **Mason**, as the managed
files of chisel now do.

## Why

In the Harness that runs chisel's projects, "crewmate" names the per-task
session that plays chisel's Architect. Chisel used the same word for the
sub-agent that Architect launches, and one word for two roles made a plan
reading get skipped. The Owner renamed the role: Architect, Mason, Typist.
A repo whose own files still say "Crewmate" while `.agents/workflow.md`
says "Mason" hands its agents a role the workflow no longer defines.

## Applies When

- `git grep -il crewmate` lists a file outside the managed files and
  outside the project's history: its archive, its journal, its changelog.

## Do Not Apply When

- None beyond the human's decision.

## Observable Gaps

1. **The glue.** Signal: `.agents/project.md` names the Crewmate. Rename
   it in the prose; the project's answers stay as they are.
   Done when: `git grep -i crewmate -- .agents/project.md` finds nothing.
2. **Open task documents.** Signal: an open spec or work document, in the
   tasks directory the task workspace section of the glue names, names the
   Crewmate. Rename the role.
   Done when: no open task document names the Crewmate.
3. **The project's own instructions and skills.** Signal: `AGENTS.md`
   outside the chisel markers, `CLAUDE.md`, or a skill chisel does not ship
   names the Crewmate. These are the project's own files: show the human
   each occurrence and rename it on their word. A "crewmate" that names
   something else, such as a harness's own session, stays.
   Done when: every occurrence is renamed, or kept on the human's word.

## Out of Scope

- The archive, the journal and the changelog: history keeps its words.
- Past tracker events that carry the `crewmate` actor; new ones carry
  `mason`.
- The intention ids recorded in `.agents/.chisel.json`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/skills/chisel-beads/SKILL.md` — **copy**, by the update.

## Validation

- `git grep -il crewmate` lists only the managed files the closing update
  will replace, the project's history, and the files where the human kept
  an occurrence.
- `git diff --stat` on the archive is empty.

## Record Result

`chisel record unreleased/crewmate-becomes-mason --applied`, or
`--skipped "<reason>"` after the human's word.
````

### The tick-rule intention, exact text

`socle/intentions/unreleased/typist-ticks-what-ran.md`, listed in
`src/socle-files.ts` right after the rename intention's line, as
`"intentions/unreleased/typist-ticks-what-ran.md",` (Architect's ruling 3;
it ships in commit 2, with its change).

````markdown
---
id: unreleased/typist-ticks-what-ran
classification: informational
---

# The Typist ticks only what really ran

## Goal

The human knows that "The Typist brief" of `.agents/workflow.md` now says
a box is ticked only for what really ran, on the real target, and that a
dry run or a run on a copy is written in the worklog with its box left
open.

## Why

A project equipped with chisel saw a Typist tick "run the script for real"
after running it only on a throw-away test base. The work document's
checkboxes are where a fresh session resumes, so a false tick skips a step
without anyone seeing it.

## Applies When

- The repo is updated from a version whose "The Typist brief" in
  `.agents/workflow.md` carries no tick rule.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: a Typist ticks a box only for what really ran,
   on the real target; a dry run or a run on a copy goes in the worklog
   and leaves its box open. A team whose own briefs say otherwise
   reconciles them.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
````

### Commit order

Commit with explicit paths, conventional commits, each message ending with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. No push.

1. `feat(socle): the crewmate becomes the mason` — every rename, the rename
   intention and its `src/socle-files.ts` line, plus the spec (status
   change) and this work document. Gates green before it.
2. `feat(socle): the typist ticks only what really ran` — the bullet in
   both `workflow.md`, the tick-rule intention and its
   `src/socle-files.ts` line, plus this work document. Gates green before it.
3. At the close: `docs(tasks): close the crewmate-becomes-mason task` —
   spec ticked, both task documents archived, the journal entry.

Typist tier: *cheap* — every change is named down to its file and its
text.

## Worklog

- 2026-11-03 — Plan written; stopped for the Architect's reading.
- 2026-11-03 — Plan approved with three rulings; the exact texts of the
  two rewrites and both intentions written above so the Typist types
  without choosing.
- 2026-11-03 — Typist, commit 1: rename applied across the planned files;
  PHILOSOPHY.md paragraph re-wrapped for the longer sentence; `diff -r
  .agents socle/agents` shows only the four known differences; templates
  identical to their copies; `deno task check` and `deno task test` green
  (76 tests). Nothing in the plan went unanswered.
- 2026-11-03 — Typist, commit 2: the Typist bullet added to both
  `workflow.md` files; tick-rule intention added and listed in
  `src/socle-files.ts`; gates green again (76 tests).
- 2026-11-03 — Mason: criteria greps and `diff -r` run, all as expected
  (the one `AGENTS.md` occurrence is the approved gloss). `code-review`
  run on `origin/main...HEAD`; the fixes below typed by the Mason itself,
  under the retouch exception (a few lines in three files); gates green.
- 2026-11-03 — Mason, close: spec criteria ticked, status `done`; nothing
  to promote (the living docs, glossary and ADR paths the glue names do
  not exist in this repo); the Owner's ruling recorded as Addendum 19 of
  the decisions record; journal entry 51; both documents archived. Nothing
  started that needs stopping: no container, server or background process.

## Implementation Checkboxes

- [x] The rename in the socle (`socle/agents/`, `socle/templates/`)
- [x] The same edits in the copies (`.agents/`, `project-management/` templates, `AGENTS.md`)
- [x] The rename in `CHARTER.md`, `README.md`, `PHILOSOPHY.md`, with the two rewrites
- [x] The rename intention and its `src/socle-files.ts` line
- [x] Gates green, commit 1
- [x] The Typist line, the tick-rule intention and its `src/socle-files.ts` line
- [x] Gates green, commit 2
- [x] Criteria greps and the `diff -r` run
- [x] `code-review`, findings recorded
- [x] Close: criteria ticked, documents archived, journal entry, retro, commit 3

## Notes & Snippets

- Precedent: the 0.3.0 change "typist by default" (commit `12ec6d2`) touched
  the same socle files, their copies, `CHARTER.md`, `README.md`,
  `PHILOSOPHY.md`, and added one intention.
- `.agents/.chisel.json` holds managed-file hashes; `12ec6d2` changed
  `.agents/workflow.md` without refreshing them, and this plan follows that
  precedent.

## Questions for the Architect (answered on the Plan line)

1. **`PHILOSOPHY.md`'s past run.** "eleven Crewmates each wrote a plan"
   tells history in a living doc. Options: rewrite to "eleven planning
   sub-agents" (recommended: no old word, no anachronism); swap to "eleven
   Masons"; keep it as history. The first two pass criterion
   no-crewmate-outside-history; the third fails it.
2. **The intention touches the project's own skills and instructions**,
   which `chisel-update` "never touches". Options: keep gap 3, explicit and
   human-validated per occurrence (recommended, as the spec asks); or drop
   the skills and say so in Out of Scope.
3. **The tick rule has no intention of its own.** The intention gate is
   satisfied by the rename's intention, but a repo's human would not hear of
   the new rule. Options: a second, `informational` intention
   `typist-ticks-what-ran`, like `0.3.0/crewmate-cleans-up`, in commit 2
   (recommended); a paragraph in the rename intention (two changes in one
   intention); or nothing, the managed copy carries it silently.

## Diff-Review Findings

Run 2026-11-03 on `origin/main...HEAD`, two fresh reviewers.

**Standards axis**

- *The rename intention's Out of Scope lists the archive*, already on
  `chisel-update`'s "What is never touched" list (`TEMPLATE.md`, "Its
  sections"). Fixed: only the journal and the changelog remain.
- *"Harness" capitalised and undefined in the rename intention's Why.*
  Fixed: "the harness that runs chisel's own projects", lower case, as
  `CHARTER.md` writes it. The commit body of the rename keeps the word;
  history is not rewritten.
- *The tick-rule intention says a team reconciles its briefs, while Out of
  Scope excludes the project's own instructions.* Answered and sharpened:
  the human reconciles, not the update agent; the gap now reads
  "reconciles them itself", the pattern of `0.3.0/typist-by-default`.
- *The tick rule lives only in the Typist brief; a Mason typing a retouch
  never reads it.* Answered: the spec's Implementation Decisions place it
  there and keep step 5 unrepeated. Worth a later look if a Mason's retouch
  ever ticks falsely.
- *The new bullet followed one ending with "."* Fixed: the previous
  bullet now ends with ";", the list reads as one.
- *Shotgun Surgery: the role table lives in `CHARTER.md` and
  `workflow.md`.* Answered: pre-existing, and the charter is the Owner's
  page; out of this task's scope.
- *`PHILOSOPHY.md` drops the role name where `AGENTS.md` maps it.*
  Answered: Architect's ruling 1, a past run told without the old word.

**Spec axis**

- All six criteria re-run and passing; `AGENTS.md`'s kept "Crewmate" is the
  approved gloss pointing at the decisions record. Answered: the
  criterion is ticked with that exception named.
- *The second intention is beyond the spec's one.* Answered: Architect's
  ruling 3.
- *Out of Scope lists the archive.* Fixed, as above.
- *Gap 3 conflicts with `chisel-update`'s "never touched" without saying
  so.* Fixed: the gap now says it names those files on purpose, each
  rename on the human's word.
- *Validation misses the manifest, which carries `crewmate` ids.* Fixed:
  `.agents/.chisel.json` is named in the check.
- *Punctuation of the new bullet.* Fixed, as above.
