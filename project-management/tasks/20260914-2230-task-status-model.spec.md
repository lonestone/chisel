# The task status model: one ladder, thirteen values, the human's wait named

**Status:** in-progress

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the six emoji statuses of a task (🔴 Not Started … ⚫
Cancelled) are replaced, everywhere the socle and this repo's workspace
speak of them, by one linear ladder of thirteen plain values. Nine sit on
the path a task walks — `creating`, `waiting-business-approval`,
`waiting-design-approval`, `ready`, `planning`, `waiting-plan-approval`,
`in-progress`, `waiting-diff-approval`, `done` — and four can replace any of
them — `blocked`, `stalled`, `deferred`, `cancelled`. Every value that waits
on a human is named by what the human must do, so a search for `waiting-`
across the workspace answers "where am I needed". The value is written
alone, `**Status:** waiting-design-approval`, no emoji before it. The
vocabulary lives once, in the spec template's status table; every step of
every formula says which value it leaves the task in; the thread owner alone
writes it; the beads skill stores the same values natively in the database
through bd's custom statuses, with two spelling translations and no other
mapping. Every status line in this repo's task workspace and archive is
rewritten to the new vocabulary.

**Rulings applied** (from `project-management/review-360-decisions.md`,
"Addendum 8 (2026-09-10) — chantier 7, le modèle de statuts des tâches",
decisions S7.1 to S7.8, and the original "F1 — Mineurs" point 4, "Statuts :
discussion dédiée à ouvrir"). In this file each is named by what it says;
the code rides beside the name, never alone:

- **S7.1, one ladder, not two axes.** The status is a single value from a
  linear list; blocked and stalled take their place in it like the others.
  The maturity a task had when it blocked is read from the file itself
  (criteria ticked, work present), not from the status.
- **S7.2, the values, and each human wait named by the human's act.** The
  nine-plus-four list above, kebab-case, "usable by humans" and portable to a
  tracker as they are. "Design" means the system design of the spec — seams,
  architecture, decisions — never UI design; every task has one. Business
  and design stay two successive values because in a team they are two
  people.
- **S7.3, one ladder for every workflow; each formula picks its path.** The
  values live once; each step body says where it leaves the task. Default
  walks every value; supervised stops only at the two spec waits; auto
  skips the four human waits (no gate, no wait). Splitting the `spec` step
  in two gated steps, where two roles approve, is a formula variant for
  later, not a value: it would pose the same two waits.
- **S7.4, the thread owner writes the status at step boundaries.** The
  Mason never touches the spec's status. `blocked` is written by the thread
  owner when a session reports a block (the channel of "Addendum 3 —
  arbitrage S1 : la trace des blocages"); `deferred` and `cancelled` by a
  human, by hand.
- **S7.5, `stalled` is a human's call, later an AI orchestrator's.** No
  formula step can write it. The criterion is written in the template:
  nobody is advancing it, nothing named is awaited, nobody intends to resume
  soon. No tooling in this chantier.
- **S7.6, the value alone.** No emoji before it, no marker per family.
- **S7.7, under beads the fine value lives in the bead, natively.** Probed
  on bd 1.2.2 (details in the decisions record): `bd config set
  status.custom "name:category,…"` with categories active / wip / frozen /
  done; `bd list` honours the categories and `bd list --status <x>` filters
  on any value; `blocked` and `deferred` are built-ins with the same names;
  `bd ready` sees only the built-in `open`, so our `ready` is written `open`
  in the database and `bd ready` stays the Mason's frontier command; our
  `in-progress` is written `in_progress`, bd's built-in that `--claim`
  sets. These are the only two translations. The line `**Status:** tracked
  as <id>` stays the sole place of a tracked task's status.
- **S7.8, every status line in the repo is rewritten by hand; the mapping
  is published for consumer repos, untooled.** 🔴 Not Started → `creating`
  or `ready` by the real state of the spec (or `in-progress` for a parent
  whose slices are partly done); 🟡 In Progress → `in-progress`; 🟠 Blocked
  → `blocked`; 🟢 Complete / Done / Delivered → `done`; ⚪ → `deferred`; ⚫ →
  `cancelled`; the free text after the value (date, reason) is kept.

Transverse rulings that bind every shipped line: G3 (English), the writing
rule of `socle/agents/discipline.md` rule 11 (name by meaning, cite by file
and section title, never a line number), and no ruling code, no
"S7.4"-style label, no decisions-record file name in shipped text.

**Process, ruled by the Owner** (Addendum 6 of the decisions record, the
fast track, extended by the Owner to chantier 4 and applied here by the
Foreman, prose and templates being lower-risk than code): the Foreman wrote
this spec; one agent plans in the work document, then types all of it and
keeps the work document; the Foreman reviews on both axes. No Architect or
Inspector sub-agents. The Foreman moves this spec's own status, dogfooding
the model: `ready` now, `in-progress` when the agent starts, `done` at
close.

## Scope

In:

- **The template's status section**, in both copies
  (`project-management/000-template.spec.md`, the dogfood copy, and
  `socle/templates/000-template.spec.md`, the shipped copy — the two differ
  today only by one link path each, and must still differ only by that).
  "Status Indicators" becomes "Statuses": one table of the thirteen values,
  each with its meaning and, for the nine on the path, the pipeline moment
  that leaves a task there; a sentence after it for each of: the value is
  written alone on the `**Status:**` line; the thread owner alone writes it,
  at step boundaries, as each formula step says; `stalled` and its
  criterion; the four off-path values replace the on-path one. The template
  skeleton's `**Status:** [Status Emoji & Text]` becomes `**Status:**
  creating`. The migration table of the old six emoji to the new values
  sits at the end of that section, in one short table, for consumer repos
  that update by hand.
- **Every formula step names the status it leaves the task in**, in the
  five presets under `socle/agents/formulas/`, as the last line of each
  step's body, in one fixed form: `Status after this step: \`<value>\`.`
  The rule that produces the value: a step that ends at a human gate leaves
  the task in that gate's `waiting-…` value; a step with no gate after it
  leaves the task in the next active value. For the default preset that
  reads: `interview` → `creating` (the spec is born with it at `spec`);
  `spec` → `creating`; `spec-review` → `waiting-business-approval` (the
  human then writes `waiting-design-approval`, then `ready`, by hand, as
  each approval lands — the step body says so); `plan` → `planning`;
  `plan-review` → `waiting-plan-approval`; `type` → `in-progress`; `verify`
  → `in-progress`; `diff-review` → `waiting-diff-approval`; `close` →
  `done`. The other four presets follow the same rule against their own
  gates; the work document lists the nine values per preset before typing.
  The supervised preset's header comment "the status of the spec document
  becomes `awaiting approval`" says `waiting-business-approval` instead.
- **The glue template** `socle/agents/project.md.tpl`, §B1 · Where task
  statuses live: the `**Status:**` bullet names the template's status table
  instead of six emoji; the "Work the frontier" bullet says a task is on
  the frontier when its status is `ready`.
- **The beads skill**, `socle/agents/skills/chisel-beads/`: `SKILL.md` says
  the database carries the same thirteen values, `bd ready` is the Mason's
  frontier (open and nothing open upstream), `bd list --status <value>`
  answers for every other value, and names the two translations.
  `CHANGING-CASE.md`: a new step of the files → database move declares the
  custom statuses, verbatim `bd config set status.custom
  "creating:active,waiting-business-approval:active,waiting-design-approval:active,planning:wip,waiting-plan-approval:wip,waiting-diff-approval:wip,stalled:frozen,done:done,cancelled:done"`,
  before Pass 1; Pass 1 reads the new values (`done` and `cancelled` left
  alone; every other value creates a bead and is handed over as itself,
  `ready` as `open`, `in-progress` as `in_progress`); the reverse move
  restores the fine value on the `**Status:**` line with the two
  translations reversed. The sentence "This is now the one and only place
  that file's status lives" stays.
- **The slice template** in `socle/agents/skills/slice-task/SKILL.md`:
  `**Status:** creating`.
- **The setup questionnaire**, `socle/agents/skills/chisel-setup/SKILL.md`,
  "§B1 — ask this, verbatim": the cost sentence of option 1 ("nothing can
  tell an agent 'these three tasks are ready to start' without reading them
  all") is no longer true once `ready` is a searchable value; it is
  replaced by the true cost (blocking edges are read from the files, one by
  one; a search answers only what a status line says).
- **The reasoning**, in `socle/agents/methodology.md`: a short section,
  titled by its subject (for example "The status of a task"), giving why
  one ladder, why each human wait is named by the human's act, why the
  thread owner alone writes it, and why the value carries no emoji. The
  formula header says the reasoning belongs there; this is where it goes.
  `socle/agents/reference.md`'s glossary gains a **Status** row pointing at
  the template's table.
- **The workspace migration**, by hand, per S7.8: every `**Status:**` line
  under `project-management/tasks/` and `project-management/archive/`
  (43 lines today) rewritten with the mapping above, free text kept. The
  six files still open (`chisel-v1` parent and its slices 06 and 07,
  `chisel-v2` parent and its slice 06, `chisel-dogfoods-itself`) are judged
  one by one and the judgment recorded in the work document with one line
  of reason each; the Foreman reviews those six.
- **`PHILOSOPHY.md`**: not opened, but if it makes a claim this chantier
  falsifies, report it in the work document.

Out:

- The seventeen Complete/Done files that sleep in `project-management/tasks/`
  instead of the archive: their statuses are rewritten like the others, but
  they are not moved. Moving them is not mechanical (a parent folder holds
  done and open slices together, and the archive rule moves a parent with
  its whole folder); it is a separate chore, reported in the work document.
- Any tooling: no command detects `stalled`, no command rewrites status
  lines, `chisel check` and `chisel update` do not read them. `src/` and
  `test/` are not opened; the test fixture `test/fixtures/brownfield-v1/`
  keeps its old-style status lines, it is test data for a v1 repo.
- The two-pass spec formula variant (business approved before the design is
  written): noted as a future extension in the methodology section, not
  written.
- Trackers other than beads (Plane, Linear…): B2's adapter-page mechanism
  is untouched; the methodology section may say in one sentence that an
  adapter maps the thirteen values to its tracker's states.
- Archived task files' content beyond their status line; Owner files under
  `project-management/` other than this task's pair; `CHANGELOG.md` (the
  Foreman writes the entry at close).
- Chantiers 6 and 8 of the plan.

## Acceptance criteria

Each is command-verifiable; record the before-value and the after-value in
the work document. "Before" is HEAD at the start of the chantier.

- [ ] **emoji-gone** — `grep -rn "🔴\|🟡\|🟠\|🟢\|⚪\|⚫" socle/
      project-management/000-template.spec.md
      project-management/000-template.work.md` → nothing (today 18 lines in
      5 files).
- [ ] **vocabulary-once** — the "Statuses" table of
      `socle/templates/000-template.spec.md` has exactly thirteen value
      rows, each value in backticks, and `grep -c "waiting-" ` on that file
      ≥ 4; `diff project-management/000-template.spec.md
      socle/templates/000-template.spec.md` shows only the one link-path
      line each way that differs today (record the diff).
- [ ] **formulas-name-status** — for each of the five files
      `socle/agents/formulas/*.formula.toml`, `grep -c "^Status after this
      step:" <file>` equals `grep -c "^\[\[steps\]\]" <file>`, and every
      value named is one of the thirteen; `grep -rn "awaiting approval"
      socle/` → nothing (today 1).
- [ ] **glue-b1** — in `socle/agents/project.md.tpl`, the `**Status:**`
      bullet of §B1 contains no emoji and names the spec template; the
      frontier bullet contains `ready`.
- [ ] **beads-native** — `grep -c "status.custom" 
      socle/agents/skills/chisel-beads/CHANGING-CASE.md` ≥ 1 and the
      verbatim config string above appears once; `grep -n "in_progress"
      socle/agents/skills/chisel-beads/*.md` shows it only beside
      `in-progress` as a translation; `grep -c "bd ready"
      socle/agents/skills/chisel-beads/SKILL.md` ≥ 1; `grep -c "bd list
      --status" socle/agents/skills/chisel-beads/SKILL.md` ≥ 1.
- [ ] **slice-template** — `grep -c '^\*\*Status:\*\* creating'
      socle/agents/skills/slice-task/SKILL.md` = 1.
- [ ] **questionnaire-true** — `grep -c "without reading them all"
      socle/agents/skills/chisel-setup/SKILL.md` → 0 (today 1).
- [ ] **reasoning-placed** — `socle/agents/methodology.md` has a `##` or
      `###` heading whose text contains "status"; `grep -c "| \*\*Status\*\*
      |" socle/agents/reference.md` = 1.
- [ ] **workspace-migrated** — `grep -rhn "^\*\*Status:\*\*"
      project-management/tasks project-management/archive | wc -l` = 43
      (today 43), and `grep -rn "^\*\*Status:\*\*" project-management/tasks
      project-management/archive | grep -v -E ":\*\*Status:\*\*
      (creating|waiting-business-approval|waiting-design-approval|ready|planning|waiting-plan-approval|in-progress|waiting-diff-approval|done|blocked|stalled|deferred|cancelled)( |$)"`
      → nothing (today 43 lines).
- [ ] **no-code-in-shipped-text** — `grep -rn "S7\.[0-9]\|review-360"
      socle/ project-management/000-template.*.md` → nothing.
- [ ] **suite-green** — `deno task test` → every test passes (25 today,
      record the count); `deno task check` → clean; `git diff --check`
      clean.
- [ ] **nothing-else-moved** — `git diff --stat <start>..HEAD` touches
      only: `project-management/000-template.spec.md`,
      `socle/templates/000-template.spec.md`, the five formula files,
      `socle/agents/project.md.tpl`, `socle/agents/methodology.md`,
      `socle/agents/reference.md`, the two beads skill files, the
      slice-task skill, the chisel-setup skill, `**Status:**` lines under
      `project-management/tasks/` and `project-management/archive/`, and
      this task's pair.

## Files map (indicative; judged after the fact)

Modify: `project-management/000-template.spec.md`,
`socle/templates/000-template.spec.md`,
`socle/agents/formulas/chisel-default.formula.toml`,
`socle/agents/formulas/chisel-supervised.formula.toml`,
`socle/agents/formulas/chisel-auto.formula.toml`,
`socle/agents/formulas/chisel-light.formula.toml`,
`socle/agents/formulas/chisel-auto-light.formula.toml`,
`socle/agents/project.md.tpl`, `socle/agents/methodology.md`,
`socle/agents/reference.md`, `socle/agents/skills/chisel-beads/SKILL.md`,
`socle/agents/skills/chisel-beads/CHANGING-CASE.md`,
`socle/agents/skills/slice-task/SKILL.md`,
`socle/agents/skills/chisel-setup/SKILL.md`, and the `**Status:**` line of
every file under `project-management/tasks/` and
`project-management/archive/`.
Avoid: `src/`, `test/`, `deno.json`, `README.md`, `PHILOSOPHY.md`,
`project-management/CHANGELOG.md`, `project-management/review-360-*.md`,
the work template (it has no status line), everything else under `socle/`.

## Verification

Run every criterion command before typing and record the before-values in
the work document; run them again at the end and write after beside
before. `deno task test`, `deno task check` and `git diff --check` before
each commit. Read the five formula files once more after editing: TOML
multi-line strings must still parse (the test suite parses them; a green
suite is the proof). Commit in small steps: templates, formulas, glue and
methodology, beads skill, other skills, workspace migration.

## Notes

Written by the Foreman on 2026-09-14 under the Owner's fast-track ruling
(Addendum 6 of the decisions record). The interview that settled the model
ran on 2026-09-10, 2026-09-11 and 2026-09-14; its eight decisions are in
"Addendum 8" of the decisions record, which the agent reads for the
reasoning but never cites in shipped text. Pointers in shipped text use
the installed form (`.agents/…`), never `socle/…`. `bd` 1.2.2 is installed
at `/opt/homebrew/bin/bd` if the agent wants to re-run the probe in a
throwaway directory under the scratchpad; nothing in this repo gets a
`.beads/`. Every amendment to this file: strike the original, date the new
version below it.
