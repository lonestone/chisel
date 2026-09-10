# Changing case — chisel-beads

The three one-time operations around the chisel-beads convention: **entering**
it (task files → a committed database), **converting** the open task files
this repo already has once you are in, and **leaving** it. Read
[SKILL.md](SKILL.md) first — this page is about the transition, not the
day-to-day routine it describes.

## Entering: task files → database

**Preconditions**, checked before anything below runs:

- **`bd` is present, at the version `chisel-setup`'s coordination question
  names.** That question normally already checked this. If you arrived here
  another way, run `bd --version` yourself and stop if it is older — go back to
  that question rather than improvising an install; this page does not repeat
  the version number, so as not to have two places that can go stale against
  each other.
- **The working tree is clean** (`git status --porcelain` prints nothing).
  `bd init` makes a commit of its own as part of setting itself up, and
  anything STAGED at that moment is swallowed into it (verified on bd 1.2.2:
  unstaged and untracked work survives, staged work does not). A clean tree is
  the simplest rule that covers it. Commit or stash what is in progress first;
  this whole procedure is safe to re-run once the tree is clean.
- **`.agents/` exists.** This is a repo chisel has already equipped; this
  procedure configures it, it does not bootstrap one from nothing.

**The sequence**, run from the repo root, one command at a time — watch each
output rather than typing the whole thing blind:

1. **Create the database, neutral from the start.**

   ```sh
   bd init --prefix <short-lowercase-id> --skip-agents --skip-hooks
   ```

   The prefix is what issue IDs carry; without it, bd uses the repo's
   directory name. The two flags make bd install its database and nothing
   else — verified on bd 1.2.2: `AGENTS.md` and `CLAUDE.md` untouched byte
   for byte, no `SessionStart` hook, no vendored `beads` skill under
   `.agents/skills/`, no Codex recipe, no git hooks. bd still makes one
   commit of its own, but a minimal one — its `.beads/` files plus a
   `.gitignore` addendum, under its own honest message. Leave that commit
   alone.

2. **Verify the neutrality — read it back, do not assert it.** The flags are
   upstream behavior and a future bd may not keep their contract. Check:
   no `BEGIN BEADS` marker in `AGENTS.md` or `CLAUDE.md`; no `SessionStart`
   entry in `.claude/settings.json` (the file may simply not exist); no
   vendored `beads` directory under `.agents/skills/`. If any of these IS
   present, remove it
   the way the fallback below describes, and report that the flags did not
   hold — that is a finding about the bd version in use.

   <details>
   <summary>Fallback — removing what the flags should have prevented</summary>

   `bd setup claude --remove` and `bd setup codex --remove` remove, between
   them: the `SessionStart` hook and the beads section of `CLAUDE.md`; the
   vendored `beads` skill, the Codex native hooks and the Codex section of
   `AGENTS.md`. Neither strips the Claude integration block from `AGENTS.md`:
   delete every `<!-- BEGIN BEADS ... -->` … `<!-- END BEADS ... -->` pair by
   hand, with the trailing blank lines the removed block leaves — and only
   those. If a removal command reports a problem, read what it says and fix
   that by hand rather than working around it. Stage what this fallback
   touched by exact path (`git add -- AGENTS.md CLAUDE.md .claude .codex
   .agents` — only the paths that actually changed, **never `git add -A`**)
   and fold it into the commit of step 4.

   </details>

3. **Link the formulas, once.** If `.beads/formulas` does not exist yet:

   ```sh
   ln -s ../.agents/formulas .beads/formulas
   ```

   If it already exists AND is that exact symlink, there is nothing to do. If
   it exists as a real directory instead, leave it alone and report it —
   never replace it: that directory is not this procedure's to overwrite, and
   a copy would be a second place `chisel update` cannot see and `chisel check`
   could never watch.

4. **Stage exactly what this procedure touched, never the repo root** —
   normally just the symlink:

   ```sh
   git add -- .beads/formulas
   ```

   **Never `git add -A` here**: a session elsewhere in this repo may have
   unrelated work in flight, and it is not this procedure's to stage. One
   commit, with a message that says what happened:

   ```
   chore: coordination database under the chisel-beads convention

   Created the committed status database with bd's own instructions
   skipped at init: this repo's one normative discourse on the subject is
   .agents/skills/chisel-beads/SKILL.md. Linked the formulas into the
   database directory.
   ```

**Confirm what is now true — read it back, do not assert it:** the repo's own
`chisel check` reports clean, and `bd ready` answers (even if the answer is
"nothing ready" — the point is that it answers at all, proving the CLI still
works with none of the tool's own instructions in place). Only then write
§B1 · Where task statuses live of `.agents/project.md`: the verdict line
becomes the database case, the
**State** line becomes `- [x] initialised`, and the section names
[SKILL.md](SKILL.md) as the convention — every later session resolves through
that pointer, so it is not optional.

## Converting: existing open task files → beads

Only once Entering has run (`.beads/` exists). Moves the coordination state of
this repo's OPEN task files into the database — closed work is untouched,
because a database full of finished beads answers no question anyone asks.

Three passes, in this order, because each needs the previous one finished. The
tasks directory is the one `.agents/project.md` §A names — never a hardcoded
path.

**Pass 1 — one bead per open task file.** List every `*.md` file under the
tasks directory (skip the archive — it is never opened by this procedure).
For each file, read its `**Status:**` line:

- No status line, or the status is already `tracked as \`<id>\`` (a bead from
  an earlier run of this pass) → leave it alone. The second case is what makes
  this pass safe to re-run: it neither duplicates a bead nor orphans one.
- 🟢 Complete or ⚫ Cancelled → leave it alone; closed work keeps its history in
  its file.
- 🔴 🟠 🟡 ⚪ (anything still open) → create its bead:

  ```sh
  bd create "<the file's first # heading, or its filename if it has none>" \
    --type task --spec-id "<the file, from the repo root>" --actor architect --silent
  ```

  If the status was 🟡 (in progress), hand that fact over too — it must not
  come back as untouched work:

  ```sh
  bd update <the id just created> --status in_progress --actor architect
  ```

  Priority is left at the default: the task files carry none to carry over,
  and inventing one here would be this procedure deciding something no human
  wrote down. Keep your own running note of which file produced which id — you
  will need it for the next two passes.

**Pass 2 — the blocking edges.** For every file this run made a bead for, read
its `**Blocked by:**` line. `None`/`none`/absent → nothing to do. Otherwise,
split it on commas/semicolons into tokens (a token is usually a slice number
like `04`, sometimes a filename): for each token, resolve it against the files
Pass 1 converted — first a sibling file in the same directory whose name
starts with `<token>-`, then anywhere in the tasks tree a file named exactly
`<token>`, `<token>.md`, or starting with `<token>-`. When a token resolves to
one of those files, wire the edge:

```sh
bd dep add <this file's bead> --blocked-by <the blocker's bead>
```

Never `--deps blocks:` for this — that phrasing means the inverse relationship.
When a token does NOT resolve — because it is prose from a parenthetical
(`04, 08 (both delivered)`), or because it names a file this run correctly
left alone — do not guess at an edge: leave it unwired and note it in the
diff you are about to show the human. The `**Blocked by:**` line itself is
never edited: it stays as the spec's own declaration; what moves into the
database is the machine-readable edge built from it.

**Pass 3 — hand the status over.** For every file Pass 1 converted, rewrite its
`**Status:**` line to name the bead:

```
**Status:** tracked as `<id>` — `bd show <id>`
```

This is now the one and only place that file's status lives.

**Nothing here commits itself.** Read the diff (`git diff`) before anything is
staged, then commit it with the human, staging exactly the task files that
changed — never `git add -A`.

## Leaving

Nothing here is unrecoverable, and that is by construction: the task files
hold every word of content, which is exactly what `--spec-id` and the empty
fields buy. What lives only in the database is the coordination layer —
statuses, claims, edges, priorities.

1. **Export it while you still can.** `bd export` writes every issue, with its
   dependencies and comments, as JSONL. Commit that file.
2. **Put the statuses back in the files.** Each record carries its `spec_id`
   and its `status`: for each open bead, restore the `**Status:**` line of the
   file it names (🔴 not started / 🟡 in progress / 🟠 blocked / 🟢 done). This
   is the reverse of the Converting section above, and the JSONL is the list to
   work from.
3. **Restore the blocking edges** — the files' `**Blocked by:**` lines were
   never removed by Converting, so in most repos there is nothing to do here;
   check the export for an edge that was added in the database and never
   written back.
4. **Flip the glue.** `.agents/project.md` §B1 goes back to "statuses in the
   task files", and `.beads/` (with the `.beads/formulas` symlink inside it) is
   deleted.
5. **Say so in the journal** declared in §A, with the date and the reason.

The repo you end up with is the repo you had before the database existed,
minus nothing.
