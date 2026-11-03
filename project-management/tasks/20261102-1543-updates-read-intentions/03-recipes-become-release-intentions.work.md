# 03 — The two recipes become release intentions — work

Created by the Crewmate at the plan step, 2026-11-03. Spec:
`project-management/tasks/20261102-1543-updates-read-intentions/03-recipes-become-release-intentions.spec.md`.

**Plan:** approved by Pierrick through promethee, 2026-11-03 (revised plan, commit 0824d3e). The release circuit becomes its own task, done right after this one.

## Program Design

### The intentions of 0.2.0 to 0.2.4

Each change a repo must act on becomes one file, written from the gaps of
`chisel-upgrade/from-0.1.x.md` and journal entries 35 to 45. They go in
the folder of the release that made the change, even though they ship
after it: the id names when the change happened, and that is what a
manifest's version is compared with.

| Id | Classification | What it carries (from the recipe or the journal) |
|---|---|---|
| `0.2.0/workflow-replaces-formulas` | migration | The prose workflow replaces formulas, presets, profiles and the rendered agent definitions (`.claude/agents`, `.codex/agents`). The orphan pass of `update` removes the managed files. The agent finds and rewrites the project's own words that still name the retired pieces, outside the managed files: AGENTS.md outside the markers, the glue, the README. |
| `0.2.0/one-tracker-section` | migration | Glue sections B1, B2 and B3 become one "B · Tracker". The adapter lines `.claude/agents`/`.codex/agents` are dropped. The project's answers are kept. |
| `0.2.0/seven-statuses` | migration | Thirteen statuses become seven, with the mapping table. Covers the open task files' status lines, beads `status.custom`, and `git rm .beads/formulas`. |
| `0.2.0/merge-and-publish-section` | migration | Glue section "I · Merge and publish" added, with its options asked of the human. |
| `0.2.0/journal-is-journal-md` | migration | `LOG.md` or `CHANGELOG.md` renamed `JOURNAL.md`, and the glue's §A follows. |
| `0.2.4/update-writes-only-what-it-installed` | informational | `update` writes templates and `task-id.sh` only if the last manifest listed them and they still exist. A repo that deleted them keeps them deleted. |
| `0.2.4/no-write-through-links` | informational | `init` and `update` no longer write through a symbolic link. A link on a written path stops them, and the update skill closes it with the human. |

I leave three changes without an intention, because no repo has anything
to do for them:

- 0.2.1 to 0.2.3 (README only);
- "the workflow names `domain-modeling` and the glossary/ADRs at close" (the
  files ship, and the copy is enough);
- `upgrade-v2` → `chisel-upgrade` (that skill is going away).

`unreleased/manifest-records-intentions` stays as it is (automatic).

### The baseline intention

It is `socle/intentions/baseline.md`, id `baseline`, classification
`migration`. It sits at the top of `intentions/`, beside TEMPLATE.md, and
not in a release folder. That keeps it out of `shippedIntentions()`, so it
is never pending for a repo with a manifest and never written by
`fullRecord`. `intentions.ts` exports `BASELINE: ShippedIntention`, and
`readIntention` reads it like the others (`parseIntention` checks its id).

**When it is staged.**

- `update` finds no manifest, or finds the first version's layer
  (`v1LayoutFound`).
- In that case the session lists **only** the baseline, not the release
  intentions.
- Why: a repo without a manifest has no release history to replay. The
  baseline takes it to the current layout whole, comparing against
  `reference/`, wherever its method lives. The release intentions describe
  moves from 0.1.x, which it never made.

**Its gaps, in order.** These come from `from-first-version.md`, made
layout-free.

1. The inventory, as facts: where the method lives.
2. Symbolic links where chisel writes.
3. The retired layer: `rules/task-*.md`, `workflows.md` and their callers.
4. The glue and the journal.
5. Statuses, with the mapping table.
6. **The human chooses which tree to keep:** the project's task tree, or
   the reference's `project-management/`. The tree not kept is not
   duplicated.

**How it closes.**

- The Record Result says: delete the workspace, then run
  `chisel init --arranged .`. That writes the manifest and records every
  shipped intention as applied (`fullRecord`).
- This is correct here. After the baseline, the repo *is* at the current
  layout, and no release intention was pending in its session. So the
  Architect's concern (init marking applied what is still pending) cannot
  happen: the pending list was only the baseline.
- With a manifest but the first version's layer still there, the session
  lists the baseline plus the pending release intentions. In that case the
  close is the usual one (`chisel update`), not `init`, because `init`
  would overwrite the record. The baseline's Record Result says both.

🧑 This replaces the note's "for instance" (a baseline that records only
up to the version reached). I see no version to record for a repo chisel
did not install. **To approve.**

### Maintaining intentions, after the Lonestone boilerplate

Revised 2026-11-03 at Pierrick's request: copy what
`lonestone-boilerplate` does. I read these files in that repo:

- `.boilerstone/docs/release-maintainer-runbook.md`;
- the `boilerstone-intention` and `boilerstone-release` skills;
- the workflows `intention-gate`, `intention-promote` and
  `release-please`;
- `release-please-config.json`.

**What this slice takes:**

- **One intention per PR, in `unreleased/`, written in the same PR as the
  change.** The file is named `slug.md`, with no `NN-` prefix, and its id
  is `unreleased/slug`. This is already the convention in TEMPLATE.md.
  Chisel gains a `CONTRIBUTING.md` whose "Intention authoring" section is
  the canon, copied from the runbook's:
  - fill the nine sections, with Why required;
  - keep the change narrow;
  - a PR that needs no intention (refactor, chisel-internal test or doc)
    says so in its description; there is no label until there is CI.
- **Promotion at the release, by a command.** `deno task
  promote-intentions <version>` runs `scripts/promote-intentions.ts`, the
  equivalent of `pnpm boilerplate intentions promote --to X.Y.Z`:
  - `git mv unreleased/<slug>.md <version>/NN-<slug>.md`, numbering after
    the files already in the folder, and rewrites the `id`;
  - it refuses when the version is not the one in `deno.json`, or when
    `unreleased/` is empty;
  - it is tested on a temporary copy of `socle/intentions/`.

  It lives in `scripts/`, not in the CLI: a repo equipped with chisel
  never promotes anything.
- **A repo that recorded an `unreleased/` id is not asked again.**
  `resolves()` already does this, and a test pins it if none does yet.
- **`.agents/project.md` §I**, this repo's glue: before publishing, run
  `deno task promote-intentions <version>`, then the gates.

**What this slice leaves, for a separate task: the release circuit
itself.** That is:

- release-please (Release PR, version bump, generated CHANGELOG, tag);
- the CI gates (`intention-gate` with the `no-intention` label,
  `intention-promote` on the Release PR);
- the release note;
- JSR publishing from CI (OIDC / trusted publisher);
- a `chisel-release` skill for the maintainer;
- the guard that stands in for `intention-promote`: refusing a publish
  while `unreleased/` is not empty. It needs a published version to
  compare against, and this repo has no git tag (checked 2026-11-03), so
  it goes with the circuit that will create the tags.

Why it is out of this slice:

- Chisel has no CI today (no `.github/`) and publishes by hand with `deno
  publish`. The circuit is GitHub infrastructure.
- It involves decisions that belong to Pierrick: secrets, a JSR trusted
  publisher, labels, branch protection.
- It is a release concern, not the conversion of the recipes this slice
  is for.

I propose the task "Chisel releases through a Release PR, after the
boilerplate".

### The Crewmate cleans up after itself

Added 2026-11-03 at Pierrick's request.

- **`socle/agents/workflow.md`, step 7 (Close — Crewmate):** before the
  report, the Crewmate stops everything it started — Docker containers,
  dev servers, background processes, each by its own identifier (container
  name or id, PID) — and only those. It never stops by pattern
  (`pkill -f`, `--all`), because that kills the work of others.
- **Its intention:** `unreleased/crewmate-cleans-up`, classification
  `informational`.
  - `workflow.md` is a managed file, so the copy is enough.
  - The update reads the change out to the human, so a team that changed
    its practice knows about it.
  - It is the first intention written by the new rule: one per change, in
    the same commit.

### `chisel-upgrade` goes, and its content moves

- **Deleted:** `socle/agents/skills/chisel-upgrade/` (three files), its
  three entries in `socle-files.ts`, and its lines in the golden tree.
  `update` removes the installed copy as an orphan.
- **`update.ts`.** `UPGRADE_INTENTION` disappears.
  - The no-manifest and first-version reasons name `baseline`.
  - The links reason names step 3 of the update skill.
  - `pending` becomes `[BASELINE]` when there is no manifest, and
    `[BASELINE, ...pending]` when the first-version layer is found with a
    manifest.
- **`install.ts`.**
  - `upgradeRecipePointer()` is deleted.
  - The links refusal of `init` says what to do itself: replace each link
    by its target's content, or remove it, then run `init` again. Nothing
    was written.
  - The journal warning says that an update session renames it, through
    the intention `0.2.0/journal-is-journal-md`.
- **`workspace.ts`:** `UPGRADE_SKILL` is deleted.
- **`chisel-update` SKILL.md** takes over what the router said and the
  intentions do not:
  - step 3 handles links (show, replace by the target's content or remove,
    on the human's yes);
  - step 4 records an intention a repo already applied by hand, found in
    its journal (id-by-rivoli's case): the gaps' signals are absent, so
    the agent proposes **apply**, checks the signals, and records it;
  - the close says "for whoever works here next" in three lines.
  - "What is never touched" is already there.
- **`project.md.tpl` §A, the README and the setup skill:** the pointers
  are rewritten to name the update session.
- **`integrity.test.ts`:** the five "BY DESIGN chisel-upgrade" waivers go.
  The retired-layer check is reversed: **nobody** in the installed socle
  names the retired layer any more, because the intentions are not
  installed. Only `.agents/user.md` stays waived.

### Tests (red first)

1. **replay-0.1.1** (`test/intentions.test.ts`). The fixture is a
   `chisel init` tree with a manifest rewritten to `version: "0.1.1"`, no
   `intentions` field, `.agents/formulas/` and `.agents/profiles/` present,
   and a glue with a "B1 · Where task statuses live" heading.
   - `update` exits 3.
   - The checklist of `session.md` lists exactly the ids of `0.2.0/*`,
     `0.2.4/*` and `unreleased/*`, in that order. That is computed from
     `shippedIntentions()` filtered on release > 0.1.1, and also written
     out literally once, so that a missing file fails.
2. **baseline.** `update` on a repo without a manifest stages only
   `baseline`. The first-version layer with a manifest stages baseline
   plus the pending ones.
3. **The intentions parse.** Every shipped intention, and the baseline,
   parses (id = path, known classification). They also carry the nine
   sections of the template.
4. **A recorded `unreleased/` id** counts for the promoted one. That
   already exists (`resolves`): I'll check it is tested, and add the test
   if not.
5. **Updated:** guards (the no-manifest and links reasons' texts), init
   (the links refusal's stderr), integrity (waivers), the golden tree.

### Order of the work

1. The red tests for replay, baseline staging and parsing.
2. The seven 0.2.x intentions and `baseline.md`, plus `socle-files.ts`.
3. `update.ts`, `intentions.ts` and `workspace.ts` (staging the baseline).
   Green, commit.
4. Remove `chisel-upgrade` and its pointers (`install.ts`, templates,
   README, skills, integrity, golden tree). Green, commit.
5. The update skill takes over. The dogfood gets `chisel update .`.
   Commit.
6. Code review, then the close.

## Worklog

**2026-11-03.**

- Wrote the red tests: the replay of a 0.1.1 install, the baseline's
  staging, and parsing with the nine sections.
- Wrote the five 0.2.0 intentions, the two 0.2.4 ones and `baseline.md`.
- `update` lists `[baseline]` without a manifest, and the baseline first
  when the first version's layer sits beside a manifest. The reasons name
  `baseline`, and step 3 of the update skill for links.
- Two older tests assumed every shipped intention was unreleased: the test
  of a manifest written before intentions now expects only the releases
  after its version, and the guards expect the new reasons.
- The journal intention's Validation no longer cites a warning that
  `check` does not print.

## Implementation Checkboxes

- [x] Red tests: replay-0.1.1, baseline staging, intentions parse
- [x] Seven 0.2.x intentions + baseline.md + socle-files
- [x] update/intentions/workspace stage the baseline — green, commit
- [x] chisel-upgrade removed with every pointer — green, commit
- [ ] chisel-update skill takes over the router; dogfood refreshed — commit
- [ ] CONTRIBUTING.md (authoring), promote-intentions script + test, §I line — commit
- [ ] workflow.md close: the Crewmate cleans up, with unreleased/crewmate-cleans-up — commit
- [ ] code-review, findings recorded
- [ ] Close: retro, journal, archive

## Notes & Snippets

## Diff-Review Findings
