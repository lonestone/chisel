# 03 — Abstract model tiers + user.md cascade

**Status:** 🟢 Complete
**Blocked by:** 01 (delivered)

**What to build:** The vendor coupling leaves the socle. Everywhere the socle
speaks about models it speaks in **tiers** — frontier / mid / cheap —
homogeneous with the roster (Architect/Inspector = frontier, Mason =
cheap/mid, Watchmen = cheap). The tier → concrete model mapping resolves
through a cascade: `.agents/user.md` (personal, GITIGNORED) >
glue `project.md` (versioned team default) > socle default. `user.md` gets a
template/shape and a lightweight generation path so any dev can create theirs
at their first session (the setup poses it for the current dev — wired in
slice 04). The v1 model policy passages (Cursor/Grok/Composer hardcoded in
methodology.md, code-review, and the late workflows.md — inventory:
`../factory-bench/research/inventaire-socle-chisel.md` §4 "Couplage vendor")
are rewritten in tier terms with the mapping read from the cascade.

## Acceptance criteria

- [x] `grep -ri "cursor\|grok\|composer\|opus\|sonnet"` over `socle/agents/`
      normative files and skills returns no model-policy hit (adapter/geste
      docs excepted, if any) — tiers only
- [x] The cascade is documented in one normative place and read by the texts
      that need a model choice (delegation, review) — pointers elsewhere
- [ ] `user.md` is gitignored in equipped projects (init poses the ignore
      rule); `update` never touches it; a fixture proves both
      — **half done, half re-attributed to slice 04** (D0.1 and Notes): the
      `update` half is delivered and fixture-proven; posing the file and its
      ignore rule belongs to the setup, which owns `.gitignore` and the glue
- [x] A dev without `user.md` still gets working defaults (glue, then socle)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-26 · Architect+Mason fused, delegation pre-approved by the Owner)

### D0 — Decisions taken at this plan gate (no human in the loop)

**D0.1 — AC3's "init poses the ignore rule" moves to slice 04.** This slice's
allotment does not include `bin/chisel.sh` (slice 02 is editing it in
parallel), and the chantier record is explicit that the ignore rule belongs to
the setup, not to `init`: *"user.md créé par le setup, gitignoré, généré par
chaque dev à sa première session"* (`bd show fb-3kk`, Decisions so far), echoed
by the parent's Scope (*"Setup v2: … `user.md` created by setup"*) and by this
session's brief (*"le setup slice 04 l'écrira ; toi tu livres le template + la
règle"*). So: **this slice delivers the template and the normative rule**;
slice 04 poses the file and writes the ignore line. The half of AC3 that is
testable today IS tested here (see D6): `init` never lays a `user.md` down,
`update` leaves a hand-written one byte-intact, `check` never flags it. The
untestable half is handed to slice 04 in the Notes, not silently dropped.

**D0.2 — the template's example mapping uses placeholders, not model ids.**
"Mapping en exemple commenté" could be read as "show real model names". It
must not: `user.md.tpl` is socle text, shipped to every tool, and the whole
point of this slice is that socle text names no vendor. Real names would also
rot within months and would trip the very grep AC 1 mandates. The example
therefore reads `**frontier:** <your tool's strongest reasoning model>` — a
shape the dev fills in, in a file that is theirs alone.

**D0.3 — the glue section is referred to by NAME, never by letter.**
`project.md.tpl` belongs to slice 04, which re-cuts §B into B1/B2/B3 and will
add the model-tier section. Naming a letter here would guess slice 04's
lettering and dangle. The socle says "the model-tier section of
`.agents/project.md`". Hand-off recorded in Notes.

**D0.4 — no "Q6/Q9" in the parent.** The brief points at "les résolutions
Q6/Q9 dans les Notes de la parente"; the parent's Notes carry five resolved
questions (formula location, formula names, bd prerequisite, step-file form,
GitLab §B2) and none of them bears on tiers or `user.md`. The binding
resolution used here is the epic's own decision line: *"Tiers de modèles
abstraits … mapping tiers → modèles en cascade : .agents/user.md (perso,
gitignoré) > glue project.md (défaut d'équipe versionné) > défaut socle. Le
couplage vendor sort du socle."*

**D0.5 — the vendor citation is paraphrased away, not re-attributed.** The
passage being rewritten quotes and links a vendor's blog post as the authority
for swarm economics. Keeping the link keeps the vendor name in a normative
socle file (AC 1). The idea is generic and is restated in our own words; the
reference survives in git history and in
`../factory-bench/research/`. Deliberate, recorded as a loss.

### D1 — The tier vocabulary (identical to slice 01's, by construction)

Slice 01 already writes `frontier` / `mid` / `cheap` into the formula step
roles (`Architect (frontier tier)`, `Mason (cheap or mid tier)`,
`Inspector (frontier tier)`). This slice does not invent a second vocabulary:
it gives that one its definition and its resolution rule, matching
`../factory-bench/roster.md`'s "Tier modèle" column.

| Tier | For | Roles |
|---|---|---|
| **frontier** | thinking, grilling, reviewing — where a wrong judgement is expensive and caught late | Architect, Inspector |
| **mid** | dispatch and ordinary tasks — competence without judgement | Foreman; a Mason on a non-mechanical slice |
| **cheap** | typing from a persisted plan; watching | Mason as typist; Watchmen |

The tier is a property of the WORK, not of the tool — that is what lets the
socle state it once and every tool honour it its own way.

### D2 — Where the cascade lives (the one normative place)

**Decision: a new `## Model tiers (and how they resolve)` section in
`socle/agents/methodology.md`, placed right after "Why slices are born thin"
and before "Where dex's phases live".** Rationale:

1. The retired `workflows.md §0 — Model policy` WAS the normative home; this
   is a relocation, not an invention. The parent's dedup rule sends doctrine
   to `methodology.md`, and the model policy is doctrine plus one resolution
   rule.
2. `methodology.md` is already a managed file installed by `init`, so the rule
   reaches every equipped repo with **zero change to `bin/chisel.sh`** — which
   slice 02 is editing right now. A new managed socle page would have forced a
   `copy_managed_files` / `managed_relative_files` edit and a near-certain
   conflict.
3. `discipline.md` (the other candidate) is delivered and out of my allotment,
   and it is deliberately the *ambient* core — a resolution table is not
   ambient.
4. The pointers already exist: both formulas' header comments end with "the
   reasoning belongs to `.agents/methodology.md`", so the formulas need no
   edit (they are delivered files anyway). `code-review` gets its pointer
   rewritten (D5). `user.md.tpl` points here rather than restating the rule —
   that is what keeps "one normative place" true and testable.

### D3 — `user.md`: template, shape, and how it gets posed

- **Canonical location: `socle/agents/user.md.tpl`**, symmetric with the
  existing `socle/agents/project.md.tpl`. Both are *templates the setup
  poses*, not managed copies: `copy_managed_files` names its sources one by
  one and never globs `socle/agents/`, so adding this file changes neither
  `init`'s output nor the manifest nor `check`.
- **Shape** (all of it commented out, on purpose — an untouched copy changes
  nothing and resolution falls straight through):
  1. a header saying what the file is (personal, never committed, may be
     absent) and pointing at the methodology section for the rule;
  2. `## Model tiers` — the commented example mapping, one line per tier,
     placeholders per D0.2, with "a tier you leave commented falls through";
  3. `## Notes for my sessions` — optional personal preferences, with the
     boundary stated: project-wide facts belong in `.agents/project.md`.
- **How it is posed:** the setup (slice 04) copies the template to
  `.agents/user.md` for the current dev and adds `.agents/user.md` to the
  project's ignore rules. `init` must never pose it (a shared installer has no
  business writing a personal file), `update` must never touch it (it is not
  in the managed list), `check` must never flag it (manifest-driven).
- **The rule, stated normatively in methodology.md:** never committed; a
  missing `user.md` is the normal case, not an error; nothing in the socle may
  require its presence.

### D4 — `socle/agents/methodology.md` — the passages rewritten

Surgery only: the sections stay, their order stays, one section is added.

| Lines (pre-edit) | Before | After |
|---|---|---|
| 114–119 | "In this repo's Cursor default … Grok for plan, implement, and review; Composer 2.5 only as an optional typist … Expensive tiers (Sonnet, Opus/Fable-class…)" + the dead `workflows.md §0` link | one paragraph: the cost gradient is a TIER gradient — thinking at frontier, typing from a persisted plan at cheap — resolved per dev and per project, linking the new section |
| 121–127 | swarm economics with a vendor blog link and a quote, "we just run them on Grok" | same argument, our own words, no citation (D0.5), ending on why the frontier tier is reserved for decomposition / design / trade-offs |
| 132 | "both from Cursor's failure modes" | "both from observed swarm failure modes" |
| 139 | "(on Grok)" | "(at the frontier tier)" |
| 149–152 | dex table: "Grok in Cursor" ×3, "Grok default; Composer 2.5 OK for simple typist" | "frontier tier" ×3, "typist session at the cheap or mid tier" |
| 201 | "start in task/slice files (and Cursor plans)" | "(and in whatever scratch plan surface the tool offers)" |
| new, after 143 | — | `## Model tiers (and how they resolve)`: the tier table (D1), then `### The cascade` — user.md > project.md > socle default, first level that answers wins tier by tier, the socle default being "your tool's strongest / standard / fastest model" (no id at all), then the no-`user.md` fallthrough written black on white, then "everything else names a tier and points here". |

Out of my allotment and left untouched: lines 5, 8 and 94 still point at
`rules/task-*.md` and `workflows.md` — slice 01 assigned those three to slice
07. My rewrite removes the fourth (the l.116 model-policy link).

### D5 — `socle/agents/skills/code-review/SKILL.md` — the coupling

| Line | Before | After |
|---|---|---|
| 71–72 | "**Model (Cursor):** spawn both review sub-agents on **Grok**. Do not use Sonnet/Opus for reviews — see [workflows.md §0](…#0-model-policy-cursor)." | "**Tier:** review is judgement work — run both sub-agents at the **frontier** tier", pointing at `../../methodology.md#model-tiers-and-how-they-resolve` |
| 69 | "Send a single message with two `Agent` tool calls. Use the `general-purpose` subagent for both." | tool-neutral: spawn both in a single turn with whatever parallel sub-agent mechanism the tool provides, a general-purpose one being enough |

Line 69 is the "outil" half of the coupling this file was allotted for; it is
one sentence and the gesture is unchanged for tools that do have an `Agent`
tool. The same coupling in `improve-codebase-architecture` and
`codebase-design/DESIGN-IT-TWICE.md` is OUT of this allotment — recorded as a
residual for slice 07's dedup pass.

### D6 — `test/run.sh` — new group 8

Group 7 (slice 01's) is left exactly as it is: it guards the recomposed layer
against regression with a deliberately narrow file list. The new group is
additive.

`-- 8. model tiers: neutrality, the cascade, user.md --`

1. **Socle-wide neutrality.** Walk every `.md`, `.toml` and `.tpl` under
   `socle/` and fail on
   `cursor|grok|composer|sonnet|opus|fable|gemini|chatgpt|copilot|claude-|gpt-[0-9]|llama|mistral|deepseek|qwen`.
   The regex deliberately does not contain a bare `claude`: `CLAUDE.md` and
   `.claude/skills` are adapter *paths*, which AC 1 excepts. Verified against
   the pre-edit tree: it matches the two files this slice rewrites and nothing
   else.
2. **One normative place.** Exactly one file under `socle/` carries the
   heading `## Model tiers (and how they resolve)`.
3. **The cascade is written where it is claimed to be**: methodology.md names
   the three levels in order and states the no-`user.md` fallthrough.
4. **Every tier word is defined**: methodology.md defines `frontier`, `mid`
   and `cheap` — the same three the delivered formulas already use.
5. **`code-review` points instead of naming**: it contains `frontier` and the
   methodology anchor, and no model name.
6. **`user.md.tpl` ships, is inert, and points**: the file exists, its mapping
   example is commented out, it references `methodology.md`, and it contains
   no model id.
7. **`init` never poses a personal file**: `.agents/user.md` absent after init
   on both fixtures.
8. **`update` never touches it, `check` never flags it**: hand-write an
   `.agents/user.md` in an equipped fixture, run `update` → byte-identical and
   still there; run `check` → exit 0.

### D7 — Order of execution

1. Persist this design (done).
2. `socle/agents/user.md.tpl` (new).
3. `socle/agents/methodology.md` (the six passages + the new section).
4. `socle/agents/skills/code-review/SKILL.md`.
5. `test/run.sh` group 8; `bash -n test/run.sh`; full `bash test/run.sh`.
6. AC greps, real output into Notes.
7. Two-axis review per `skills/code-review`, 2 parallel sub-agents, fixed
   point `a7ce105`, spec = the 🧑 zones of this slice and of the parent;
   confirmed findings applied.
8. Slice status/ACs/deliverables, Notes, dated CHANGELOG entry,
   explicit-path commit on `slice-03-model-tiers`. No push, no merge.

### Verification

- `bash test/run.sh` → all green, real output in Notes (group 8 verbatim).
- `grep -rniE '<vendor regex>' socle/` → empty.
- `grep -rn 'frontier\|mid\|cheap' socle/` → the formulas (slice 01),
  methodology.md, code-review, user.md.tpl — one vocabulary, no synonym.
- `chisel init` then `chisel update` / `chisel check` on a scratch fixture
  with a hand-written `.agents/user.md` → untouched, clean.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-26)

- Wrote `socle/agents/user.md.tpl`: the template the setup will pose as
  `.agents/user.md`. Entirely inside HTML comments, so an untouched copy
  overrides nothing; the example mapping carries placeholders, not model ids
  (D0.2). It POINTS at the methodology section instead of restating the rule —
  the review caught a first draft that restated the cascade ordering.
- `socle/agents/methodology.md`: the six vendor passages rewritten in tier
  terms (table in D4), and one new section, `## Model tiers (and how they
  resolve)`, inheriting the normative role of the retired
  `workflows.md §0 — Model policy`. The sections, their order and everything
  non-vendor are untouched — surgery, not a rewrite (slice 07 owns the rewrite).
- `socle/agents/skills/code-review/SKILL.md`: the model prescription becomes a
  **tier** request pointing at the cascade, and the sub-agent gesture is
  phrased tool-neutrally.
- `test/run.sh`: new group 8. Group 7's vendor alphabet was extracted into one
  shared `model_name_re` (review finding) so the narrow regression scan and the
  new socle-wide scan cannot drift apart.

### Vocabulary — the same three words, everywhere

The tier names are NOT new here: the formulas shipped by slice 01 already say
`Architect (frontier tier)`, `Mason (cheap or mid tier)`,
`Inspector (frontier tier)`. This slice defines them and adds the resolution
rule; it invents no synonym. They match `../factory-bench/roster.md`'s "Tier
modèle" column. One collision was found and defused in prose: `Frontier` is
also a glossary term in the same file (the set of slices whose blockers are
done) — the tier section says so explicitly.

### Hand-offs — what this slice deliberately leaves to others

| To | What | Why here |
|---|---|---|
| **Slice 04** (setup + glue v2) | Pose `.agents/user.md` from `socle/agents/user.md.tpl` for the current dev, and add `.agents/user.md` to the project's ignore rules | The setup owns the glue and the questionnaire; a shared installer has no business writing a personal file (D0.1). The chantier record says the same: *"user.md créé par le setup, gitignoré, généré par chaque dev à sa première session"* |
| **Slice 04** | Add a **model-tier section to `project.md.tpl`** — the middle rung of the cascade | `project.md.tpl` is slice 04's allotment (D0.3). Until it exists the cascade resolves in two rungs, which is correct behaviour, not a bug: level 2 is written as "if the team has agreed on one and written it there" |
| **Slice 07** (docs & dedup) | `methodology.md` lines 5, 8 and 94 still point at `rules/task-*.md` and `workflows.md` | Slice 01 flagged those three as slice 07's and the Owner scoped them out of here. This slice removed the fourth (the l.116 model-policy link) because it WAS the vendor passage |
| **Slice 07** | The `Agent` tool / `subagent_type=Explore` coupling in `improve-codebase-architecture` and `codebase-design/DESIGN-IT-TWICE.md` | Only `code-review` was allotted here |

### Verification output

`bash test/run.sh`, real run against the committed fixtures (TMPDIR pointed at
the session scratchpad), with `python3` 3.13 on PATH so the optional TOML parse
actually runs: **128 passed, 0 failed** (103 before this slice; group 8
contributes 25). On the default interpreter (3.9, no `tomllib`) it is 127
passed, 0 failed plus the printed `SKIP: TOML parse check` — group 8 itself has
no python3 dependency (see the review findings below).

Group 8 lines, verbatim:

```
-- 8. model tiers: neutrality, cascade, user.md --
PASS: tiers: no model identifier anywhere in the socle (adapter paths excepted)
PASS: tiers: the resolution rule is written in exactly one socle file
PASS: tiers: frontier is defined
PASS: tiers: mid is defined
PASS: tiers: cheap is defined
PASS: cascade: level 1 is the personal user.md
PASS: cascade: level 2 is the versioned glue
PASS: cascade: level 3 is the socle default
PASS: cascade: a dev with no user.md is not blocked
PASS: code-review: asks for a tier
PASS: code-review: points at the one normative place
PASS: code-review: no pointer left to the retired workflows.md
PASS: user.md: the socle ships a template
PASS: user.md: the template points at the one normative place
PASS: user.md: the template says the file is never committed
PASS: user.md: the example mapping is commented out (an untouched copy overrides nothing)
PASS: init: no personal .agents/user.md posed (brownfield)
PASS: init: no personal .agents/user.md posed (boilerplate)
PASS: init: the user.md template stays in the socle
PASS: update: no personal .agents/user.md conjured up
PASS: update: the user.md template stays in the socle
PASS: user.md fixture: init exits 0
PASS: user.md: update exits 0
PASS: user.md: update leaves the personal file byte-intact
PASS: user.md: check stays clean with a personal file present
```

The three new invariants were mutation-tested rather than trusted: a model name
appended to an unrelated skill makes the socle-wide scan report that file; a
second copy of the `## Model tiers (and how they resolve)` heading in
`discipline.md` makes the one-normative-place assertion name both files;
uncommenting the template's example mapping makes the inertness check fail.
The socle-wide scan was re-mutated after the regex was unified, with a bare
`anthropic` — a word the first draft of that regex could NOT catch.

Greps (AC 1, verbatim):

```
$ grep -rni "cursor\|grok\|composer\|opus\|sonnet" socle/agents/
(none)
$ grep -rniE 'cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai|copilot|claude-|llama|mistral|deepseek|qwen' socle/
(none)
$ grep -rn "workflows.md" socle/
socle/agents/methodology.md:8   ← slice 07's residual (see hand-offs)
```

`bash -n test/run.sh` → syntax OK. `chisel init` → `update` → `check` on a
scratch fixture carrying a hand-written `.agents/user.md`: file byte-intact,
check `clean — no divergence`.

### Two-axis review (2026-08-26, fixed point `a7ce105`)

Run per `skills/code-review`: two sub-agents in parallel, Standards and Spec
(the spec being the 🧑 zones of this slice — ACs and the persisted design — and
of the parent), aggregated without re-ranking.

**Applied**

| Axis | Finding | Fix |
|---|---|---|
| Standards | `user_tpl_live="$(python3 …)"` — a failed command substitution in a plain assignment aborts the whole suite under `set -euo pipefail`, with no FAIL line and no tally. The suite's own stated posture 75 lines above is that the floor is a bare `python3` | replaced by an `awk` HTML-comment stripper; group 8 now has no python3 dependency at all |
| Standards | Two divergent vendor regexes: group 8 scanned a SUPERSET of files with a WEAKER alphabet — it could not catch `anthropic`, `openai` or a bare `gpt` | one shared `model_name_re`, defined once and used by both scans; re-mutation-tested with `anthropic` |
| Standards | The assertion said "no model or vendor name anywhere in the socle" while its own comment admitted the regex carries no bare vendor word | renamed: "no model identifier anywhere in the socle (adapter paths excepted)" |
| Standards | "code-review: asks for a tier, **not a model**" — the needle only proves the first half | renamed to what it checks; a comment says the second half is the socle-wide scan's job |
| Standards | Group 7's comment claimed methodology.md and the skills "lose their vendor wording in slices 03 and 07" — true of PHILOSOPHY.md only, once this slice landed | comment corrected |
| Standards / Spec | `user.md.tpl` restated the cascade ordering and what each tier is for — a second normative statement that the heading-only test would not catch, against D2 | the template now points at the methodology section twice and states nothing |
| Spec | `update` was only proven not to TOUCH an existing `user.md`; that it never CREATES one was untested, though `t4` was right there | two assertions added on `t4` (no `user.md`, no `.tpl` after update) |
| Spec | The cascade's level 2 sent the reader to "`.agents/project.md` … in its model-tier section", which does not exist until slice 04 — a dangling pointer inside the rule itself | level 2 reworded: "if the team has agreed on one and written it there. Most repos have not, and skip straight to the next level" |
| Spec | The tier table named **Watchmen** and **Foreman** — roles the parent leaves as fog / defers, and which no other socle text mentions | Roles column trimmed to the roles the socle actually speaks (Architect, Inspector, Mason) |
| Spec | Notes empty, status 🔴, ACs unticked, CHANGELOG untouched at review time | done in this pass (D7 step 8) |

**Declined, with reason**

- *Standards: `methodology.md:8` still links the deleted `workflows.md`, in a
  file this diff edits — and the diff adds the symmetric assertion for
  `code-review`.* Correct, and deliberately not fixed: slice 01 assigned
  `methodology.md` lines 5, 8 and 94 to slice 07 and the Owner scoped them out
  of this allotment. Line 116 was fixed here only because it WAS the
  model-policy pointer. Recorded in the hand-offs table above.
- *Spec: rewriting `code-review`'s sub-agent gesture is tool decoupling, not
  model policy — scope creep.* The allotment for that file is explicitly "le
  couplage vendor/outil", both halves; the change is one sentence and alters
  no behaviour for tools that do expose an `Agent` tool. The same coupling in
  two OTHER skills was left alone precisely because they were not allotted —
  which is the boundary the finding is really about, and it held.
- *Spec: AC 4 is proven by a doc grep, not by behaviour.* True, and it is the
  only honest test available at this point in the pipeline: there is no
  runtime that resolves tiers — the cascade is read by agents, not by code.
  What IS behavioural is asserted (no `user.md` is ever posed or required, and
  an equipped repo without one is `check`-clean). A behavioural test becomes
  possible only if v2 ever grows a resolver; nothing plans one.
