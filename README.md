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

> ⚠️ **Work in progress.** v1 is being built — see
> [project-management/tasks/](./project-management/tasks/) (this repo dogfoods
> its own methodology).

## What it will do

- `chisel init` — copy the socle into your repo (`.agents/` + adapters:
  `AGENTS.md` managed block, `CLAUDE.md` import, `.claude/skills` symlink,
  `/project-management/` workspace) then run a setup questionnaire that writes
  `.agents/project.md` — the glue holding YOUR paths (tasks, docs, reading
  list, gate commands).
- `chisel update` — re-render the managed parts from a newer socle; never
  touches your glue or your files.
- `chisel check` — report socle version and local divergences.
- `sync-upstream` (maintainers, in this repo) — pull Matt Pocock's skill
  improvements into our forks: agent proposes, human validates.

## Provenance

Skills forked from [mattpocock/skills](https://github.com/mattpocock/skills)
(MIT) and adapted; methodology fused with the Lonestone task lifecycle and
patterns from dex's "Why Software Factories Fail". Piloted on two production
repos before extraction.
