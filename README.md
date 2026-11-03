# Chisel

**Chisel is a protocol for coding agents: a task workflow.** Hand your
agent a task — an issue in your tracker, a line in beads, a sentence in the
prompt — and chisel is the way it takes that task to a reviewed commit, and
to a pull request if you want one.

It ships as a few pages of prose and a set of skills in an `.agents/`
folder that Claude Code, Cursor and Codex all read. No server, no engine:
the protocol is written down, and the agent follows it.

## What chisel is

**Skills that scope the task before any code.** When the intent is fuzzy,
the agent grills you with Matt Pocock's `grilling` skill: one question at a
time, each with the answer it would pick. Then it writes a short spec, with
the decisions that need you at the top and the **seams**, the boundaries the
code will be tested through, named before any code.

**Skills that keep the codebase understood.** The `domain-modeling` skill,
also Pocock's, keeps a glossary of the domain and records the decisions
that are hard to reverse as ADRs. Every task also adds an entry to
`JOURNAL.md`, so the next agent knows what happened and why.

**A way of organising files.** Every task is a spec and a work document in
the repo, the work document holding the plan, the worklog and the review
findings. With the journal, they are artefacts on disk: any agent can pick
up where another stopped, even after a session dies.

**Sub-agents where they bring something, and nowhere else.**

- **The Architect** is the agent you talk to: the project lead. It scopes
  the task, reads the plans, and brings only the key questions to you.
  Because the coding happens elsewhere, it can run several Masons in
  parallel, each in its own worktree, without drowning its context.
- **The Mason** is a frontier model that analyses and plans. It
  writes the plan, stops for the Architect's reading, has a Typist code it
  test first, and closes the task.
- **The reviewers** know nothing of the session that wrote the code, and
  that is the point. They read the diff against your standards and against
  the spec, with Pocock's `code-review` skill.
- **The Typist** types the approved plan on a cheaper model. The Mason
  types itself only a retouch of a few lines, or while the plan is not
  settled.

**Firm rules for the end of a task.** No task closes without the review and
your gate commands: lint, tests, build. What an agent may do on its own is
written down: the Mason commits but does not push, and merging and
publishing wait for you unless your project hands them over. The close has
its loops too: the Mason ticks the acceptance criteria against reality,
updates the living docs, the glossary and the ADRs, writes the journal
entry, and proposes what the process should learn.

## What chisel is not

- **Not an orchestrator.** It does not watch your tracker, schedule tasks
  or decide which one runs next. That is you, or whatever you put above it:
  a harness, a script, a long-lived thread.
- **Not built for a swarm.** An Architect runs a handful of Masons.
  Ninety in parallel is another world, with other tools.
- **Not tied to a tracker.** Task files (the default), beads, Plane, GitHub
  Issues: the agent only needs the skill or connector that reads and
  updates a task there. The spec and the plan stay in the repo whatever you
  choose.
- **Not an engine.** There is no pipeline to configure. Today's models need
  direction, not machinery: our heavier second version cost more and did
  not earn it back.
- **Not benchmarked yet.** These choices come from production use on
  Lonestone projects, not from a measured comparison. That comparison is
  still to do.

## Try it

From the root of your repo:

```bash
deno x jsr:@lonestone/chisel init
```

Then open your agent and ask it to run the `chisel-setup` skill. It looks
around the repo and proposes each setting in turn: where your tasks live,
your lint and test commands, whether it may merge on its own. What you
confirm is written to `.agents/project.md`, the one file that makes chisel
yours.

On a repo that already has a method of its own — OpenSpec or Spec Kit
specs, a task folder, decision records, another agent's rules, a
hand-written `AGENTS.md` — `init` installs nothing. It names what it found,
stages a workspace git ignores, `.chisel-workspace/`, and exits with code 3.
The same skill starts there: for each thing found, it recommends keeping it
where it is with chisel pointing at it, bringing it into chisel's format, or
leaving it beside chisel, and waits for your answer before the next. Then it
installs with `init --arranged`, writes only what you accepted, and goes on
with the settings.

That's it. Give it a task.

Chisel needs Deno 2.6 or later, and nothing else: no `node_modules`, no
global install. `deno x` runs with every permission, as npx would; `deno run
jsr:@lonestone/chisel` asks only for read and write in the target directory
and network access to `jsr.io`. To pin a version, name it:
`jsr:@lonestone/chisel@0.2.2`. In the day after a release Deno refuses a
version that fresh; add `--min-dep-age 0` to the command, or wait.

## What happens when you give it a task

In practice, a task goes like this.

1. **The Architect reads the task and the code it touches.** When the task
   is clear, it writes a short spec straight away. When it is not, it asks
   you questions first.
2. **It launches a Mason**, which writes the plan and stops.
3. **The Architect reads the plan**, corrects it and approves it. Only the
   questions that touch your decisions come back to you.
4. **A Typist codes the plan**, test first, on a cheaper model; the
   Mason then runs the `code-review` skill on the whole diff, with two
   fresh reviewers.
5. **The Mason fixes what they found and closes the task**: criteria
   ticked, docs updated, an entry in the project journal, a commit, the
   tracker updated.
6. **The Architect opens the pull request.** Merging and publishing wait for
   your word, unless your project told chisel otherwise.

The whole workflow is one page: `.agents/workflow.md`.

## Keeping it up to date

```bash
deno x jsr:@lonestone/chisel update
```

`update` refreshes what chisel installed and never touches your settings,
your journal or your own files. A file of chisel's that someone edited is
put back and named on an `overwritten:` line.

**Each release ships intentions**: one per change your repo must act on,
written for an agent, and classified by how much judgement it needs. Your
manifest, `.agents/.chisel.json`, records which ones you applied or
skipped. When every pending intention needs no judgement, `update` copies
and records them, as above.

**When one needs judgement, or your repo is not as chisel installed it** —
no manifest, the first version's files, a symbolic link where chisel
writes — `update` writes nothing in your files. It stages a workspace,
`.chisel-workspace/`, that git ignores: the pending intentions, the
reference tree of the new version, and a checklist. It prints the
checklist and exits with code 3. Then ask your agent to follow the
`chisel-update` skill it names: the agent proposes what to apply, finds
where your repo keeps its method, shows each move before making it, stops
for you on anything breaking, and records each result with
`chisel record`. You validate the diff.

**Coming from 0.1.x**, the session lists the intentions of 0.2.0: the
prose workflow that replaces formulas and agent definitions, one tracker
section, seven statuses, the merge and publish section, and the journal
renamed `JOURNAL.md`. The agent applies each one with you, then closes with
`chisel update`, which removes what 0.1.x installed and this version
retired. A file someone edited is left in place and named on an
`orphaned:` line. **A repo chisel did not install** but that already has an `.agents/`
folder, or one chisel installed in its first version, gets one intention instead, `baseline`: it takes the repo
to the current layout whole, wherever its method lives today.

On a repo chisel has not installed yet, a path `init` would write that is
a symbolic link, or sits under one, is one of the things it stages for the
setup skill; `init --arranged` refuses one, naming each. Outside
`.agents/`, `update` only refreshes the files it installed and you kept, so
it never plants a second task workspace beside yours.

`chisel check` tells you which version is installed, whether anything
drifted from it, and which intentions are pending.

## Working on chisel itself

Run the CLI straight from a checkout, on any target directory:

```bash
deno run -A src/main.ts init ../some-repo
```

`deno task test` runs the suite ([test/TESTS.md](./test/TESTS.md) says what
it protects); `deno task check` type-checks, lints and format-checks.

Every commit is conventional, `type(scope): description`: run
`deno task hooks` once in a clone to install the commit-msg hook.

To release, a maintainer prepares the Release PR that release-please keeps
open on `main` with the `chisel-release` skill, and a human merges it; CI then
tags it and publishes to JSR. [RELEASING.md](./RELEASING.md) explains the
system, and what gets published is what `publish.include` in `deno.json` names.

The `sync-upstream` script pulls Matt Pocock's skill improvements into our
forks: the agent proposes each merge, a human validates skill by skill.

## Where it comes from

What chisel is and is not for: [CHARTER.md](./CHARTER.md). Why it exists,
the alternatives we tested, and the beliefs behind the design:
[PHILOSOPHY.md](./PHILOSOPHY.md).

The skills are forked from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT) and adapted.
The method fuses the Lonestone task lifecycle with patterns from dex's "Why
Software Factories Fail", and ran on two production repos before it was
extracted.
