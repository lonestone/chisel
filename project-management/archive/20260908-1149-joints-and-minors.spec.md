# Joints and minors pass

**Status:** 🟢 Complete (2026-09-09)

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

The 360 review of 2026-08-27 produced 22 decisions, recorded in
`project-management/review-360-decisions.md`, and a revised action plan of
eight chantiers at the end of that file. Two are closed: chantier 1 remodelled
the roles and the formulas (CHANGELOG entry 23), chantier 2 split every task
file into a `.spec.md` and a `.work.md` (CHANGELOG entry 24).

This is chantier 3, "Passe jointures & mineurs". Its content is the rulings
A1, A3, A4, B1, E1, E2 and F1 except sub-items 1, 4 and 12 — every one of them
already ruled, which is why the plan calls this chantier "mécanique, aucun
arbitrage restant". Nothing here reopens a decision. What it repairs is the
first class of defect the review found: pointers that resolve into thin air,
claims the code no longer honours, and doctrine written in a place nobody can
read it from. Five socle files still send a reader to a glue section called
"Tracker section" that has never existed; the README still says `chisel init`
asks a question, and it asks none; the shipped spec template still calls the
🧑 zone the human's when the doctrine says it is the zone owner's.

Chantiers 1 and 2 already executed part of this list while passing through.
Each item below carries the state verified in the repo today, with its count;
what is done is recorded as done and not re-specified.

## Scope

**Included** — one row per ruling, with the carriers verified in this repo on
2026-09-08. The commands behind each count are in Notes, "Verified counts".

| Ruling | What changes | Carriers today |
|---|---|---|
| **A1 (1)** | The five pointers name a section that exists: `§B · Coordination`, or `§B2 · Link to an external tracker` where the pointer means the external tracker | 5: `methodology.md:35`, `skills/wayfinder:30`, `slice-task:17`, `code-review:18`, `triage:48` |
| **A1 (2)** | The reference to "Wayfinding operations" notes, which no glue section defines, is deleted | 1: `skills/wayfinder:30` |
| **A1 (3)** | §D · Documentation reference of the glue template gains an "Architecture index" field, default `doc/architecture/ARCHITECTURE.md` — the `close` step of all five formulas already starts a reader from it | 0 in `project.md.tpl`; assumed by 5 formulas |
| **A3 (1)** | "Full analysis: `SDD-bench/fusion-pierrick-pocock.md`" is deleted — development context, not doctrine | 1: `methodology.md:14` |
| **A3 (2)** | The `sync-upstream` page moves beside its script, out of the set `chisel init` copies (the script is already at `socle/scripts/sync-upstream.sh`) | `skills/sync-upstream/SKILL.md` + 2 lines of `golden-tree.txt` |
| **A3 (3)** | ALREADY DONE by chantier 1 — "The Ledger" replaced by "the coordination state" | 0 |
| **A4** | The README states the real flow: `chisel init` installs with safe defaults and asks nothing; the questionnaire is the `chisel-setup` skill, run afterwards, which fills `.agents/project.md` | 1 false claim at `README.md:38-46`; `chisel-setup` named 0 times |
| **B1** | The template's zone table names the zone's OWNER — in the default preset, the human — and points at "Zone ownership" of `.agents/methodology.md` | 1 "Human, always" in each template copy; "Zone ownership" named 0 times |
| **E1** | The factory stops being a product cell and becomes a possible destination, perhaps outside chisel, question left open. No beads machinery is written | 2: `methodology.md:65`, `PHILOSOPHY.md:134` |
| **E2** | The profiles README states that a tier is resolved at read time, by the delegator, at spawn, and that a generated definition carries no model field | 0 statements of the rule |
| **F1.2** | "three role profiles" becomes "the role profiles" | 1: `skills/upgrade-v2:13` |
| **F1.3** | ALREADY DONE by chantiers 1–2 — the step is `plan-review`, the formulas name a role and its contract with no tier, `mason.md` and the roster read "cheap or mid" | 0 |
| **F1.5** | The discipline's prototype row aligns on rule 6 of the `prototype` skill (throwaway branch plus pointer), and the close-time cleanup of consumed prototype branches is written once | 1 "delete the code" at `discipline.md:98`; "throwaway branch" 0 times |
| **F1.6** | `retro` stops claiming the discipline is rendered into the AGENTS block — verified false, the block points at it (`templates/AGENTS-block.md:14`) | 1: `skills/retro:117` |
| **F1.7** | "Nothing in this socle names a model or a vendor" is narrowed to models and tiers | 1: `methodology.md:324` |
| **F1.8** | The `**Status:**` and `**Version:**` headers leave the template files themselves, and the opaque "rewrite labels" rule is rewritten to stand alone in one place | 2 header lines in each of 4 template files; 6 rewrite-label carriers (5 formulas + `methodology.md:437`). "moved here from `type`" already gone |
| **F1.9** | The `update`-redirect rule is deleted from the discipline, leaving 11 numbered rules; the CLI's refusal message already does the redirect | 1 rule — today numbered **11**, not 10 |
| **F1.10** | `grill-with-docs` is deleted, with zero inbound references from any other socle file | 6: its `SKILL.md`, its lock entry, 2 `golden-tree.txt` lines |
| **F1.11** | `triage` leaves the shipped socle, its standing intention recorded | 40 across `socle/`, the lock and the tree: 3 skill files, the side-lane row `discipline.md:102`, its lock entry, 4 tree lines |

Three of those rows need a sentence of their own:

- **A1 (2) stops at the deletion.** The rest of that ruling — the wayfinder
  kept and made local-first, per the F1.1 amendment — is chantier 6 and is not
  touched here.
- **F1.9's rule number moved under it.** The ruling calls it "règle 10";
  chantier 1 inserted a new rule 10 and stripped this one's preset wiring
  without deleting it, so the target is today's rule 11. Rule 12 (a section
  reference names its file and its title) stays and becomes rule 11; its house
  is chantier 5's business.
- **A1 (1)'s fifth carrier disappears rather than being renamed.**
  `triage:48` leaves with its file under F1.11, which is why slice 03 closes
  that criterion.

**Ruled IN, with reason** — pending proposals nobody owned:

- **The stale "Tracker section" pointer (5 carriers).** In scope, and it is
  not a new item: it IS ruling A1 (1), whose own title is « "Tracker section"
  ×5 ». Verified unexecuted today.
- **The outdated invocation vocabulary, `AGENTS.md:10-13` and
  `socle/agents/profiles/README.md:67`.** In scope. Both were recorded as
  proposals by chantier 2's slice 03 and sat outside all five of its slice
  maps, so they ship stale unless a round owns them; both are one-clause
  edits of exactly this chantier's kind — a shipped text naming something the
  system no longer has. `profiles/README.md:67` says `work on slice <file>`
  where the four other carriers say `<spec-document>`; `AGENTS.md:10-13`
  persists the plan "into the file" when the plan's destination is now the
  work document.
- **Ruling G16 into the socle (reviewers fresh, the Mason reused in a live
  thread).** In scope. G16 names its own carrier — the Foreman profile, which
  owns the spawn — and says explicitly that it travels "avec les résidus
  `AGENTS.md` / `profiles/README.md` déjà consignés", which this chantier is
  taking. It is one statement in one file and reopens nothing. Today the rule
  lives only in this repo's `AGENTS.md:18-19`, so an equipped project never
  learns it.
- **`README.md:19-31` and `PHILOSOPHY.md:126-142`, the two stale front-door
  paragraphs** — a bounded rider, flagged for the Owner to strike. README
  still describes one spec file holding "program design underneath, the
  agent's working notes at the bottom" and a plan "PERSISTED into the spec
  file", both retired by chantier 2; PHILOSOPHY still counts "Three presets"
  where there are five and still calls auto a permission, retired by ruling
  G10. Reason to take them: A4 and E1 open both files anyway, and E1's new
  sentence cannot be stated coherently inside a paragraph that miscounts the
  presets. Precedent: at chantier 1 the Owner arbitrated that the README
  counts as a carrier when a criterion grepping only `socle/` left the front
  door teaching a deleted feature (CHANGELOG entry 23).

**Ruled OUT, with reason:**

- **The `chisel-beads` bare `§B1` / `§B2` / `§H` references.** Chantier 5
  owns them by name: its entry in the decisions record lists
  `socle/agents/skills/chisel-beads/`, `chisel-setup/` and `upgrade-v2/` as
  carriers of the sweep, and says "rien ne change au principe déjà tranché,
  seule la liste s'allonge". Verified today: 8 such bare references in
  `chisel-beads`, 17 in `upgrade-v2`, 35 in `chisel-setup`. A1's five renames
  happen to land in the compliant form; that is a by-product, not a licence to
  sweep.
- **The `chisel-beads` blocked-status documentation gap.** Out of scope, and
  still unowned. `socle/agents/methodology.md:150-153` rules that where
  statuses live in beads "the task's own bead takes beads' native blocked
  status", and `socle/agents/skills/chisel-beads/SKILL.md` — the page that
  carries every other bead command verbatim — never says how. Closing it
  means naming the `bd` command that sets that status, which no ruling
  settles and which this chantier's "no arbitrage left" charter excludes. It
  needs an owner: chantier 5 already reopens that file, or a small task of
  its own. The Owner decides.
- **Ruling F1.1 (the wayfinder made local-first).** Chantier 6. Only its
  "Wayfinding operations" half, which A1 (2) rules deleted, is taken here.
- **Ruling F1.4 (the task status model).** Chantier 7, a discussion to open.
- **Ruling F1.12 (the glue parser).** Chantier 4, inside the Deno port.

**Not Included:**

- Any change to `bin/chisel.sh`. The CLI's behaviour is untouched: nothing
  here changes what `init` does, only what the text says it does. Its refusal
  message already carries F1.9's redirect.
- Any change to `test/installer.sh`, `test/run.sh`, `test/lib.sh` or
  `test/TESTS.md`. The only suite file this task edits is the golden layout
  fixture, and only by removing lines (see Seams).
- The 600-line cap on `test/` (chantier 4, ruling D4), the bare-section-
  reference sweep (chantier 5), the vendored-skill doctrine audit (ruling G9),
  the deferred rulings G7, G12 and G13.
- Adding example model names to the socle. Ruling E2 permits them; it does not
  order them. See Implementation Decisions.

## Acceptance Criteria

Every criterion has a short descriptive **name**, never a bare ordinal label,
and is machine-verifiable. Every grep below was RUN against this repo on
2026-09-08; its current match count is in Notes, "Verified counts". An
amended criterion is struck and its dated replacement is added below it —
never erased.

- [x] **tracker-pointer-resolves** — `grep -rn "Tracker section" socle/`
      returns nothing, and every surviving citer names a section that exists:
      `§B · Coordination` of `.agents/project.md`, or `§B2 · Link to an
      external tracker`.
- [x] **wayfinding-notes-gone** — `grep -rn "Wayfinding operations" socle/`
      returns nothing.
- [x] **architecture-index-declared** — §D · Documentation reference of
      `socle/agents/project.md.tpl` declares an "Architecture index" field
      whose default is `doc/architecture/ARCHITECTURE.md`.
- [x] **sdd-bench-pointer-gone** — `grep -rn "SDD-bench" socle/` returns
      nothing.
- [x] **sync-upstream-unshipped** — `socle/agents/skills/sync-upstream/` does
      not exist, the page sits beside its script under `socle/scripts/`, and
      `grep -n "sync-upstream" test/fixtures/golden-tree.txt` returns nothing.
- [x] **readme-init-truthful** — `README.md` claims no question for `chisel
      init`, and names `chisel-setup` as the questionnaire that fills
      `.agents/project.md` afterwards.
- [x] **readme-gradient-current** — `README.md` no longer places program
      design or working notes inside the spec file, and no longer persists the
      plan into it: `grep -n "persists the plan into the spec file" README.md`
      returns nothing.
- [x] **template-zone-owner** — in both `socle/templates/000-template.spec.md`
      and `project-management/000-template.spec.md`: `grep -c "Human, always"`
      is 0, and each file names "Zone ownership" of `.agents/methodology.md`
      at least once.
- [x] **factory-claim-degraded** — `grep -rn "Factory = auto" socle/
      PHILOSOPHY.md README.md` returns nothing, and the surviving sentence in
      each of the two files presents the factory as a possible destination,
      perhaps outside chisel.
- [x] **philosophy-presets-current** — `grep -n "Three presets"
      PHILOSOPHY.md` returns nothing; the five presets are named, and auto is
      not described as a project permission.
- [x] **tiers-prose-only** — `socle/agents/profiles/README.md` states that a
      tier is resolved at read time by the delegator at spawn, and that a
      generated definition carries no model field.
- [x] **model-claim-scoped** — `grep -n "Nothing in this socle names a model
      or a vendor" socle/agents/methodology.md` returns nothing, and the
      replacement sentence restricts the claim to models and tiers.
- [x] **profiles-uncounted** — `grep -rn "three role profiles" socle/`
      returns nothing.
- [x] **prototype-capture-aligned** — `grep -n "delete the code"
      socle/agents/discipline.md` returns nothing; the prototype side-lane row
      names the throwaway branch and its pointer; and the close-time cleanup
      of consumed prototype branches is written in exactly one place.
- [x] **retro-block-pointer-accurate** — `grep -rn "rendered into the AGENTS
      block" socle/` returns nothing.
- [x] **template-sediment-gone** — none of the four template files
      (`socle/templates/000-template.spec.md`, `000-template.work.md`, and
      both `project-management/` mirrors) carries a `**Status:**` or
      `**Version:**` header line of its own.
- [x] **rewrite-label-selfstanding** — `grep -rn "rewrite label"
      socle/agents/formulas/` returns nothing, and exactly one socle file
      carries the rule, stated so that it is understood without its original
      context.
- [x] **update-redirect-rule-gone** — `socle/agents/discipline.md` has 11
      numbered rules, none of them the `update` redirect, and
      `grep -c "upgrade-v2" bin/chisel.sh` is at least 1.
- [x] **grill-with-docs-gone** — `grep -rn "grill-with-docs" socle/
      upstream.lock.json test/fixtures/golden-tree.txt` returns nothing.
- [x] **triage-unshipped** — `grep -rn "triage" socle/ upstream.lock.json
      test/fixtures/golden-tree.txt` returns nothing.
- [x] **work-on-invocation-current** — `grep -rn "work on slice <file>\|work
      on task <file>" socle/ AGENTS.md` returns nothing; every invocation
      names `<spec-document>`.
- [x] **agents-md-persist-destination** — this repo's `AGENTS.md` names the
      work document as where the plan is persisted.
- [x] **role-reuse-in-socle** — `socle/agents/profiles/foreman.md` states
      ruling G16: judging roles are spawned fresh, the Mason is reused from
      plan through typing within a live thread.
- [x] **suite-green** — `bash test/run.sh`, run with a `python3` that has
      `tomllib`, reports 0 failed, with the "integrity: no pointer into thin
      air" scenario passing.

## Seams

- **Seam 1 · the installed socle text surface** — what an equipped repo reads
  under `.agents/`, plus this repo's own front door (`README.md`,
  `PHILOSOPHY.md`, `AGENTS.md`) and the two template mirrors under
  `project-management/`. Observable behaviour: the named greps above, and the
  suite's `integrity: no pointer into thin air` scenario, which proves that
  every `.agents/...` path and every sibling link in the installed tree
  resolves to a file that exists. That scenario is the guard on the three
  removals: it fails if any text still points at a deleted page.
- **Seam 2 · the installer suite** — `bash test/run.sh`: tree in, tree out.
  Its `test/fixtures/golden-tree.txt` is the contract for what `chisel init`
  installs, compared byte for byte in two scenarios (brownfield and
  boilerplate).

**Does a criterion need a suite change?** Yes, and only one file, and only by
deletion. `sync-upstream-unshipped`, `grill-with-docs-gone` and
`triage-unshipped` each remove entries from `test/fixtures/golden-tree.txt`: 2
lines for `sync-upstream`, 2 for `grill-with-docs`, 4 for `triage` — 8 lines
in total. No assertion is added, removed or rewritten; no runner, library or
scenario file is touched. Slice 03 is the only slice that may edit anything
under `test/`.

## Architecture

**System design.** This is a text-and-glue task with no runtime component.
Every change is a one-clause edit, a file move, or a file deletion; nothing
gains a function, a branch or a data structure. The design question is
therefore not *how* but *where*: which carrier holds each ruling once, and
which carriers are downstream readers that must stop contradicting it.

The per-ruling carrier map is the Scope table above; the two riders add
`socle/agents/profiles/foreman.md` (ruling G16) and
`socle/agents/profiles/README.md:67` plus `AGENTS.md:10-13` (the invocation
vocabulary).

**What the design has to settle is the file boundaries**, because two files
carry several unrelated edits each, one file is both a carrier and a deletion
target, and one moves rather than changes:

- `socle/agents/methodology.md` holds five edits (A1 (1), A3 (1), E1, F1.7,
  F1.8's surviving sentence). All five go to one slice; splitting one file
  across two slices buys nothing and costs a conflict.
- `socle/agents/discipline.md` holds three: the prototype side-lane row
  (F1.5), the numbered-rule deletion (F1.9) and the triage side-lane row
  (F1.11). The first two go with the doctrine slice; the third goes with the
  file it removes, because the row and the skill die together.
- `socle/agents/skills/triage/SKILL.md` is both a carrier of A1 (1) and a file
  F1.11 deletes. Deletion wins: renaming its pointer first would be work
  thrown away, so the file sits on the renaming slice's files-to-avoid map.
- `socle/agents/skills/sync-upstream/` moves rather than changes. The move
  alone unships the page, because `managed_relative_files` in `bin/chisel.sh`
  finds only `agents/skills`, `agents/formulas` and `agents/profiles` —
  `socle/scripts/` is already outside the copied set. No CLI change is needed
  to unship anything.

The indicative files-to-modify / files-to-avoid map of each slice is in
"Slices & Dependencies".

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

Cross-cutting rulings and application choices. The rulings themselves are in
`project-management/review-360-decisions.md`; what follows is only what they
left to application, decided here so no session has to guess.

1. **Which section each A1 pointer names.** Ruling A1 sets `§B · Coordination`
   as the target and `§B2 · Link to an external tracker` where the pointer
   means the external tracker. Applied per carrier:
   `methodology.md:35` (the reserved word "ticket") → §B2;
   `wayfinder:30` (the issue tracker) → §B2;
   `slice-task:17` (where slices are published) → §B · Coordination;
   `code-review:18` (where task files live) → ~~§B · Coordination~~
   §A · Task workspace (amended 2026-09-09 by the foreman at slice 02's
   `diff-review`: the sentence names the task workspace, which §A defines;
   §B holds only B1 and B2);
   `triage:48` → moot, the file leaves with F1.11.
   Each reference carries the section title with the number, which is the form
   rule 11 of the discipline already requires (rule 12 until slice 01 deleted
   the update-redirect rule and renumbered it — corrected 2026-09-09).
2. **No section-reference sweep.** The bare `§B`, `§C`, `§F`, `§B1` and `§H`
   citations that remain across the profiles, the formulas, `discipline.md`
   and the three chisel skills are chantier 5's, by name, in the decisions
   record. A1's five renames land compliant as a side effect. Do not extend
   the pass; a session that "helpfully" sweeps has taken another chantier's
   work and made its diff unreviewable.
3. **Where the sync-upstream page lands.** `git mv
   socle/agents/skills/sync-upstream/ socle/scripts/sync-upstream/`, keeping
   the `SKILL.md` name and its frontmatter. Reason: `socle/scripts/` is
   already outside the set `managed_relative_files` copies (it finds only
   `agents/skills`, `agents/formulas`, `agents/profiles`), so the move alone
   unships it; the directory shape keeps the page re-pluggable and the diff a
   rename. Rejected: flattening to `socle/scripts/sync-upstream.md`, which
   costs a content rewrite for nothing. `README.md:60-62` mentions the skill
   but claims no path, so it needs no edit for this.
4. **`triage` and `grill-with-docs` are deleted, not parked.** F1.11 takes
   `triage` out of the shipped socle "pour le moment"; F1.10 deletes
   `grill-with-docs` outright. Neither is parked in a new directory: git
   history and the upstream repo hold the text, and rule 8 of the discipline
   is satisfied by the CHANGELOG entry recording the removal and the standing
   intention (triage is worth revisiting with a real team tracker). Both lose
   their `upstream.lock.json` entry, because an entry whose skill directory no
   longer exists makes `sync-upstream --check` look up a missing path.
5. **Where ruling G16 lives.** One bullet in the "What it does" list of
   `socle/agents/profiles/foreman.md`, after the bullet that states the
   two-part spawn. Reason: the Foreman owns the spawn, so the rule about which
   spawns are fresh belongs with it. Not duplicated in `methodology.md` —
   ruling E3 bet on sobriety against drift, and a second copy is the drift.
6. **The "rewrite labels" rule: rewritten once, not six times.** F1.8 allows
   "rewritten to be self-explanatory or deleted". Applied as: the clause
   leaves the `close` step of all five formulas, and
   `socle/agents/methodology.md:437` keeps it as one sentence that names what
   a temporary rewrite label is and gives an example, so it is understood
   without its origin story. Reason: six copies of a sentence nobody could
   read was the finding; the formulas' `close` step owns order and artifacts,
   and the promotion doctrine's home is the methodology. If the Owner would
   rather the operational instruction stay where the agent reads it, the
   alternative is a one-line pointer in each formula — say so at spec review.
7. **Both copies of each template change.** chisel is not installed on itself
   (no `.agents/` in this repo), so `project-management/000-template.spec.md`
   and `000-template.work.md` are hand-maintained mirrors of the
   `socle/templates/` sources, not managed installs. B1 and F1.8 edit all
   four. The mirrors deliberately differ from the sources on one line — their
   methodology link is repo-relative (`../socle/agents/methodology.md`) where
   the source is install-relative (`/.agents/methodology.md`). Keep that
   difference; it is not drift.
8. **§D's new field needs no `chisel-setup` change.** The setup skill scripts
   verbatim question screens for §B1, §B2 and §H only; §D is presented as a
   prefill and confirmed. A new field with a default therefore ships without
   touching the skill.
9. **Deleting a numbered discipline rule is safe to renumber.** The only
   rule-number citations in the socle are `discipline.md:69` ("rule 9") and
   `skills/retro/SKILL.md:8` ("discipline.md rule 8"). Both are below 11, so
   removing rule 11 moves nothing they cite. Verified.
10. **Example model names are not added.** Ruling E2 permits the socle to list
    models as illustrations of a tier; it does not require it, and F1.7 only
    asks that the over-claim be narrowed. Introducing the first vendor names
    into the socle is a change worth its own decision, so the permission is
    recorded and left unexercised. This silence is deliberate, not an
    oversight.
11. **English, per ruling G3.** Every line written or rewritten is in English.
    Owner quotes keep their original language, in quotation marks.
12. **Ruling G18 applies to every line written.** Direct statement first; an
    image only where it carries information the direct statement does not.
    The prose this task rewrites is doctrine other people read under time
    pressure.

## Testing Strategy

- **Seam 1 (the socle text surface) is tested by grep and by the integrity
  scenario.** Each named criterion is a command with an expected count, and
  the suite's `integrity: no pointer into thin air` scenario is the behaviour
  test that matters for the three removals: it installs the socle into a
  fixture and asserts that every `.agents/...` path and every sibling
  markdown link in the installed tree resolves. It is also mutation-tested
  in place (two broken pointers are planted and must be caught), so a green
  result means something.
- **Seam 2 (the installer suite) is run in full on every slice**, not only on
  the one that edits the fixture — a text change can break the golden tree
  comparison by accident. Slice 03 additionally proves the tree matches after
  the three removals.
- **Run the suite with a `python3` that has `tomllib`.** Recorded in the
  decisions record under chantier 4: below python 3.11 the formula parse check
  silently reports SKIP and the run announces a green it has not earned. On
  the Owner's machine: `PATH=/opt/homebrew/bin:$PATH bash test/run.sh`.
  Baseline today: 9 scenarios, 94 assertions, 0 failed.
- **No new test is written.** No behaviour is added; the suite's job here is
  to prove nothing regressed while the text moved.

## Slices & Dependencies

**Sizing check, out loud.** Sliced — three slices. Not because the work is
hard: every edit is one clause, and every criterion is a grep. Because of
volume. The carriers total 4,450 lines across 27 files: 2,113 in the doctrine
and glue set (`methodology.md` 446, the five formulas 1,106, `project.md.tpl`
201, `foreman.md` 183, `discipline.md` 107, `profiles/README.md` 71), 1,637 in
the templates, front door and satellite skills, and 700 in the shipped-set
group. One session that reads enough of all three to edit them safely lands
near the 120k threshold rule 7 of the discipline warns about, and a Mason that
runs out of context in the middle of 24 criteria leaves a half-repaired joints
pass — worse than a clean boundary. A single session is defensible if the Owner
prefers it; the cut below is the honest reading.

The cut follows the two seams rather than the volume: slice 01 and 02 cannot
touch the installer suite at all, slice 03 is the only one that can. That also
prevents wasted work — slice 03 deletes two carriers slice 02 would otherwise
have renamed.

- **Slices:**
  1. **`01-doctrine-and-glue-text`** (blocked by: none) — the socle's own
     doctrine, glue template, profiles and formulas.
     *Files to modify:* `socle/agents/methodology.md` (A1 (1) pointer, A3 (1)
     SDD-bench, E1 factory, F1.7 model claim, F1.8 rewrite-label sentence),
     `socle/agents/discipline.md` (F1.5 prototype row, F1.9 rule deletion and
     renumber), `socle/agents/project.md.tpl` (A1 (3) §D field),
     `socle/agents/profiles/README.md` (E2, and the `work on slice <file>`
     clause), `socle/agents/profiles/foreman.md` (G16), the five
     `socle/agents/formulas/*.formula.toml` (F1.8 clause removal only).
     *Files to avoid:* everything under `test/`, `bin/`, `socle/templates/`,
     `socle/agents/skills/`, `project-management/`, `README.md`,
     `PHILOSOPHY.md`, `AGENTS.md`.
     *Criteria it closes:* `architecture-index-declared`,
     `sdd-bench-pointer-gone`, `model-claim-scoped`, `tiers-prose-only`,
     `prototype-capture-aligned`, `rewrite-label-selfstanding`,
     `update-redirect-rule-gone`, `role-reuse-in-socle`, and `suite-green` for
     its own run. Contributes to `tracker-pointer-resolves`,
     `factory-claim-degraded` and `work-on-invocation-current`.
  2. **`02-templates-front-door-and-skills`** (blocked by: none) — the review
     surface, the repo's front door, and the satellite skills.
     *Files to modify:* `socle/templates/000-template.spec.md`,
     `socle/templates/000-template.work.md`,
     `project-management/000-template.spec.md`,
     `project-management/000-template.work.md` (B1, F1.8 sediment),
     `README.md` (A4, and the stale gradient paragraph), `PHILOSOPHY.md` (E1,
     and the preset count), `AGENTS.md` (the persist destination), and the
     `SKILL.md` of `wayfinder` (A1 (1), A1 (2)), `slice-task` (A1 (1)),
     `code-review` (A1 (1)), `upgrade-v2` (F1.2), `retro` (F1.6), `prototype`
     (F1.5 cleanup habit).
     *Files to avoid:* everything under `test/`, `bin/`,
     `socle/agents/methodology.md`, `socle/agents/discipline.md`,
     `socle/agents/project.md.tpl`, `socle/agents/formulas/`,
     `socle/agents/profiles/`, and — specifically —
     `socle/agents/skills/triage/`, `socle/agents/skills/grill-with-docs/`
     and `socle/agents/skills/sync-upstream/`, which slice 03 removes.
     *Criteria it closes:* `wayfinding-notes-gone`, `readme-init-truthful`,
     `readme-gradient-current`, `template-zone-owner`,
     `philosophy-presets-current`, `profiles-uncounted`,
     `retro-block-pointer-accurate`, `template-sediment-gone`,
     `agents-md-persist-destination`, and `suite-green` for its own run.
     Contributes to `tracker-pointer-resolves`, `factory-claim-degraded` and
     `work-on-invocation-current`.
  3. **`03-the-shipped-set-shrinks`** (blocked by: none; run it last) — the
     only slice that changes which files an equipped repo receives, and the
     only one that may edit anything under `test/`.
     *Files to modify:* delete `socle/agents/skills/grill-with-docs/`, delete
     `socle/agents/skills/triage/`, move
     `socle/agents/skills/sync-upstream/` to `socle/scripts/sync-upstream/`,
     remove the triage side-lane row from `socle/agents/discipline.md:102`,
     remove the `triage` and `grill-with-docs` entries from
     `upstream.lock.json`, remove the eight corresponding lines from
     `test/fixtures/golden-tree.txt`.
     *Files to avoid:* `test/installer.sh`, `test/run.sh`, `test/lib.sh`,
     `test/TESTS.md`, `bin/chisel.sh`, and every file slices 01 and 02 own —
     `discipline.md` excepted, for that one row.
     *Criteria it closes:* `sync-upstream-unshipped`, `grill-with-docs-gone`,
     `triage-unshipped`, `tracker-pointer-resolves` (its last carrier leaves
     with the triage file), `suite-green`.

**Accepted overlap.** `socle/agents/discipline.md` appears in the map of
slice 01 (numbered rules, prototype row) and of slice 03 (the triage row).
Two different rows of one table and one numbered list: low conflict risk,
recorded rather than engineered away. Every other file belongs to exactly one
slice.

**Ordering.** No slice blocks another, but run 03 last: it removes carriers the
other two would otherwise rename, and it is the only one that touches the
suite fixture, so keeping it last means one fixture change reviewed once.

## Deliverables

- [x] Three slice spec documents under
      `project-management/archive/20260908-1149-joints-and-minors/`, authored at
      the `slice-task` step from this parent, each gaining its own work
      document at `plan`.
- [x] The socle repaired against rulings A1, A3, A4, B1, E1, E2 and F1
      (sub-items 2, 3, 5, 6, 7, 8, 9, 10, 11), with the 24 named criteria
      above verified.
- [x] `grill-with-docs` and `triage` out of the socle; `sync-upstream` out of
      the shipped set and beside its script.
- [x] Ruling G16 stated in `socle/agents/profiles/foreman.md`.
- [x] `test/fixtures/golden-tree.txt` matching the new shipped set, suite
      green.
- [x] A dated CHANGELOG entry recording the pass, the three removals and the
      standing intention on `triage`.
- [x] A retrospective in this file at `close`.

## References

- `project-management/review-360-decisions.md` — the rulings this task
  applies, one entry each for A1, A3, A4, B1, E1, E2 and F1, plus the "Plan
  d'action révisé" whose item 3 is this chantier, and the addenda carrying
  G16 (role reuse) and G18 (direct prose).
- `project-management/CHANGELOG.md`, entries 23 and 24 — what chantiers 1 and
  2 actually shipped, which is why A3 (3) and F1.3 are already done and why
  the discipline's rules are renumbered.
- `project-management/archive/20260828-2217-split-spec-and-work-documents/03-formulas-follow.md`,
  section "Proposals — reported, not typed" — where the `AGENTS.md` and
  `profiles/README.md` vocabulary residues were recorded, with the reason no
  slice of that task owned them.
- `project-management/vendored-skills-audit.md` — the independent audit of the
  sixteen vendored skills (ruling G9); it names the same dead "Tracker
  section" pointer in `code-review` and `wayfinder`, and confirms A1's
  finding from a second direction.
- `socle/templates/000-template.spec.md`, "The two zones" — the table ruling
  B1 rewrites, and the shape this document itself follows.
- `socle/agents/methodology.md`, "Zone ownership" — the doctrine the
  template's new wording points at.
- `test/installer.sh`, scenario "integrity: no pointer into thin air" — the
  behaviour test that guards the three removals, and what counts as a pointer
  for it.
- `bin/chisel.sh`, function `managed_relative_files` — the exact set
  `chisel init` copies, which is why moving a page into `socle/scripts/`
  unships it.

## Notes

Only material written into this file before a work document exists. This is
not the Mason's working space; its notes, snippets and worklog belong in the
work document's **Notes & Snippets**.

**Verified counts — 2026-09-08, `architect`.** Every number below was
produced by running the command against this working tree at authoring time,
on branch `review-360`. They are the "before" side of the acceptance criteria.

| Check | Today |
|---|---|
| `grep -rn "Tracker section" socle/` | 5 hits, 5 files |
| `grep -rn "§B · Coordination" socle/` | 0 |
| `grep -rn "§B2 · Link to an external tracker" socle/` | 0 |
| `grep -rn "Wayfinding operations" socle/` | 1 |
| `grep -c "Architecture index" socle/agents/project.md.tpl` | 0 |
| `grep -rn "SDD-bench" socle/` | 1 |
| `grep -rni "the ledger" socle/ bin/ README.md PHILOSOPHY.md` | 0 (A3 (3) done) |
| `grep -c "asks one question" README.md` | 1 |
| `grep -c "chisel-setup" README.md` | 0 |
| `grep -c "persists the plan into the spec file" README.md` | 1 |
| `grep -c "Human, always" socle/templates/000-template.spec.md` | 1 |
| `grep -c "Zone ownership" socle/templates/000-template.spec.md` | 0 |
| `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` | 2 |
| `grep -c "Three presets" PHILOSOPHY.md` | 1 |
| `grep -c "Nothing in this socle names a model or a vendor" socle/agents/methodology.md` | 1 |
| `grep -rn "three role profiles" socle/` | 1 |
| `grep -c "delete the code" socle/agents/discipline.md` | 1 |
| `grep -c "throwaway branch" socle/agents/discipline.md` | 0 |
| `grep -rn "rendered into the AGENTS block" socle/` | 1 |
| template `**Status:**` / `**Version:**` header lines | 2 in spec source, 2 in work source, same in both mirrors |
| `grep -rn "rewrite label" socle/agents/formulas/` | 5 (one per formula) |
| `grep -c "rewrite label" socle/agents/methodology.md` | 1 |
| numbered rules in `socle/agents/discipline.md` | 12; the `update` redirect is rule 11 |
| `grep -c "upgrade-v2" bin/chisel.sh` | 2 |
| `grep -rn "grill-with-docs" socle/ upstream.lock.json test/fixtures/golden-tree.txt` | 6 |
| `grep -rn "triage" socle/ upstream.lock.json test/fixtures/golden-tree.txt` | 40 |
| `grep -rn "work on slice <file>\|work on task <file>" socle/ AGENTS.md` | 2 |
| `grep -c "work document" AGENTS.md` | 0 |
| every `.agents/skills/<name>` path cited in `socle/` (`grep -roE "\.agents/skills/[a-z0-9./-]+" socle/ \| sort \| uniq -c`) | only `chisel-beads/` (6) and `chisel-setup/` (1) — no socle text points at `triage`, `grill-with-docs` or `sync-upstream` by path, so the integrity scenario will not break on their removal |
| bare `§` section references in the three chisel skills | 8 in `chisel-beads`, 17 in `upgrade-v2`, 35 in `chisel-setup` — chantier 5's sweep, untouched here |
| `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` | 9 scenarios, 94 assertions, 0 failed |

**Two rulings were already fully executed by chantiers 1 and 2**, and are
recorded as done rather than re-specified: **A3 (3)** ("The Ledger" replaced
by "the coordination state" — 0 occurrences left, CHANGELOG entry 21) and
**F1.3** (the design-check tier aligned on "cheap or mid" — the step was
renamed to `plan-review` and the formula bodies now name a role and its
contract with no tier at all; `mason.md` and the roster both read "cheap or
mid").

**One ruling was partly executed.** **F1.9**'s "règle 10" is now rule **11**:
chantier 1 inserted a new rule 10 and stripped the preset wiring from the
`update` rule (CHANGELOG entry 23) but did not delete it. The ruling is
unambiguous — "supprimée, point final" — so the rule goes, and rule 12
becomes rule 11.

**B1 was verified, not assumed.** The spec template chantier 2 landed still
carries the pre-B1 wording. Its zone table says "Human, always, before code";
the file never names "Zone ownership". The contradiction B1 exists to remove
is still shipped.

**Two riders are flagged for the Owner to strike.** `README.md:19-31` and
`PHILOSOPHY.md:126-142` are stale from chantiers 1 and 2 rather than from a
ruling in this list, and are ruled in only because A4 and E1 open both files
anyway. If the Owner would rather this chantier stay strictly inside its
seven rulings, strike `readme-gradient-current` and
`philosophy-presets-current` at spec review; the rest of the task is
unaffected.

**One gap stays unowned and needs a decision.** The `chisel-beads` skill does
not document the blocked status the methodology tells the reader to use. See
"Ruled OUT" in Scope for why it is not repaired here.

**On the length of the REVIEW CAREFULLY zone.** It runs 276 lines, and most of
that is the 19-row Scope table and the 24 named criteria. Both are the review
surface itself for a pass that applies nineteen separate rulings: compressing
either would move the decision material out of the zone that is supposed to
hold it. The prose around them is deliberately short. Recorded so a spec
review reads the length as a choice rather than as bloat — and so that if the
Owner disagrees, the fix is fewer rulings per chantier, not a thinner table.

**Author's note, 2026-09-08, `architect`.** No blocker was met writing this
spec. Every claim about the current state above was produced by running its
command against this working tree, not read from an earlier report; where the
360 review's own report and this repo disagreed, the repo won.

**Foreman note, 2026-09-09 · `foreman`.** Implementation Decision 1 cited
"rule 12" of the discipline for the section-reference form. Slice 01 deleted
rule 11 and renumbered 12 to 11 (commit `65c505e`), so the citation now reads
"rule 11", with the old number kept in parentheses. Found by slice 01's
Inspector (finding Sp1); no ruling changed.

**Foreman note, 2026-09-09 · `foreman`.** Implementation Decision 1 sent
`code-review:18` to §B · Coordination. Slice 02 applied it verbatim; its
Inspector (finding Sp3, escalation E-1) showed the sentence describes where
the task workspace is declared, which is §A · Task workspace of
`.agents/project.md`, while §B holds only B1 and B2. The decision is amended
above, struck and dated, and the line is corrected in slice 02's follow-up
commit. `slice-task:17` keeps §B · Coordination, so the `§B · Coordination`
grep of `tracker-pointer-resolves` stays non-zero.

**Closed, 2026-09-09 · `foreman`.** Slices 01, 02 and 03 closed 🟢 with their
Inspectors' verdicts recorded in each slice spec. Deliverables: the three
slice pairs; the socle repaired against A1, A3, A4, B1, E1, E2 and F1 (24
criteria green on the tree, re-run by slice 03's Inspector); `grill-with-docs`
and `triage` gone, `sync-upstream` at `socle/scripts/`; the role-reuse rule at
`socle/agents/profiles/foreman.md:38`; fixture 90 lines, lock 14, suite
9/94/0; CHANGELOG entry 25; this retrospective. The audit's present-tense
skill count received a dated addendum (slice 03 escalation E-2, Sp1).

## Retrospective

Written at `close`, 2026-09-09. Three slices in two days, each through the
same shape: program design persisted in a work document → Architect
validation (one round for slice 03, two for slice 02) → typing → fresh
Inspector; six verdicts, six PASS. All 24 named criteria re-run green by the
last Inspector.

What worked. The two-document model carried its first real load: every role
after the plan was a fresh session (the session tool that would have kept a
Mason alive was unavailable the whole time), and each one rebuilt its
understanding from the spec/work pair alone without a single misreading of
intent — the promise chantier 2 made is now observed, not claimed. The
plan-review caught what typing would have shipped: a pointer to a section
that did not exist, an after-count that contradicted the design's own table,
an edit the spec had ruled in and the design had left out. Strike-and-date
amendments kept every correction traceable.

What cost. Slice specs written on 2026-09-08 went stale as the earlier
slices landed: line numbers moved, counts dropped, one "drop from 5 to 2"
became "4 to 1". Every Mason re-measured at `plan` and none was misled, but
each re-measurement was a dated note and a foreman correction. A parent
Implementation Decision assigned a pointer to the wrong section of
`.agents/project.md` and was applied verbatim through two reviews before the
Inspector read the sentence it was attached to. The PHILOSOPHY rider grew
from one paragraph (126-142) to 68-136 through two foreman rulings under the
Owner's standing go; every edit is defensible and each was reviewed on both
axes, but the essay is the Owner's and the growth is reported as reversible.

Proposals, for the Owner to rule on:

1. Slice specs should anchor on strings, not line numbers, and state that
   every count is re-measured at `plan`; the `slice-task` skill should say
   so. Line numbers are indicative the moment another slice lands.
2. An Implementation Decision that assigns a section pointer should be
   checked against the target file's headings when the spec is written, not
   at `diff-review`.
3. Confirm or reverse the two thread-owner rulings reported as reversible:
   the `PHILOSOPHY.md` rider at 68-136, and the amendment of Implementation
   Decision 1 (`code-review:18` → `§A · Task workspace`).
4. Loose ends with no owner, small: `PHILOSOPHY.md:75-78` says "proposes a
   task file" where the collective term is loose, not false; the comment at
   `socle/scripts/sync-upstream.sh:144` counts 15 lock entries where there are
   14. Either chantier 5 or a one-line fix at the Owner's convenience.
