---
name: chisel-setup
description: Fill in .agents/project.md — the per-repo glue — after `chisel init`. Explores the repo, prefills sections A-H, presents each one at a time for confirmation, and writes accepted sections back surgically. Also poses the current dev's personal .agents/user.md. Re-runnable later to revisit any section.
disable-model-invocation: true
---

# Chisel setup

Turn `.agents/project.md`'s defaults into this repo's actual glue, and pose
the current dev's personal file. One pass, sections A through H, each confirmed
before the next. Re-running later to revisit a single section is normal — treat
the current file as the starting recommendation, not as done-forever.

## How to talk to the user here

Everything the user is shown is quoted as a **blockquote** in this file. That
is not decoration: it is the boundary between what the user reads and what you
read, and it is what makes the rule below checkable.

**Speak the user's language, not the toolkit's.** On screen: no "glue", no
"socle", no "ledger", no "formula", no "bead", no section letters, no field
names. Every option gets one line saying what it buys and what it costs, in
words someone who has never read this repo would understand. The letters (§A,
§B1…) are for the file and for you.

## Step 0 — Precondition

Check `.agents/.chisel.json` exists. If it does not, stop here and tell the
user to run `npx @lonestone/chisel init` first — this skill configures the
glue, it never installs the socle. Do not attempt to bootstrap `.agents/`
yourself.

## Step 1 — Silent exploration

Before asking anything, scan the repo and note what you find. Do not narrate
the scan step by step — gather everything first, then state the findings as
facts when you reach the section they affect.

- **Boilerplate marker**: does `apps/documentation/` exist? If so, this is a
  **boilerplate-mode** repo — §D and §G point into it, §C is prefilled from
  its known layout. Otherwise this is **brownfield mode**.
- **`package.json` scripts**: read `lint`, `test`, `typecheck`, `build`, and
  any dev/browser-check script → prefills for §F.
- **Existing docs**: `README.md`, `doc/`, `docs/`, `CONTEXT.md`, `docs/adr/`
  → candidates for §C (reading list) and §G (glossary/ADRs).
- **Existing task workspace from a previous methodology** (e.g. a
  `doc/project-management/` from an earlier convention): if one exists,
  flag it for §A instead of silently assuming the default root.
- **`bd --version`**: run it, record what it says (or that the command does not
  exist), and do nothing else with it. It feeds §B1's prerequisite screen only.
  Never install anything.
- **`.beads/`**: if the directory already exists, this repo already keeps its
  statuses in a database — §B1's recommendation becomes "keep what you have".
- **`.agents/user.md`**: if it already exists, Step 5 reports it and touches
  nothing.

**Fact vs decision** (same discipline as the `grilling` skill): what the scan
established is *stated* to the user, not asked. Only genuine decisions —
things the scan cannot determine on its own, or choices with real
alternatives — get a question.

## Step 2 — Walk sections A through H, one at a time

For each section, in letter order:

1. State any relevant facts from Step 1's scan.
2. Give your **recommended** value — prefilled from the scan plus the
   questionnaire defaults (root `/project-management/`; statuses in the task
   files; no external tracker; boilerplate reading list into
   `apps/documentation`; living docs = `apps/documentation` for
   boilerplate else `doc/**`; gate commands from `package.json`; glossary/ADRs
   into `apps/documentation` for boilerplate else root `CONTEXT.md` +
   `docs/adr/`; model tiers unset).
3. Wait for the user's answer before moving to the next section. Accepting a
   recommendation in one word ("yes", "ok", "sounds good") is enough to move
   on — do not demand elaboration when the user is happy with the default.

**Never present two sections in the same message.** Each section gets its
own turn, exactly like the grilling discipline this skill borrows: one
question, wait, then the next. §B is two questions — B1 and B2 — and they
are two separate messages, not one screen with both headings.

Per-mode prefills:

- **Boilerplate mode** — §D and §G point into `apps/documentation` (THE doc
  reference: business + architecture, no split). §C is prefilled from the
  boilerplate's known layout (its `apps/documentation` entry point +
  `README.md`).
- **Brownfield mode** — §C is not a plain open question. Present the scanned
  candidates (README, whatever doc entry points the scan found) as a DRAFT
  reading list, then refine it with the user — a short back-and-forth, not a
  single blind ask. This is the "scan and assist" behavior the brownfield
  acceptance criterion asks for.

Skip §E entirely here — see Step 3.

### §B1 — ask this, verbatim

> **Where do your tasks' statuses live?**
>
> Today every task is a markdown file in this repo, and its status is a line
> inside that file. That works, and most projects should keep it.
>
> 1. **In the task files** — nothing to install, everything shows up in a
>    normal diff, and two people can only collide on the same file. The cost:
>    nothing can tell an agent "these three tasks are ready to start" without
>    reading them all.
> 2. **In a small database committed next to them** — the files still hold the
>    content; a tool keeps the statuses and what-blocks-what, so "what is ready
>    to start?" is one command instead of a reading session. The cost: one tool
>    to install, and one habit — pull when you start, push when you stop.
>
> _There is a third arrangement — the same database with a background service,
> for several agents working at once on one machine. It is **not supported yet**;
> ask when you need it, and it gets built then._
>
> You can move from 1 to 2 later: that move is tooled and only touches tasks
> that are still open. Moving back is a `git revert` on the spot; later than
> that, it is by hand.
>
> Recommended: **1 — in the task files**.

The background service is shown, never offered: it is a fact about what exists,
not a case the user can pick today. If they ask for it anyway, say it is not
supported yet, record option 2 — which is what they would run on each machine
regardless — and note the ask wherever this repo tracks work.

Nor is a database ever the answer to "we are several developers": if the user
says they are a team, option 2 is the answer for the same reasons it is the
answer for one person, and nothing about the choice changes.

If the answer is option 2, run **Step 6** before moving on to §B2.

### §B2 — ask this, verbatim

> **Should tasks here point back to tickets in another tool?**
>
> Some teams keep their client discussion, or their bug reports, somewhere
> else. Each task can carry a link back to the ticket it came from, so a reader
> can jump between the two. Nothing is copied or synchronised: the task file
> stays the place where the work is described.
>
> 1. **No link** — tasks live here and nowhere else.
> 2. **GitHub Issues** — each task records the issue it came from.
> 3. **Plane** — the same, with a Plane work item.
>
> Another tool can be added later without changing anything in the toolkit: it
> takes one page saying how to read a ticket there and where to write the link
> back. This list is open, not a menu of three.
>
> Recommended: **1 — no link**.

**Any answer other than "no link" means writing the adapter page** — including
GitHub and Plane, which the socle ships no page for: the list being open means
every tracker is wired the same way, not that two of them are built in. Write it
with the user, now, before moving to §C, the reading list:

- where it lives: with the living docs declared in §D (say the path out loud);
- what it holds: how to find and read a ticket in that tool, what to copy into
  the task file when a task comes from one, and what (if anything) goes back;
- then name it on §B2's **Adapter page** line, together with the tracker and
  where the link back is written.

If the user names a tool that is not on the list, the answer is the same three
bullets — do not improvise a wiring, and do not refuse. If they would rather not
write the page now, record the tracker and leave the Adapter page line as
`_(to write)_` — never as a path to a page that does not exist.

### §H — ask this, verbatim

> **Does the team want to pin which model does which kind of work?**
>
> The toolkit asks for a *level* rather than a name — the strongest model for
> thinking and reviewing, the cheapest for typing out a plan that is already
> written. Each of you answers that for your own tool, in your own file, which
> is never committed. This section only matters if the team has agreed on one
> answer for everybody.
>
> Recommended: **leave it unset**.

## Step 3 — §E is read-back only, never asked

Section E (Adapters) is written by `chisel init`, not by this questionnaire.
When you reach it in the walk, read the current checklist state back to the
user as a fact (which of the five adapters are present) — do not ask a question
about it. If an adapter is missing, do not fix it here: note it as something
`chisel check` should catch, and move on to §F.

## Step 4 — Surgical writes to `.agents/project.md`

After a section is accepted, write it immediately — do not batch writes
until the end of the walk. Each write is scoped to exactly one section:

- Find that section's `## <letter> · ...` heading.
- Replace everything from immediately after that heading line up to (but not
  including) the next `## ` heading, or end of file if there is none.
- For a sub-section (`### B1 · ...`), the span is the same rule one level down:
  from just after its heading to the next `### ` **or** `## ` heading,
  whichever comes first. Answering one sub-section leaves the others
  byte-identical.
- Leave every byte outside that span untouched: other sections, any content
  a human added above §A or after §H, custom sections the file doesn't
  define (e.g. a hand-added `## I · ...`).

**Never rewrite the whole file.** A full-file rewrite is the one mistake
that would silently discard user edits living outside the questionnaire's
own sections — the whole point of this step is that it can't happen.

On a re-run, the section's *current* content in `project.md` — not the
template default — is what you present as the new recommendation in Step 2.
Accept-in-one-word keeps working on a re-run exactly as it does on a first
run.

## Step 5 — The personal file (also runnable on its own)

This step stands alone. "Set up my personal file", or a second dev's first
session on an already-configured repo, runs THIS step and nothing else — no
questionnaire, no package, no network.

1. If `.agents/user.md` already exists, say so and change nothing. It is the
   dev's own file; it is never overwritten, never merged, never re-templated.
2. Otherwise copy `.agents/user.md.tpl` to `.agents/user.md`. The template is
   installed by `chisel init` and is entirely commented out, so the fresh copy
   changes nothing until its owner edits it.
3. Make sure `.agents/user.md` is ignored by git: if no existing rule already
   covers it, append the line `.agents/user.md` to the repo's `.gitignore`
   (create the file if there is none). Append once — never a duplicate line on
   a re-run.
4. Tell the user, in one line:

> **Your own file.** I created `.agents/user.md` from the template and added it
> to `.gitignore`, so it is never committed. It is where you say which model
> your tool should use for each level of work; left as it comes, it changes
> nothing. Teammates get theirs the same way — copy `.agents/user.md.tpl`, or
> ask any session to do it.

Never commit `.agents/user.md`, and never copy one dev's file for another.

## Step 6 — When §B1 is a database

Only when the user picked option 2. This step CREATES state — it is the one
place in this skill that does. What it runs is written out in full in
`.agents/skills/chisel-beads/CHANGING-CASE.md` — its *entering* section (and,
if this repo already has open task files, its *converting* section too): read
it before running anything here, and follow it command by command, watching
each output rather than typing the whole sequence blind. The convention those
sections serve is `.agents/skills/chisel-beads/SKILL.md` — read that first.

1. **Check the prerequisite.** The tool is `bd`, and the minimum version is
   **1.2.2** — everything this workflow relies on was validated there. Compare
   what `bd --version` printed in Step 1 against it.
2. **If `bd` is missing or older than 1.2.2, never install it yourself.** Show
   this, then wait:

> **This one needs a tool installed: `bd`, version 1.2.2 or newer.** I will not
> install it for you — that is your machine's business, not this repo's.
> To install it: `curl -sSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash`, or your usual package manager.
>
> Say the word and I will keep the statuses in the task files for now instead.
> Moving to the database later is tooled and only touches tasks that are still
> open — choosing the files today costs you nothing tomorrow.

3. **Require a clean working tree, and say why before you check.** Creating the
   database commits the whole repository — everything in flight, not just its
   own files — and no setting turns that off. So:

> **One condition before I create it: nothing uncommitted.** The tool commits
> the whole repository as part of setting itself up, and there is no way to ask
> it not to. Anything you have in progress would land in that commit. Commit or
> stash it, and tell me when to go — this step is safe to re-run.

   If `git status --porcelain` is not empty, stop here and wait. Do not stash
   anything on the user's behalf.

4. **Run the entering sequence.** Follow `CHANGING-CASE.md`'s *entering*
   section, from the repo root, one command at a time. It creates the
   database, re-owns the `bd init` auto-commit under a message that says what
   happened, removes the instructions the tool installs on its own (managed
   blocks, session hook, vendored skill), links the formulas, then commits on
   the exact paths it touches. If any command refuses, read what it says and
   fix that — never work around it.

5. **Confirm what is now true**, out loud, by reading it back rather than
   asserting it: `chisel check` is clean, and `bd ready` answers. Then tick §B1.

6. **Write §B1.** The verdict line becomes the database case, the State line
   becomes `- [x] initialised`, and the section names the convention — that
   pointer is what every later session resolves through, so it is not optional:

   ```
   **Statuses: in a database committed next to the task files.** The task files
   still hold all the content; the database holds the statuses, the blocking
   edges and who is on what.

   - **State:** - [x] initialised
   - **Convention:** `.agents/skills/chisel-beads/SKILL.md` — how a record
     points at its task file, how a session syncs, and the two guards
   - **Habit:** pull at the start of a session, push at the end (the convention
     names the three-command routine that also checks the push landed)
   ```

   Use Step 4's sub-section write span: §B's other sub-sections stay
   byte-identical.

7. **If this repo already holds open task files, move them.** Only then, and
   only once §B1 is written: follow `CHANGING-CASE.md`'s *converting* section.
   One bead per OPEN task file, pointing back at it; the blocking edges come
   from the files' own `**Blocked by:**` lines; the archive is never read; and
   each open file's status line is rewritten to name its bead, so a status
   lives in exactly one place. It commits nothing — show the diff, then commit
   with the user.

8. **Say what happened**, and hand over the one thing they now have to know:

> **Done.** The statuses now live in a small database committed next to your
> task files, and the tool's own instructions have been removed from this repo —
> the working convention it follows here is written in
> `.agents/skills/chisel-beads/SKILL.md`, which is the one page to read before
> creating or claiming anything.
>
> The habit it costs you: pull when you start a session, push when you stop.
> One rule to never break: never `git push --mirror` from a clone — it deletes
> the database's history on the server.

## Step 7 — Closing summary

After §H is written, print a one-screen summary of what got written (one
line per section, A–H), plus one line for the personal file, plus — when §B1
chose a database — the one thing still to do. Then suggest the natural next
move: create a first task, or run `chisel check` to confirm the adapters are
all in place.
