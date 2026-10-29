# Chisel

**Lonestone's dev-workflow socle, installable in any repo.**

Chisel processes one task: it takes it from its intent to its commit, and
to its pull request when one is wanted. It bundles our agent methodology —
reading-gradient spec documents, seams named before code, a plan persisted
and read before any code, a two-axis review by fresh eyes — into a single
`.agents/` folder that Claude Code, Cursor and Codex all read, posed by one
command:

```bash
deno x jsr:@lonestone/chisel init
```

Requires **Deno 2.6 or later** and nothing else — no `node_modules`, no
global install. `deno x --install-alias` creates the `dx` alias, after which
the same command reads `dx jsr:@lonestone/chisel init`. `deno x` runs the
command with every permission, as npx would; `deno run jsr:@lonestone/chisel`
asks for read and write inside the target directory and net access to
`jsr.io`, where the packaged socle is read from.

Deno refuses a package version published less than 24 hours ago (its
minimum dependency age policy). In the day after a release, add
`--min-dep-age 0` to the command, or wait.

To pin a version, name it in the specifier:

```bash
deno x jsr:@lonestone/chisel@0.1.1 init
```

**Why this exists** — the problem, the alternatives we tested, and the
beliefs behind the design: [PHILOSOPHY.md](./PHILOSOPHY.md).

## How a task runs

The workflow is one page of prose, `.agents/workflow.md`. Four roles:

- **The Architect** is the agent you, or an orchestrator, talk to. It reads
  the task, writes the spec document — from the task when the task is
  clear, after an interview when it is not — launches a Crewmate, reads its
  plan, and brings only the key questions to you.
- **The Crewmate** is a sub-agent. It writes the plan into a work document
  beside the spec and stops for the Architect's reading. Then it codes, runs
  the review, and closes the task.
- **The Typist** is optional: a sub-agent on a cheaper model that types an
  approved plan. By default the Crewmate types itself.
- **The reviewers** are fresh sub-agents launched by the `code-review` skill.
  They read the diff on two axes — Standards and Spec — with no context from
  the session that wrote it.

The spec document is a **reading gradient**: the decisions worth reviewing
carefully sit at the top, the rest ordered after them. **Seams** — the
public boundaries a feature is tested through — are named before any code.
The plan is **persisted in the work document** and approved before any code:
a plan that only lives in the conversation is invisible to the next session,
to the review, and to a crash.

**Chisel does not orchestrate.** Watching a tracker to launch agents,
scheduling tasks, deciding which task runs next belong to the layer above:
a human, a harness, an orchestrator thread, a script. Merging and publishing
wait for your explicit word.

## Setup, after init

`chisel init` installs the socle with safe defaults and asks nothing. The
questionnaire is the `chisel-setup` skill, run afterwards in an agent
session: it reads the repo, proposes each section of `.agents/project.md` one
at a time, and writes back what you confirm. Re-run it later to revisit a
single section.

The answer worth knowing about up front is **§B · Tracker, of
`.agents/project.md`**: where your tasks live and what reads and updates
them. The default is the task files themselves — nothing to install. Beads,
Plane, GitHub Issues or another tool work too: the glue names the skill or
the connector that reads and updates a task there. The spec and work
documents stay in the repo whatever the tracker.

## The upgrade path

`chisel update` refreshes the managed parts of `.agents/` from a newer
socle; it never touches your glue (`.agents/project.md`) or your own files.
On a repo installed from 0.1.x it also removes what that version installed
and this one retired — its step files, its role pages, the agent
definitions in `.claude/agents/` and `.codex/agents/` — as long as nobody
edited them, and names the ones someone did. The rest of the move — the
glue's tracker section, the task statuses, your own text — is the
`chisel-upgrade` skill's, run in an agent session with a human validating
each step. On a repo still on the first version's layout, `update` refuses
by name and points at the same skill.

## Other commands

- `chisel check` — reports the socle version and any local divergence from
  what was installed.
- `sync-upstream` (maintainers of this repo) — pulls Matt Pocock's skill
  improvements into our forks: the agent proposes each merge, a human
  validates skill by skill.

## From a checkout (maintainers)

Run the CLI straight from the repo, on any target directory:

```bash
deno run -A src/main.ts init ../some-repo
```

`deno task test` runs the suite ([test/TESTS.md](./test/TESTS.md) says what
it protects) and `deno task check` type-checks, lints and format-checks.

**Releasing.** Bump `version` in `deno.json`, add the dated entry to
`project-management/CHANGELOG.md`, commit, then `deno publish` from a clean
tree (`--allow-dirty` only when untracked files you mean to keep sit in the
tree). The published set is what `publish.include` in `deno.json` names.
Consumers see the new version once Deno's minimum dependency age has passed,
or sooner with `--min-dep-age 0`.

## Provenance

Skills forked from [mattpocock/skills](https://github.com/mattpocock/skills)
(MIT) and adapted; methodology fused with the Lonestone task lifecycle and
patterns from dex's "Why Software Factories Fail". Piloted on two production
repos before extraction.
