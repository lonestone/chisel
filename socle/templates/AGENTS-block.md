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
applies to every conversation, with or without a task artifact, and its first
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
- The spec document is the source of truth for requirements and sole status.
  The matching work document holds the Mason's program design, worklog and
  implementation checkboxes.
- A blocker always leaves a written trace in the task's own documents, signed
  with its author's role plus the date and the time, with the ruling on it
  recorded in the same place — the form and the destinations are
  `.agents/methodology.md` ("Escalation, and the blocked-task report").
- The invoking session is the **Foreman** (`.agents/profiles/foreman.md`): it
  runs the formula, and it holds the interview, the mechanical verify and the
  close itself. Every other step is a fresh sub-agent it spawns — Architect,
  Checker, Mason, Inspector. Read a role's profile in `.agents/profiles/`
  before spawning it; the contracts live there.

`.agents/formulas/chisel-light.formula.toml` keeps the human gates and drops
the validation sub-agents: no Checker on the spec, no `plan-review`, and at the
diff review the human reads in the Inspector's place.
`.agents/formulas/chisel-supervised.formula.toml` keeps exactly one human gate
— the Owner approves the spec, nothing else — with every sub-agent.
`.agents/formulas/chisel-auto.formula.toml` is the same pipeline with every
human gate replaced by escalation: a doubting step blocks and reports one rung
up instead of waiting. `.agents/formulas/chisel-auto-light.formula.toml` drops
both — no gate, no sub-agent — and exists to be measured against the others,
not as a lighter way to work.

Which preset governs a run is the human's choice, made at invocation and never
an agent's. Under the default and light the run stops at each step and the
human relaunches it; under supervised, auto and auto-light the Foreman spawns
the next step itself, fresh.

Paths (task workspace, template, journal, gate commands) resolve through
`.agents/project.md`. The vocabulary, the rule that says who owns a review
zone and the model tiers are `.agents/reference.md`; the reasoning behind all
of it is `.agents/methodology.md`. This block only routes; the socle at
`.agents/` carries the content.
