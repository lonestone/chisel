# Normative reference and writing rules

**Status:** 🟢 Complete (2026-09-10)

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the normative material that `socle/agents/methodology.md`
still hosts (the glossary, zone ownership, model tiers) moves to one short
reference file the skills, formulas and templates point at; methodology
becomes the essay of the why again. The writing rules the 360 review settled
land where they belong: the FORM in the two task templates, the BEHAVIOUR as
one compact discipline rule, the CONTROL as a Checker duty. And the sweep the
earlier chantiers deferred here: every bare `§X` citation in the socle names
its file and its section title on first mention.

**Rulings applied** (from `project-management/review-360-decisions.md`,
section headings quoted): "E4 — methodology.md héberge du normatif" point 1;
"G1 — Les règles de rédaction" points 1 and 3; "C1 — Zone 🧑 non
autoportante"; "C2 — Références par numéro de ligne"; plan item 5 with its
2026-08-27 and 2026-08-28 additions (the § sweep, all carriers). Transverse:
G2 (no numeric limit anywhere), G3 (English).

**Process, ruled by the Owner on 2026-09-10** (Addendum 6 of the decisions
record): fast track. The Foreman wrote this spec; one agent executes all of it
and keeps the work document; the Foreman reviews on both axes. No Architect
or Inspector sub-agents on this chantier.

## Scope

In:
- New file `socle/agents/reference.md` (installed as `.agents/reference.md`):
  the glossary table, the zone-ownership doctrine, the model tiers and their
  cascade. Definitions and tables, no essay prose, no numeric constraint.
- `methodology.md` keeps a one-paragraph pointer where each extracted block
  was, saying what the reader finds in the reference (G1 point 1).
- "Seam" defined once, in the reference. `tdd` and `codebase-design` keep one
  reminder line plus a pointer. If the `codebase-design` "Seam" turns out to
  be Feathers' design seam rather than chisel's test seam, the reminder line
  says how the two relate; it does not silently merge them.
- Discipline rule 11 becomes the compact writing rule: name things by their
  meaning, not by a code (a code that must be cited carries its meaning in
  parentheses); a reference to another document names the file and the
  section title, never a bare number and never a line number; every
  cross-reference says in one sentence what the reader finds there. The count
  of numbered rules stays 11.
- Both task templates (socle sources and their `project-management/` mirrors)
  carry the form in a short note at the top of the Notes or Context section:
  named criteria, no codes without meaning, no line-number references,
  references by file and title.
- `profiles/checker.md` gains one duty: a spec zone that cannot be read on its
  own (codes without meaning, a sentence that needs another file to be
  understood, line-number references) is a blocking finding.
- The § sweep across `socle/` (and `socle/scripts/sync-upstream/SKILL.md`):
  the first `§X` citation in each document carries the section title and the
  file (`§B2 · Link to an external tracker of .agents/project.md`); later
  mentions in the same document may shorten. Today 178 bare citations in 19
  files.
- Wiring: the reference is installed (golden tree 90 → 91), listed where the
  reading list is declared (`AGENTS-block.md` and `§C · Reading list` of
  `project.md.tpl` if they list methodology and discipline), and resolvable
  by the pointer-integrity scenario. If `bin/chisel.sh` does not already copy
  every top-level `agents/*.md`, add the file to its copy list and nothing
  else.

Out (ruled or deferred elsewhere):
- E4 point 2 (`chisel-light`): done by chantier 1.
- `PHILOSOPHY.md`, `README.md`: not opened. If either makes a claim this
  chantier falsifies, report it in the work document.
- Archived task files and Owner files under `project-management/`: never
  swept, never edited. Only the two template mirrors and this task's pair.
- No lint script (G1 point 3: the Checker judges, not a grep). No numeric
  limits (G2).
- Chantiers 4, 6, 7, 8 of the plan.

## Acceptance criteria

Each is grep-verifiable; record the before-count and the after-count in the
work document.

- [x] **reference-exists** — `socle/agents/reference.md` exists with three
      sections titled exactly `## Glossary`, `## Zone ownership`,
      `## Model tiers`; `grep -c "^## " socle/agents/reference.md` → 3 (a
      short intro above them is allowed, no other `##`).
- [x] **methodology-is-the-why** — ~~`grep -c "^| \*\*" socle/agents/methodology.md`
      → 0 (today 10 glossary rows)~~ no glossary row left:
      `grep -cE '^\| \*\*(Task|Spec document|Work document|Slice|Seam|Reading gradient|Blocking edge|Frontier|Expand|One-shot)\*\*' socle/agents/methodology.md`
      → 0 (today 10); the roster and the dex-phase tables are not normative
      definitions and stay (amended 2026-09-09 by the foreman at review: the
      first grep matched 23 rows, 10 of them those two tables — the agent's
      Finding 2). `grep -c "^### The cascade" socle/agents/methodology.md`
      → 0 (today 1); the three former sections are each replaced by one
      paragraph pointing at `reference.md` by file and title. Methodology
      keeps every "Why …" section untouched.
- [x] **seam-defined-once** — `grep -rln "^| \*\*Seam\*\*" socle/` → only
      `socle/agents/reference.md`; `tdd/SKILL.md` and `codebase-design/SKILL.md`
      each contain `reference.md` once (today 0 / 0).
- [x] **writing-rule-in-discipline** — `grep -cE "^[0-9]+\. " socle/agents/discipline.md`
      → 11 (today 11); rule 11's bold title names writing, and the rule body
      contains the three clauses (codes carry their meaning; file and title,
      never a line number; a cross-reference says what the reader finds).
      `grep -c "line number" socle/agents/discipline.md` ≥ 1 (today 0).
- [x] **form-in-templates** — `grep -c "line number" socle/templates/000-template.spec.md`
      ≥ 1 and same for `000-template.work.md` (today 0 / 0); the mirrors are
      identical to their sources except the doctrine-pointer line:
      `diff` of each pair → exactly one differing line (today: one).
- [x] **checker-duty** — `grep -c "line-number\|line number" socle/agents/profiles/checker.md`
      ≥ 1 (today 0) and the duty names "blocking".
- [x] **no-bare-first-citation** — for every file under `socle/` that
      contains `§`, the first match of `§[A-H][0-9]?` in that file is followed
      by ` · ` and the same sentence names `.agents/project.md`. Verification
      command in the work document, run over all ~~19~~ 21 files, before and
      after; after: ~~19 of 19~~ 22 of 22 pass, `reference.md` included
      (today ~~0 of 19~~ 4 of 21 — measured by the agent, Finding 1; amended
      2026-09-10 by the foreman at review).
- [x] **reference-installed** — `grep -c "reference.md" test/fixtures/golden-tree.txt`
      → 1 (today 0); `wc -l` → 91 (today 90); `grep -c "reference.md" socle/templates/AGENTS-block.md`
      ≥ 1 (today 0).
- [x] **no-numeric-form-limit** — `grep -nE "[0-9]+ (lines|words|characters)" socle/agents/reference.md socle/templates/000-template.*.md`
      → nothing.
- [x] **suite-green** — `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` →
      9 scenarios, 0 failed, formula parse check PASS (today 94 assertions;
      record the after-count, it may move only if a fixture-driven assertion
      counts files); `git diff --check` clean; `test/` stays under its
      600-line cap (`test/run.sh` reports it).

## Files map (indicative; judged after the fact)

Create: `socle/agents/reference.md`.
Modify: `socle/agents/methodology.md`, `socle/agents/discipline.md`,
`socle/agents/profiles/*.md`, `socle/agents/formulas/*.toml`,
`socle/agents/skills/{chisel-setup,upgrade-v2,chisel-beads,retro,wayfinder,slice-task,code-review,tdd,codebase-design}/…`,
`socle/scripts/sync-upstream/SKILL.md`, `socle/templates/000-template.spec.md`,
`socle/templates/000-template.work.md`, `project-management/000-template.spec.md`,
`project-management/000-template.work.md`, `socle/templates/AGENTS-block.md`,
`socle/agents/project.md.tpl` (§C reading list, if it lists the doctrine
files), `test/fixtures/golden-tree.txt`, `bin/chisel.sh` only if needed for
the copy.
Avoid: everything else under `project-management/`, `PHILOSOPHY.md`,
`README.md`, `test/*.sh`, `upstream.lock.json`.

## Verification

Re-run every criterion command; write after beside before. Suite green after
each commit. `git diff --check` before each commit.

## Notes

Written by the Foreman on 2026-09-10 under the Owner's fast-track ruling
(Addendum 6). Pointers in shipped text use the installed form
(`.agents/…`), never `socle/…`; no ruling id, no "G16"-style label, no
decisions-record file name in shipped text. Every amendment to this file:
strike the original, date the new version below it.

**Closed, 2026-09-10 · `foreman`.** Fast track per Addendum 6: one agent
planned (`b830bc4`) and typed (`19d31b2`, `3bbcb8b`, `6f67697`, `059cb18`);
the foreman reviewed on both axes, PASS and PASS, findings in the work
document. The agent's run ended before it closed its work document; the
foreman closed it, signed. Two criteria amended above at review, struck and
dated. The agent's Finding 3 (pointers in `project.md.tpl` §H and
`user.md.tpl` retargeted from the removed methodology section to
`reference.md`) is accepted as within intent. Suite 9 scenarios, 94
assertions, 0 failed; golden tree 91 lines. The `§` sweep the chantiers 1 and
3 deferred here is done: 22 of 22 shipped documents name file and title on
the first mention of each section.
