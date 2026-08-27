# 07 — Docs rewrite + one-source-per-concept dedup

**Status:** 🟢 Complete
**Blocked by:** 05, 06

**What to build:** The documentation catches up with v2 and the normative
duplication dies. PHILOSOPHY §4 rewritten in the mode vocabulary — the
W0/W1/W2 labels are RETIRED everywhere (they roughly map: W0 ≈
Controlled/Silent, W1+W2 ≈ Controlled/Active, W3 ≈ Auto — the modes describe
piloting postures, not work sizes). `methodology.md` refreshed: matrix,
roster vocabulary, tiers, ledger convention — doctrine only. README updated
(what/why/install/modes in plain english, under 5 min). Then the
**one-source-per-concept pass** over the whole socle (duplication inventory:
`../factory-bench/research/inventaire-socle-chisel.md` §4): artifact
structure → templates; doctrine → methodology; triggering → formula steps;
every other occurrence becomes a pointer (known v1 duplicates: artifact
structure ×3, typist delegation ×3, model policy ×3, sizing check ×3).

## Acceptance criteria

- [x] `grep -rn "W0\|W1\|W2"` over `socle/`, `PHILOSOPHY.md`, `README.md`
      returns no mode-label hit
- [x] PHILOSOPHY §4 and methodology.md present the piloting postures and the
      coordination choice as one default plus options (matrix framing retired
      — Owner ruling, plan gate 2026-08-27), the invocation-posture principle,
      the Brief-stays-human invariant, and the roster — consistent with the
      shipped formulas and profiles
- [x] For each duplicated concept of the v1 inventory, exactly one normative
      source remains and the other occurrences are links — mapping listed in
      this slice's Notes
- [x] README covers the two setup-visible choices (coordination, auto) and
      the upgrade path, in plain language
- [x] The whole test suite stays green after the rewrite (rewritten from
      "CLI test greps of slices 01/03" — those greps were deleted by slice 09;
      Owner ruling, plan gate 2026-08-27)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

Planned 2026-08-27, against `main` @ `b84558c`, suite green: **9 scenarios,
88 assertions, 0 failed, 588 of the 600-line cap**. That is the baseline every
step below must come back to.

### D0 — the block is lifted

The header reads **Blocked by: 05, 06**. Neither blocks the documentary work:

- **05** is 🟢.
- **06** is 🟠 only because its two real pilots (evea-ai, music-downloader)
  wait on the Owner. Every socle artifact it owed shipped — the `upgrade-v2`
  skill, `LOG.md` as the v2 default, the §A journal rule, the reshaped waiver.
  Nothing written here reads a pilot's result.

07 starts now. A sentence a pilot would later contradict is a `retro` finding,
not a dependency.

### D1 — two acceptance criteria predate the decisions they must satisfy

**This is the one thing the plan cannot settle alone.** Both are 🧑 zone text.
Stated with a proposed reading; the Owner rules at the plan gate.
**Ruled at the plan gate, 2026-08-27: the Owner accepted both proposed
readings, and the two ACs above are rewritten accordingly.**

**AC2 asks for "the matrix (piloting × coordination)".** The audit round
retired that framing: *"Vocabulary: 'a default + options', the matrix is
retired"* (parent, `20260826-1512-chisel-v2.md:366-374`). Writing the matrix
back into PHILOSOPHY §4 and `methodology.md` would ship the vocabulary the
Owner replaced.

> **Proposed reading:** AC2's five ingredients are the *substance*, not the
> word. The two axes still exist — a piloting posture chosen per invocation,
> a coordination state that is repo state — so they are presented as **one
> default plus two options** (beads, auto), with the three presets named and
> "Factory = auto × beads" stated. The invocation-posture principle, the
> Brief-stays-human invariant and the roster are written as AC2 asks.
> The word "matrix" does not appear as the framing.

**AC5 asks that "CLI test greps (slice 01/03) still green".** Slice 09 deleted
those greps permanently: *"group 13 (neutrality greps), every prose/magic-string
assertion in groups 7-9 (word pins, wording checks, W-label greps)… An AC
written as a grep is verified once at review time and never committed as a
test"* (`09-test-suite-rebuild.md:31-34`). The tests AC5 names no longer exist.

> **Proposed reading:** AC5 becomes *the whole suite stays green* — strictly
> more than it asked. Their surviving structural heirs are the ones to watch:
> `init`'s `assert_file_not_contains ".agents/rules/"`, `render`'s
> no-invented-numeric-limit scan, and `integrity`'s v1-citers assertion.

**AC1 is a grep, and stays one.** `test/TESTS.md` standing rule 1 forbids
committing it: it is verified once, at review time, by running
`grep -rnE "W0|W1|W2" socle/ PHILOSOPHY.md README.md` and showing the empty
output in the worklog. **No new test is added by this slice.**

### D2 — the debt inventory

Ten slices legated to 07. Every one, its source, and the step that settles it.
A line marked ↷ is deliberately NOT settled here and names its new owner.

**Retired v1 layer still cited**

- [x] `methodology.md:5` cites `.agents/rules/task-*.md` — `01:297`, `03:276` → **S2**
- [x] `methodology.md:8` links `[workflows.md](./workflows.md)` — `01:297`, `03:335` → **S2**
- [x] `methodology.md:94` cites `task-progressing.md` — `01:297`, `03:276` → **S2**
- [x] `PHILOSOPHY.md:6` links `socle/agents/workflows.md` — `01:300` → **S4**
- [x] `PHILOSOPHY.md:125` links `workflows.md` "(the visual guide, gates and model policy)" — `01:300` → **S4**
- [x] `test/installer.sh:377-378` — the two waiver lines' `+ DEBT` half expires — `08:185-194`, `06:172-177` → **S2**
- [x] `test/installer.sh:401` — `methodology.md` leaves the v1-citers allow-list — `06:248-257`, `CHANGELOG.md:105-110` → **S2**

**Owner vocabulary: "a default + options"**

- [x] `chisel-controlled` → `chisel-default`, every occurrence — `08:221-224`, `10:143`, `11:269`, parent `:267-269` → **S1**
- [x] `foreman.md:18` heading "## Controlled: the Foreman is you" — same rename — **S1**
- [x] `chisel-supervised` is named in no routing text — `08:221-224`, parent `:267-269` → **S3**
- [x] PHILOSOPHY §4 W0/W1/W2 labels — AC1, `07:21-22` → **S4**
- [x] "Silent" as a mode name — parent `:414-417`. **Already absent from `socle/`** (verified); only §4's W0 line carries it → **S4**
- [x] `methodology.md` speaks "planner session / typist session", not the roster — AC2 → **S2**

**Naming what now resolves by search**

- [x] `AGENTS-block.md:33` "the project glue allows it" — does not name **§B3** — `04:615` → **S3**
- [x] `chisel-auto.formula.toml` header "the project glue enables it" — same — `04:615` → **S3**
- [x] `chisel-supervised.formula.toml:30-31` — same — `04:615` (by extension) → **S3**
- [x] `methodology.md:174-176` cascade level 2 — does not name **§H** — `04:616` → **S2**
- [x] Nothing routes to `.agents/profiles/` from the ambient layer — `02:463-479`, **explicitly flagged as needing an owner** → **S3**

**Owner rulings awaiting their wording**

- [x] 🧑 = the zone's OWNER, not "the human" — parent `:375-383`; today `discipline.md:16` says "Human-owned zones are law" and `methodology.md:50` "the human's property" — `08:309-313` → **S2** (doctrine) + **S3** (ambient)
- [x] The escalation chain + **the Owner's digest**, named 9× across profiles and formulas and **defined nowhere** — parent `:375-383`, `08:309-313` → **S2** (defined once) + **S3** (named in the ambient core)
- [x] A refused `update` is a redirect: chain onto `upgrade-v2`, propose in default / run in supervised·auto — parent `:279-285` → **S3**

**The journal**

- [x] `methodology.md:11,233-242,251` still says CHANGELOG — `06:248-257` → **S2**
- [x] "written by hand, never generated" is missing from the doctrinal page (06 could only write it in glue §A) — `06:128-135` → **S2**
- [x] `discipline.md:9` "changelog entries" — `06:264-265` → **S3**
- [x] `PHILOSOPHY.md:116,119` CHANGELOG — → **S4**
- [x] Glue §A field label `Changelog:` / §C `<Changelog>` — `06:118-126`, `06:258-263` → **settled by ruling R2, kept as-is**

**One source per concept** (v1 inventory §4:116, re-verified against today's tree)

- [x] Model policy ×3 → **already one source**: `methodology.md` "Model tiers", which says so; §H points at it, `code-review` points at it. Verified, recorded, no edit → **S6** (mapping table only)
- [x] Sizing check ×3 → the three layers are legitimate (doctrine · trigger · know-how); the overlap to remove is `slice-task/SKILL.md:43-44` restating the glossary's definition → **S5**
- [x] Typist delegation ×3 → `methodology.md:107-143` and `:190-208` say it twice inside one file, in retired vocabulary; `mason.md` holds the role contract; the formulas hold the trigger → **S2**
- [x] Artifact structure ×3 → task shape = `templates/000-task-file-template.md`; slice shape = `slice-task`'s emitted template; `methodology.md` stops restating and points → **S2**
- [x] `improve-codebase-architecture/SKILL.md:34` — `Agent` tool / `subagent_type=Explore` hardcoded — `03:277` → **S5**
- [x] `codebase-design/DESIGN-IT-TWICE.md:23` — "the Agent tool" hardcoded — `03:277` → **S5**

**Stale after slices 10 and 11**

- [x] `foreman.md:51` and `profiles/README.md:8-9` list "Architect, Mason, Inspector" — `checker.md` shipped in slice 11 and is missing from both → **S3**
- [x] `methodology.md` describes a 7-step pipeline world; the formulas ship **9 steps** (`spec-review`, `design-check` added by slice 10) → **S2**

**Not settled here** ↷

- ↷ **The CLI does not read glue §A** — `init` hardcodes `project-management/` (`06:266-270`; inventory §4:115). Behaviour, not documentation: fixing it changes what `init` writes and what the golden tree contains. **New owner: the Owner**, as a post-v2 task — it predates v2 and touches the installer, not the docs.
- ↷ **`render` only checks three of the four rendered profiles** (`installer.sh:251` loops `architect mason inspector`; `checker` is installed and rendered but unverified). Test coverage, not documentation, and the suite budget is the Owner's. **New owner: the Owner** — reported, not fixed.
- ↷ **`chisel-setup`'s §B3 verbatim question stays binary.** Making it three-valued is questionnaire work that reaches `upgrade-v2` too, and no AC asks for it. The glue §B3 names the presets instead (ruling R3). **New owner: the Owner**, if a three-way setup question is ever wanted.
- ↷ **The dogfooding task** `20260826-2302-chisel-dogfoods-itself.md` is post-v2 and untouched (parent `:277`).
- ↷ **06's two real pilots** and the parity re-verification stay the Owner's (`06:240-244`).
- ↷ **Beads routing into the doctrine** (`05:238-241`, "slice 07 owns any further routing"): **settled by ruling** — no beads vocabulary enters `discipline.md` or `methodology.md` beyond the one place the Owner's digest needs it (the blocking `escalation` bead, named as a §B-conditional mechanic). The convention stays reachable through §B1 and the skill's own description. No further routing is added.

### D3 — three rulings the plan makes

**R1 — the waiver lines survive; only their DEBT half expires.**
The brief reads "make the two DEBT lines expire". Deleting the lines would turn
the suite **red**: `upgrade-v2/SKILL.md` legitimately names both paths, so both
keep dangling and would resurface in `dangling-new.txt`. Slice 06 already said
so — *"the two v1 waiver lines can no longer expire"* (`CHANGELOG.md:125-129`).
What expires is the annotation and the allow-list:

- `installer.sh:377-378` — strip `+ DEBT (still cited by methodology.md — slice 07)`, leaving the BY DESIGN half.
- `installer.sh:401` — expected value becomes `.agents/skills/upgrade-v2/SKILL.md ` (one entry, trailing space kept).

**Consequence for the budget: this frees ZERO lines.** Both edits are in place.
The suite stays at 588. No step below spends a line it does not have.

**R2 — the glue field stays `Changelog:`.**
06 handed the rename here as an open question. The answer is no. `project.md`
is the one file `update` never rewrites (asserted, `installer.sh:138`), so
renaming the field splits every already-equipped repo from every new one with
no mechanism to converge. The *word* is the real problem, and the word is fixed:
socle prose says **the journal declared in `.agents/project.md` §A**. Debt
closed by decision, not deferred.

**R3 — §B3 gains the preset names, not a third answer.**
The line already governs "running without stopping at the human decision
points", and `chisel-supervised` is such a run. §B3's prose names both non-default
presets and states that the same one-word line governs them both; the
questionnaire keeps its two answers.

---

### S1 — the rename, atomic

**Files** (complete; `grep -rni controlled` was run over `socle/ bin/ test/`
and the root — every hit below, and only these):

| Path | What |
|---|---|
| `socle/agents/formulas/chisel-controlled.formula.toml` | `git mv` → `chisel-default.formula.toml`; `formula = "chisel-default"` (l.18); header l.1 and `description` l.19 read "Default" |
| `socle/agents/formulas/chisel-auto.formula.toml` | l.1 and l.23 cite `chisel-default` |
| `socle/templates/AGENTS-block.md` | l.19 path |
| `socle/agents/foreman.md` | l.18 heading → `## Default: the Foreman is you` |
| `test/fixtures/golden-tree.txt` | l.7 (keeps alphabetical order: `chisel-auto`, `chisel-default`, `chisel-supervised`) |
| `test/installer.sh` | l.48, 131, 150-151, 219 (paths + the `controlled=` variable), l.235 (the parse dict key) |

`bin/chisel.sh` never names a formula — the manifest walks the socle source.
Do **not** touch `writing-great-skills/GLOSSARY.md:145`: "controlled by the
agent" is ordinary English.

**Recopied:** every path string, mechanically. **Written:** three short
sentences — the two formula headers and the `description` — swapping
"Controlled mode" for "the default", nothing else re-argued.

Net lines: 0. Net assertions: 0. Suite green, commit.

### S2 — `methodology.md`, the doctrinal source

The biggest piece. The file is rewritten in place: its sections keep their
order where the order still holds, and it gains what only it can carry.

**Removed / repointed**

- l.4-8 header map → the **what/where** is the task template declared in
  `.agents/project.md` §A; the **order and the gates** are `.agents/formulas/`;
  the **ambient invariants** are `.agents/discipline.md`; this file is the why.
  Neither retired path survives.
- l.94 `(rule: task-progressing.md)` → the `plan` step of the formulas.
- l.11, 233-242, 251 → **the journal declared in §A**; the section becomes
  "Why the journal stays", and gains 06's rule verbatim in substance: written
  by hand, one dated entry per task, **never generated** — not from a
  coordination database's audit trail, not from git history. ADRs are a
  separate artifact.
- l.174-176 cascade level 2 → names `.agents/project.md` **§H**.
- l.50 → rewritten under the ownership doctrine below.

**Written new**

1. **A default and two options.** chisel has one default behaviour; two options
   add to it — **beads** (the status database, repo state, additive) and
   **auto** (permission not to wait, an invocation posture, §B3). The three
   presets: `chisel-default` (the human holds every gate), `chisel-supervised`
   (one asynchronous gate — the Owner approves the spec, and nothing else),
   `chisel-auto` (no gates; a doubting step escalates). **Factory = auto ×
   beads** — the only combination that requires beads, because only it needs
   queues, lanes and asynchronous gate lists. Plain auto is one chained
   session and needs none.
2. **The roster**, in one table: Owner (the Brief, always), Architect (thinks),
   Checker (reviews the spec, never its author), Mason (types), Inspector
   (reviews the diff, never its author), Foreman (routes — not an agent).
   Contracts live in `.agents/profiles/`; the Foreman's reasoning in
   `.agents/foreman.md`. The table names roles and points; it does not restate
   a profile.
3. **Zone ownership.** 🧑 marks the zone's **owner**, and ownership follows
   authorship of the approval: in the default the human approved spec and plan,
   so both are his; in auto the Architect authored them, so a Mason's
   escalation terminates there and the human never hears of it; in supervised
   the spec is the human's and the plan the Architect's. **The Brief is always
   the human's, in every mode.** A 🧑 zone is never overridden silently, in any
   mode — it is contested upward, never edited sideways.
4. **The escalation chain, and what the Owner's digest is.** Mason → Architect
   → Inspector → the Owner's digest, one rung at a time, climbing to the owner
   of the contested zone. The digest is named nine times across the profiles
   and the formulas and defined nowhere; it is defined here, once, and it
   creates **no new artifact**: a dated ⚠️ line in the journal declared in §A,
   plus — when §B1 says the coordination state lives in beads — a blocking
   `escalation` item assigned to the Owner, per the §B convention. That is the
   whole mechanic.
5. **The pipeline is nine steps**, not seven: `spec-review` (a Checker, fresh
   session, never the author, two rounds max) and `design-check` (the Mason
   posts its program design; the plan's Architect answers VALIDATED or
   corrections, two rounds max, then a finding against the plan) are part of
   the doctrine now. Where the gates sit is the formulas' business, named per
   preset, not restated step by step.

**Deduplicated**

- l.107-143 and l.190-208 say the delegation doctrine twice. They fuse into one
  passage in roster vocabulary — Architect thinks, Mason types, the plan is the
  boundary — keeping dex's phase table (it earns its place: it maps phases to
  artifacts) and dropping the second prose telling. "planner session" and
  "typist session" disappear.
- Wherever the file describes the *shape* of an artifact it stops and points:
  task shape → `templates/000-task-file-template.md`; slice shape → the template
  `slice-task` emits. The glossary entries stay — they are the vocabulary
  source, not a structure restatement.
- The model-tier section is already the single source and says so. Left as is.

**In the same commit — the waiver, per ruling R1:** `installer.sh:377-378`
and `installer.sh:401`. **These two edits and the `methodology.md` rewrite
cannot be split**: `integrity` asserts the allow-list in both directions, so
fixing the file without the test turns the suite red, and the reverse too.

**Recopied:** the glossary table, the model-tier section and its cascade, dex's
phase table, the provenance note — moved or trimmed, not re-argued. **Written:**
the five new passages above, the fused delegation passage, and the repointed
header. No invented numeric limit anywhere — `render` scans for
`40 lines|8 lines|half of the slice|half the spend|target ~` over the whole
installed socle and this file is in it.

Net assertions: 0. Net lines in `test/`: 0. Suite green, commit.

### S3 — the ambient layer and the routing texts

`socle/agents/discipline.md`

- rule 3 → the zone's **owner**, one sentence, pointing at `methodology.md` for
  the doctrine written in S2. The ambient core states the law; it does not
  re-derive it.
- rule 6 → names the chain (Mason → Architect → Inspector → the Owner's digest)
  and points at `methodology.md` for what the digest is.
- **New, short:** *before spawning a role, read its profile* — the rule lives
  today only in `profiles/README.md` and `architect.md`, and nothing in the
  ambient layer routes an agent to `.agents/profiles/` at all. This closes
  slice 02's residual, the only hand-off in the task marked *needs assigning,
  not just noting* (`02:463-467`).
- **New, short — the refused `update` is a redirect.** An agent whose
  `chisel update` is refused for a v1 layout does not stop there: it chains
  onto `upgrade-v2` per the active preset — **proposes** it in the default,
  **runs** it under supervised or auto, the new glue questions following that
  preset's gates. `bin/chisel.sh` is **not** touched: the CLI stays dumb, and a
  migration needs judgement, which is the skill's job. (This also keeps
  `guards`' two refusal assertions untouched.)
- l.9 "changelog entries" → "journal".

`socle/templates/AGENTS-block.md`

- The default pipeline is `.agents/formulas/chisel-default.formula.toml`.
- Names the other two presets and what each drops, and names **§B3** as the
  line that permits them — replacing "the project glue allows it".
- One line routing to `.agents/profiles/`: the formula steps name roles, the
  contracts are there, read the profile before spawning one.
- The block is byte-compared against its own render (`installer.sh:43-44`);
  `installer.sh:47-48` follows S1's path. Nothing else to update.

`socle/agents/project.md.tpl` §B3 — per ruling R3: the same one-word line, now
naming `chisel-supervised` and `chisel-auto` as the two runs it governs, and
restating that the choice of which one is asked for in-session, never granted
in-session.

`socle/agents/formulas/chisel-auto.formula.toml` and
`chisel-supervised.formula.toml` — headers name **§B3** instead of "the project
glue enables it". Header comments only; **no step body is touched** (supervised's
bodies are auto's byte for byte by slice 08's design — that invariant is not
asserted today, and this slice must not be what breaks it).

`socle/agents/foreman.md:51` and `socle/agents/profiles/README.md:8-9` — the
roles list gains **Checker** (shipped by slice 11, missing from both).

**Recopied:** the §B3 line, the profile-list sentences. **Written:** four short
additions to `discipline.md` and the block's preset paragraph — each a few
sentences, in the ambient core's existing voice.

Net assertions: 0. Net lines in `test/`: 0. Suite green, commit.

### S4 — `PHILOSOPHY.md` §4 and `README.md`

`PHILOSOPHY.md`

- l.6 and l.124-127: the `workflows.md` links go. The reference list becomes
  `methodology.md` (the concepts), `.agents/discipline.md` (the ambient core),
  `.agents/formulas/` (the order and the gates), the task template.
- **§4 rewritten.** W0/W1/W2 disappear. Three situations become: the ambient
  discipline (every conversation, no artifact — this is what W0 was, and it is
  not a mode, it is the default's behaviour when there is nothing to file);
  one task; a parent task with slices. Then the presets, in the D2 vocabulary:
  a default plus beads and auto, the three preset names, Factory = auto ×
  beads. The mapping is stated for a reader who knew the old labels — W0 ≈ the
  default with no artifact, W1+W2 ≈ the default with one, W3 ≈ auto — and then
  the labels are gone. **They map to work sizes; the presets describe piloting
  postures. That is why they were retired, and §4 says so in one sentence.**
- l.116 and l.119: CHANGELOG → the journal.
- §3's bullets are unchanged doctrine and stay; the "Humans own the gates"
  bullet gains the ownership nuance in a clause, not a paragraph.

`README.md` — rewritten. Today it says "v1 is being built" and "What it will
do". Target: **what / why / install / the default and its two options / the
upgrade path**, plain English, readable in a sitting.

- What chisel is and what `npx @lonestone/chisel init` poses.
- The default: reading-gradient spec files, seams before code, the plan
  persisted, two-axis review, the human at the gates.
- **The two choices setup actually shows you** (AC4): where task statuses live
  (§B1 — markdown files, the default; or beads, the status database) and
  whether an agent may run without stopping (§B3 — off by default). Both are
  one line in `.agents/project.md`, both changeable later.
- **The upgrade path**: `chisel update` for a v2 repo; a v1 repo is refused by
  name and goes through the `upgrade-v2` skill first — agent migrates, human
  validates.
- `chisel check`, and `sync-upstream` for maintainers of this repo.
- The "⚠️ Work in progress / v1 is being built" banner goes.

**Recopied:** the install command, the provenance paragraph, PHILOSOPHY's
sources block. **Written:** §4 and the whole README body.

`PHILOSOPHY.md` and `README.md` are not installed, so `integrity` never walks
them — their links are checked by reading, at review time, and the check is
shown in the worklog.

Net assertions: 0. Suite green, commit.

### S5 — the dedup residuals

- `socle/agents/skills/improve-codebase-architecture/SKILL.md:34` — "use the
  Agent tool with `subagent_type=Explore`" becomes tool-neutral, in the exact
  shape slice 03 already landed in `code-review/SKILL.md:69`: whatever
  exploration sub-agent the tool provides, the brief carrying what it needs.
- `socle/agents/skills/codebase-design/DESIGN-IT-TWICE.md:23` — "Spawn 3+
  sub-agents in parallel using the Agent tool" — same treatment; the count and
  the "radically different interface" requirement are unchanged.
- `socle/agents/skills/slice-task/SKILL.md:43-44` — drops the restated
  definition of a slice and points at the glossary in `.agents/methodology.md`.
  The skill keeps the *know-how*: how to cut, how to quiz, what to publish.

**Recopied:** `code-review:69`'s phrasing, as the pattern. **Written:** two
sentences and one pointer.

Net assertions: 0. Suite green, commit.

### S6 — close

- AC1 verified by running the grep and pasting the empty result into the
  worklog — per `TESTS.md` rule 1, verified at review time, never committed.
- AC3's mapping table written into **Notes**, as AC3 requires: one row per
  duplicated concept of the v1 inventory, its single normative source, and
  where the other occurrences now point.
- The debt inventory of D2 ticked, item by item, with what was settled where.
- Deliverables and ACs ticked against reality; status set; dated entry in
  `project-management/CHANGELOG.md`; `retro`.

### D4 — execution order

Six steps, each ending on a **green suite and a commit**. The order is not
arbitrary: S1 fixes the name every later text writes, and S2 carries the test
edits that only its own rewrite makes legal.

1. **S1** — the rename. Mechanical, atomic, isolable.
2. **S2** — `methodology.md` + the waiver and allow-list, one commit.
3. **S3** — `discipline.md`, the AGENTS block, §B3, the two formula headers,
   the two stale role lists.
4. **S4** — PHILOSOPHY §4, README.
5. **S5** — the three dedup residuals.
6. **S6** — close.

**Budget, stated plainly.** Net **0** new assertions and net **0** new lines in
`test/` across all six steps. The suite stays at 588 of 600. Ruling R1 frees
nothing — both waiver edits are in place — so no step may plan to spend a gain
that does not exist. If a step needs a line, that is a finding for the Owner.

**On size.** This is a large slice: `methodology.md` alone is 15.2 Ko rewritten
against decisions spread over eleven files. The six commits are the mitigation —
each leaves the tree green and the next step resumable from this Design by a
fresh session. A Mason that runs out of room after any step hands off; it does
not compress.

### D5 — out of scope, explicitly

- **`bin/chisel.sh`.** Not touched. The refusal message keeps its wording (the
  redirect is written in `discipline.md`), and `init`'s hardcoded
  `project-management/` is the Owner's, post-v2.
- **The task `20260826-2302-chisel-dogfoods-itself.md`** — post-v2. 07 does not
  read it, does not advance it.
- **06's pilots and the parity re-verification** — the Owner's.
- **Formula step bodies.** Only the three headers and the two name strings
  change. No step description is edited: slice 10 and 11 own that surface, and
  supervised's bodies must stay auto's byte for byte.
- **`inspector.md`**, `architect.md`, `mason.md`, `checker.md` — the profiles
  are slice 08/10/11's delivered contracts. 07 adds `checker` to two *lists*
  that forgot it; it does not edit a profile body.
- **`chisel-setup`'s questionnaire** — §B3 stays a two-answer question.
- **New tests.** None. AC1 and the link checks are review-time verifications.
- **Beads vocabulary** in `discipline.md` / `methodology.md` beyond the digest's
  §B-conditional mechanic.

### D6 — questions the plan could not settle

1. **AC2's "matrix"** — D1. The proposed reading writes the substance in the
   Owner's retired-matrix vocabulary. Needs a yes.
2. **AC5's deleted greps** — D1. The proposed reading is "the whole suite stays
   green". Needs a yes.

Both are 🧑 zone text, so neither is decided here.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Execution log

Six commits, each a green suite (9 scenarios, 88 assertions, 0 failed, 588
of the 600-line cap — unchanged start to finish, per the plan's zero-line
budget):

1. **S1** — `215dbf4` — `chisel-controlled` → `chisel-default`, atomic. The
   file table's `grep -rni controlled` was re-run before committing and
   caught one hit the plan's table missed: `chisel-auto.formula.toml:7`
   ("where Controlled waits, Auto ESCALATES") — the same retired mode-name
   vocabulary, same mechanical treatment, folded into the same commit.
2. **S2** — `88417dd` — `methodology.md` rewritten as the sole doctrinal
   source, plus the ruling-R1 waiver/allow-list edit in `test/installer.sh`
   (the two cannot be split: `integrity` asserts the allow-list both ways).
3. **S3** — `ddfc5dc` — the ambient layer and the routing texts:
   `discipline.md`, `AGENTS-block.md`, `project.md.tpl` §B3, the two formula
   headers (comments only — the auto/supervised byte-for-byte body invariant
   from slice 08 was re-diffed after the edit and holds), the two stale role
   lists.
4. **S4** — `0ae77f2` — `PHILOSOPHY.md` §4 and `README.md`. See "AC1 vs the
   plan's literal wording" below for one deliberate deviation.
5. **S5** — `8f5d6da` — the three dedup residuals (two hardcoded "Agent
   tool" mentions, one restated slice definition).
6. **S6** — this commit — close.

### AC1 — the grep, verified at review time (never committed as a test)

```
$ grep -rnE "W0|W1|W2" socle/ PHILOSOPHY.md README.md
$ echo "exit: $?"
exit: 1
```

Empty output, exit 1 (no match). Re-run after every step from S1 onward;
first came back empty at S4, the step that touched the last two carriers of
the labels (`PHILOSOPHY.md` §4 and its own earlier draft).

### AC1 vs the plan's literal wording — one deliberate deviation

D3/S4's design text asks for the retired labels to be mapped explicitly for
a reader of the earlier design: *"W0 ≈ the default with no artifact, W1+W2 ≈
the default with one, W3 ≈ auto."* Writing that sentence verbatim would have
put the literal strings `W0`, `W1`, `W2` into `PHILOSOPHY.md` — which is
exactly what AC1's own grep, defined two paragraphs earlier in the same
Design (D1), forbids. The two instructions contradict each other within the
same slice.

Resolved in favor of the mechanical, gating criterion (AC1): §4 explains
*that* an earlier design used size-based labels and *why* they were retired
(work size vs. piloting posture — a sentence, per the plan's own summary
goal), without spelling out the old label strings. The reader-facing
Rosetta-stone mapping the plan asked for is not in the shipped text as a
result — flagging this precisely so the Owner can override the call if the
literal mapping is wanted enough to justify amending AC1 instead.

### AC3 — the one-source-per-concept mapping

| Duplicated concept (v1 inventory) | Normative source | Other occurrences → now pointers |
|---|---|---|
| Model policy ×3 | `methodology.md` — "Model tiers (and how they resolve)" | Already one source going in (verified, not edited): `project.md.tpl` §H points and says not to restate; `code-review/SKILL.md` points via anchor link; every formula step names a tier and stops there |
| Sizing check ×3 | Doctrine — `methodology.md` "Why slicing is conditional"; trigger — the formulas' `spec` step; know-how — `slice-task/SKILL.md` | `slice-task/SKILL.md`'s two bullets restating "demoable on its own" / "sized for a single fresh context window" dropped; replaced by a pointer to the Glossary (S5) |
| Typist delegation ×3 | `methodology.md` — the Corollary under "Why slices are born thin", now in roster vocabulary (Architect / Mason) | The second prose telling, in "Where dex's phases live", dropped; its table kept (it earns its place — maps dex phases to artifacts) (S2). `mason.md`/`architect.md` hold the role contracts, unchanged — they were never the duplicate |
| Artifact structure ×3 | Task shape: `templates/000-task-file-template.md`; slice shape: `slice-task`'s emitted `<slice-template>` | `methodology.md`'s Glossary keeps only the one-line Task/Slice vocabulary entries — checked for a structural restatement to remove; none existed (S2) |
| `improve-codebase-architecture/SKILL.md:34` — hardcoded "Agent tool" / `subagent_type=Explore` | `code-review/SKILL.md:69`'s tool-neutral phrasing | Now reads "whatever exploration sub-agent your tool provides, with a brief carrying what it needs" (S5) |
| `codebase-design/DESIGN-IT-TWICE.md:23` — hardcoded "the Agent tool" | Same pattern as above | Now reads "whatever parallel sub-agent mechanism your tool provides"; sub-agent count and the "radically different interface" requirement unchanged (S5) |

### D2 debt inventory

Ticked in place above, item by item, each with the step that settled it —
34 lines, all closed by S1–S5. The six ↷ lines (D2's last block) are
untouched by design: they are reassigned to the Owner as post-v2 tasks, not
settled by this slice.

### Found, not fixed (out of scope, flagged for the Owner)

- **`methodology.md`'s delegation Corollary still calls the Architect/Mason
  split "opt-in".** Every shipped formula (`chisel-default`,
  `chisel-supervised`, `chisel-auto`) always assigns the `type` step to a
  Mason — there is no formula-level path where the Architect types its own
  plan. "Opt-in" may still hold informally (nothing stops a human from doing
  both roles themselves outside the formula's letter), but the wording
  wasn't re-argued here: S2's brief was a vocabulary swap
  (planner/typist session → Architect/Mason), not a re-litigation of whether
  delegation is still optional. Not in D2's inventory; left as found.
- No other out-of-scope issues surfaced during S1–S5.

### D5 out of scope — confirmed untouched

`bin/chisel.sh`, the dogfooding task, 06's pilots, every formula step body
beyond the two headers named in S3, the four profile bodies, `chisel-setup`'s
questionnaire, and beads vocabulary beyond the digest's §B-conditional
mechanic — none of these were read for a change, per D5.

**Two Owner corrections received after S6 was written, applied as a
dedicated commit on top** (the executing Mason stalled mid-application; the
orchestrator finished it): (1) a glue subsection is referenced as file +
section title at first mention — "§B3 · Autonomous runs of
`.agents/project.md`" — never a bare number; applied to the files this
slice's steps already touch (README, methodology.md, AGENTS-block.md, the
two opt-in formula headers). (2) `methodology.md`'s "Why slices are born
thin" section rewritten as "The two designs — and why they do not happen at
the same moment": the SYSTEM design (Architecture, 🧑) is settled at
creation and is what makes a slice ready to produce — a slice can be big at
birth; only the PROGRAM design (files, signatures, TDD order) waits for the
plan step. PHILOSOPHY's "Spec once, design just-in-time" bullet aligned
("Two designs, two moments"). Suite green after both.
