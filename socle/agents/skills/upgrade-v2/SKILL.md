---
name: upgrade-v2
description: Migrate a repo equipped with chisel v1 to v2 — retire the three rules and the visual guide, install the discipline core, the formulas and the profiles, rename the journal to LOG.md, and fill the glue's new sections. One step at a time, the human validating each one; task files and archive are never touched.
disable-model-invocation: true
---

# Upgrade to v2

A repo equipped with chisel v1 carries a normative layer that v2 retired: three
rule files (`.agents/rules/task-*.md`) and a visual guide
(`.agents/workflows.md`).
v2 replaces them with an ambient discipline core, three workflow presets and
three role profiles, and it renames the narrative journal. `chisel update`
REFUSES such a repo by design — updating it would leave two normative
discourses side by side, and `chisel check` would report neither. This skill is
the way through, and it is the only one.

It is a migration, not a command: **you move one thing at a time and the human
validates each move**. Nothing here is batched, and nothing is done to a repo
whose owner is not in the conversation.

Run it from the repo being migrated.

## What is never touched

Say this out loud at the start, and hold to it:

- **Task files and the archive.** Every file under the task workspace declared
  in §A of the project's glue keeps its bytes — content, status lines,
  checkboxes, all of it. The only file in that workspace this migration edits is
  the journal, and it edits its NAME, not its content.
- **The project's own glue values.** §A's paths, the reading list, the gate
  commands: they were answered once, they stay answered. This migration ADDS
  the sections v1 had no equivalent for, and changes exactly one existing
  value — the journal's name.
- **Anything outside `.agents/`, the glue and the journal's filename.** Source
  code, documentation, CI, git history: out of scope. If the migration seems to
  need one of them, stop and say so.

## Step 0 — Preconditions

1. **Confirm this really is a v1 repo.** It is, if `.agents/rules/task-*.md`
   or `.agents/workflows.md` exists. If neither does, this repo is already on
   v2: stop, say so, and run `npx @lonestone/chisel update` instead.
2. **Require a clean working tree.** `git status --porcelain` must be empty.
   The migration's whole safety net is that the human can read one diff and
   revert it in one command; unrelated changes mixed into it destroy that.
   If the tree is dirty, stop and ask for it to be committed or stashed.
3. **Say what is about to happen**, in three lines: the retired layer goes, the
   v2 layer is installed, the journal is renamed. Then wait. A migration nobody
   agreed to is not a migration.

## Step 1 — Inventory, stated as facts

Gather all of this before saying anything, then state it as findings — do not
narrate the scan:

- which of the retired files are present (`.agents/rules/task-*.md`, and
  anything else under that directory; `.agents/workflows.md`);
- what §A of `.agents/project.md` declares: the task workspace, and above all
  the journal's current path and name;
- how many files live in the task workspace and in the archive (the number you
  will check again at the end);
- which sections the glue already has, and which of §B1, §B2 and §H are
  missing — a v1 glue has none of them;
- whether `.agents/user.md` exists (the personal, never-committed file).

Present it as a short table, then move on. Facts are stated; only genuine
decisions are asked.

## Step 2 — Retire the v1 layer

List the exact files you are about to delete — the ones Step 1 actually found,
not the ones this page names — and wait for the human's yes. With both present:

```
git rm .agents/rules/task-*.md .agents/workflows.md
```

Remove only what exists: one of the two may be missing, and a command naming an
absent path removes nothing at all. Anything git does not track goes with a
plain `rm`.

**The rules directory itself must not survive**, whatever is inside it —
`chisel update` refuses a repo that still has one, and it does not look at the
contents. So if it holds anything beyond the retired three — a rule someone
added locally — that file is the project's, not the toolkit's: name it
separately, and ask where it should MOVE to (a project instruction outside the
managed block of `AGENTS.md` is the usual home). Never delete it silently, and
never leave it where it is: leaving it there locks the repo out of `update`
with no way back in.

Do not touch `AGENTS.md` by hand here. Its managed block still routes to the
files you just removed, and Step 4 rewrites it.

## Step 3 — Rename the journal

v2's default name for the narrative journal is `LOG.md`. v1 called it
`CHANGELOG.md`, which collides with the file most repos already use for their
releases — two different documents under one name.

1. Rename the file §A declares, keeping its history:

   ```
   git mv project-management/CHANGELOG.md project-management/LOG.md
   ```

   Use the path from the inventory, not this example, if the project keeps its
   workspace elsewhere.

2. Update §A of `.agents/project.md` so the journal line names the new file.
   That line is the ONE place the path is declared: every step and every skill
   that writes to the journal resolves through it.

3. Do not touch the file's CONTENT. The journal is written by hand — one dated
   entry per task, added at the end of the work. It is never generated: not
   from a coordination database's audit trail, not from the git history. The
   entries already in it are the project's memory, and reformatting them would
   be rewriting someone's notes.

If §A declares a journal that does not exist — some v1 repos never kept one —
there is nothing to rename: say so, point §A at `LOG.md`, and let Step 4's
installer create the empty one. Never write entries for work you did not watch
happen.

Architecture decision records are a separate artifact and this step does not
touch them.

## Step 4 — Install the v2 layer

```
npx @lonestone/chisel init .
```

`init` is the right command here, and it is not guarded against a v1 layout on
purpose — it is what poses the v2 files. It:

- installs `.agents/discipline.md` (the ambient core), `.agents/formulas/`
  (the presets), `.agents/profiles/` (the role contracts) and the
  per-tool definitions rendered from them in `.claude/agents/` and
  `.codex/agents/`;
- installs `.agents/user.md.tpl`, the template each dev copies to their own
  `.agents/user.md` — it never creates the personal file itself;
- rewrites the managed block of `AGENTS.md`, which is how the v1 router that
  pointed at Step 2's files disappears;
- leaves `.agents/project.md` exactly as it is. The glue is the project's file;
  `init` writes it once, on a repo that had none.

Two things to check right after, before moving on:

- If the installer warns that a skill in `.agents/skills/` was not installed by
  chisel, that is another tool's file and it is being left alone. Nothing to do.
- If this repo's task workspace is NOT `project-management/`, the installer has
  just created one there anyway — it does not read the glue's paths yet. One
  file in it actually matters: delete `project-management/LOG.md`, which is a
  seeded journal with a header and a dated entry, not an empty file. Leaving it
  is the two-journal outcome this migration exists to prevent. The empty
  `tasks/` and `archive/` directories are harmless (git does not track them),
  and `project-management/000-task-file-template.md` stays where the installer
  put it — it is a managed file and `chisel check` expects it at that path.
  Say what you deleted.

## Step 5 — Complete the glue

v1's glue has no equivalent of §B1 (where task statuses live), §B2 (the link to
an external tracker) or §H (the team's model tiers). Fill them by asking, **one
question per message**, and ask only what the existing glue does not already
answer — this is a migration, not a fresh setup.

The wording of those questions is not this skill's to invent: it is written,
verbatim and in plain language, in `.agents/skills/chisel-setup/SKILL.md`. Use
its §B1, §B2 and §H screens as they stand, and its Step 4 rule for writing
the answers back — one section's span at a time, every byte outside it left
untouched. If the v1 glue's shape differs enough that a section has no home yet,
add the missing heading in letter order and nothing else.

The defaults are the same as for a new repo, and for a repo being migrated they
are almost always the right answer: statuses in the task files, no external
tracker, model tiers unset. A migration that changes how the team works, on top
of moving their files, is two changes wearing one diff.

Two more items from `chisel-setup` belong here, and it describes both:

- the personal file — copy the template to `.agents/user.md` for the dev
  running this, and make sure git ignores it (never overwrite an existing one);
- §E, the adapter inventory. On a fresh repo `init` writes it and ticks it; on
  a migrated one it does neither, because it only writes a glue it created —
  so the section has to be added here, with each adapter ticked from what is
  actually in place. `chisel check` in Step 6 is what confirms the ticks are
  true.

## Step 6 — Verify

Run, and show the results:

1. `npx @lonestone/chisel check` — it must be clean. A `DIVERGED` line here
   means a managed file was hand-edited; a `MISSING` line means Step 4 did not
   finish.
2. `git status --porcelain` — the changed paths must be the ones this migration
   touched, and nothing else.
3. `git diff --stat` on the task workspace — the journal's rename, and NOTHING
   else. A single changed line in a task file or in the archive is a failed
   migration, not a detail: revert it.
4. `npx @lonestone/chisel update` — it must be accepted. This is the real
   definition of "migrated": the command that refused this repo at the start
   now runs. If it still refuses, something the guard looks for survived
   Step 2, and the message says what.
5. Grep the repo for readers of the retired layer. Anything still pointing at
   `.agents/rules/task-*.md` or `.agents/workflows.md` — a project instruction
   outside the managed block, a README, a CI job — is a pointer into thin air
   now. List them for the human; fixing them is a decision, not a cleanup.

## Step 7 — Hand over

1. Show the human the full diff and let them read it. Their reading of it is
   the validation gate of the whole migration — everything before it was
   preparation.
2. Once they accept it, add one dated entry to the journal — its new name —
   saying the repo moved to v2, what was retired, and what is now in place.
3. Commit it as one commit, so the migration can be reverted as one commit.

Then say what changed for whoever works here next, in three lines: the ambient
core applies to every session; real scoped work follows the default preset in
`.agents/formulas/`; the journal is now `LOG.md` and is still written by hand.
