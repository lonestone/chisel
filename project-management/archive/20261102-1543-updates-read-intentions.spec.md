# Updates and installs read intentions

**Status:** done

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

Chisel is agentic, and its own install and update are not. Today `init`
writes first and looks afterwards, and `update` is a script that copies
files; since 0.2.4 it at least refuses what it does not recognise. The
judgement lives only in `chisel-upgrade`, two hand-written recipes for the
two generations a repo may come from, which `update` never reads.

The Owner's direction, 2026-11-02: take the Lonestone boilerplate as the
model. An update reads **intentions**, changelogs written for agents, one
per change of a release. An update must be as smart as the setup: when it
sees that a project keeps things in other folders, it takes initiative and
shows what it does. An install that finds project management already in
place — OpenSpec, Spec Kit, a task folder with files in it — proposes to
the human how to arrange it, before writing anything.

The boilerplate's machinery, for reference: each release ships intentions
in `.boilerstone/migration-intentions/<version>/NN-slug.md`, with an
`unreleased/` folder while they are written; a classification says how
much judgement each needs (`migration`, `breaking-manual`, `informational`,
`no-migration`); `upgrade prepare` stages a disposable workspace holding
the pending intentions, the reference files and a session checklist; an
agent skill applies them; `upgrade record` writes the result into the
project's tracking file.

## Scope

**Included:**
- Intentions shipped per release, in the format the `chisel-upgrade`
  intentions already use, with a classification.
- The manifest records each intention applied or skipped, with the reason.
- `update` takes a **fast path** when it can: the repo is exactly what
  chisel installed and every pending intention needs no judgement. Then it
  copies and records, as today. Otherwise it writes nothing in the
  project's files: it stages a workspace and hands over to an agent skill
  that applies the intentions with judgement.
- `init` takes the same fast path on a repo with nothing to arrange.
  Otherwise the setup inventories what exists and proposes a placement,
  and writes only after the human's ruling.
- The two current recipes become intentions of the releases that made
  those changes.
- Chisel equips itself with the new install, as the proof of slice 02.

**Not Included:**
- Domains, as the boilerplate filters by stack area: chisel has one.
- Fetching releases into git refs: the reference is the published package.
- Publishing: each release stays the Owner's word.

## Acceptance Criteria

The criteria live in each slice's spec document. This task is done when
the three slices are.

## Seams

- **`chisel update`** — fast path: copies, records, exit 0. Otherwise:
  no write outside the workspace, the checklist printed, a distinct exit
  code that says "an agent has work to do".
- **`chisel init`** — the same split.
- **`chisel record`** — writes one intention's result into the manifest.
- **The update skill** — applies the checklist of a staged workspace.
- **The setup skill** — inventory and placement before the first write.

## Architecture

**System design:** the CLI keeps the bookkeeping — stage, list, record,
check — and the fast path. Every move that needs judgement is an
intention an agent applies, shown to the human, validated on the diff.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

- **Owner, 2026-11-02:** a scripted fast path stays for the exact case;
  everything else goes through intentions. The breakdown is the three
  slices below.
- **Classifications:** `automatic` (the fast-path copy closes it),
  `migration` (an agent applies it with judgement), `breaking-manual` (a
  human decides before anything moves), `informational` (read, nothing
  to do).
- **A repo's baseline:** `init` at version X records every intention up
  to X as applied; only later ones are pending.
- **The workspace is disposable and never committed**; `update` refuses
  to overwrite one that exists, as the boilerplate's `prepare` does.

## Testing Strategy

- Fixtures per starting case: fast path, a moved folder, a pending
  `migration` intention, an install on a repo with OpenSpec, Spec Kit, or a
  task folder with files.
- The prose of intentions and skills is read at the review, never pinned
  by a test.

## Slices & Dependencies

Folder: `project-management/tasks/20261102-1543-updates-read-intentions/`.

1. **01 — Update reads intentions** (blocked by: none)
2. **02 — Install arranges what it finds** (blocked by: 01)
3. **03 — The two recipes become release intentions** (blocked by: 01)

## Deliverables

- [x] The three slices, each closed.

## References

- Lonestone boilerplate, `.boilerstone/docs/upgrade-runbook.md` and
  `how-it-works.md`: the consumer side of intentions.
- `.boilerstone/migration-intentions/TEMPLATE.md`: the format.
- `socle/agents/skills/chisel-upgrade/`: the two recipes of 0.2.4.
- `project-management/archive/20261102-1439-make-update-refuse-what-it-does-not-recognise.spec.md`:
  the refusals this builds on.
- `project-management/tasks/20260826-2302-chisel-dogfoods-itself.spec.md`:
  the older dogfood task slice 02 replaces.

## Notes

## Retrospective

Closed 2026-11-03, after slice 03.

**What held.** Taking the boilerplate as the model gave the three slices one
shape: `update` and `init` take a fast path when nothing needs judgement and
stage a workspace otherwise, and the judgement lives in pages an agent
reads, never in the CLI. Removing `chisel-upgrade` left nothing behind it:
its content is in the 0.2.0 intentions and `baseline`, and the integrity
test asserts no installed page names the retired layer.

**What cost.** The record of chisel itself predated the 0.2.0 intentions,
so the dogfood had to record them by hand; real repos on 0.2.4 never wrote
`intentions` and get the baseline record instead. Prose about the CLI
drifted from the CLI twice ("the close records the baseline", a step cited
by number): both found only by the fresh review.

**Proposals, for the Owner to rule on.**
1. *A claim a page makes about what a command writes is checked against
   `src/` at review*, as a standing line of the Standards reviewer's brief.
   Twice in this task the review caught it; nothing else would.
2. *The releases themselves follow the boilerplate*: Release PR, intention
   gate, promotion checked before merge, publishing from CI. Opened as its
   own task, "Chisel releases through a Release PR, after the boilerplate".
3. *Detecting a first-version layer outside `.agents/` beside a manifest*:
   the code does not, the page now says so. Worth a slice only if a repo
   in that state turns up.
