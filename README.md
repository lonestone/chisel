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
**reading-gradient** spec file: the decisions worth reviewing carefully sit
at the top, program design underneath, the agent's working notes at the
bottom — detail is never cut, only ordered.

**Seams** — the public boundaries a feature is tested through — are agreed
before any code is typed. A fresh session then plans against the real code
and **persists the plan into the spec file** before writing a line: a plan
that only lives in the conversation is invisible to the next session, to the
completion review, and to a crash. Typing can be delegated to a cheaper
model from that persisted plan; the Architect who planned it never types
what it planned.

At completion, a **two-axis review** checks Standards (the repo's own
conventions) and Spec (did the work do what the 🧑 zones asked, and nothing
more) side by side — never merged into one list, so one axis cannot mask the
other.

## The two choices setup actually shows you

`chisel init` asks two questions beyond your paths, both written as one line
each in `.agents/project.md`, both changeable later by re-running the
question:

- **Where task statuses live (§B1).** The default is the task files
  themselves — nothing to install. The other answer is a committed `bd`
  database when a repo wants queries instead of a reading session; adding it
  later is tooled and only touches open tasks.
- **Whether an agent may run without stopping (§B3).** Off by default. Turn
  it on and a human can ask, in a given session, for `chisel-supervised`
  (one asynchronous gate — the Owner approves the spec, nothing else) or
  `chisel-auto` (no gates; a doubting step escalates instead). Nobody grants
  themselves that permission in-session — it lives in this versioned line
  either way.

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
