# Normative reference and writing rules — work

Created by the Mason session at `plan`, 2026-09-10. Spec:
`project-management/tasks/20260910-1447-normative-reference-and-writing-rules.spec.md`.

This chantier runs on the Owner's fast track (Addendum 6 of the decisions
record): one session plans and types the whole task, the Foreman reviews the
result on both axes. There is no `plan-review`, so this program design is
self-checking: every before-count below was measured in this session with the
command that states it, and every expected after-count is written down before
the edit that produces it.

## Program Design

### Shape of the change

One new file carries the normative material, four groups of edits follow it.

1. `socle/agents/reference.md` is created and wired into the install: the
   golden tree, the `AGENTS.md` managed block, and `bin/chisel.sh` (which
   copies top-level `agents/*.md` file by file, not by glob — verified, so the
   new file must be named in three places there).
2. `socle/agents/methodology.md` loses the glossary, the zone-ownership
   doctrine and the model tiers, and keeps one pointer paragraph under each of
   the three headings. Everything that pointed at one of those sections is
   retargeted at the reference. `Seam` stops being defined three times.
3. Discipline rule 11 becomes the writing rule; both task templates carry the
   form; the Checker gains the readability duty.
4. The `§` sweep: the first section citation of every file that has one names
   the file and the section title.

Group order matters only in one place: the reference must exist before
anything points at it, so it lands first. Between group 1 and group 2 the
glossary exists in two files at once; no acceptance criterion and no suite
assertion is evaluated at that intermediate commit, and the suite is green at
each one.

### The three headings kept in methodology (and why)

`methodology.md` links to two of the extracted sections by in-file anchor:
`[Zone ownership](#zone-ownership)` from "A default, and two options" and from
"Why a reading gradient (and not shorter files)", and
`[Model tiers](#model-tiers-and-how-they-resolve)` from "The two designs".
"Why a reading gradient …" is a `Why …` section and must stay untouched.
Keeping the three headings with their exact current titles — and replacing
only their bodies with the pointer paragraph — leaves every one of those
anchors resolving and leaves the `Why …` sections byte-identical. That is the
reason the extraction does not delete the headings.

### Criterion by criterion — the edit, the before, the expected after

**reference-exists.** Create `socle/agents/reference.md` with an intro and
exactly three `## ` sections: `## Glossary`, `## Zone ownership`,
`## Model tiers` (the cascade stays a `###` subsection, which `^## ` does not
match). Full text below.
- `grep -c "^## " socle/agents/reference.md` — before: file absent. After: 3.

**methodology-is-the-why.** Replace the bodies of `## Glossary (uniform
wording)`, `## Zone ownership` and `## Model tiers (and how they resolve)`
with one pointer paragraph each; add the reference to the file's opening
paragraph.
- `grep -c "^| \*\*" socle/agents/methodology.md` — before: **23**, not the
  10 the spec states. After: **10**. See Finding 2 below: the pattern also
  matches the roster table (6 rows) and the dex-phase table (4 rows), which
  the Scope does not move and for which the reference has no section.
- `grep -c "^### The cascade" socle/agents/methodology.md` — before: 1.
  After: 0.
- Every `Why …` section stays byte-identical (checked with
  `git diff socle/agents/methodology.md` at review).

**seam-defined-once.** The glossary row `| **Seam** | …` moves with the
glossary. `tdd/SKILL.md` keeps its reminder line and gains the pointer;
`codebase-design/SKILL.md` keeps Feathers' design seam and gains one sentence
saying how the two senses relate — they are NOT merged (see Finding 4).
- `grep -rln "^| \*\*Seam\*\*" socle/` — before: `socle/agents/methodology.md`.
  After: `socle/agents/reference.md` only.
- `grep -c "reference.md" socle/agents/skills/tdd/SKILL.md` — before 0, after 1.
- `grep -c "reference.md" socle/agents/skills/codebase-design/SKILL.md` —
  before 0, after 1.

**writing-rule-in-discipline.** Rule 11 is rewritten (text below). Rule 3's
pointer at the zone-ownership doctrine is retargeted at the reference. The
count of numbered rules does not move.
- `grep -cE "^[0-9]+\. " socle/agents/discipline.md` — before 11, after 11.
- `grep -c "line number" socle/agents/discipline.md` — before 0, after ≥ 1.

**form-in-templates.** The form note (text below) goes at the top of
`## Context` in both socle templates and, byte-identical, in both
`project-management/` mirrors.
- `grep -c "line number" socle/templates/000-template.spec.md` — before 0,
  after ≥ 1; same for `000-template.work.md` — before 0, after ≥ 1.
- `diff socle/templates/000-template.spec.md project-management/000-template.spec.md`
  — before: exactly one differing line (the doctrine pointer). After: exactly
  one differing line, still the doctrine pointer — which changes target from
  `methodology.md` to `reference.md` on both sides at once. Same for the work
  pair.

**checker-duty.** One bullet added to the Checker's Mission list (text below).
- `grep -c "line-number\|line number" socle/agents/profiles/checker.md` —
  before 0, after ≥ 1; the bullet contains the word "blocking".

**no-bare-first-citation.** The sweep, with the command and the per-file
figures below.
- Before: **4 of 21** files pass, not 0 of 19 (Finding 1). After: 21 of 21.

**reference-installed.** `test/fixtures/golden-tree.txt` gains
`.agents/reference.md` between `.agents/project.md` and `.agents/skills`;
`bin/chisel.sh` gains `REFERENCE_SRC`, one `cp` in `copy_managed_files` and
one `printf` in `managed_relative_files`; `AGENTS-block.md` names the
reference in its closing routing paragraph.
- `grep -c "reference.md" test/fixtures/golden-tree.txt` — before 0, after 1.
- `wc -l test/fixtures/golden-tree.txt` — before 90, after 91.
- `grep -c "reference.md" socle/templates/AGENTS-block.md` — before 0,
  after ≥ 1.

`project.md.tpl` §C · Reading list lists `README.md` and the changelog only —
it does not list the doctrine files — so under the spec's own condition the
reference is NOT added there. Its §H · Model tiers is retargeted, because it
points at a methodology section this task removes (Finding 3).

**no-numeric-form-limit.** No numeric form constraint is written anywhere:
the form note and rule 11 are qualitative.
- `grep -nE "[0-9]+ (lines|words|characters)" socle/agents/reference.md socle/templates/000-template.*.md`
  — before: nothing (reference absent, templates clean). After: nothing.

**suite-green.** No file under `test/` other than the fixture is touched, so
the line cap does not move.
- `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` — before: 9 scenarios, 94
  assertions passed, 0 failed, formula parse check PASS, 592 lines. After:
  expected identical (the golden-tree assertion compares against the updated
  fixture; no assertion counts files, so 94 should hold).
- `git diff --check` before each commit.

### Exact new text — `socle/agents/reference.md`

```markdown
# Reference — vocabulary, zone ownership, model tiers

The words this workflow uses, the rule that says who owns a review zone, and
the three model tiers with the order in which they resolve. Each is written
here once and pointed at from everywhere else, so a definition has one home
and no copy to drift from. The reasoning behind the workflow is
`.agents/methodology.md`; the rules that apply to every session are
`.agents/discipline.md`; the order of the steps and the gates are
`.agents/formulas/`.

## Glossary

| Term | Meaning |
|---|---|
| **Task** | The unit of work and its spec document in the task workspace declared in `.agents/project.md` (default `/project-management/tasks/`), named `<time-id>-<intention>.spec.md`; a typed task also has a matching `<time-id>-<intention>.work.md` beside it. |
| **Spec document** | The approved review surface: intent, acceptance criteria, seams, system design, decisions, testing strategy, slices, deliverables, references, pre-plan Notes and retrospective. It carries the task's sole status and has the reading gradient's two 🧑 zones; it never carries Mason working material. |
| **Work document** | The Mason-owned companion, created at `plan` beside a spec document by replacing `.spec.md` with `.work.md`. It carries program design, pseudo-code, worklog, implementation checkboxes, Notes & Snippets and Inspector findings, and has no zone marker. |
| **Slice** | A child task produced by decomposing a large task: a tracer-bullet vertical cut through every layer, demoable on its own, sized for a single fresh context window. Lives as `tasks/<time-id>-<feature>/<NN>-<slug>.spec.md`, with its work companion created only when typed. A small task IS its own single slice — no slice documents are created for it. |
| **Seam** | The public boundary where a feature is tested — agreed with the human BEFORE implementation. Tests live at seams, never against internals. Fewer is better (ideal: one). |
| **Reading gradient** | The ordering of the spec document by review criticality: 🧑 REVIEW CAREFULLY (short, decision-rich system design and intent) → 🧑 REVIEW IF RELEVANT (remaining review surface). Detail is never cut, it is ordered. The work document has no zone and is Mason-owned working space. |
| **Blocking edge** | A dependency between slices: "slice 3 is blocked by slice 1". A slice with no blockers can start immediately. |
| **Frontier** | The set of slices whose blockers are all done — what can be worked on right now. |
| **Expand–contract** | The sequencing for wide mechanical refactors (rename a column, retype a shared symbol): add the new form beside the old → migrate call sites in batches → delete the old form. The exception to vertical slicing. |
| **One-shot** | Work done without a task artifact. The work rules (context preamble, plan-first, vertical discipline) still apply; only the file bookkeeping is skipped. |

We do NOT use the word "ticket" for local work. It is reserved for items in an
external tracker (Linear, GitHub Issues), if/when one is wired up — see
§B2 · Link to an external tracker of `.agents/project.md`.

## Zone ownership

The 🧑 mark names the owner of a review zone, not simply "the human" — and
ownership follows one rule: a zone belongs to whoever **approved** it, and
where nobody approves it, to whoever **authored** it. The marks occur only in
the spec document. The work document has no zone marker: it belongs entirely
to the Mason that creates it.

- In the **default**, the human approves the spec document; the work document
  remains Mason-owned even when the human gates its program design.
- In **light**, the human approves the spec document; the Mason owns its work
  document without a `plan-review` gate.
- In **supervised**, the human approves the spec document; the Mason owns the
  work document even though the Architect validates its program design.
- In **auto**, no human approves the spec document: it belongs to the
  Architect that authored it (the Checker reviews it, it does not author it),
  while the Mason owns the work document and the Architect validates its
  program design.
- Under **`chisel-auto-light`** the spec zones are **ignored**, not reassigned
  to their author: the preset designs, plans and types in one go. Ruled by the
  Owner on 2026-08-28: "Dans le cas d'un chisel-auto-light ces zones sont à
  ignorer : ça design + plan + code d'une traite."

**The Brief is always the human's, in every mode.** A 🧑 zone is never
overridden silently, in any mode — a conflict with one is contested upward,
never edited sideways.

## Model tiers

The normative text of this socle names no model: what a step or a role declares
is a **tier**. Tool names are not covered by that rule and appear wherever they
are useful. The three tiers are the ones the role roster in
`.agents/methodology.md` ("The roster", one line per role) assigns:

| Tier | What it is for | Roles |
|---|---|---|
| **frontier** | Thinking, grilling, reviewing — where a wrong judgement is expensive and only caught much later | Foreman (owns the thread, leads the interview, rules on reports); Architect (exploration, spec and system design, the `plan-review` verdict); Checker (spec review); Inspector (the two-axis review) |
| **mid** | Ordinary tasks and dispatch — work that needs competence but not judgement | A Mason on a slice that is delicate, or in a codebase it does not know |
| **cheap** | The how of a slice whose system design is settled, when that how is mechanical | A Mason on such a slice |

(Not to be confused with **Frontier** in the glossary above — the set of
slices whose blockers are all done. Same word, two unrelated meanings: here a
model tier, there a position in the dependency graph.)

A tier is a property of the **work**, not of the tool: it says how much
judgement the step needs. That is why the socle can state it once and let
every tool honour it its own way.

### The cascade

Which concrete model a tier means is resolved in this order, and the first
level that answers for a tier wins that tier:

1. **`.agents/user.md`** — the dev's personal file: their tool, their account,
   their model ids. It is **never committed** — the setup poses it from the
   socle template and adds it to the project's ignore rules, so each dev
   writes their own at their first session and nobody inherits anyone else's.
2. **`.agents/project.md`, §H · Model tiers** — the versioned glue's team
   default mapping for this repo, if the team has agreed on one and written
   it there. Most repos have not, and skip straight to the next level.
3. **The socle default**, which contains no model id at all: *frontier* is the
   strongest reasoning model your tool offers you, *mid* its standard everyday
   model, *cheap* its fastest and least expensive one.

**A dev with no `user.md` is never blocked.** Resolution falls through to the
team default, and then to the socle default — which every tool can satisfy.
A missing `user.md` is the normal case, not an error: no rule, skill, formula
step or command may require its presence, and none may read it as the only
source of a fact that matters to anyone else.

This is the only place the resolution rule is written. Everywhere else —
formula steps, skills — names a tier and points here.
```

What moved verbatim, and what was trimmed:

- The glossary table and the "ticket" paragraph move byte for byte.
- Zone ownership moves byte for byte, heading text apart.
- Model tiers moves byte for byte except two trims. The opening sentence
  "The three tiers are the same three the roster uses:" becomes a reference
  that names its file and title, because the roster stays in methodology. And
  the closing clause of the tier-is-a-property paragraph — "and why a step
  that names a tier is still readable in five years, when today's model names
  are gone" — is rationale, so it moves into methodology's pointer paragraph
  instead of staying in the reference.

The reference's own first `§` citation is `§B2 · Link to an external tracker
of .agents/project.md`, so the file passes the sweep criterion it is subject
to like any other.

### Exact new text — methodology's three pointer paragraphs

Opening paragraph, the one addition (`the definitions … are .agents/reference.md`):

> This document explains the reasoning behind the task workflow so that humans
> and agents apply it with judgement, not cargo-cult. The **what/where** are
> the spec and work templates declared in §A · Task workspace of
> `.agents/project.md` (defaults `/project-management/000-template.spec.md`
> and `/project-management/000-template.work.md`); the **vocabulary, the zone
> ownership rule and the model tiers** are `.agents/reference.md`; the **order
> and the gates** are `.agents/formulas/`; the **ambient invariants** are
> `.agents/discipline.md`; this file is the **why**.

`## Glossary (uniform wording)`:

> The words this workflow uses — task, spec document, work document, slice,
> seam, reading gradient, blocking edge, frontier, expand–contract, one-shot —
> are defined in "Glossary" of `.agents/reference.md`, which also says why
> "ticket" is reserved for an external tracker. This file uses them and never
> redefines them.

`## Zone ownership`:

> Who owns a 🧑 zone under each preset, and why the work document has no zone
> marker at all, is stated in "Zone ownership" of `.agents/reference.md`. The
> rule there rests on one idea, developed below: a zone belongs to whoever
> answered for it, so the reader always knows whose decision a section
> carries.

`## Model tiers (and how they resolve)`:

> What the three tiers are for, and the order in which a tier resolves to a
> concrete model, are in "Model tiers" of `.agents/reference.md`. The reason
> the socle names tiers and never models: a tier is a property of the work —
> how much judgement the step needs — so a step that declares one is still
> readable in five years, when today's model names are gone, and every tool
> can honour it its own way.

### Exact new text — discipline rule 11

The rule that replaces the current rule 11 (which is the same rule in narrower
form: it covered references only). The list keeps exactly eleven entries.

> 11. **Writing: name things by their meaning, and cite by file and title.**
>     Three rules, on every document written or edited in this repo. **Name
>     things by their meaning, not by a code** — an acceptance criterion is
>     `no-orphan-file`, not `AC2`; a decision is named by what it decided.
>     When a code genuinely must be cited, its meaning comes with it in
>     parentheses. **A reference to another document names the file and the
>     section title** — "§A · Task workspace of `.agents/project.md`" — never
>     a bare number, and never a line number: a line number is wrong the next
>     time the file is edited, so prose is cited by its section title plus a
>     few verbatim words. The first mention in a document carries file and
>     title; later mentions in the same document may shorten. **Every
>     cross-reference says in one sentence what the reader finds there**, so
>     nobody has to open a file to learn whether it was worth opening.

Rule 3's pointer moves with the doctrine it cites:

> 3. **Zone-owner sections are law.** Sections marked 🧑 in any spec document
>    carry their owner's decisions — who that is follows the rule in
>    `.agents/reference.md` ("Zone ownership"), which names the owner of each
>    zone under each preset. Never contradict one silently: if the work
>    reveals a conflict with a 🧑 zone, stop and surface it.

### Exact new text — the form note in the two templates

At the top of `## Context` in `socle/templates/000-template.spec.md` and, byte
for byte, in `project-management/000-template.spec.md`:

> **The form of this file.** Acceptance criteria, seams and decisions are
> named by what they say, never by a code; a code that genuinely must be cited
> carries its meaning in parentheses. A reference names its file and its
> section title — never a line number, which is wrong by the next edit — and
> says in one sentence what the reader finds there. Each 🧑 zone is understood
> without opening another file: a link that offers depth is welcome, a link
> the sentence cannot be read without is not. The rule is the writing
> rule of `.agents/discipline.md`, and the Checker treats a zone that fails it
> as a blocking finding.

At the top of `## Context` in `socle/templates/000-template.work.md` and, byte
for byte, in `project-management/000-template.work.md`:

> **The form of this file.** Program-design decisions, worklog entries and
> findings are named by what they say, never by a code; a code that genuinely
> must be cited carries its meaning in parentheses. A reference names its file
> and its section title — never a line number, which is wrong by the next edit
> — and says in one sentence what the reader finds there. The rule is the
> writing rule of `.agents/discipline.md`.

### Exact new text — the Checker duty

A fourth bullet in the Checker's Mission list, after "The repo's own rules":

> - **A zone that cannot be read on its own.** A 🧑 zone is understood without
>   opening another file. Codes with no meaning attached, a sentence that needs
>   a second document before it parses, a reference by line number — each is a
>   **blocking** finding, and it cites the writing rule of
>   `.agents/discipline.md`. A
>   link that offers depth is welcome; a link the sentence cannot be read
>   without is not.

### The `§` sweep — procedure and figures

Rule 11 asks the FIRST mention in a document to carry file and section title;
later mentions in the same document may shorten. So the sweep edits one
citation per file, not all 176. Section titles come from
`socle/agents/project.md.tpl`: §A · Task workspace, §B · Coordination,
§B1 · Where task statuses live, §B2 · Link to an external tracker,
§C · Reading list, §D · Documentation reference, §E · Adapters,
§F · Gate commands, §G · Glossary & decisions, §H · Model tiers.

The check, run before and after over every file under `socle/` that contains a
citation — it asserts both halves of the criterion (the citation carries
` · `, and the sentence around it names `.agents/project.md`):

```bash
python3 - <<'PY'
import re, subprocess, pathlib
pat = re.compile(r'§[A-H][0-9]?')
files = sorted(subprocess.run(['grep', '-rl', '§', 'socle/'],
                              capture_output=True, text=True).stdout.split())
ok = 0
for f in files:
    t = pathlib.Path(f).read_text()
    m = pat.search(t)
    start = max(t.rfind('. ', 0, m.start()), t.rfind('\n\n', 0, m.start()))
    end = t.find('. ', m.end())
    sentence = t[start + 1:end if end > 0 else m.end() + 120]
    good = t[m.end():m.end() + 3] == ' · ' and '.agents/project.md' in sentence
    ok += good
    print('PASS' if good else 'FAIL', f)
print(f'{ok} of {len(files)} pass')
PY
```

Before: **4 of 21 pass** — `methodology.md`, `code-review/SKILL.md`,
`slice-task/SKILL.md` and `wayfinder/SKILL.md` already carry a qualified first
citation. Expected after: 21 of 21.

Per file, the citation that gets fixed. The count in brackets is that file's
total of `§X` citations before the sweep, then how many of them were bare —
measured this session, and reported unchanged afterwards except for the one
line each edit touches:

| File | citations / bare before | first citation today | fixed to |
|---|---|---|---|
| `agents/discipline.md` | 3 / 2 | rule 1, `§C` | `§C · Reading list` |
| `agents/formulas/chisel-auto-light.formula.toml` | 18 / 18 | header comment, `§A paths` | `§A · Task workspace` |
| `agents/formulas/chisel-auto.formula.toml` | 18 / 18 | same comment | same |
| `agents/formulas/chisel-default.formula.toml` | 18 / 18 | same comment | same |
| `agents/formulas/chisel-light.formula.toml` | 18 / 18 | same comment | same |
| `agents/formulas/chisel-supervised.formula.toml` | 18 / 18 | same comment | same |
| `agents/methodology.md` | 5 / 1 | already `§A · Task workspace` | unchanged |
| `agents/profiles/architect.md` | 4 / 4 | spec template, `§A` | `§A · Task workspace` |
| `agents/profiles/checker.md` | 5 / 5 | reading list, `§C` | `§C · Reading list` |
| `agents/profiles/foreman.md` | 3 / 3 | tracker convention, `§B` | `§B · Coordination` |
| `agents/profiles/inspector.md` | 1 / 1 | tracker convention, `§B` | `§B · Coordination` |
| `agents/profiles/mason.md` | 6 / 6 | tracker convention, `§B` | `§B · Coordination` |
| `agents/skills/chisel-beads/CHANGING-CASE.md` | 4 / 4 | `§B1` | `§B1 · Where task statuses live` |
| `agents/skills/chisel-beads/SKILL.md` | 4 / 4 | frontmatter description, `§B1` | `§B1 · Where task statuses live` (body's first mention too) |
| `agents/skills/chisel-setup/SKILL.md` | 35 / 35 | "The letters (`§A`, `§B1`…)" | names the glue and both titles |
| `agents/skills/code-review/SKILL.md` | 1 / 0 | already qualified | unchanged |
| `agents/skills/retro/SKILL.md` | 3 / 3 | `§C`, `§D` | `§C · Reading list`, `§D · Documentation reference` |
| `agents/skills/slice-task/SKILL.md` | 2 / 0 | already qualified | unchanged |
| `agents/skills/upgrade-v2/SKILL.md` | 17 / 15 | "`§A` of the project's glue" | `§A · Task workspace of .agents/project.md` |
| `agents/skills/wayfinder/SKILL.md` | 1 / 0 | already qualified | unchanged |
| `scripts/sync-upstream/SKILL.md` | 1 / 1 | "`§A` of their glue" | `§A · Task workspace of their own .agents/project.md` |

Two files need the sentence to gain the file name as well as the title, because
they name the glue only by its role: `upgrade-v2/SKILL.md` ("the project's
glue") and `scripts/sync-upstream/SKILL.md` ("their glue"). `chisel-setup`
needs the same for a third reason — its sentence is about the letters
themselves, not about one section.

Wrapping: `wayfinder`, `code-review`, `slice-task` and `prototype` are written
one line per unit and are never rewrapped; `retro` and `upgrade-v2` wrap at
about 80 columns and stay there; `codebase-design/SKILL.md` is one long line
per paragraph, so its Seam sentence is appended in place.

The five formula edits are the same two comment lines in five files, so the
TOML bodies are untouched and the parse check cannot move. The one citation
inside a step string that changes is none: every first mention in a formula is
in the header comment.

### Files this design touches

Create: `socle/agents/reference.md`.

Modify: `socle/agents/methodology.md`, `socle/agents/discipline.md`,
`socle/agents/profiles/{architect,checker,foreman,inspector,mason,README}.md`,
`socle/agents/formulas/*.toml` (five),
`socle/agents/skills/{chisel-beads/{SKILL,CHANGING-CASE},chisel-setup/SKILL,code-review/SKILL,retro/SKILL,slice-task/SKILL,tdd/SKILL,codebase-design/SKILL,upgrade-v2/SKILL}.md`,
`socle/scripts/sync-upstream/SKILL.md`, `socle/templates/000-template.spec.md`,
`socle/templates/000-template.work.md`, `socle/templates/AGENTS-block.md`,
`socle/agents/project.md.tpl` (§H only), `socle/agents/user.md.tpl`,
`test/fixtures/golden-tree.txt`, `bin/chisel.sh`, and this work document.

Two files outside the spec's map are touched, both for the same reason — they
point at a methodology section this task removes: `socle/agents/user.md.tpl`
and `socle/agents/project.md.tpl` §H (the map anticipated §C only). See
Finding 3.

Untouched, as the spec requires: `PHILOSOPHY.md`, `README.md`, `test/*.sh`,
`upstream.lock.json`, everything else under `project-management/` including
the archive, and the spec document itself.

## Worklog

**2026-09-10 — plan.** Read the profile, the discipline, the whole
methodology, the spec, and the decisions record's sections "C · Lisibilité des
tâches", "E · Dette déclarative" (E4), "G · Règles de rédaction" (G1, G2, G3),
plan item 5 with its two additions, and Addendum 5 (G18) and 6. Measured every
before-count with the commands the criteria name; read `bin/chisel.sh` and
found that it copies top-level `agents/*.md` one by one, so the reference must
be named there. Wrote this program design. Four findings against the spec,
below — none of them blocks the work.

## Implementation Checkboxes

- [ ] Group a — `reference.md` created and wired (golden tree, AGENTS block,
      `bin/chisel.sh`)
- [ ] Group b — methodology extracted with its three pointer paragraphs,
      every pointer into the extracted sections retargeted, `Seam`
      deduplicated in `tdd` and `codebase-design`
- [ ] Group c — discipline rule 11 rewritten and rule 3 retargeted, the form
      note in both template pairs, the Checker duty
- [ ] Group d — the `§` sweep
- [ ] Group e — this document closed with the after-counts

## Notes & Snippets

### Findings against the spec (the spec is never edited)

**Finding 1 — the sweep figures are off, and four files already pass.**
Signed `mason`, 2026-09-10. The spec says "Today 178 bare citations in 19
files" and, in the criterion, "today 0 of 19 — measure it". Measured:
**185** `§X` citations in **21** files under `socle/`, of which **176** are
bare, spread over **18** files; and **4 of 21** files already carry a
qualified first citation (`methodology.md`, `code-review/SKILL.md`,
`slice-task/SKILL.md`, `wayfinder/SKILL.md`). Nothing about the work changes:
the criterion is per-file and the target is every file passing, so the sweep
runs over 21 files and the after figure is 21 of 21.

**Finding 2 — `methodology-is-the-why` cannot reach 0 within the Scope.**
Signed `mason`, 2026-09-10. The criterion reads
`grep -c "^| \*\*" socle/agents/methodology.md` → 0 (today 10 glossary rows).
The pattern matches **23** lines today, not 10: the glossary's 10 rows, the
roster's 6 rows, the model-tiers table's 3 rows, and the dex-phase table's 4
rows. Removing the three blocks the Scope names leaves **10** — the roster and
the dex-phase table. Reaching 0 would mean either moving those two tables into
the reference, which the criterion `reference-exists` forbids by pinning the
file to exactly three sections (and neither table is vocabulary, zone
ownership or tiers), or stripping the bold from their first column to satisfy
a grep, which degrades two readable tables for nothing. So this criterion is
met in intent — no normative definition table is left in methodology, and the
three named blocks are gone — and its number is reported as 23 → 10 rather
than 23 → 0. The Foreman rules on it at review.

**Finding 3 — the Files map under-counts the pointers at the extracted
sections.** Signed `mason`, 2026-09-10. The map anticipates
`socle/agents/project.md.tpl` "§C reading list, if it lists the doctrine
files". §C lists `README.md` and the changelog only, so nothing is added
there. But two files point at `.agents/methodology.md`, section "Model tiers
(and how they resolve)", which this task removes:
`socle/agents/project.md.tpl` §H · Model tiers and `socle/agents/user.md.tpl`
(twice). Both are retargeted at `.agents/reference.md` ("Model tiers"); the
alternative is shipping a pointer at a section that no longer exists.
`socle/agents/profiles/README.md` has the same pointer and is already covered
by the map's `socle/agents/profiles/*.md`.

**Finding 4 — `codebase-design`'s "Seam" is Feathers' design seam, as the
spec suspected.** Signed `mason`, 2026-09-10. `codebase-design/SKILL.md`
defines Seam as "a place where you can alter behaviour without editing in that
place; the *location* at which a module's interface lives" — a design-time
placement decision. The glossary's Seam is "the public boundary where a
feature is tested — agreed with the human BEFORE implementation". They are two
senses of one word, and the spec's instruction applies: the reminder line says
how they relate and does not merge them. The sentence added to
`codebase-design` names both senses and says where they meet — a design seam
is where a test seam can be placed, and choosing one as the test seam is the
agreement the task workflow asks for. `tdd/SKILL.md`'s seam IS the glossary's
seam, so its reminder line simply points at the definition.

### Claims in files this task may not open

`PHILOSOPHY.md` and `README.md` are out of scope. Checked at close for a claim
this chantier falsifies; recorded here if one is found.

## Diff-Review Findings

Written by the reviewer at the two-axis review. On this chantier the Foreman
holds both axes itself (Addendum 6): no Inspector sub-agent runs.
