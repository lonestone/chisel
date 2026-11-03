---
id: baseline
classification: migration
---

# The baseline: a repo chisel did not install, or its first version

## Goal

The repo keeps its method in one tree, its doctrine and skills in
`.agents/`, no symbolic link on a path chisel writes, and no layer of the
first version. After this, `chisel init --arranged .` writes the manifest,
and every later update reads only the intentions of releases still to come.

## Why

A repo without a manifest (`.agents/.chisel.json`) has no release history
for chisel to replay. Its method predates the CLI or was copied by hand,
and it lives where the project chose: doctrine in `doc/agents/`, a task
workspace outside `project-management/`, skills linked into
`.agents/skills/` from elsewhere. No script can tell which of those files
are chisel's and which are the project's. The release intentions describe
moves from one chisel version to the next, which this repo never made. So
the baseline takes it to the current layout whole, comparing each piece
with `reference/`, wherever that piece lives today.

The first version also had another method: three rule files and a visual
guide, six status words, and a journal called `CHANGELOG.md`, a name that
collides with a release changelog.

## Applies When

- `.agents/.chisel.json` does not exist, whatever else the repo has; or
- the first version's rule files (`task-*.md` in a `rules/` directory) or
  its visual guide (`workflows.md`) exist where `AGENTS.md`, `CLAUDE.md` or
  `.agents/` lead.

## Do Not Apply When

- The human has decided, after reading this intention, not to adopt chisel
  in this repo. Delete `.chisel-workspace/` and write nothing else.

## Observable Gaps

Close them in this order. `chisel init` refuses links, so the links are
gone before the close runs it.

1. **The inventory.** Signal: none yet; this gap is facts. Find every piece
   of the method through the pointers in `AGENTS.md` and `CLAUDE.md`, the
   task workspace section of `.agents/project.md` when a glue exists, and
   the symbolic links under `.agents/`; never by assuming a path. State to
   the human, as facts: where the doctrine and skills are, where the task
   workspace is (tasks, archive, journal, task templates), whether it
   exists in more than one place, and which pieces are first-version ones.
   Done when: the human has read the inventory, and every later gap works
   from it.

2. **Links where chisel writes.** Signal: a symbolic link on a path
   `reference/` has (`AGENTS.md`, `CLAUDE.md`, a file or directory under
   `.agents/`, `.agents` and `.agents/skills` included,
   `scripts/task-id.sh`, the two templates under `project-management/`),
   or on a directory above one. List them with `ls -l AGENTS.md CLAUDE.md`
   and `find .agents scripts project-management -type l`. Two cases are
   common:
   - **A linked `AGENTS.md` or `CLAUDE.md`**, often one pointing at the
     other. Show both contents; the human chooses what each file holds.
     Replace each link by a real file holding that content
     (`cp "$(readlink AGENTS.md)" AGENTS.md.new && mv AGENTS.md.new
     AGENTS.md`). The file a link pointed at keeps its own content.
   - **A linked skill of a name chisel ships**, such as
     `.agents/skills/tdd` pointing into `doc/agents/skills/tdd`. Show the
     diff between the link's destination and
     `reference/.agents/skills/<name>/`; the human chooses which content
     stays. Remove the link (`git rm`): the close poses chisel's version.
     An edit the human keeps moves to a skill of the project's own, under
     a name chisel does not ship, or to the project's instructions outside
     the chisel markers of `AGENTS.md`. The destination copy goes or stays
     by the human's word; it is never edited.

   A skill chisel does not ship stays linked: chisel never writes it.
   Done when: no path `reference/` has, and no directory above one, is a
   symbolic link.

3. **The retired layer.** Signal: rule files `task-*.md` in a `rules/`
   directory and a `workflows.md` beside them, wherever the inventory found
   the method. List the exact files, wait for the yes, then `git rm` only
   what exists. A rule someone added locally is the project's: name it,
   and ask where it moves (usually a project instruction outside the
   chisel markers of `AGENTS.md`).
   Done when: no rule file and no visual guide remains, and a search for
   their names finds no pointer at them outside the archive.

4. **The glue and the journal.** Signal: no `.agents/project.md`, a path in
   its task workspace section that does not exist, or a journal still
   called `CHANGELOG.md` or `LOG.md`. Write the glue from
   `reference/.agents/project.md`, the project's answers kept. Rename the
   journal to `JOURNAL.md` in its directory with `git mv`, its content
   untouched, and rewrite the Journal line. Then complete the glue with
   `.agents/skills/chisel-setup/SKILL.md` (under `reference/` until the
   close poses it): its tracker, model tiers and merge and publish
   questions, one per message, and its "One voice in `AGENTS.md`" step for
   the project's text that still describes the old method. If the repo has
   its own `scripts/task-id.sh`, compare it with
   `reference/scripts/task-id.sh`: the close overwrites it, so a script
   that does more is renamed first, with the human's yes.
   Done when: the glue exists, its questions are answered, and there is
   one journal.

5. **The statuses.** Signal: an open task file whose status line holds one
   of the first version's six words, often after a coloured circle. Show
   the human the list old → new first, then edit by the table below, the
   free text after the word kept.
   Done when: every open task carries one of the seven statuses of
   `reference/.agents/workflow.md` ("Statuses").

   | Old | New |
   |---|---|
   | Not Started | `draft` or `ready`, by the real state of the spec — `blocked` when a named dependency holds it, `in-progress` for a parent whose slices are partly done |
   | In Progress | `in-progress` |
   | Blocked | `blocked` |
   | Complete / Done / Delivered | `done` |
   | Deferred | `deferred` |
   | Cancelled | `cancelled` |

6. **Which tree to keep.** Signal: the inventory found the task workspace
   in more than one place, or somewhere other than `project-management/`.
   **The human chooses which tree to keep:** the project's own (such as
   `doc/project-management/`) or `project-management/` as `reference/`
   has it. Move what goes into the kept tree with `git mv`, content
   untouched; the tree not kept is not duplicated. Point the task
   workspace section of the glue at the kept tree: tasks, archive,
   journal, roadmap, the two templates, the task id script. Chisel's
   doctrine and skills always live in `.agents/`: the CLI writes nowhere
   else.
   Done when: one task workspace remains, the human named it, and every
   path the task workspace section names exists.

## Out of Scope

- The archive, and the content of open task files beyond their status
  line.
- A skill chisel does not ship, linked or not, and the project's own
  doctrine pages that are not the first version's rules.
- Source code, CI, dependencies, lockfiles and git history.
- Pushing or publishing anything.

## Reference Paths

- `.agents/discipline.md`, `.agents/methodology.md`,
  `.agents/workflow.md`, `.agents/reference.md`, `.agents/skills/` —
  **copy** (the close poses them); an edit the project keeps moves to a
  skill of its own name.
- `.agents/project.md` — **adapt**: the project's answers win, the
  template's sections and labels stay.
- `AGENTS.md` — **adapt**: the managed block is chisel's, everything
  outside it is the project's.
- `project-management/000-template.spec.md` and
  `project-management/000-template.work.md` — **copy**, into the kept
  tree.
- `scripts/task-id.sh` — **copy**, unless the project's own does more: it
  is then kept under another name.

## Validation

- `chisel check` is clean.
- `chisel update` exits 0 with no `removed:`, `orphaned:` or `stale:` line
  left to act on, and `git status` shows no tree the human did not keep.
- `find .agents -type l` lists only skills chisel does not ship.
- `git diff --stat` on the archive is empty. A changed archived file is a
  failed migration: revert it.
- A search of the repo's own text for `rules/task-`, `workflows.md` and the
  old journal name: what is left is listed for the human.

## Record Result

The baseline is not recorded by `chisel record`: the command that closes
the session records it.

- **No manifest.** Delete `.chisel-workspace/`, then run
  `chisel init --arranged .`. It poses the socle, writes the manifest and
  records every shipped intention as applied: after the baseline the repo
  is at the current layout. When the kept tree is not
  `project-management/`, move the two templates `init` seeded into it,
  remove only what `init` seeded in `project-management/`, then run
  `chisel update`: it stops tracking the templates it no longer finds
  there and never recreates them.
- **A manifest, with the first version's layer beside it.** The session
  also lists the pending release intentions: apply them after the
  baseline, then close with `chisel update` as usual. Never `init` here:
  it would overwrite the record.

The journal entry names the tree kept and each link replaced.
