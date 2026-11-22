# 01 — Human review with crit — work

Created by the Mason at the plan step, 2026-11-22. Spec:
`project-management/tasks/20261119-1644-relecture-humaine/01-human-review-with-crit.spec.md`.

**Plan:** approved by the Architect, 2026-11-22, with these rulings on the
Mason's questions: (1) the template lives at `.agents/synthesis.md.tpl`;
(2) yes, add `**Review depth:** full | strategic` to the spec template and
a sentence in step 2 (parent decision 13 already makes it a line of the
spec); (3) yes, the chisel-setup §J question is in this slice; (4) a repo
without crit: the step says where to get it and stops for the human;
(5) always read `baseRefName` and pass `--base-branch`. One correction:
the synthesis is written on the **frontier** tier, not « never the light
tier » — Pierrick's « pas Sonnet » excludes the mid tier too (decision 25).

## Program Design

### Files touched

| File | Change |
|---|---|
| `socle/agents/synthesis.md.tpl` (new) | The synthesis template. |
| `src/paths.ts` | `SOCLE.synthesisTemplate = "socle/agents/synthesis.md.tpl"`. |
| `src/install.ts` | One `COPIED_FILES` entry: `[SOCLE.synthesisTemplate, ".agents/synthesis.md.tpl"]`, beside the `user.md.tpl` entry. |
| `src/socle-files.ts` | The template and the two intentions, sorted. |
| `test/fixtures/golden-tree.txt` | `.agents/synthesis.md.tpl` added. |
| `test/init.test.ts` | One case: §J and its depth line are in the generated `project.md`, and the template is installed. |
| `socle/agents/workflow.md` and `.agents/workflow.md` | Step 7 writes the synthesis; new step 8; one new row in the stops table; "After the close" amended. Both copies byte-identical. |
| `socle/agents/project.md.tpl` | New `## J · Review` section; header comment says A–J. |
| `.agents/project.md` | The same §J, filled for this repo (`full`). |
| `socle/agents/skills/chisel-setup/SKILL.md` and `.agents/skills/chisel-setup/SKILL.md` | A §J question; "A through I" becomes "A through J". |
| `socle/intentions/unreleased/human-review-step.md` (new) | Informational intention. |
| `socle/intentions/unreleased/review-section.md` (new) | Migration intention: add §J to an existing `project.md`. |
| `test/TESTS.md` | The `init` row names §J and the synthesis template (one clause). |

| `socle/templates/000-template.spec.md` and `project-management/000-template.spec.md` | A `**Review depth:** full \| strategic` line in the header (ruling 2). |

Untouched: crit itself, `reference.md`.

### Where the synthesis template lives

`socle/agents/synthesis.md.tpl`, installed as `.agents/synthesis.md.tpl`.
Same mechanism as `user.md.tpl`. Why not `project-management/` beside the
spec and work templates: `update` writes a file outside `.agents/` only when
the last manifest already listed it. A new template there would reach fresh
installs and never existing ones. The template is a trial and will change;
under `.agents/` every `update` refreshes it, `check` sees drift, and the
integrity test checks the step's pointer to it.

### The template's shape

The template has a short header comment (who writes it, when, for whom,
one article page at most, never one sentence, critical decisions only),
then four headings:

1. **What changed and why**: two or three paragraphs of prose.
2. **Critical decisions**: each with its reason and the alternative left
   aside.
3. **Data schema, before → after**: a before/after pair, or "No schema
   change." on one line.
4. **Architecture change**: the large change, or "None." on one line.

No proofs and no file-by-file account. Those are the two other readings.

### The synthesis file

- **Where it lives:** beside the spec of what the PR delivers, named by
  replacing `.spec.md` with `.synthesis.md`. For a sliced task that is the
  slice.
- **Who writes it:** the Mason, at step 7 (close), before archiving, on
  the frontier tier (decision 25: not the mid tier either). The step says
  « frontier tier » in those words.
- **What happens to it:** it is archived with the spec and work documents
  and committed in the PR.

### How the crit story opens on it

The synthesis is part of the PR diff, so crit needs no change. Step 8 tells
the Architect what to do when writing the story with `crit story --guide`
and the project's guide:

- the first chapter holds only the synthesis file's hunk;
- the prologue says to read it first and that the review may stop there.

The proofs (slice 04) come next, then the code chapters.

### How step 8 reads the PR base

1. `gh pr view <n> --json number,baseRefName` gives the base. Never assume
   `main`.
2. The story is prepared and ingested with `--pr <n> --base-branch <base>`.
3. The wait is `crit --pr <n> --base-branch <base>`, run in the background.
4. Without a forge PR (no remote), the step reviews the branch diff with
   `--base-branch <base>`, where the base is the branch the work was cut
   from.

### Step 8 text: what it must say (workflow.md)

The heading is `### 8. Human review — Architect`, placed after "After the
close — Architect", in the same register as the other steps. In order:

- **Entry:** the PR is open and the synthesis is committed in it.
- **The three readings, in order:**
  - strategic: the synthesis. What it carries, one page at most. The human
    may stop there with comments, and the review goes no further.
  - proofs: what the floor demands. Slice 04 fills this in.
  - reading guide: the crit story on the PR diff.
- **Depth:**
  - the spec's depth line, falling back to §J's default;
  - `strategic` = the synthesis plus the proofs the floor demands;
  - `full` = down to the guide.
- **Base:** the base comes from the PR (see above).
- **Waiting:**
  - the agent waits for the human and answers every comment;
  - no question goes into crit; questions go to the human in conversation;
  - an expired wait re-runs the same crit command (or `crit --session <id>`)
    and waits again. It is not a blocker; only another failure is.
- **Missing crit:** if `crit` is not installed, the step names where to get
  it (https://crit.md, then `crit install <agent>`) and stops for the human
  (ruling 4).
- **Exit:** the human approves, or comments are answered and addressed;
  merging still follows `.agents/project.md`'s merge and publish section.

Room for later slices:

- slice 03 adds the one-shot sentence to this step;
- slice 04 fills in the proofs reading and adds commands to §J.

Neither needs a restructuring: each reading is its own short paragraph.

### Other workflow.md edits

- **Step 7 (close):**
  - the Mason writes the synthesis from `.agents/synthesis.md.tpl`, on the
    frontier tier;
  - the archiving sentence moves the synthesis with the spec and work
    documents.
- **"After the close":** the merge waits for step 8.
- **"Where the work stops" table:** one row: the Architect, at the human
  review, waiting for the human's reading.
- **Statuses table:** unchanged. `done` is left by step 7; the review is
  of a PR, not a status.

### §J · Review (project.md.tpl and .agents/project.md)

The section is a comment, then the depth line:

```markdown
## J · Review

<!-- How far down the human goes at the human review (workflow step 8):
`strategic` stops at the synthesis and the proofs the floor demands;
`full` goes down to the reading guide. A spec's own depth line wins. -->

- **Default depth:** full
```

Slice 04 appends its commands and the proofs location under it. It is parsed
by `src/glue.ts` like any lettered section; nothing in `src/` reads it yet.

### The spec's depth line (ruling 2)

- Spec template (socle and this repo's copy, kept identical): under
  `**Status:** draft` in the template block, add
  the line `**Review depth:** full`. After the template's "## Statuses"
  section, add a short "## Review depth" section: the value is `full` or
  `strategic`; it says how far down the human goes at the human review
  (step 8 of [workflow.md](/.agents/workflow.md)); omitted, the review
  section of `.agents/project.md` gives the default.
- workflow.md step 2: one sentence: the spec carries the review depth
  line, `full` or `strategic`, when the task departs from §J's default.
- The diff stays a floor (parent decision 13): `strategic` never skips the
  proofs the floor demands.

### chisel-setup

- Walking A–J: one verbatim question for §J ("full or strategic,
  recommended full") in the same style as the §I question.
- Step 7 and the summary wording go from A–I to A–J.

### Intentions

- `unreleased/human-review-step`: informational (`copy`).
  - The workflow gains step 8.
  - crit is needed on the machine that runs it.
  - The synthesis template arrives by copy.
  - Reference Paths: `workflow.md` and `synthesis.md.tpl` (copy).
- `unreleased/review-section`: migration.
  - Add §J with a depth to the repo's `project.md`.
  - Modelled on `0.2.0/04-merge-and-publish-section.md`: `.agents/project.md`
    adapt, `chisel-setup/SKILL.md` copy.

Each has the nine sections in order (the integrity test enforces it).

### Tests and their order

Tests check behaviour only. TESTS.md says no test pins prose, so ACs about
what the step says are verified at review, not committed.

1. **Template ships:**
   - write the `init` test first (red: no `.agents/synthesis.md.tpl`, no §J);
   - add the template, the `SOCLE` key, the `COPIED_FILES` entry, the
     socle-files line and the golden tree line;
   - the template half of the test turns green, and the integrity listing
     test passes.
2. **§J:**
   - add §J to `project.md.tpl`: the test turns fully green;
   - add §J to this repo's `.agents/project.md`.
3. **workflow.md:** step 7, step 8, the stops row and "After the close" in
   `socle/`, then copied to `.agents/`. The integrity pointer test checks
   `.agents/synthesis.md.tpl`.
4. **Depth line:** the spec template line (both copies) and the step 2
   sentence (both workflow copies).
5. **chisel-setup:** the §J question and the A–J wording, mirrored.
6. **Intentions:** the two files and their socle-files lines. The intention
   parse test is green and `deno task release-check gate origin/main`
   passes. `human-review-step` also names the spec template's new line.
7. **Gates:** `deno task check`, `deno task test`; TESTS.md row.

A commit at each green step.

## Worklog

- 2026-11-22: plan written. Read the slice spec, the parent spec, workflow.md,
  project.md.tpl, chisel-setup, install.ts, paths.ts, manifest.ts,
  socle-files.ts, the integrity tests, TESTS.md and the crit story CLI.
- 2026-11-22: plan revised after the Architect's rulings: frontier tier for
  the synthesis, the spec depth line, crit's source (https://crit.md).

## Implementation Checkboxes

- [ ] `init` test for the template and §J (red)
- [ ] Synthesis template, `SOCLE` key, `COPIED_FILES` entry, socle-files, golden tree
- [ ] §J in `project.md.tpl` (test green) and in `.agents/project.md`
- [ ] workflow.md: step 7, step 8, stops row, "After the close"; mirrored to `.agents/`
- [ ] Spec template depth line (both copies) and the step 2 sentence
- [ ] chisel-setup: §J question, A–J wording; mirrored
- [ ] Intentions `human-review-step` and `review-section`, listed
- [ ] TESTS.md `init` row
- [ ] `deno task check`, `deno task test`, intention gate green

## Notes & Snippets

- `updateWrites` (src/install.ts) writes a file outside `.agents/` only if it
  is in `previous.managed` and still exists. That is why the template is
  not under `project-management/`.
- crit (main-ced1f6b):
  - review: `crit --pr <n>`, `--base-branch`, `--scope layer|full-stack`
    (default layer for a PR), `--session <id>` to reconnect;
  - story: `crit story --guide`, `--prep <path>`, `--story-file <json>`;
  - waiting: run `crit` in the background until Finish Review; on a timeout,
    re-run.
- project.md.tpl's header comment still says "sections A–H" although I
  exists; fixed to A–J in passing.

## Diff-Review Findings
