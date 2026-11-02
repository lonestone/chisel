# Chisel

Chisel gives your coding agent a way of working. Hand it a task — an issue
in your tracker, a line in beads, a sentence in the prompt — and it takes it
all the way to a reviewed commit, and to a pull request if you want one.

It is Lonestone's dev-workflow socle: a few pages and skills in an
`.agents/` folder that Claude Code, Cursor and Codex all read. There is no
server and no workflow engine. The method is written in plain prose, and
current models follow it well.

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

That's it. Give it a task.

Chisel needs Deno 2.6 or later, and nothing else: no `node_modules`, no
global install. `deno x` runs with every permission, as npx would; `deno run
jsr:@lonestone/chisel` asks only for read and write in the target directory
and network access to `jsr.io`. To pin a version, name it:
`jsr:@lonestone/chisel@0.2.0`. In the day after a release Deno refuses a
version that fresh; add `--min-dep-age 0` to the command, or wait.

## What happens when you give it a task

The agent you talk to plays the **Architect**: think of it as the project
lead. It does not write the code itself.

1. **It reads the task and the code it touches.** When the task is clear,
   it writes a short spec straight away. When it is not, it asks you
   questions, one at a time, each with the answer it recommends.
2. **It launches a Crewmate**, a sub-agent that writes the plan and stops.
3. **The Architect reads the plan**, corrects it and approves it. Only the
   questions that touch your decisions come back to you.
4. **The Crewmate codes**, test first, then runs the `code-review` skill.
   Two fresh sub-agents read the diff, one against your repo's standards and
   one against the spec. They never saw the coding session, and that is the
   point.
5. **The Crewmate fixes what they found and closes the task**: criteria
   ticked, docs updated, an entry in the project journal, a commit, the
   tracker updated.
6. **The Architect opens the pull request.** Merging and publishing wait for
   your word, unless your project told chisel otherwise.

In a long conversation, the same Architect runs several Crewmates, one per
task. A Typist, a sub-agent on a cheaper model that only types an approved
plan, is there if your models make it worth it; most of the time the
Crewmate types itself.

Everything worth keeping lands in the repo, not in a chat history. The spec
puts the decisions you should read carefully at the top. The **seams** — the
boundaries the feature is tested through — are named before any code. The
plan lives in a work document beside the spec, so the next session, the
review and you can all read it. The journal, `project-management/JOURNAL.md`,
tells the story one task at a time.

The whole workflow is one page: `.agents/workflow.md`.

## It works with your tracker

Your tasks can live in the task files themselves (the default, nothing to
install), in beads, in Plane, in GitHub Issues or anywhere else. The agent
only needs the skill or connector that reads and updates a task there; the
spec and the plan stay in the repo whatever you choose.

Chisel does not watch your tracker or decide which task runs next. That is
you, or whatever you put above it: a harness, an orchestrator, a script.

## Keeping it up to date

```bash
deno x jsr:@lonestone/chisel update
```

`update` refreshes what chisel installed and never touches your settings,
your journal or your own files.

**Coming from 0.1.x**, `update` also removes what that version installed
and this one retired: the step files, the role pages, the agent definitions
in `.claude/agents/` and `.codex/agents/`. A file someone edited is left in
place and named on an `orphaned:` line; a line of your settings that has
become false is named on a `stale:` line. Then ask your agent to run the
`chisel-upgrade` skill: it rewrites the tracker settings, moves your task
statuses to the new ones, and renames the journal, with you validating each
step.

**Coming from the first version**, `update` refuses and points at the same
skill, which retires the old layer first.

`chisel check` tells you which version is installed and whether anything
drifted from it.

## Working on chisel itself

Run the CLI straight from a checkout, on any target directory:

```bash
deno run -A src/main.ts init ../some-repo
```

`deno task test` runs the suite ([test/TESTS.md](./test/TESTS.md) says what
it protects); `deno task check` type-checks, lints and format-checks.

To release, bump `version` in `deno.json`, add a dated entry to
`project-management/JOURNAL.md`, commit, and run `deno publish` from a clean
tree. What gets published is what `publish.include` in `deno.json` names.

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
