<!--
  chisel managed block. Everything between the `chisel:begin` and
  `chisel:end` markers is written by `chisel init` and rewritten by every
  `chisel update` — hand edits made inside are lost at the next update.
  Everything outside the markers is yours; chisel never touches it.

  To adjust the workflow for THIS project only: write your instructions
  outside the markers (they take precedence for your agents, the block
  stays as-is). To change what the block says for every equipped project:
  edit `socle/templates/AGENTS-block.md` in the chisel repo — this text is
  copied verbatim from that file.
-->

**Always** — follow `.agents/discipline.md`. It is the ambient core: it
applies to every conversation, with or without a spec file, and its first
rule tells you what to read before acting.

**For real, scoped, multi-step work** — the pipeline is
`.agents/formulas/chisel-default.formula.toml`. Execute it as an ordered
checklist, top to bottom (it spans more than one session — the steps say
where the breaks are):

- Each `[[steps]]` is one step and `needs` gives the order. Follow the step's
  `description`: it names the role, the skills to invoke (`.agents/skills/`)
  and the artifacts to produce.
- Each `[steps.gate] type = "human"` means **stop and ask the human** before
  starting that step. Never assume approval.
- Track progress in the spec file itself (status and checkboxes from the
  template) — it is the source of truth for content and progress.
- Each step names a role (Architect, Checker, Mason, Inspector) — read its
  profile in `.agents/profiles/` before spawning it; the contracts live there.

`.agents/formulas/chisel-auto.formula.toml` is the same pipeline with every
human gate replaced by escalation — a doubting step stops and hands one rung
up instead of waiting. `.agents/formulas/chisel-supervised.formula.toml` sits
between the two: the same steps as auto, but with exactly one human gate — the
Owner approves the spec, nothing else. Both are opt-in: either runs only when
a human explicitly asks for it in that session AND `.agents/project.md`
permits it (§B3 · Autonomous runs) — never chosen by an agent on its own.

Paths (task workspace, template, journal, gate commands) resolve through
`.agents/project.md`. The reasoning behind all of it is
`.agents/methodology.md`. This block only routes; the socle at `.agents/`
carries the content.
