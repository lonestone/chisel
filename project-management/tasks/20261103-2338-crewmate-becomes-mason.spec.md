# The Crewmate becomes the Mason, and the Typist ticks only what really ran

**Status:** ready

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

Two requests from the Owner, Pierrick, on 2026-11-03.

**The rename.** In the Harness that runs chisel's projects, "crewmate"
names the per-task session a secondmate launches, and that session plays
chisel's **Architect**. Chisel used the same word for the sub-agent the
Architect launches to plan and close a task. One word for two roles made a
plan reading get skipped (task chisel-intentions). The Owner's words:
"Chisel must not talk about a crewmate. Architect → Mason → Typist." The
**Mason** is the Harness's builder: the sub-agent the Architect launches to
build.

**The Typist line.** A project equipped with chisel reported, on task
id-by-rivoli: a Typist ticked "run charger.py for real" after running it
only on a throw-away test base. The work document's checkboxes are a fresh
session's resume point, so a false tick skips a step without anyone
seeing it.

## Scope

**Included:**
- Rename the role Crewmate → Mason, and every derived word ("The Crewmate
  brief", "Crewmates", the `crewmate` actor of `chisel-beads`), in: the
  socle (`socle/agents/`, `socle/templates/`), its dogfooded copy
  (`.agents/`), `AGENTS.md`, `README.md`, `PHILOSOPHY.md`, `CHARTER.md`,
  the task templates of `project-management/`.
- One line in "The Typist brief" of `workflow.md`: a box is ticked only
  for what really ran, on the real target; a dry run or a run on a copy
  is written in the worklog.
- A `migration` intention in `socle/intentions/unreleased/`, listed in
  `src/socle-files.ts`: an equipped repo renames "Crewmate" in its own
  files (its `.agents/project.md`, open specs and work documents, its own
  skills); the managed files arrive by the update's copy.

**Not Included:**
- History keeps its words: `CHANGELOG.md`, `project-management/archive/`,
  `project-management/JOURNAL.md`, `project-management/review-360-decisions.md`,
  the published intentions (`socle/intentions/0.2.0/`, `0.3.0/`), their
  file names in `src/socle-files.ts`, and the intention ids recorded in
  `.agents/.chisel.json`.
- Any change of what the role does. Only its name changes.

## Acceptance Criteria

- [ ] **no-crewmate-outside-history** — `git grep -il crewmate` lists only
  the history files of "Not Included", the new intention (it names the
  old word to find it), and this task's own documents.
- [ ] **no-crewmate-idea-left** — a case-insensitive `git grep -w crew`
  outside history finds nothing that names the role.
- [ ] **typist-ticks-what-ran** — "The Typist brief" of
  `socle/agents/workflow.md` carries the tick rule: real run, real target,
  dry run or copy in the worklog.
- [ ] **socle-copy-identical** — `diff -r .agents socle/agents` shows only
  `.chisel.json`, `project.md`/`project.md.tpl` and `skills/chisel-release`.
- [ ] **intention-ships** — `socle/intentions/unreleased/crewmate-becomes-mason.md`
  follows `socle/intentions/TEMPLATE.md`, classification `migration`, and
  is listed in `src/socle-files.ts`.
- [ ] **gates-green** — `deno task check` and `deno task test` pass.

## Seams

- The managed socle files an equipped repo receives — the role reads
  "Mason" everywhere a repo installs or updates.
- The intention — the page an update session reads to rename the word in
  the project's own files.

## Architecture

**System design:** a word swap across prose, plus one sentence and one new
intention. The socle under `socle/` is the source; `.agents/` is its copy
and is kept byte-identical for the shared files.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

- **The word.** "Mason" in English, capitalised like the other roles;
  plural "Masons"; the brief section is "The Mason brief"; the
  `chisel-beads` actor is `mason`.
- **Read, not replaced blindly.** A sentence where the swap reads badly
  ("a Mason", article and rhythm) is rewritten, not just patched.
- **The tick rule** sits in "The Typist brief" as a positive bullet; step
  5 of `workflow.md` keeps "tick as work lands" and does not repeat it.
- **The intention's classification** is `migration`: an agent acts on the
  project's own files, the human validating each rename. Its old state
  signal is `git grep -i crewmate` outside the managed files and the
  project's history.
- Prose written for agents passes through the `writing-for-agents` skill.

## Testing Strategy

- No test reads the prose. The criteria above are greps and diffs; the
  existing suite guards `src/socle-files.ts` and the intention format.

## Slices & Dependencies

- **Slices:** one pass.

## Deliverables

- [ ] The renamed socle and its copy, the docs and templates
- [ ] The Typist line
- [ ] The intention
- [ ] A pull request in conventional commits

## References

- `.agents/workflow.md`, "The roles" and "The Typist brief" — the role and
  the brief to change.
- `CONTRIBUTING.md`, "Intention authoring" — how an intention ships.
- `socle/intentions/TEMPLATE.md` — the intention format.

## Notes

## Retrospective
