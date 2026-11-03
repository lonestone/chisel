# The Typist by default — work

Created by the Crewmate at the plan step, 2026-11-03. Spec:
`project-management/tasks/20261103-1449-the-typist-by-default.spec.md`.

**Plan:** approved by the brief of promethee (Architect), 2026-11-03: the
brief fixes the new default and asks the Crewmate to carry it to the pull
request, the Owner having said "ok" to it. No separate reading.

## Program Design

A doctrine change, no code. The wording is the Crewmate's; the plan below
gives every edit as exact text, so the typing is **mechanical** and goes to
a Typist at the *cheap* tier (socle default on Claude Code: Haiku). Each
edit replaces an exact passage; a passage that is not found is reported,
not guessed.

Where each meaning lives: the rule in `workflow.md`, the tier per role in
`reference.md`, the reason in `methodology.md`. Chisel's own docs
(`CHARTER.md`, `README.md`, `PHILOSOPHY.md`) say it in one line each.

### Edit 1 — `socle/agents/workflow.md`, "The roles", Crewmate row

Old:
```
| **Crewmate** | A sub-agent launched by the Architect. | Writes the plan in the work document and stops for the Architect's reading. Then codes, runs `code-review`, and closes the task. |
```
New:
```
| **Crewmate** | A sub-agent launched by the Architect. | Writes the plan in the work document and stops for the Architect's reading. Then launches a Typist to code it, runs `code-review`, and closes the task. |
```

### Edit 2 — same file, "The roles", Typist row

Old:
```
| **Typist** | Optional. A sub-agent launched by the Crewmate. | Types code from the approved plan and decides nothing. Worth it only when it runs on a cheaper model than the Crewmate. By default the Crewmate types itself. |
```
New:
```
| **Typist** | A sub-agent launched by the Crewmate once the plan is approved. | Types code from the approved plan and decides nothing, at the *mid* tier, or *cheap* when the plan is mechanical (`.agents/reference.md`, "Model tiers"). |
```

### Edit 3 — same file, step 5

Old:
```
**5. Code — Crewmate, or a Typist it launches.** Execute the approved plan
in vertical steps, test-first at the agreed seams (the `tdd` skill). Tick
```
New:
```
**5. Code — a Typist the Crewmate launches.** Once the plan is approved,
the Crewmate launches a Typist with the brief below: at the *mid* tier, or
*cheap* when the plan is mechanical, every change named down to its file
and place. The cascade of `.agents/reference.md`, "Model tiers", resolves
the model. The Crewmate types itself only a retouch of a few lines, or
while the plan is not settled, and writes which and why in the work
document's worklog. The Typist executes the approved plan
in vertical steps, test-first at the agreed seams (the `tdd` skill). Tick
```

### Edit 4 — same file, "Where the work stops", a row after the Crewmate's

Insert after the line
```
| Crewmate | Architect | After the plan; after the close, with its report; on a blocker it cannot rule on |
```
the line:
```
| Typist | Crewmate | After its part of the plan; on anything the plan does not answer |
```

### Edit 5 — same file, "Sub-agents"

Old:
```
- **The Typist** runs on a cheaper model, when there is one.
```
New:
```
- **The Typist** types the approved plan on a cheaper tier than the
  Crewmate's.
```

### Edit 6 — `socle/agents/reference.md`, "Model tiers", the mid and cheap rows

Old:
```
| **mid** | Ordinary work that needs competence but not judgement | A Typist on a delicate plan, or in a codebase it does not know |
| **cheap** | Typing a plan that is settled and mechanical | A Typist |
```
New:
```
| **mid** | Ordinary work that needs competence but not judgement | The Typist, by default |
| **cheap** | Typing a mechanical plan: every change named down to its file and place, nothing left to choose | The Typist, when the plan is mechanical |
```

### Edit 7 — `socle/agents/methodology.md`, the Typist paragraph

Old:
```
Once the plan is approved it is a complete brief, which is what makes a
Typist possible: a cheaper model can type a settled plan. Whether it pays
depends on the models at hand; by default the Crewmate types its own plan,
which is what happened in the field. Either way the brief is **artifacts
only, never the conversation**: explicit references beat shared memory, and
```
New:
```
Once the plan is approved it is a complete brief, which is what makes a
Typist possible: a cheaper model types a settled plan, and the frontier
tier is kept for judgement — the spec, the plan, the review. So the
Crewmate hands the typing to a Typist by default. A Crewmate that types its
own plan pays the frontier price for typing: on 2026-11-03 one of chisel's
own tasks ran 383 calls, all at the frontier tier, none of them a Typist's.
The brief is **artifacts
only, never the conversation**: explicit references beat shared memory, and
```

### Edit 8 — `CHARTER.md`, "The roles", Typist row

Old:
```
| **Typist** | Optional. A sub-agent launched by the Crewmate. | Types code from the approved plan, decides nothing. Worth it when the Typist runs on a cheaper model than the Architect and the Crewmate. By default the Crewmate types itself. |
```
New:
```
| **Typist** | A sub-agent launched by the Crewmate once the plan is approved. | Types code from the approved plan, decides nothing, on a cheaper model than the Architect and the Crewmate: the *mid* tier, or *cheap* when the plan is mechanical. The Crewmate types itself only a retouch of a few lines, or while the plan is not settled. |
```

### Edit 9 — `README.md`

Old:
```
- **The Typist** exists only if you want a much cheaper model to type an
  approved plan. By default, the Crewmate types itself.
```
New:
```
- **The Typist** types the approved plan on a cheaper model: the *mid*
  tier, or *cheap* when the plan is mechanical. The Crewmate types itself
  only a retouch of a few lines.
```

### Edit 10 — `PHILOSOPHY.md`

Old:
```
  implements. A Typist on a cheaper model can type an approved plan, but in
  the field the Crewmates typed their own work, so it is optional.
```
New:
```
  implements. A Typist on a cheaper model types the approved plan: the
  frontier price goes to the judgement, not to the typing.
```

### Edit 11 — the copies

Copy `socle/agents/workflow.md`, `socle/agents/methodology.md` and
`socle/agents/reference.md` over their `.agents/` namesakes.

### Edit 12 — the intention

Create `socle/intentions/unreleased/typist-by-default.md` with exactly the
content of "The intention" in Notes & Snippets below, and add the line
`  "intentions/unreleased/typist-by-default.md",` to `src/socle-files.ts`,
after `"intentions/unreleased/manifest-records-intentions.md",`.

### Gates

`deno task check`, `deno task test`, then
`deno task release-check gate origin/main` once the changes are committed.

## Worklog

- 2026-11-03 — Crewmate: plan and wording written; the edits go to a Typist
  at the *cheap* tier (Haiku), the plan being mechanical. The spec, this
  file, the decisions record and the journal are the Crewmate's own.

## Implementation Checkboxes

- [x] Edits 1–7 in `socle/agents/`
- [x] Edits 8–10 in chisel's own docs
- [x] Edit 11, the copies
- [x] Edit 12, the intention and `src/socle-files.ts`
- [x] Gates green

## Notes & Snippets

### The intention

```
---
id: unreleased/typist-by-default
classification: informational
---

# The Crewmate hands the typing to a Typist

## Goal

The human knows that `.agents/workflow.md` now has the Crewmate launch a
Typist once the plan is approved, at the *mid* tier, or *cheap* when the
plan is mechanical, and type itself only a retouch of a few lines or while
the plan is not settled.

## Why

The workflow said "By default the Crewmate types itself", so nothing sent
the typing to a cheaper model: on 2026-11-03 one of chisel's own tasks ran
383 calls, all at the frontier tier, none of them a Typist's. An approved
plan is a complete brief, and typing it needs no frontier judgement. The
frontier tier stays with the Architect, the Crewmate's plan and the
reviewers.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` says the
  Crewmate types itself by default.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md`, `methodology.md` and
  `reference.md` are managed files and the copy `chisel update` makes
  carries the change; the session only reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it in two
   sentences: once the plan is approved, the Crewmate launches a Typist at
   the *mid* tier, or *cheap* when the plan is mechanical; the cascade of
   `.agents/reference.md`, "Model tiers", resolves the model, so a team
   that wants other models names them in `.agents/project.md`, section H,
   or a dev in `.agents/user.md`. A team whose own instructions say the
   Crewmate types itself reconciles them.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/methodology.md` — **copy**, by the update.
- `.agents/reference.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
```

## Diff-Review Findings

To come.
