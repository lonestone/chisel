# 03 — Formulas follow

**Status:** 🟢 Complete (2026-09-02)
**Blocked by:** 02 — doctrine follows (complete 2026-09-02). The step bodies
point at the profile contracts and the methodology that slice rewrote.

**What to build:** the five formulas in `socle/agents/formulas/` — their
`plan`, `type`, `diff-review` and `close` steps, **and their headers** — teach
the two-document task model the doctrine now carries: program design and
checkboxes live in the work document, the diff review receives the spec
document as its requirement and the work document as evidence, `close`
archives both files, and no formula text sends a write into "the spec file"
or into a 🤖 agent zone the spec no longer has.

## Acceptance criteria

This slice closes one parent criterion in full and contributes its share to
two task-closing ones; full wording and the governing system design stay in
`project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
§Acceptance Criteria.

- [x] **formulas-send-the-work-to-the-work-document** (owned in full by this
  slice) — `grep -rn "checkboxes in {{spec}}" socle/agents/formulas/` returns
  nothing. Given each of the five formulas, When its `plan`, `type`,
  `diff-review` and `close` steps are read, Then the program design is
  persisted into the work document, the checkboxes are ticked there, the
  `plan` step no longer has the Mason update the spec document's status, the
  diff review receives the spec document as its requirement and the work
  document as evidence, and `close` archives both files, promoting the
  evergreen material out of the work document first.
- [ ] **no-file-says-the-spec-file** (formulas share of the parent task's
  closing check — this slice contributes, never closes) — after this slice,
  `grep -rn "the spec file" socle/agents/formulas/` returns nothing (nine
  matches today, across the five headers and step bodies); each becomes the
  precise document it means.
- [ ] **the-program-design-has-left-the-spec** (formulas share of the parent
  task's closing check) — after this slice, `grep -rn "Design section"
  socle/agents/formulas/` returns nothing (five matches today, one per
  formula); the persist instruction names the work document.
- [x] **no-agent-zone-in-formulas** (slice criterion, from parent
  G14 point 7: the 🤖 zone disappears from the spec) — `grep -rn "AGENT
  ZONE\|🤖" socle/agents/formulas/` returns nothing; the reading-gradient
  line each formula carries describes the spec document's two 🧑 zones and
  the Mason-owned work document instead.
- [x] **suite-green** (slice share) —
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passes with zero
  failures (the formulas parsing check needs a python with `tomllib`; that
  PATH provides it).

## System design

The parent spec's Architecture and Implementation Decisions are settled
input, not a decision surface. Apply the document boundary exactly as the
doctrine now states it (methodology, discipline, profiles — all landed at
commit `863094c`):

- `plan` — the Mason creates the matching work document beside the spec and
  persists its draft program design there; it never edits the spec document,
  and it no longer updates the spec document's status (the thread owner
  maintains the sole status).
- `plan-review` — the Architect validates the persisted design in the work
  document; there is no post-validation persistence cycle.
- `type` — implementation checkboxes are ticked in the work document; the
  worklog lives there.
- `diff-review` — the Inspector judges the diff against the whole spec
  document; the work document is evidence only; findings are written into
  the work document.
- `close` — archives **both files** together, promoting evergreen material
  first: system-design/architecture material from the spec document's
  source, program-design material from the work document.
- Headers: two formulas tell a doubting step to write into "the spec file"
  and a third names the Notes the next step writes. Where a header or step
  touches blocker reporting, it must match the landed rule 6 (amended
  2026-09-02): the trace lives in the task's documents, signed role plus
  date and time — never a journal line or a separate escalation item. State
  the duty in one line and point at the methodology; do not restate the
  full rule (the dedup pattern the seven carriers already follow).
- The reading-gradient line stops naming a 🤖 zone: the spec document has
  two 🧑 zones and no agent zone; the work document has no zone marker and
  belongs to the Mason entirely.

## Files map

**Modify:** the five files of `socle/agents/formulas/` —
`chisel-default.formula.toml`, `chisel-supervised.formula.toml`,
`chisel-auto.formula.toml`, `chisel-light.formula.toml`,
`chisel-auto-light.formula.toml`.

**Avoid:** everything outside `socle/agents/formulas/`. This slice shares no
file with slice 4 or slice 5.

## Verification

- Socle text seam: the four greps named above, then a cross-file read of the
  five formulas against the landed doctrine (methodology, discipline,
  profiles) for step-by-step consistency — same steps, same destinations,
  same actors, in all five presets.
- Installer seam: `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — the
  suite's formula parsing check (gates, step counts) must stay green; no
  test change is expected.

## References

- Parent system design and decisions:
  `project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
  §Architecture, §Implementation Decisions, and the slice-3 entry of
  §Slices & Dependencies.
- Owner rulings: `project-management/review-360-decisions.md`, G14 (the
  split) and G15, Addendum 3 (blocker trace in the task's documents).
- Slice-02 precedent (doctrine wording the formulas must agree with):
  `project-management/tasks/20260828-2217-split-spec-and-work-documents/02-doctrine-follows.md`.

---

---

> 🧑 **REVIEW IF RELEVANT** — program design, persisted at plan time.

## Design — persisted at plan time

Persisted at the `plan` step by `mason`, 2026-09-02 16:23. Written under the
parent spec's §Implementation Decisions, decision 10: this combined plain
`.md` artifact temporarily serves as this slice's work record, so the program
design, the implementation checkboxes and the worklog live in this section
until slice 05 migrates the convention. Signed the way the blocker trace of
`socle/agents/methodology.md` ("Escalation, and the blocked-task report")
requires — role plus date and time — because the same signature convention
governs everything this session writes here.

No code is typed at `plan`. Validation of this design is the Architect's at
`plan-review`, and the Owner's go comes after it.

**Revised at `plan-review` round 1 by `mason`, 2026-09-02 16:34** — the
Architect returned NOT VALIDATED on round 1. What this revision changed: the
blocking defect is now **item 12** of §1, carried into the two files' edit
tables in §2, the inventory, and the checkbox list of §3 (the round-1 design
pinned those two ranges untouched and would have shipped them); item 2 gained
the installed-pointer guard; item 4 gained the auto-light clause; §4's four
questions are now recorded rulings rather than questions, with Q3's count
corrected and Q4's hedge removed; and two unowned residues are recorded as
proposals in §5. Root cause of the blocking defect, named so it is not
repeated: round 1 read `socle/agents/discipline.md` rules 2, 6 and 12 and
**not rule 7**, which is the rule the defect violates. Rule 7 is now read and
listed in §0.

### 0 · What was read, and the state it was read in

The parent spec (§Architecture, §Implementation Decisions, the slice-3 entry
of §Slices & Dependencies, the criterion
**formulas-send-the-work-to-the-work-document**, and §Notes & Snippets for
the verified carrier counts); the doctrine landed at commit `863094c`
(`socle/agents/methodology.md` — Glossary, "Zone ownership", "Escalation, and
the blocked-task report", "The two designs", "Where dex's phases live", "Why
a two-axis review at completion", "Artifact ladder"; `socle/agents/discipline.md`
rules 2, 6, **7** ("Session hygiene": build fresh from the spec/work pair,
"never an ambiguous \"the file\"" — added at round 2, and the rule the
blocking defect of round 1 violated) and 12, plus "The pipeline, for real
scoped work"; the four profiles `mason.md`, `architect.md`, `inspector.md`, `foreman.md`); the two
templates `socle/templates/000-template.spec.md` and
`000-template.work.md`; `socle/templates/AGENTS-block.md` as the reference
shape for the deduplicated blocker line; `socle/agents/project.md.tpl` §A and
§B1 for what the glue now declares; the five formulas in full; and
`test/installer.sh` (`group_render`, and the "no pointer into thin air"
integrity check).

**Gate baseline confirmed before designing:**
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` → **9 scenarios, 94
assertions passed, 0 failed**, suite at 592 lines of its 600-line cap.

**What the suite asserts about the formulas, and therefore what this design
must not disturb** (`test/installer.sh`, group `render: formulas parse as
TOML, profile renders carry the body verbatim`): each file parses as TOML;
`version` is an integer; `formula` is one of the five preset names, all five
seen; step ids are unique; and the step count and the ordered list of
human-gated step ids are exact —

| Preset | Steps | Gated steps, in order |
|---|---|---|
| `chisel-default` | 9 | `plan`, `type`, `close` |
| `chisel-light` | 7 | `plan`, `diff-review` |
| `chisel-supervised` | 9 | `plan` |
| `chisel-auto` | 9 | (none) |
| `chisel-auto-light` | 6 | (none) |

So: **no step is added or removed, no step id is renamed, no `[steps.gate]`
table is added, removed or moved, and no `needs` edge changes.** This slice
edits `description` strings and comments only. Two further mechanical
constraints ride along: the integrity check resolves every `.agents/…` path
written in the text against the installed tree, so new text may only point at
paths that exist (`.agents/methodology.md`, `.agents/project.md`,
`.agents/profiles/*.md`, `.agents/formulas/*.formula.toml` all do; the work
template is NOT under `.agents/`, so it is named as "the work template
declared in `.agents/project.md` §A" and never as a path); and
`assert_files_identical` compares the installed `chisel-default.formula.toml`
byte for byte with the socle source, which is satisfied automatically because
`bin/chisel.sh` copies it.

### 1 · Program design — the target shape of the five formulas

Stated once here; §2 turns it into per-file edits. Under the two-document
model each formula must say exactly this, in the vocabulary the doctrine now
uses ("spec document", "work document" — never "spec file", in any casing):

1. **Headers — the ownership sentence.** Today every header says "The content
   and the progress belong to the spec file". After this slice: the
   requirements, the review surface and the task's **sole status** belong to
   the **spec document**; the program design and the **progress** belong to
   the **work document** the Mason creates at `plan`. The sentence keeps its
   existing job — declaring that the formula owns only the order and the
   gates — and gains the second destination.

2. **Headers — the blocker line** (only the two presets that carry one:
   `chisel-auto`, `chisel-supervised`). Today: "it blocks the task, writes
   what it doubts into the spec file, and reports to the Foreman". After:
   **one line stating the duty plus a pointer** to
   `socle/agents/methodology.md` ("Escalation, and the blocked-task report"),
   exactly the dedup pattern the seven doctrine carriers adopted at slice 02
   and `socle/templates/AGENTS-block.md` demonstrates. The line never
   restates the rule, never names a journal line, and never names a separate
   escalation item — both retired by G15/Addendum 3. What it keeps is the
   preset-specific half that is genuinely the formula's business: the report
   goes to the Foreman, which decides within what it owns and hands anything
   above that to the human — full stop, there is no other rung inside the
   run.
   **The pointer is written in its INSTALLED form** — `` `.agents/methodology.md` ``
   ("Escalation, and the blocked-task report"), never `socle/agents/…`: the
   formulas ship into a consumer repo at `.agents/`, where no `socle/` path
   resolves. This design must carry the guard itself, because the suite's
   "no pointer into thin air" check only matches literal `.agents/…` strings
   and would stay silent on the wrong form. Same rule for every path this
   slice writes into a formula.

3. **Headers — `chisel-supervised`'s degraded-run paragraph.** "the status of
   the spec file becomes `awaiting approval`" and "the human reads the spec
   file" both become the **spec document**: that is the file that carries the
   sole status, so the sentence is true only in the new vocabulary.

4. **The `spec` step — the reading-gradient line.** Today: "Respect the
   reading gradient: 🧑 zones short and decision-rich, detail in the 🤖
   zone." After: the spec document's **two** 🧑 zones — REVIEW CAREFULLY then
   REVIEW IF RELEVANT — short and decision-rich, detail ordered after them
   rather than cut; **there is no agent zone**, because the Mason's working
   space is the separate work document it creates at `plan`. This is the only
   place 🤖 occurs in the formulas, and it is why the `spec` step is in this
   slice even though the slice title names four other steps.
   The rewritten line lands **identically in all five presets, auto-light
   included**, and that is deliberate: the line governs how the spec document
   is WRITTEN, not who approves its zones. Methodology's "Zone ownership"
   says that under `chisel-auto-light` the spec zones are *ignored, not
   reassigned* — the gradient still orders the document, so the sentence that
   orders it stays the same in every preset. A per-preset variant here would
   invent a doctrine difference that does not exist.

5. **The `plan` step.** Four changes, in one step body:
   - **Create the work document first.** It is `{{spec}}`'s path with
     `.spec.md` replaced by `.work.md`, in the same directory, from the work
     template declared in `.agents/project.md` §A. No new formula variable —
     parent decision 6: `[vars.spec]` stays the single required pointer,
     because a required variable would have to be supplied by an invoker at a
     moment when the file does not exist yet.
   - **Persist into that document, not into `{{spec}}`.** "PERSIST it into
     the Design section of {{spec}}" becomes: persist it into that work
     document, **under its Program Design heading** (the section name the
     work template declares), still BEFORE any code, still with the citations
     clause.
     **Corrected at `type`, 2026-09-02 16:47, `mason`.** The round-1/2 design
     said "the work document's **Program Design section**". Typed verbatim,
     that phrase reintroduced the criterion's own grep string —
     `grep -rn "Design section" socle/agents/formulas/` came back with five
     matches, one per file, because "Design section" is a substring of
     "Program Design **section**". The criterion
     **the-program-design-has-left-the-spec** requires it to return nothing,
     so the wording became "under its Program Design heading", which names
     the same heading of `socle/templates/000-template.work.md` and clears
     the grep. A wording fix inside the *how*, revised here in writing per
     the Mason contract rather than carried in the session's head; the *what*
     did not move.
   - **`{{spec}}` is read-only to the Mason.** Say it where the step tells
     the Mason to read it in full.
   - **Drop the status update.** "and update its status" goes, per parent
     decision 3: one status, in the spec document, maintained by the thread
     owner. Nothing replaces it — the resume point is the implementation
     checkboxes, now in the work document.

6. **The `plan-review` step** (the three presets that run one). The Architect
   reads `{{spec}}` and the program design the Mason persisted in the
   **matching work document** — the current wording says "the slice and the
   program design persisted at `plan`", which no longer names a destination.
   Verdict semantics are untouched: VALIDATED or corrections, typing needs
   VALIDATED. The never-edits-that-file clause is deliberately NOT restated
   here — `socle/agents/profiles/architect.md` owns it, and this slice does
   not duplicate contracts into the order file.

7. **The `type` step.** "ticking the implementation checkboxes in {{spec}}"
   becomes ticking them **in the matching work document**, and the same
   sentence names that document as where the worklog lands. The resume-point
   clause and "the full suite is the next step's job" stay.

8. **The `diff-review` step** (the four presets that have one). The
   requirement is the **whole spec document, system design included** — not
   "its 🧑 zones", which is the enumeration failure this chantier exists to
   kill — and the **matching work document is evidence only**, a divergence
   between the two designs being a finding rather than a reference. Where an
   Inspector runs it, findings are written into the work document.

9. **The `close` step.** Two changes:
   - **Promote before archiving, from the right source.** The promotion
     paragraph moves ahead of the bookkeeping paragraph, matching
     `socle/agents/profiles/foreman.md` ("At `close`, after promoting
     evergreen material needed for documentation, …") and the criterion's
     "promoting the evergreen material out of the work document first". And
     it names both sources, per methodology's "Artifact ladder":
     **system-design and architecture diagrams from the spec document**,
     **as-built seams, state machines and program-design diagrams from the
     work document**. Today the single phrase "from the Design" names a
     section that will not exist.
   - **Archive both files.** "then move **it** to the archive" becomes both
     files together — the spec document and its matching work document — with
     the sliced-parent case stated as the Foreman contract states it: a
     parent spec has no work document of its own and archives together with
     its slice folder.

10. **`[vars.spec]`'s own description.** "Path to the task spec file
    (markdown, chisel template)" becomes the **spec document** (from the spec
    template). The key, its `required = true` and its name are untouched —
    only the human-readable description, which otherwise keeps the retired
    phrase alive in all five files.

11. **`chisel-default`'s `description` field.** "The spec file owns the
    content; this formula owns the order and the gates" becomes the spec
    document owning the content and the status, the work document the
    progress. Case-sensitively this is "The spec file", so the parent's grep
    does not see it; leaving it would still ship the retired vocabulary in
    the one string every tool surfaces first.

12. **The `spec` step's handoff clause — "the file" is retired**
    (`chisel-default.formula.toml:91-93` and
    `chisel-light.formula.toml:87-89`, the two presets where the human
    relaunches every step; the other three spawn the next step themselves and
    carry no such clause). Today, identically in both: "Then STOP: the
    session that creates does not implement. The build starts fresh from the
    file — `work on task <file>`, or `work on slice <file>` for a slice whose
    blockers are all done." Three ambiguous references per line, and
    `socle/agents/discipline.md` rule 7 names that ambiguity explicitly —
    "resume from the spec and work documents, never an ambiguous \"the
    file\"" — while G14 point 1 is what makes "the file" name two files
    instead of one. After: the build **starts fresh from the spec/work
    pair**, with the invocations written `work on task <spec-document>` and
    `work on slice <spec-document>` — the corrected form three carriers
    already use (`socle/agents/methodology.md` "The two designs",
    `socle/agents/profiles/foreman.md`, and
    `socle/agents/discipline.md` rule 10). The spec document is what the
    invoker has; the work document is created by the session that arrives, so
    the invocation names the spec document and the sentence names the pair.
    **Blocking defect of round 1**: the round-1 design listed both ranges as
    untouched and closed its files-to-modify plan, which would have shipped
    them.

**Per-preset deviations** — the same shape, minus the steps a preset does not
run. Nothing below adds or removes a step or a gate:

| Preset | Steps present of the ones this slice touches | Deviation |
|---|---|---|
| `chisel-default` | `spec`, `plan`, `plan-review`, `type`, `diff-review`, `close` | the full shape, item 12 included; gates on `plan`, `type`, `close` keep their comment blocks untouched |
| `chisel-supervised` | same six | plus the degraded-run paragraph (item 3) and the header blocker line (item 2); no handoff clause, so item 12 does not apply; one gate, on `plan` |
| `chisel-auto` | same six | plus the header blocker line (item 2); no handoff clause, so item 12 does not apply; no gate |
| `chisel-light` | `spec`, `plan`, `type`, `diff-review`, `close` | item 12 applies (it is the other preset the human relaunches); no `plan-review`, so item 6 does not apply; the two clauses that say "this preset runs no `plan-review`" (in `plan` and in `type`) stay verbatim; `diff-review`'s actor is the human, so item 8 applies without the findings-destination clause — the Owner's own review is not a section of any file (parent §Architecture) |
| `chisel-auto-light` | `spec`, `plan`, `type`, `close` | no `plan-review` and no `diff-review`, so items 6 and 8 do not apply; no handoff clause, so item 12 does not apply; its `close` keeps its own opening paragraph ("No review ran in this preset…") ahead of the promotion paragraph |

Steps this slice does **not** touch, and why: `interview` (its "into the
Notes of the spec the next step writes" clause stays TRUE under parent
decision 2, which keeps a Notes section in the spec document for pre-`plan`
writers); `spec-review` (same, for "findings written into the Notes of
{{spec}}"); `verify` (mechanical, names no document); and every
`[steps.gate]` comment block (gates are out of scope by the work order and by
the suite's assertion).

### 2 · Target edits, by carrier

Line numbers are as of the current tree (branch `review-360`, tip `9db116f`),
before any edit; they shift as edits land, so the resume point in §3 is the
checkbox list, never a line number. Every replacement keeps the file's
prevailing ~79-column wrap and its existing voice. "Item N" refers to §1.

#### `socle/agents/formulas/chisel-default.formula.toml` (218 lines)

| Lines | What is there | Replacement intent |
|---|---|---|
| 25–28 | "This file owns the ORDER and the GATES… The content and the progress belong to the spec file" | item 1 |
| 34 | `description = "… The spec file owns the content; this formula owns the order and the gates."` | item 11 |
| 43 | `[vars.spec]` description "Path to the task spec file" | item 10 |
| 74–76 | "from the task file template declared in `.agents/project.md` §A" + "detail in the 🤖 zone" | item 4, plus the template-name repair below |
| 91–93 | `spec` body, handoff clause: "The build starts fresh from the file — `work on task <file>`, or `work on slice <file>`…" | item 12 |
| 114–129 | `plan` body: "PERSIST it into the Design section of {{spec}}" (120–121); "…and update its status" (127–128) | item 5, all four changes |
| 142–146 | `plan-review` body: "Read the slice and the program design persisted at `plan`" | item 6 |
| 153–158 | `type` body: "checkboxes in {{spec}}" (155–156) | item 7 |
| 184–189 | `diff-review` body: "whose 🧑 zones are the requirements of the Spec axis" (186–188) | item 8 |
| 196–214 | `close` body: bookkeeping paragraph (198–204) with "move it to the archive"; promotion paragraph (205–210) with "from the Design" | item 9, both changes (paragraph order swaps) |

Untouched in this file: lines 1–24, 29–33, 35–42, and 44–113 except 74–76 and
91–93; the three `[steps.gate]` blocks (130–135, 159–164, 215–218);
`spec-review` (96–105); `verify` (166–177). The `spec` step's "Then STOP: the
session that creates does not implement" sentence stays — only the handoff
clause that follows it is rewritten (item 12).

#### `socle/agents/formulas/chisel-supervised.formula.toml` (221 lines)

| Lines | What is there | Replacement intent |
|---|---|---|
| 9–13 | degraded-run paragraph: "the status of the spec file becomes `awaiting approval`" (10), "the human reads the spec file" (11) | item 3 |
| 22–25 | "it blocks the task, writes what it doubts into the spec file, and reports to the Foreman…" | item 2 |
| 32–35 | ownership sentence, "…belong to the spec file" (33) | item 1 |
| 53 | `[vars.spec]` description | item 10 |
| 87–89 | template pointer + "detail in the 🤖 zone" | item 4 + template-name repair |
| 125–140 | `plan` body: persist (131), status (138–139) | item 5 |
| 155–159 | `plan-review` body | item 6 |
| 166–171 | `type` body: checkboxes (168–169) | item 7 |
| 191–196 | `diff-review` body | item 8 |
| 203–221 | `close` body: bookkeeping (204–211), promotion (212–217) | item 9 |

Untouched: the single `[steps.gate]` block (141–148) including its comment,
`interview` (58–78), `spec-review` (107–116), `verify` (173–184), and the
preset's `description` at 44 (it says "the Owner approves the spec" — no
retired phrase, no edit).

#### `socle/agents/formulas/chisel-auto.formula.toml` (205 lines)

| Lines | What is there | Replacement intent |
|---|---|---|
| 15–18 | "it blocks the task, writes what it doubts into the spec file, and reports to the Foreman…" | item 2 |
| 24–27 | ownership sentence, "…belong to the spec file" (25) | item 1 |
| 45 | `[vars.spec]` description | item 10 |
| 79–81 | template pointer + "detail in the 🤖 zone" | item 4 + template-name repair |
| 117–132 | `plan` body: persist (123), status (130–131) | item 5 |
| 139–143 | `plan-review` body | item 6 |
| 150–155 | `type` body: checkboxes (152–153) | item 7 |
| 175–180 | `diff-review` body | item 8 |
| 187–205 | `close` body: bookkeeping (188–195), promotion (196–201) | item 9 |

Untouched: no gate blocks exist; `interview` (50–70), `spec-review`
(99–108), `verify` (157–168).

#### `socle/agents/formulas/chisel-light.formula.toml` (191 lines)

| Lines | What is there | Replacement intent |
|---|---|---|
| 26–29 | ownership sentence, "…belong to the spec file" (27) | item 1 |
| 44 | `[vars.spec]` description | item 10 |
| 74–76 | template pointer + "detail in the 🤖 zone" | item 4 + template-name repair |
| 87–89 | `spec` body, handoff clause, identical to the default's | item 12 |
| 99–116 | `plan` body: persist (105), status (112–113); the "runs no `plan-review`" clause (114–115) stays | item 5 |
| 128–135 | `type` body: checkboxes (130–131); the "nothing else validated it" clause (133–134) stays | item 7 |
| 155–162 | `diff-review` body, actor the human: "whose 🧑 zones are the requirements" (159–160) | item 8, without a findings destination |
| 173–191 | `close` body: bookkeeping (174–181), promotion (182–187) | item 9 |

Untouched: both `[steps.gate]` blocks (117–121, 163–166) including the
Owner's quoted placement in the header (lines 1–6), `interview` (49–65),
`verify` (137–148), and the rest of the `spec` step (67–90 except 74–76 and
87–89) — its own sizing-check wording, which differs from the default's,
is not this slice's business.

#### `socle/agents/formulas/chisel-auto-light.formula.toml` (174 lines)

| Lines | What is there | Replacement intent |
|---|---|---|
| 29–32 | ownership sentence, "…to the spec file" (30) | item 1 |
| 47 | `[vars.spec]` description | item 10 |
| 81–83 | template pointer + "detail in the 🤖 zone" | item 4 + template-name repair |
| 105–120 | `plan` body: persist (111), status (118–119) | item 5 |
| 127–134 | `type` body: checkboxes (129–130); the "nothing else validated it" clause (132–133) stays | item 7 |
| 154–173 | `close` body: its own opening (155–158), bookkeeping (159–164), promotion (165–170) | item 9, keeping the opening paragraph first |

Untouched: the no-`diff-review` justification in the header (8–10), the
zone-ignoring nature of the preset (doctrine, not this file), `interview`
(52–72), `verify` (136–147).

#### The template-name repair, declared explicitly

All five `spec` steps say "Write {{spec}} from the **task file template**
declared in `.agents/project.md` §A". After slice 01, §A declares a **Spec
template** and a **Work template** and no "task file template" — so the
pointer names something the glue no longer has. The repair is one noun in a
sentence this slice already rewrites for item 4, in a file inside this
slice's map, and slice 01 put the formulas in its files-to-avoid list, so no
other slice owns it. It becomes "from the **spec template** declared in
`.agents/project.md` §A". Five occurrences, one per file. Flagged rather than
smuggled: it is a truthfulness repair, not one of this slice's four named
criteria — see open question **Q1** if the reviewer would rather it were cut.

#### Inventory — occurrences found, per file

Counted against the current tree; the first four rows are the criteria's own
greps, the rest are the passages the doctrine makes false and no criterion
greps.

| Pattern | default | supervised | auto | light | auto-light | Total |
|---|---|---|---|---|---|---|
| `the spec file` (case-sensitive, the parent's grep) | 1 | 4 | 2 | 1 | 1 | **9** |
| `Design section` | 1 | 1 | 1 | 1 | 1 | **5** |
| `checkboxes in {{spec}}` | 1 | 1 | 1 | 1 | 1 | **5** |
| `AGENT ZONE` | 0 | 0 | 0 | 0 | 0 | **0** |
| `🤖` (all in the `spec` step) | 1 | 1 | 1 | 1 | 1 | **5** |
| `spec file`, case-insensitive (adds the five `[vars.spec]` descriptions and `chisel-default`'s preset `description`) | 3 | 5 | 3 | 2 | 2 | **15** |
| `from the Design into the living docs` (`close`) | 1 | 1 | 1 | 1 | 1 | **5** |
| `move it to the archive` (`close`) | 1 | 1 | 1 | 1 | 1 | **5** |
| `update its status` (`plan`) | 1 | 1 | 1 | 1 | 1 | **5** |
| `task file template` (`spec`) | 1 | 1 | 1 | 1 | 1 | **5** |
| `are the requirements of the Spec axis` / `are the requirements` (`diff-review`) | 1 | 1 | 1 | 1 | 0 | **4** |
| `Read the slice and the program design` (`plan-review`) | 1 | 1 | 1 | 0 | 0 | **3** |
| `the file` / `<file>` — the handoff clause, item 12 (one line per file, three ambiguous references on it) | 1 line | 0 | 0 | 1 line | 0 | **2 lines, 6 references** |

The four criteria greps must all return nothing afterwards; `spec file` in
any casing must return nothing too, which is stricter than the parent's grep
and is the target this design commits to; and so must
`grep -rn "the file\|<file>" socle/agents/formulas/`, whose only two matches
today are the handoff clause of item 12.

### 3 · Implementation order, and the resume point

One preset at a time, `chisel-default` first because it is the reference the
other four headers point at for the axes reading, and because the suite
compares it byte for byte against its installed copy. Within a file: header,
then `[vars.spec]`, then the steps top to bottom. The checkboxes below ARE
the resume point — a fresh Mason restarts at the first unticked one.

- [x] 1 · `chisel-default.formula.toml` — items 1, 11, 10, 4 (+repair), 12,
  5, 6, 7, 8, 9. Then `python3 -c 'import tomllib,sys;tomllib.load(open(sys.argv[1],"rb"))'`
  on the file as a fast parse check.
- [x] 2 · `chisel-supervised.formula.toml` — items 3, 2, 1, 10, 4 (+repair),
  5, 6, 7, 8, 9. Parse check.
- [x] 3 · `chisel-auto.formula.toml` — items 2, 1, 10, 4 (+repair), 5, 6, 7,
  8, 9. Parse check.
- [x] 4 · `chisel-light.formula.toml` — items 1, 10, 4 (+repair), 12, 5, 7,
  8 (no findings destination), 9. Parse check. Item 12's clause is identical
  in both carriers, so the two edits must land on the same replacement text.
- [x] 5 · `chisel-auto-light.formula.toml` — items 1, 10, 4 (+repair), 5, 7,
  9 (opening paragraph kept first). Parse check.
- [x] 6 · The four criteria greps, run and pasted into the worklog:
  `grep -rn "checkboxes in {{spec}}" socle/agents/formulas/`,
  `grep -rn "the spec file" socle/agents/formulas/`,
  `grep -rn "Design section" socle/agents/formulas/`,
  `grep -rn "AGENT ZONE\|🤖" socle/agents/formulas/` — all four empty; plus
  two stricter ones, also empty:
  `grep -rni "spec file" socle/agents/formulas/` and
  `grep -rn "the file\|<file>" socle/agents/formulas/` (item 12).
- [x] 7 · Cross-file read of the five formulas against the landed doctrine
  (methodology, discipline **rule 7 included**, the four profiles): same
  steps, same destinations, same actors in all five presets; every invocation
  and every resume instruction names the spec/work pair rather than "the
  file"; every path written in its installed `.agents/…` form; and no
  contract restated that a profile already owns.
- [x] 8 · `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — expect 9
  scenarios, 94 assertions, 0 failed, unchanged from the baseline. Zero test
  changes are expected; a needed test change is a finding, not a fix.
- [ ] 9 · Commit. **Deliberately left unticked**: the thread owner ordered the
  diff to stay uncommitted so the Inspector reviews the working tree at
  `diff-review`. The design's per-preset commit plan is superseded by that
  instruction, not forgotten — committing is the Foreman's at `close`.

Files-to-modify, complete and closed: the five files of
`socle/agents/formulas/`. Nothing else — no test, no profile, no template, no
glue. A needed touch outside that map is not typed: it goes to the worklog
and to the spawner under the proposal door.

### 4 · The four questions, ruled and closed

Round 1 recorded these as open. The Architect ruled all four at
`plan-review`; none escalated to the Owner. They are **closed** — recorded
here as rulings, not reopened when typing.

- **Q1 — the template-name repair. RULING: KEEP it.** Renaming "task file
  template" to the spec template §A actually declares is in scope: it is
  settled by parent decision 8 (a rename repoints its own citers — deleting
  or renaming a thing while leaving a pointer at the old name is a broken
  state we would create ourselves), and no other slice can fix it because
  slice 01 put the formulas in its files-to-avoid map. Five occurrences, one
  per file, exactly as §2's template-name repair paragraph states.
- **Q2 — `chisel-auto-light` has no header blocker line. RULING: LEAVE it**,
  as recommended. No criterion asks for the line, and ambient discipline
  rule 6 plus the Mason and Foreman contracts bind every mode, auto-light
  included. The asymmetry stays recorded here so a later reader finds a
  decision rather than an oversight.
- **Q3 — the `interview` and `spec-review` "Notes of the spec" clauses.
  RULING: settled, not open — leave them untouched.** Parent decision 2
  keeps a Notes section in the spec document precisely for these pre-`plan`
  writers, and G15 point 1 sends a pre-`plan` blocker to the same place, so
  every one of those clauses stays true; "the spec" is not the retired
  phrase. **Count corrected** (round 1 said "three files, one noun each",
  which undercounted): there are **six occurrences across four files** — the
  `interview` clause at `chisel-auto.formula.toml:68`,
  `chisel-supervised.formula.toml:76` and
  `chisel-auto-light.formula.toml:70`, and the `spec-review` clause at
  `chisel-default.formula.toml:104`, `chisel-auto.formula.toml:107` and
  `chisel-supervised.formula.toml:115`. None is edited by this slice.
- **Q4 — where a human reviewer's `diff-review` findings go in
  `chisel-light`. RULING: SETTLED — nowhere in the files.** `chisel-light`'s
  `diff-review` states no findings destination, because the Owner's own
  review is not a section of any file: parent §Architecture, on the Owner's
  words recorded in `project-management/review-360-decisions.md`, G14 point 4
  — « La review n'est pas un truc écrit pas l'owner, c'est écrit pas
  l'Inspector. Ma review à moi se fait dans le chat ou via un autre
  channel. » The round-1 hedge that offered to add a destination is removed:
  it reopened a closed ruling.

No blocker. Nothing in the parent spec, the doctrine or the suite left an
open *what* this design had to guess at.

### 5 · Implementation worklog

(No typing yet — the entries below are `plan`-side. Dated entries continue
here at `type`, one per work session: what was attempted, what landed, what
was reverted and why. Every entry signed with the role plus the date and the
time.)

- **2026-09-02 16:23 — `mason`** — Program design persisted at `plan`, round
  1. No code typed. Gate baseline confirmed before designing: 9 scenarios,
  94 assertions, 0 failed. Four open questions recorded, no blocker.
- **2026-09-02 16:34 — `mason`** — Design revised after the Architect's NOT
  VALIDATED at `plan-review`, round 1 of 2. One blocking defect folded in as
  §1 item 12 (the `spec` step's handoff clause names "the file" in
  `chisel-default.formula.toml:91-93` and `chisel-light.formula.toml:87-89`,
  against `socle/agents/discipline.md` rule 7 and G14 point 1), carried into
  §2's two edit tables, the inventory row, and §3's checkboxes 1, 4, 6 and 7;
  the two ranges are no longer pinned untouched. Three non-blocking
  adjustments folded in: the installed-`.agents/…` pointer guard on item 2,
  the count fix on Q3 (six occurrences across four files, not three), and the
  deliberate-in-all-five clause on item 4. The four questions are now
  recorded rulings and closed; Q4's hedge removed. Root cause of the blocking
  defect recorded in the preamble: rule 7 was not among the discipline rules
  read at round 1. Files to modify unchanged: the five formulas, and nothing
  else.

- **2026-09-02 16:56 — `mason`** — **`type` step: the design typed, all five
  formulas.** 47 exact-match replacements applied with a per-edit assertion
  that each target string occurred exactly once (no fuzzy match, no line-wise
  patching: every unit — header block, step body, close step — was recomposed
  whole and substituted, per the Architect's round-2 remark 2). Item 12's
  clause was written once for the default and pasted byte-identically into
  light; verified with `diff` afterwards, and the reading-gradient block of
  item 4 was likewise verified byte-identical across all five (one md5 for
  five files). The blocker pointer of item 2 landed in its installed form
  `` `.agents/methodology.md` `` in both carriers, and
  `grep -rn "socle/" socle/agents/formulas/` confirms no `socle/` path leaked
  in (round-2 remark 1).
  **One correction to the design, made in writing** (§1 item 5, dated
  16:47): "Program Design section" reintroduced the `Design section` grep
  string; reworded to "under its Program Design heading". Caught by the
  criterion's own grep, before the suite.
  **Two wrap repairs** in the text this step wrote: the promote paragraph
  split the reference `` `.agents/project.md` `` / `§D` across a line break
  in all five files — rewrapped so the section reference stays whole
  (discipline rule 12 in spirit, and the ST3 ragged-wrap finding of slice 02
  in letter). Verified afterwards: no prose line in any of the five files
  exceeds 79 characters; the only longer lines are the single-line TOML
  `description =` values (the files' pre-existing norm — the preset
  descriptions run 159–226 characters) and the box-drawing separators.
  **Verification, checkbox 6 — all six greps, raw and empty** (the spec-side
  §Verification names four; the design runs six, and none was invented after
  approval):

  ```
  $ grep -rn "checkboxes in {{spec}}" socle/agents/formulas/
  (exit 1 — no match)
  $ grep -rn "the spec file" socle/agents/formulas/
  (exit 1 — no match)
  $ grep -rn "Design section" socle/agents/formulas/
  (exit 1 — no match)
  $ grep -rn "AGENT ZONE\|🤖" socle/agents/formulas/
  (exit 1 — no match)
  $ grep -rni "spec file" socle/agents/formulas/
  (exit 1 — no match)
  $ grep -rn "the file\|<file>" socle/agents/formulas/
  (exit 1 — no match)
  ```

  **Checkbox 7 — cross-file read**: the five diffs read against the landed
  doctrine, step by step. Same steps, same destinations, same actors in all
  five presets; every invocation names `<spec-document>`; every path in its
  installed form; no contract restated that a profile already owns (the
  Architect's never-edits rule and the Mason's escalation form stayed out, as
  the design said they would). Steps left alone as designed: `interview`,
  `spec-review`, `verify`, and every `[steps.gate]` comment block.
  **Checkbox 8 — `git diff --check` clean; the suite**: `PATH="/opt/homebrew/bin:$PATH"
  bash test/run.sh` → **9 scenarios, 94 assertions passed, 0 failed**,
  identical to the pre-work baseline, with
  `PASS: formulas: all five presets parse as TOML (version integer, unique
  step ids, gates 3/2/1/0/0)`. Step counts and gate lists confirmed unchanged
  and printed in full: default 9 / `[plan, type, close]`, light 7 /
  `[plan, diff-review]`, supervised 9 / `[plan]`, auto 9 / `[]`, auto-light
  6 / `[]`. Zero test files touched.
  Working tree: only the five formulas modified. Not committed — the
  Inspector reviews the uncommitted diff (checkbox 9 annotated accordingly).

- **2026-09-02 17:07 — `mason`** — **ST-1 applied** (Inspector finding, ruled apply by the
  thread owner): `chisel-light.formula.toml`'s `diff-review` requirement clause
  recomposed as one wrapped unit to carry the two phrases the other three
  presets state — "system design included" and "a divergence between the two
  designs is a finding, never a requirement to judge against" — keeping Q4's
  silence on the findings destination, since light's reviewer is the human.
  Re-verified: the six greps empty, `git diff --check` clean, suite 9
  scenarios / 94 assertions / 0 failed, step counts and gate lists unchanged.

**Proposals — reported, not typed** (proposal door,
`socle/agents/profiles/mason.md`). Two residues carry the same "the file"
ambiguity item 12 retires, and both sit **outside all five slice maps of the
parent task**, so they ship stale unless a later round owns them. Neither
blocks this slice; both are reported to the spawner and recorded here.

- `AGENTS.md:10-13` (this repo's own instructions, not the socle): "work
  from the file in a fresh session (`work on task <file>` / `work on slice
  <file>`); plan approved by the human and PERSISTED into the file before any
  code". Three ambiguous references plus a persist destination that is now
  the work document. *Size:* four lines in one file. *Risk:* low — repo-level
  instructions, not shipped socle, no code depends on it; but it is the file
  every session in this repo reads first, so a stale line teaches the wrong
  model daily. *Deliverable without it:* yes — this slice is clean without
  it; only the repo's own dogfooding stays behind.
- `socle/agents/profiles/README.md:67`: "`work on slice <file>` for a Mason
  working a slice". *Size:* one clause. *Risk:* low in blast radius, higher
  in consequence than the first — this one IS shipped socle, and slice 02's
  map covered the four profiles but not the profiles README, so no slice of
  the parent task owns it. *Deliverable without it:* yes.

## Notes

Created 2026-09-02 at the start of slice 03, in accordance with the parent
spec's intermediate-convention decision. Two proposals recorded by slice 02
touch neighbouring files and stay out of this slice's map:
`socle/agents/skills/retro/SKILL.md:42` (slice 04, a re-pointing rather than
a rename) and the chisel-beads blocked-status gap (unowned; the doctrine
names a native blocked status the beads skill does not document yet).

- 2026-09-02 17:20 — **foreman** — Slice closed at commit `fd1dc95`. Both
  Inspector axes passed; ST-1 aligned before commit; the two parent-closing
  criteria stay unticked by design (this slice contributes, the task closes
  them). Archival of the pair happens at task `close`.
