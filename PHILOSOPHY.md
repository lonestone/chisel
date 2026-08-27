# Philosophy

Why chisel exists, what we tried before building it, and the beliefs its
design rests on. For *how* the methodology works day to day, read
[socle/agents/methodology.md](./socle/agents/methodology.md) — this document
is the why.

## 1. The problem

Coding agents type faster than we review. That inverts the economics of
software work: the bottleneck is no longer producing code, it is **a human
understanding what was produced well enough to trust it**. A methodology for
agent-assisted work is therefore not a code-production system — it is a
**review-throughput system**.

We came to this after months of real use, with three recurring frustrations
about the tools we tried:

1. **The learning curve is ugly.** Invented vocabulary, CLIs to memorize,
   ceremony before the first useful minute.
2. **Everything is too verbose.** Maybe rightly so for LLM output quality —
   but the human no longer knows *what* to read, so reads nothing. In our
   experience, unreviewed agent work degrades quality fast. Verbosity
   doesn't just cost tokens; it silently removes the human from the loop.
3. **Everything is too "active".** Most frameworks only work when you drive
   them — run this command, follow that workflow. We want a system that
   lives in the background: the agent follows the discipline by itself,
   notices when a conversation has become real work, and *proposes* the
   process instead of requiring it.

## 2. What we studied and tested

Between June and August 2026 we analyzed the spec-driven-development
landscape in depth (source-level, all cloned and read), and battle-tested
the finalists on production repos.

| Project | What we did | Outcome |
|---|---|---|
| [OpenSpec](https://github.com/Fission-AI/OpenSpec) | **Adopted, customized, used for a month on a real project** | Rejected after real use: verbose artifacts, mediocre CLI, and above all — we never knew what to re-read as humans |
| [Spec-kit](https://github.com/github/spec-kit) | Source analysis | Heaviest ceremony of the lot; the constitution/specify/plan/tasks pipeline is the "active system" problem incarnate |
| [specs.md](https://github.com/fabriqaai/specs.md) | Source analysis | Interesting machine-checkable acceptance criteria (its `fabro` runner); the idea survives in how we write ACs |
| [Superpowers](https://github.com/obra/superpowers) | Source analysis | Validated the skills-as-process-memory approach, but too big and too opinionated to adopt wholesale |
| [LeanSpec](https://github.com/codervisor/leanspec) | Source analysis | Closest to our verbosity diagnosis; discarded after the project pivoted away from its own core idea |
| [mattpocock/skills](https://github.com/mattpocock/skills) | **Adopted — forked as our engine** | The best per-moment engineering practices we found: grilling, seams, TDD, tracer-bullet slicing, two-axis review. Small, composable, no runtime |

Two outside sources shaped the structure as much as the tools did:

- **dex's "Why Software Factories Fail"** (HumanLayer): the phase model —
  Product → System Architecture → Program Design → Implementation — and the
  observation that **human review of the first three is incompressible**.
  Skipping it doesn't remove the cost, it moves the cost downstream where
  it's bigger.
- **Cursor's [agent-swarm model economics](https://cursor.com/blog/agent-swarm-model-economics)**:
  frontier models for planning and cheap/fast models for execution only pay
  off if the executor receives a **complete, self-contained brief** — which
  told us exactly where the delegation boundary must sit.

And one decisive experiment of our own: our pre-existing house methodology
(rich self-contained task files + a dated CHANGELOG the agents read and
write) had quietly outperformed every framework we tested. The conclusion
wasn't "adopt a framework", it was **fuse what worked**: our lifecycle and
artifacts, Pocock's skills as the engine.

## 3. Our conclusions

These are the beliefs chisel is built on:

- **Review is the bottleneck, so optimize for reading.** Task files use a
  *reading gradient*: what the human must review carefully is short and at
  the top (🧑 context, scope, acceptance criteria, seams); design worth
  checking comes next (🧑 if relevant); the agent's verbose working notes
  sink to the bottom (🤖). Detail is never cut — it is ordered. Humans
  re-read again ⇒ quality comes back.
- **Ambient by default, ceremony on demand.** The discipline applies to
  every conversation (read the project context, plan first, verify before
  "done"). The agent detects when a chat has become real work and proposes
  a task file — it never forces one. The one-shot fix stays cheap.
- **Two designs, two moments.** The system design (how the pieces talk) is
  settled at creation time and reviewed there — a slice is ready to produce
  when it is settled, not before. The program design (files, signatures,
  test order) happens at each slice's plan step, with the real code in view
  — and once validated it is **persisted into the slice file before any
  code is typed**. A plan that only lives in the conversation is invisible
  to the completion review, to dependent slices, and to re-runs.
- **Think and type are different jobs.** Planning needs a frontier model
  and a human gate; typing from a complete persisted brief doesn't. The
  **plan is the delegation boundary**: product, architecture and program
  design are never delegated; execution can be, to a faster/cheaper model,
  with the planner reviewing the diff. (Validated in production — this
  repo's own slices were typed by a cheaper model from persisted designs.)
- **Humans own the gates — and a 🧑 zone's owner follows who approved it, not
  simply "the human".** Seams (where we test) are agreed before code. Plans
  are approved before typing. Slicing is validated before publication. An
  unanswered proposal is a rejected proposal.
- **Own your forks.** The Pocock skills are vendored with per-skill
  upstream tracking (`x-upstream` frontmatter + lock file). Upstream
  improvements are pulled a few times a year: the agent proposes each merge
  preserving our documented adaptations, a human validates skill by skill.
  A fork that diverges too far gets honestly unplugged (`upstream: none`)
  instead of pretending to track.
- **One folder, every tool, no duplication.** The socle lives in
  `.agents/`, read by Claude Code, Cursor and Codex through thin adapters
  (an `AGENTS.md` managed block, a `CLAUDE.md` import, one symlink).
  Project-specific paths live in ONE file — `.agents/project.md`, the glue —
  so the socle itself stays byte-identical across repos and updates never
  conflict with your customizations.

## 4. The methodology, in brief

Three situations, one discipline:

- **The ambient discipline** — every conversation, no artifact. Read the
  project's reading list, plan first, verify before claiming done, suggest a
  task when the work outgrows the chat. This is not a mode: it is what the
  default behaves like when there is nothing to file.
- **One task** — two sessions. CREATE: an interview (grilling) shapes the
  task file — context, scope, acceptance criteria, seams — and logs it in
  the journal. WORK: a fresh session reads the file, plans against the real
  code, gets the plan approved and persisted, offers to delegate the typing,
  then builds and closes (lint/tests/build, browser check if UI, the
  journal, living docs).
- **A parent task with slices** — big features: a parent task plus thin
  vertical slices with dependency edges. Any slice whose blockers are done
  can start, each in a fresh session following the one-task WORK shape.

On top of that discipline, chisel runs as **one default plus two options**.
The default holds every gate at the human. Two options add to it, and each
is independent of the other: **beads** (a status database, repo state,
additive — nothing above it changes) and **auto** (permission to run
without stopping, asked for per invocation — never the project's permanent
setting). Three presets combine them: `chisel-default` (the discipline
above, exactly), `chisel-supervised` (the same steps with one asynchronous
gate — the Owner approves the spec, nothing else), `chisel-auto` (no gates;
a doubting step escalates instead). **Factory = auto × beads** — the only
combination that needs beads, for its queues and asynchronous gate lists;
plain auto is one chained session and needs none.

An earlier design named these situations with size-based labels instead —
they read as **work sizes**, where the framing above reads as **piloting
postures**. The two axes are not the same thing, and keeping the old labels
kept conflating them, which is why they are retired rather than kept
alongside the new vocabulary.

The full reference: [methodology.md](./socle/agents/methodology.md) (the
concepts), [`.agents/discipline.md`](./socle/agents/discipline.md) (the
ambient core), [`.agents/formulas/`](./socle/agents/formulas/) (the order
and the gates, per preset), and the task template in
[socle/templates/](./socle/templates/000-task-file-template.md).

## Sources

**Frameworks studied (all source-level, cloned and read):**

- [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec) — adopted,
  customized, used for a month in production, then rejected
- [github/spec-kit](https://github.com/github/spec-kit) — GitHub's
  constitution/specify/plan/tasks pipeline
- [fabriqaai/specs.md](https://github.com/fabriqaai/specs.md) —
  machine-checkable acceptance criteria (the `fabro` runner)
- [obra/superpowers](https://github.com/obra/superpowers) —
  skills-as-process-memory, taken to its maximum
- [codervisor/leanspec](https://github.com/codervisor/leanspec) — the
  "context economy" diagnosis of spec verbosity
- [mattpocock/skills](https://github.com/mattpocock/skills) — **our engine**;
  forked and vendored with per-skill upstream tracking (see
  [upstream.lock.json](./upstream.lock.json))

**References that shaped the design:**

- dex (Dex Horthy, HumanLayer) — *Why Software Factories Fail*:
  [the essay](https://x.com/dexhorthy/article/2081058573556306030) and
  [the AI Engineer talk](https://www.youtube.com/watch?v=Ib5GBkD555M).
  The Product → System Architecture → Program Design → Implementation phase
  model, and why human review of the first three is incompressible.
- Cursor — [*Agent swarm model economics*](https://cursor.com/blog/agent-swarm-model-economics).
  Frontier-plans / cheap-executors only works with complete, self-contained
  briefs — where our delegation boundary comes from.
- [AGENTS.md](https://agents.md) — the cross-tool agent-instructions
  standard (Linux Foundation) our unified `.agents/` layout builds on.

**Field validation:** piloted on two production repos (music-downloader,
evea-ai), dry-run tested on a third untouched monorepo, and dogfooded by
this very repo — every chisel feature was built as a slice of its own
methodology, most of them typed by a cheaper model from a persisted plan.
