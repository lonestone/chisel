# Chisel

**Lonestone's dev-workflow socle, installable in any repo.**

Chisel bundles our agent methodology — reading-gradient task files, seams
agreed before code, think/type split with model tiers, two-axis review — into
a single `.agents/` folder that Claude Code, Cursor and Codex all read, posed
by one command:

```bash
npx @lonestone/chisel init
```

**Why this exists** — the problem, the alternatives we tested, and the
beliefs behind the design: [PHILOSOPHY.md](./PHILOSOPHY.md).

## The default

By default, every gate stays at the human. A task starts as an interview
(one question at a time, a recommended answer with each), which shapes a
**reading-gradient** spec document: the decisions worth reviewing carefully
sit at the top, the rest ordered after them — detail is never cut, only
ordered. That document holds the requirement and nothing else; the program
design and the working notes live in a work document beside it, created by
the session that implements the task.

**Seams** — the public boundaries a feature is tested through — are agreed
before any code is typed. A fresh session then plans against the real code
and **persists the plan into the work document** before writing a line: a
plan that only lives in the conversation is invisible to the next session, to
the completion review, and to a crash. Typing runs from that persisted plan,
and it can run on a cheaper model; whoever reviews a design never types the
work it approved.

At completion, a **two-axis review** checks Standards (the repo's own
conventions) and Spec (did the work do what the 🧑 zones asked, and nothing
more) side by side — never merged into one list, so one axis cannot mask the
other.

## Setup, after init

`chisel init` installs the socle with safe defaults and asks nothing. The
questionnaire is the `chisel-setup` skill, run afterwards in an agent
session: it reads the repo, proposes each section of `.agents/project.md` one
at a time, and writes back what you confirm. Re-run it later to revisit a
single section.

The answer worth knowing about up front is **§B1 · Where task statuses live,
of `.agents/project.md`.** The default is the task files themselves —
nothing to install. The other answer is a committed `bd` database when a repo
wants queries instead of a reading session; adding it later is tooled and
only touches open tasks.

## The upgrade path

`chisel update` re-renders the managed parts of `.agents/` from a newer
socle; it never touches your glue (`.agents/project.md`) or your own files.
Run against a repo still on the retired v1 layout, it **refuses by name** and
points at the `upgrade-v2` skill instead — an agent migrates the layout, a
human validates the result before anything is re-installed.

## Other commands

- `chisel check` — reports the socle version and any local divergence from
  what was installed.
- `sync-upstream` (maintainers of this repo) — pulls Matt Pocock's skill
  improvements into our forks: the agent proposes each merge, a human
  validates skill by skill.

## Provenance

Skills forked from [mattpocock/skills](https://github.com/mattpocock/skills)
(MIT) and adapted; methodology fused with the Lonestone task lifecycle and
patterns from dex's "Why Software Factories Fail". Piloted on two production
repos before extraction.
