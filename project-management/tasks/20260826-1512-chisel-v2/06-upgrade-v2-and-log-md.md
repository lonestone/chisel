# 06 — upgrade-v2 skill + LOG.md, pilot migration = parity check

**Status:** 🟠 Blocked (2026-08-26) — the skill, the LOG.md default and their
proofs are delivered; AC3 and AC4 wait on the Owner's real pilots (handoff in
Notes)
**Blocked by:** 04, 08

**What to build:** The v1→v2 migration path — a SKILL, not machinery in
`update` (the system is young; the agent migrates file by file, the human
validates). `upgrade-v2` on a v1-equipped repo: removes the 3 rules +
`workflows.md`, poses `discipline.md` / formulas / profiles / generated
definitions, renames `CHANGELOG.md` → `LOG.md` (v2 default — collision with
the boilerplate's release changelog; path already glue-configurable §A),
fills the new glue sections (§B1–B3, tiers) by incremental questionnaire,
leaves existing tasks/archive untouched. The socle's own default texts switch
to `LOG.md` (template, discipline/formula wording, setup default); the
narrative journal stays HANDWRITTEN by the agent after each task — never
generated from the beads audit trail; ADRs unchanged (D5-G). Then the real
proof: migrate at least one real pilot (evea-ai by Pierrick,
music-downloader by its own agent) and run the **parity re-verification** — a
real Controlled × markdown session end-to-end on the migrated repo, checked
against `../factory-bench/prototypes/parity-report.md` (same sequence, gates,
artifacts, verification), including one sliced case (`slice-task`), which the
prototype bench never exercised.

## Acceptance criteria

- [x] `upgrade-v2` on a v1 fixture: rules + workflows.md gone, v2 files
      posed, `CHANGELOG.md` → `LOG.md`, existing tasks/archive byte-intact,
      `chisel check` clean after — test group 14, which also proves the refused
      `update` is accepted again once the migration is done
- [x] Socle defaults all say `LOG.md`; a v2 fresh install never creates a
      `project-management/CHANGELOG.md` — group 15, plus the absence asserted in
      the layout of every fixture; and a repo that already HAS one gets no
      second journal beside it
- [ ] At least one real pilot migrated via the skill (human-validated diff)
      — **the Owner's, see the handoff in Notes**
- [ ] Parity session on the migrated pilot logged against the parity
      checklist — no missing step, no missing gate, artifacts conform; the
      sliced case exercised — **the Owner's, see the handoff in Notes**
- [x] No LOG generation from audit trail anywhere in the socle (the decision
      is written down where LOG discipline is defined) — §A of the glue, the
      one place every writer resolves the journal through; asserted as an
      invariant over the whole socle, not as one needle

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

Fixed point: `9b5d5fe` (slices 01–04 and 08 delivered). Sources: this slice's
ACs, the parent's Notes ("Audit round", fb-3kk.10 and fb-3kk.13),
`../factory-bench/research/inventaire-socle-chisel.md` (the exact v1 layout to
migrate), `../factory-bench/decisions.md` F6. Slice 08's guard
(`update` refuses a v1 layout, naming `upgrade-v2`) is the door this slice
fills: the refusal must lead somewhere.

Seven decisions, then the file tree.

### D1 — the skill IS the migration; the CLI stays dumb

No migration machinery in `init`/`update` (fb-3kk.10: the system is young, the
agent migrates file by file and the human validates). `upgrade-v2` is a skill
in the socle, `disable-model-invocation: true` like `chisel-setup` — a
migration is never something an agent starts on its own.

The one exception, and it is a guard, not machinery: the
`project-management/` skeleton refuses to create a second journal (D3).

`init` is deliberately reachable on a v1 repo — slice 08 wrote that decision
down (its D1) precisely so this skill could use it.

### D2 — the order of operations, and why `init` comes third

1. **Preflight** — clean tree, confirm the v1 layout is really there, take the
   inventory (which files, which journal path, how many task files).
2. **Retire the v1 layer** — the three rule files and the visual guide, with
   the human validating the list before anything is deleted.
3. **Rename the journal** — `git mv` of the file named by the project's own
   glue §A, then that §A line updated to `LOG.md`.
4. **Install v2** — `npx @lonestone/chisel init .`: poses `discipline.md`, the
   three formulas, the profiles, the per-tool definitions, the personal-file
   template, and re-renders the AGENTS.md managed block (the v1 router, which
   pointed at the files step 2 removed, disappears here).
5. **Complete the glue** — §B1/§B2/§B3 and §H by incremental questionnaire,
   asking only what the v1 glue does not already answer.
6. **Verify** — `chisel check` clean, the retired layer gone, the task files
   and the archive byte-identical to what they were before step 1.
7. **Hand over** — the human reads the diff; then one dated entry in the
   renamed journal.

The order is load-bearing in two places. **Retire before install**: running
the installer first would recreate, for a few minutes, exactly the state slice
08's guard exists to forbid — two normative discourses in one repo. **Rename
before install**: the skeleton writes a journal when it finds none, so an
`init` run before the rename would leave a fresh empty `LOG.md` beside the old
`CHANGELOG.md` — two journals, which is the one outcome this rename exists to
prevent. (D3 makes that second hazard harmless too; the order still states the
intent.)

### D3 — `LOG.md` is the default for NEW projects; existing repos keep theirs

The default changes in exactly three places: the skeleton in `bin/chisel.sh`,
the §A default of `project.md.tpl`, and — for repos already equipped — nowhere,
because §A is the indirection every formula already resolves through ("a dated
entry in the changelog declared in `.agents/project.md` §A"). A repo whose glue
says `CHANGELOG.md` keeps writing to `CHANGELOG.md` and nothing breaks; the
rename is a step of the migration, not a side effect of an upgrade.

The guard: `ensure_project_management_skeleton` creates `LOG.md` only when
there is no journal there at all. If a `CHANGELOG.md` already sits in the task
workspace — every repo equipped by v2 before this slice has one — it creates
nothing and warns, naming `upgrade-v2`. Same discipline as slice 08's D1: when
chisel would make a repo incoherent, it says so and points at the tool that
does it properly, rather than acting.

### D4 — §A keeps the label `Changelog`, only its VALUE changes

The formulas and `discipline.md` are out of this slice's grip, and they resolve
the journal by prose ("the changelog declared in §A"), not by field name.
Renaming the field to `Journal` would leave three normative files pointing at a
label that no longer exists, for a wording gain that belongs to slice 07's
"default + options" vocabulary pass. So §A reads
`- **Changelog:** /project-management/LOG.md`, §C's `<Changelog>` reference is
untouched, and the field rename is handed to 07.

### D5 — where "handwritten, never generated" is written down

AC5 asks for the decision to live where the LOG discipline is defined.
`methodology.md` (the "Why the CHANGELOG stays" page) is out of grip — slice 07
owns that file. The place in grip that every reader and every formula actually
resolves through is §A of the glue, so the rule is one sentence in §A's
comment: the journal is written by hand, one dated entry per task, **never
generated from a coordination database's audit trail**; ADR records are
unaffected. The skill repeats it at the step that renames the file, which is
where a migrating agent is most likely to invent a generator.

Tested as an invariant rather than as a needle: every socle file that mentions
an audit trail must also say the journal is not generated from one (and the set
is asserted non-empty, so the scan cannot pass by matching nothing).

### D6 — the dry migration: what a shell can prove of a skill

A test cannot run an agent, so it proves the two halves separately and couples
them:

- **The prose half** — the skill text is asserted to name each step it
  prescribes (retire, `git mv`, run the installer, hand the glue questions to
  the setup skill, never touch `tasks/`).
- **The mechanical half** — the deterministic steps are replayed on a fresh
  copy of the `brownfield-v1` fixture, and the before/after is asserted: the
  retired layer gone, `LOG.md` present and byte-identical to the `CHANGELOG.md`
  it came from (a journal is MOVED, never regenerated), every task file and
  archive file byte-identical, the v2 files posed, the AGENTS.md block no
  longer routing to the retired layer, the v1 glue not clobbered by `init` and
  its §A line now naming `LOG.md`, and `chisel check` clean.

The coupling is the point: if a step leaves the skill, its needle assertion
fails; if a step stops working, the replay fails. The test uses `mv` where the
skill says `git mv` (the temp copies are not git repos) and asserts the skill
says `git mv` — history preservation is the skill's business, file movement is
the test's.

### D7 — the fixture grows a task workspace; two waiver lines change category

`test/fixtures/brownfield-v1/` is reused, not duplicated: it gains the
`project-management/` a real v1 repo has — one `CHANGELOG.md`, one open task, one
archived task. Slice 08's group 11 does not read that directory, so its guard
scenario is unaffected.

Group 12's waiver: the skill must NAME the layer it retires, so
`.agents/rules/task-*.md` and `.agents/workflows.md` now dangle from a file
that is right to mention them. The two lines move from DEBT (closes when slice
07 rewrites `methodology.md`) to BY DESIGN + DEBT, and stop being self-retiring
— handed to slice 07 in the Notes. The skill uses those two exact spellings and
no other `.agents/rules...` form, so the migration adds no new waiver line.

### D8 — added in the review round: the glue must not point at a missing file

D1 said the CLI stays dumb "one guard aside". There are two now, and the second
was found by the standards review. When D3's guard declines to create `LOG.md`
because a `CHANGELOG.md` is already there, a glue THIS `init` run just created
still carries the template's default — so §A declares a journal the installer
deliberately did not write, and every text that resolves the journal through §A
follows it into thin air. `point_new_glue_at_existing_journal` rewrites that one
line, under exactly `tick_adapter_inventory`'s conditions: only on a glue this
run created, and only while the line is still the template's untouched default.
A value a human answered is never rewritten by the installer.

### File tree

```
socle/agents/skills/upgrade-v2/SKILL.md      NEW — the migration (D1, D2)
bin/chisel.sh                                LOG.md skeleton + the second-journal guard (D3)
socle/agents/project.md.tpl                  §A default value + the handwritten rule (D3, D4, D5)
socle/agents/skills/sync-upstream/SKILL.md   one clause: its CHANGELOG is the chisel repo's own
test/fixtures/brownfield-v1/project-management/  NEW — journal + one task + one archived task (D7)
test/run.sh                                  group 14, group 4/1 renamed to LOG.md, waiver reasons
test/TESTS.md                                group 14 row + the waiver's two categories
project-management/CHANGELOG.md              one dated entry (this repo keeps its own name)
```

Order of work (each step leaves the suite green): the default switch
(chisel.sh + tpl + the suite's existing LOG.md needles) → the fixture → the
skill → group 14 → TESTS.md → review.

**Not in this slice, and not attempted**: the pilot migration and the parity
re-verification (AC3 and AC4). They are the Owner's, on real repos; the handoff
is in the Notes and the two boxes stay unticked.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

Sources: this slice's ACs, the parent's Notes (fb-3kk.10 and fb-3kk.13),
`../factory-bench/research/inventaire-socle-chisel.md` (the v1 layout, file by
file) and `../factory-bench/decisions.md` F6. Out of grip and untouched:
`chisel-setup` (slice 05 is in it in parallel — this skill POINTS at it for the
question wording and adds nothing to it), the formulas, the profiles,
`discipline.md`, `methodology.md`, PHILOSOPHY and README (slice 07).

### Handoff to the Owner — AC3 and AC4 stay unticked

The pilot migration and the parity re-verification are not this session's to
do: they need real repos and a real human validating a real diff. What ships
here is the tool and its proof on the fixture. Concretely, what is waiting:

- **AC3 — one real pilot migrated.** evea-ai by the Owner, music-downloader by
  its own agent (parent's Implementation Decisions). The procedure is
  `upgrade-v2`, run from the repo being migrated; the tree-level result it
  should produce is exactly what group 14 asserts, so a migration that ends
  somewhere else is a bug in the skill, not in the repo.
- **AC4 — the parity session.** One Controlled × markdown session end to end on
  the migrated pilot, checked against
  `../factory-bench/prototypes/parity-report.md` (same sequence, same gates,
  same artifacts, same verification), including one sliced case via
  `slice-task` — which the prototype bench never exercised. It is the parent's
  third acceptance criterion too, so it closes two boxes at once.

Both boxes stay `[ ]` above, and the slice is delivered as "the migration path
exists and is proven on a fixture", not as "v2 parity is re-verified".

### Signalments to slice 07 (reported, not acted on)

1. **`methodology.md` still names the retired layer AND the old journal.** Its
   "Why the CHANGELOG stays" section and its `.agents/rules/task-*.md` /
   `workflows.md` citations are both in that file, which is 07's. Two things to
   do there: align the journal's name and add the "never generated" rule to the
   doctrinal page (this slice could only write it in §A of the glue), and drop
   the citations of the retired layer. The suite still forces the second: the
   waiver's two v1 lines can no longer expire (the migration skill legitimately
   names those paths), so group 12 now asserts WHICH files may cite the retired
   layer — `methodology.md` is on that list today, and fixing it fails the
   assertion until the line is removed. Same forcing function, one level up.
2. **The glue field is still labelled `Changelog`.** §A now reads
   `- **Changelog:** /project-management/LOG.md`. Renaming the field to
   `Journal` would have orphaned three normative files that resolve it by prose
   ("the changelog declared in §A") — formulas and `discipline.md`, all out of
   grip here. It belongs with 07's "default + options" vocabulary pass, together
   with §C's `<Changelog>` reference.
3. **`discipline.md` line 9 says "changelog entries"** — generic, harmless, and
   the same vocabulary pass.
4. **The CLI still does not read §A.** `init` hardcodes `project-management/`,
   so a repo whose workspace lives elsewhere gets a stray skeleton — including
   a seeded journal, which the migration skill now tells the agent to delete by
   name. That is the inventaire's "chemins en dur contredisant la glue" finding,
   older than v2 and outside this slice's ACs; reported, not fixed.

### Signalment to slice 05

Group 15's no-generation invariant fires on any socle text that raises
generating the journal without ruling it out. The beads convention is the
document most likely to raise it (F6 in `../factory-bench/decisions.md` says the
changelog line is "générable depuis l'audit trail à terme" — the Owner has since
rejected that, fb-3kk.13). Writing it there will trip the suite, which is the
intent.

### Two notes on files beyond the obvious ones

- **`sync-upstream/SKILL.md` gained one clause** (planned — it is in the Design's
  file tree): its `project-management/CHANGELOG.md` is the CHISEL repo's own
  journal, and the file now says so. Without it, "no socle text sends a project
  to a CHANGELOG.md" is a rule with an unexplained exception. Two socle files
  legitimately name that file now — this one and the migration skill — and group
  15 lists both by name rather than excusing them with a regex.
- **Two test groups, not one.** The Design said "group 14"; the migration and
  the journal default shipped as 14 AND 15. They are two situations, and the
  suite counts scenarios: folding the second into the first would have hidden a
  whole behaviour behind one PROTECTS line.

### Review round (two axes, fixed point `9b5d5fe`)

**Standards.** Eight findings taken, three declined.

1. **A repo could be locked out of `update` forever.** The guard tests the
   rules DIRECTORY, not the retired files; the skill's Step 2 invited keeping a
   locally-added rule in it. That repo would then be refused by `update` and
   turned away by this skill's own Step 0 ("already on v2") — a closed loop.
   Fixed on the skill's side, not the guard's: the directory must not survive,
   a kept rule MOVES out of it, and the skill says why. Changing slice 08's
   guard to look at files instead would have reopened a delivered decision to
   fix a trap this skill created.
2. **Step 4's cleanup instruction would have broken Step 6.** On a repo whose
   workspace is not `project-management/`, `init` leaves a seeded journal AND a
   managed template there; "remove the empty skeleton" would have deleted the
   template and made `check` report MISSING. Now the skill names the one file
   that matters (`project-management/LOG.md`, seeded, not empty), says the
   template stays where the installer put it, and says why.
3. **The glue could point at a journal that does not exist** — D8 above.
4. **`git rm` of two paths when only one exists removes nothing**, and Step 0
   explicitly allows the one-of-two case. Step 2 now removes what the inventory
   found, and says so.
5. **Needles locked to mid-sentence English.** Re-anchored on the eight step
   headings and the fenced commands — the shape and the mechanics — plus three
   sentences that carry a rule. A test that fails on "so that" teaches people
   to stop editing the document.
6. **A bare `rmdir` under `set -e`** would abort the suite mid-group with no
   FAIL line and no tally the day the fixture grows a fourth file. `rm -rf`.
7. **An assertion that followed the test's own `sed`.** Kept (init could
   clobber the glue in between) but paired with the one that was missing: the
   OLD name is gone from §A, which nothing checked.
8. **The audit-trail sweep** iterated an unquoted variable (breaks on a path
   with a space) and its `pass` claimed more than it measured. Now a
   `while read` loop, the existence claim asserted directly on the file that
   carries the rule, and the sweep widened past the single phrase "audit trail"
   — mutation-tested with a planted "we could generate the log from the audit
   trail", which it catches.

Declined, with reasons: the warning going to stderr while `init` exits 0 and
prints success (every other chisel warning does exactly that — foreign skill,
foreign definition; changing it is a CLI-wide decision, not this slice's); and
"the rationale is written in three places" (three audiences — the maintainer in
`chisel.sh`, the equipped repo's reader in §A, the migrating agent in the
skill — but `chisel.sh`'s copy was cut to a pointer at §A, which is the
normative one). The third, "the replay does not prove the skill's commands
run", is true and irreducible in a shell: `TESTS.md` row 14 now says what the
group proves instead of implying more.

**Spec.** Six findings. Three (empty Notes, missing changelog entry, unticked
ACs) had already been done between the review's read and its report. Two taken:
the waiver's lost forcing function (the group now names the files allowed to
cite the retired layer, so slice 07's debt still expires — see `TESTS.md`), and
the same `methodology.md` handoff, now written above. One acknowledged as a
stretch and left: §A gained normative prose, not just a value — AC5 asked for
the rule to be written where the journal discipline is defined, and §A is the
only such place in this slice's grip.

### What a shell can and cannot prove here

Group 14 replays the skill's mechanical steps; it does not run an agent, and it
says so. The half it cannot replay — the human validating the diff, the
incremental questionnaire, the judgment calls on a local rule file someone
added under the retired directory — is exactly the half AC3 covers on a real
pilot. The needle assertions are the seam between the two: every step the
replay performs is asserted to be prescribed by the skill, so the two cannot
drift apart silently.
