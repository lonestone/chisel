# The codebase-audit skill: the 360 review's protocol, distilled

**Status:** in-progress

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a new skill of chisel's own, `codebase-audit`, under
`socle/agents/skills/codebase-audit/`, that makes an agent run a whole-repo
audit the way the 360 review of this repo was run on 2026-08-27: several
**finders** read the material **blind**, one per **lens**, in parallel;
every serious **claim** is verified before it is asserted; the findings are
**triaged** against the audits and rulings that came before, so nothing
already decided is litigated again; one **report** is written into the
repo; and the human decides **block by block**, one question at a time,
with the auditor's recommendation in each. The skill stops at the decisions
and the action plan they form — it fixes nothing itself; each decision
becomes a task through the normal path (interview, spec). Written according
to the `writing-great-skills` skill, registered in the installer's file
list and in the golden tree, so that `chisel init` ships it.

**Rulings applied** (from `project-management/review-360-decisions.md`; in
this file each is named by what it says, the code riding beside the name):

- **G4, distil a codebase-audit skill** (2026-08-27): "`socle/agents/skills/codebase-audit/`,
  en anglais, distillé du protocole de cette session : finders indépendants
  à l'aveugle, un par lentille (paramétrables selon le projet) →
  vérification des claims graves avant affirmation → tri contre les audits
  antérieurs et les arbitrages Owner (nouveau / correctif raté / déjà tranché
  — on ne re-litige pas) → rapport → décisions bloc par bloc, une question à
  la fois, recommandation incluse. Écriture selon `writing-great-skills`."
  Plan item 8.
- **G19, a code never travels alone** (Addendum 7): the audit that produced
  this skill also produced the codes (A1, F1.4, S2) the Owner could no
  longer place weeks later. The skill's report and decisions record name
  every block and finding by what it says; a code, if kept for
  cross-reference, rides beside the name.
- **G17, the repo is the only memory** (Addendum 4): the report and the
  decisions are files in the repo, never an assistant's memory or a chat
  artefact alone.
- **G2, no numeric limit in shipped text; G3, English.** Rule 11 of
  `socle/agents/discipline.md` (name by meaning, cite by file and section
  title, never a line number) binds every line of the skill.

**Process, ruled by the Owner** (Addendum 6 of the decisions record, the
fast track, extended by the Owner to chantier 4 and applied here by the
Foreman: a skill is prose, and the Foreman ran the protocol it distils): the
Foreman wrote this spec; one agent plans in the work document, then types
all of it and keeps the work document; the Foreman reviews on both axes. No
Architect or Inspector sub-agents. The Foreman moves this spec's status:
`ready` now, `in-progress` when the agent starts, `done` at close.

## Scope

In:

- **The skill file** `socle/agents/skills/codebase-audit/SKILL.md`, with
  frontmatter `name: codebase-audit`, a human-facing one-line `description`,
  `disable-model-invocation: true` (an audit is always a human's decision to
  run; nothing fires it on its own, so it pays no context load — the
  `writing-great-skills` rule on invocation), and **no `x-upstream`** block:
  this skill is chisel's own, like `chisel-beads` and `chisel-setup`.
- **The protocol as ordered steps**, each ending on a checkable completion
  criterion, in this order:
  1. **Frame.** What is audited (a repo, a socle, a subsystem — the human
     names it), which lenses (the default set below, which the human trims
     or extends: one question, recommendation included), and what came
     before — the prior audits, decisions records and ADRs the triage will
     read against, located through `.agents/project.md` (§A · Task
     workspace and §G · Glossary and decisions) and by asking the human
     what else exists. Criterion: scope, lens list and prior-record list
     written down before any finder starts.
  2. **Finders, blind, one per lens, in parallel.** Each finder is a
     sub-agent at the frontier tier (resolved through the cascade in
     "Model tiers" of `.agents/reference.md`), briefed with its lens and
     the material only — not the other lenses, not the prior records: blind
     means it finds on its own, and agreement between blind finders is
     evidence. Each returns findings, one per line of argument: the claim,
     where (file and section title, or the quoted line), severity as the
     finder sees it, and how a reader would verify it. Criterion: every
     file in scope read by every finder whose lens applies to it, stated
     as a list, not a summary.
  3. **Verify.** Every claim that would change a decision or accuses the
     code of a behaviour is reproduced by the auditor before it is asserted
     — run the command, read the line, diff the two files; what cannot be
     reproduced is kept as "unverified" and says so. Criterion: no serious
     claim in the report without its reproduction or its "unverified" mark.
  4. **Triage against what came before.** Each finding is classed **new**,
     **a fix that did not take** (an earlier ruling meant to remove it and
     it is still there — named with that ruling), or **already ruled** (the
     human decided otherwise; listed once for the record and not argued
     again). Duplicates across lenses merge, keeping the stronger
     reproduction. Criterion: every finding carries one of the three
     classes.
  5. **Report.** One file in the repo, in the task workspace's root
     declared in §A of `.agents/project.md`, named
     `<YYYYMMDD>-audit-<scope>.md`, blocks by subject, each block and each
     finding named by what it says, cited by file and section title, with
     its class and its verification status; a code, if the human wants one
     for cross-reference, rides beside the name. Criterion: the file
     exists, every finding of step 4 is in it, none without a citation.
  6. **Decisions, block by block.** The auditor interviews the human with
     the `grilling` skill's discipline — one question per block, the
     recommended answer inside it, the human's own words kept in their
     language — and writes each decision as it lands into a decisions
     record beside the report (`<YYYYMMDD>-audit-<scope>-decisions.md`),
     each decision named by what it decided, with a plain-word state (to
     decide, decided, deferred). Decisions are the human's; facts are
     looked up, not asked. Criterion: every block has a decision or a dated
     deferral, and the record ends with the action plan — the ordered list
     of chantiers the decisions form, each to become a task by the normal
     path. The skill stops there.
- **The default lens set**, parameterizable at step 1, each lens one line
  saying what the finder hunts: **joints** (every pointer resolves — a
  path, a section title, a name that must exist); **contradictions** (one
  subject settled two ways in two places); **over-claims** (a document
  claims a behaviour the code or its tests do not have); **sediment**
  (layers left behind by past changes — dead options, stale labels, orphan
  files, a template quoting its own history); **behaviour** (the code
  against its tests and its stated contract — bugs, untested paths, a test
  that proves nothing); **cold reader** (what a reader arriving weeks later
  cannot place — jargon, invented labels, codes travelling alone). Where
  the lens set sits on the information hierarchy — inline in `SKILL.md`,
  or disclosed to a sibling file such as `LENSES.md` with the finder brief
  — is the agent's call under the `writing-great-skills` rule (inline what
  every run needs; disclose what only some runs reach), and the work
  document says why.
- **The skill's own form**, judged against `writing-great-skills` and its
  glossary: leading words (lens, blind, claim, triage, block) used and not
  restated; no sentence that fails the no-op test; the positive stated
  where a prohibition tempts; one source of truth per meaning (the
  `grilling` skill is pointed at for the interview discipline, never
  paraphrased; the `code-review` skill is named as the diff-scale sibling
  this audit is not). The work document records the pass: each failure
  mode of `writing-great-skills`, and what was cut or reworded for it.
- **Registration**: the new file or files added to `SOCLE_FILES` in
  `src/socle-files.ts` in the list's existing order, and to
  `test/fixtures/golden-tree.txt` (the directory line and one line per
  file, in the tree's existing order). The `init` and `boilerplate` tests
  compare the installed tree to that golden; the `integrity` test checks
  every `.agents/…` pointer and sibling link in the new text resolves.
- **`test/TESTS.md`**: untouched unless a group's one-line description
  stops being true; the agent says so in the work document either way.

Out:

- Any change to `code-review`, `retro`, `grilling`,
  `improve-codebase-architecture` or `writing-great-skills`: the new skill
  points at them, it does not edit them.
- Any mention of the skill in `methodology.md`, `reference.md`, `README.md`
  or the formulas: the skill is user-invoked and found by its name; if a
  place clearly owes it a sentence, the work document proposes the sentence
  and the Foreman rules at review.
- Running an audit: the skill is written, not exercised on this repo. Its
  first real run is a later decision of the Owner.
- The two Owner files under `project-management/` (notes and analysis of
  the 360 review): never opened, never cited in shipped text. The skill
  distils the protocol as the decisions record describes it, not those
  files.
- `CHANGELOG.md` (the Foreman writes the entry at close), archived tasks,
  the templates, `deno.json`.
- Chantier 6, the wayfinder local-first, and the two chores the status
  model left (done files sleeping in `tasks/`, the archive rule's case for
  a partly-done parent).

## Acceptance criteria

Each is command-verifiable; record the before-value and the after-value in
the work document. "Before" is HEAD at the start of the chantier.

- [ ] **skill-exists** — `socle/agents/skills/codebase-audit/SKILL.md`
      exists; its frontmatter has `name: codebase-audit`, a `description`,
      `disable-model-invocation: true`, and `grep -c "x-upstream"` on it
      → 0.
- [ ] **protocol-ordered** — `SKILL.md` has six numbered steps in the order
      Frame, Finders, Verify, Triage, Report, Decisions (headings or list
      items whose text contains those words in that order), and each step's
      text contains "Criterion" or "Done when" (one checkable completion
      criterion per step).
- [ ] **triage-classes** — the skill text names the three classes: `grep
      -c "new"`, `grep -ci "did not take"`, `grep -ci "already ruled"` on
      the skill folder each ≥ 1.
- [ ] **lenses-named** — the six default lenses appear in the skill
      folder: `grep -rci` for each of `joints`, `contradictions`,
      `over-claims`, `sediment`, `behaviour`, `cold reader` ≥ 1.
- [ ] **siblings-pointed** — `grep -c "grilling"
      socle/agents/skills/codebase-audit/SKILL.md` ≥ 1 and `grep -c
      "code-review"` ≥ 1; `grep -rn "one question at a time"
      socle/agents/skills/codebase-audit/` → 0 (the discipline is pointed
      at, not paraphrased).
- [ ] **names-not-codes** — the skill text says findings and blocks are
      named by what they say and that a code rides beside the name: `grep
      -ci "beside"` ≥ 1; `grep -rn "S7\.\|G4\|G17\|G19\|review-360\|chantier"
      socle/agents/skills/codebase-audit/` → 0.
- [ ] **repo-is-memory** — the skill names the report file pattern and the
      decisions file pattern: `grep -c "audit-" SKILL.md` ≥ 2, and `grep -c
      "project.md" SKILL.md` ≥ 1 (paths resolve through the glue).
- [ ] **registered** — every file under `socle/agents/skills/codebase-audit/`
      is listed in `src/socle-files.ts` and, as `.agents/skills/codebase-audit/…`,
      in `test/fixtures/golden-tree.txt`, which also lists the directory;
      `wc -l test/fixtures/golden-tree.txt` = 91 + 1 + the number of files
      (today 91).
- [ ] **wgs-pass-recorded** — the work document has a section naming each
      failure mode of `writing-great-skills` (premature completion,
      duplication, sediment, sprawl, no-op, negation) with what was done
      about it in this skill.
- [ ] **suite-green** — `deno task test` → every test passes (25 today,
      record the count); `deno task check` → clean; `git diff --check`
      clean.
- [ ] **nothing-else-moved** — `git diff --stat <start>..HEAD` touches
      only: files under `socle/agents/skills/codebase-audit/`,
      `src/socle-files.ts`, `test/fixtures/golden-tree.txt`, `test/TESTS.md`
      (only if a description stopped being true), and this task's pair.

## Files map (indicative; judged after the fact)

Create: `socle/agents/skills/codebase-audit/SKILL.md`, and any disclosed
sibling the agent justifies (for example `LENSES.md`).
Modify: `src/socle-files.ts`, `test/fixtures/golden-tree.txt`.
Avoid: every other skill, `socle/agents/*.md`, the formulas, the templates,
`src/` beyond the file list, `test/` beyond the golden tree and `TESTS.md`,
`README.md`, `PHILOSOPHY.md`, `project-management/` beyond this task's pair.

## Verification

Run the criterion commands before typing and record the before-values; run
them again at the end and write after beside before. `deno task test`,
`deno task check` and `git diff --check` before each commit. Read the
finished skill once as a cold reader would — someone who never saw the 360
review — and record in the work document the three places that made them
stop, with what was changed for each. Commit in small steps: the skill, the
registration, the work document's close.

## Notes

Written by the Foreman on 2026-09-15 under the Owner's fast-track ruling
(Addendum 6 of the decisions record), on the Owner's "go" after the status
model chantier closed. The protocol is what the Foreman ran on 2026-08-27
as described by ruling G4 and by the shape of the decisions record itself
(blocks A to G, one decision per block, taken out loud with the Owner one
question at a time, statuses to decide / decided / deferred). Pointers in
shipped text use the installed form (`.agents/…`), never `socle/…`. Deno is
at `~/.deno/bin/deno`, not on the default `PATH`. Every amendment to this
file: strike the original, date the new version below it.
