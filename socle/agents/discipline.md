# Discipline — the ambient core

These rules apply to **every** conversation in this repo, with or without a
task artifact. A one-shot fix runs under the same discipline as a sliced feature;
the only difference is the paperwork.

1. **Read before acting.** At session start, read the reading list declared in
   `.agents/project.md` §C (by default the README and the most recent
   journal entries). Say which documents and rules you are working under.

2. **Plan first.** Even for a one-shot fix: say what you are about to do
   before doing it. Nothing half-decided crosses into code. When the work has
   a spec document, the program design is PERSISTED into its matching work
   document before any code — a draft at `plan`, validated at `plan-review`
   where the formula runs one; how and where is the `plan` step of the
   formula (see below).

3. **Zone-owner sections are law.** Sections marked 🧑 in any spec document
   carry their owner's decisions — who that is follows the doctrine in
   `.agents/methodology.md` ("Zone ownership"). Never contradict one silently:
   if the work reveals a conflict with a 🧑 zone, stop and surface it.

4. **Verify before "done".** Run the project's gate commands declared in
   `.agents/project.md` §F (lint, tests, build; a browser check when UI
   behaviour changed). Evidence first — red output is reported as red, never
   narrated as green.

5. **The bridge rule.** No task artifact for casual conversation or one-shot work.
   But when a conversation turns into real, scoped, multi-step work, recognize
   it and PROPOSE the pipeline (a spec document and its formula) — inform, never
   force. Formality is opt-in; detection is not. Most work should stay
   small: if everything becomes a big feature, review gets diluted and the
   method has failed.

6. **Escalate, don't improvise.** Blocked twice on the same thing, or pushed
   outside the approved plan → stop and ask. A sub-agent reports to its
   **spawner** — the owner of the thread of work it was spawned into, which
   decides within what it owns; above the thread owner sits the human, and
   nothing else. Every blocker, in every mode, leaves a written trace in the
   task's own documents, signed with its author's role plus the date and the
   time, and the ruling on it is recorded in the same place — the form and
   the destinations are `.agents/methodology.md` ("Escalation, and the
   blocked-task report"). Never force a passage on your own authority.

7. **Session hygiene.** Create in one sitting (interview → spec document → slicing
   feed each other); build **fresh**, from the spec/work pair — that is why the
   plan is persisted. The pair is the unit of context: resume from the spec and
   work documents, never an ambiguous "the file". Past roughly 120k tokens an agent
   reasons worse: don't push through, use the `handoff` skill and open a fresh
   session on its summary.

8. **The repo is the only memory.** Never store project knowledge in a
   harness memory (auto-memory or any equivalent outside the repo); it goes in
   the repo's files, visible to review and git. Lessons about the way of
   working go through `retro` at close.

9. **Read a role's profile before spawning it.** Compose the brief from the
   `Inputs` section of the profile in `.agents/profiles/` you are about to
   spawn — never from habit and never from your own conversation. The
   contract lives with the role that consumes it. This duty belongs to the
   owner of the thread — the Foreman, whose contract is
   `.agents/profiles/foreman.md`.

10. **A session opened to execute a step takes that step's role.** A fresh
    session started to run a step of the pipeline — `work on slice
    <spec-document>` and its kin — reads that step's role profile in
    `.agents/profiles/` before acting, and works under it for the whole
    session. The profile is the contract whether the session was spawned or
    opened by hand: rule 9 binds the side that delegates, this one binds the
    side that arrives.

11. **A section reference names its file and its title.** When a document you
    write or edit cites a section of another file, the first mention carries
    both — "§A · Task workspace of `.agents/project.md`" — never a bare
    number; later mentions in the same document may shorten it. A reader must
    know where to go without searching.

## The pipeline, for real scoped work

The order of steps and the gates live in `.agents/formulas/` — see the block
in `AGENTS.md`. The spec document owns requirements and sole status; the work
document owns program design and implementation progress. The formula owns
only the order and gates; the know-how of each step lives in the skill that
step names.

## Side lanes

Not everything starts as a feature idea:

| Situation | Use | Then |
|---|---|---|
| Something's broken (hard bug, flake, regression) | `diagnosing-bugs` — build a repeatable failing check first, THEN theorize; regression test before the fix | the fix lands as normal work |
| A design question that talking cannot settle | `prototype` — throwaway code, one command to run; keep the answer, and keep the code on a throwaway branch out of main with a pointer to that branch | back into the interview |
| Reading legwork (docs, API facts) | `research` — background agent, cited markdown file | feeds the interview |
| So big and foggy it cannot even be sliced | `wayfinder` — map the open DECISIONS first, resolve them one by one | then the spec document and its slices |
| A spare moment to make the codebase nicer to work in | `improve-codebase-architecture` | produces an idea → normal flow |

Skills live in `.agents/skills/`. The reasoning behind all of this — why a
reading gradient, why seams, why the plan is persisted, why the review has two
axes — is `.agents/methodology.md`.
