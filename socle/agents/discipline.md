# Discipline — the ambient core

These rules apply to **every** conversation in this repo, with or without a
task file. A one-shot fix runs under the same discipline as a sliced feature;
the only difference is the paperwork.

1. **Read before acting.** At session start, read the reading list declared in
   `.agents/project.md` §C (by default the README and the most recent
   journal entries). Say which documents and rules you are working under.

2. **Plan first.** Even for a one-shot fix: say what you are about to do
   before doing it. Nothing half-decided crosses into code. When the work has
   a spec file, the approved plan is PERSISTED into that file before any code
   — how and where is the `plan` step of the formula (see below).

3. **Zone-owner sections are law.** Sections marked 🧑 in any spec file carry
   their owner's decisions — who that is follows the doctrine in
   `.agents/methodology.md` ("Zone ownership"). Never contradict one silently:
   if the work reveals a conflict with a 🧑 zone, stop and surface it.

4. **Verify before "done".** Run the project's gate commands declared in
   `.agents/project.md` §F (lint, tests, build; a browser check when UI
   behaviour changed). Evidence first — red output is reported as red, never
   narrated as green.

5. **The bridge rule.** No spec file for casual conversation or one-shot work.
   But when a conversation turns into real, scoped, multi-step work, recognize
   it and PROPOSE the pipeline (a spec file, the formula) — inform, never
   force. Formality is opt-in; detection is not. Most work should stay
   small: if everything becomes a big feature, review gets diluted and the
   method has failed.

6. **Escalate, don't improvise.** Blocked twice on the same thing, or pushed
   outside the approved plan → stop and ask. Where there is no human to ask,
   escalate one rung — Mason → Architect → Inspector → the Owner's digest —
   and write the blocker into the spec file; never force a passage on your own
   authority. What the digest is: `.agents/methodology.md` ("Escalation, and
   the Owner's digest").

7. **Session hygiene.** Create in one sitting (interview → spec file → slicing
   feed each other); build **fresh**, from the file — that is why the plan is
   persisted. Past roughly 120k tokens an agent reasons worse: don't push
   through, use the `handoff` skill and open a fresh session on its summary.

8. **The repo is the only memory.** Never store project knowledge in a
   harness memory (auto-memory or any equivalent outside the repo); it goes in
   the repo's files, visible to review and git. Lessons about the way of
   working go through `retro` at close.

9. **Read a role's profile before spawning it.** Compose the brief from the
   `Inputs` section of the profile in `.agents/profiles/` you are about to
   spawn — never from habit and never from your own conversation. The
   contract lives with the role that consumes it.

10. **A refused `update` is a redirect.** An agent whose `chisel update` is
    refused for a v1 layout does not stop there: it chains onto the
    `upgrade-v2` skill per the active preset — proposes it in the default,
    runs it under `chisel-supervised` or `chisel-auto`, the new glue
    questions following that preset's gates.

## The pipeline, for real scoped work

The order of steps and the gates live in `.agents/formulas/` — see the block
in `AGENTS.md`. The spec file owns the content and the progress; the formula
owns only the order and the gates; the know-how of each step lives in the
skill that step names.

## Side lanes

Not everything starts as a feature idea:

| Situation | Use | Then |
|---|---|---|
| Something's broken (hard bug, flake, regression) | `diagnosing-bugs` — build a repeatable failing check first, THEN theorize; regression test before the fix | the fix lands as normal work |
| A design question that talking cannot settle | `prototype` — throwaway code, one command to run; keep the answer, delete the code | back into the interview |
| Reading legwork (docs, API facts) | `research` — background agent, cited markdown file | feeds the interview |
| So big and foggy it cannot even be sliced | `wayfinder` — map the open DECISIONS first, resolve them one by one | then the spec file and its slices |
| A spare moment to make the codebase nicer to work in | `improve-codebase-architecture` | produces an idea → normal flow |
| Raw issues coming from an external tracker | `triage` — dormant until one is wired up in `.agents/project.md` §B | → normal flow |

Skills live in `.agents/skills/`. The reasoning behind all of this — why a
reading gradient, why seams, why the plan is persisted, why the review has two
axes — is `.agents/methodology.md`.
