# 08 — Post-audit hardening: installer guards, test legibility, supervised preset, proposal door

**Status:** 🟢 Done (2026-08-26)
**Blocked by:** None (01–04 delivered) — **runs BEFORE 05 and 06** (it
reorganizes the test suite they will grow)

**What to build:** The corrective slice from the adversarial audit
(`../factory-bench/research/audit-fable-v2.md`) plus the Owner's round of
decisions (parent Notes, "Audit round"). Four bundles:

1. **Installer guards** (both bugs proven live by the audit): `chisel update`
   on a v1 layout (a repo that still has `.agents/rules/` or
   `.agents/workflows.md`) REFUSES with a clear message pointing to
   `upgrade-v2` — it must never leave two normative discourses side by side.
   And a file chisel did not write in `.agents/skills/` is NEVER adopted as
   managed by `update` (warn, leave alone) — the same discipline
   `.claude/agents/` already applies via its marker; the bd-init case (a
   foreign `beads/` skill dir) is the fixture.
2. **Test suite legibility** (the Owner's explicit complaint + audit finding
   5): every group opens with a `PROTECTS:` line printed at run time; the
   final summary counts SCENARIOS (groups) alongside assertions; tautological
   asserts (copied-file-exists ×2 fixtures) pruned or folded; the three
   neutrality scans unified on the one shared regex; a `test/TESTS.md`
   one-pager (group → what it protects → what a failure means) — THAT is the
   Owner's review surface, not the sh. Plus the missing test the audit
   proved: **referential integrity** — every internal pointer in the
   installed socle resolves to an existing file (would have caught the
   dangling `rules/` pointers).
3. **The `chisel-supervised` formula** (Owner decision, human-ON-the-loop):
   third preset, same steps byte-identical to the other two, exactly ONE
   human gate — spec approval, sitting on the `plan` step — plan approval
   and review arbitration handled as in auto (Architect persists, Inspector
   arbitrates). Works degraded without beads: stop at the gate, status
   `awaiting approval`, fresh session resumes after the human edits.
   Invariant tests become three-way (same step ids, bodies identical,
   gate-set is the only diff: default = 3, supervised = 1, auto = 0).
4. **The proposal door in the profiles** (Cursor-article insight, Owner
   decision): `mason.md` — when the work reveals a needed change beyond the
   persisted plan (touching core code, structure), PROPOSE it upward to the
   Architect; never silently do it, never silently drop it. `architect.md` —
   rule on Mason proposals; when the magnitude exceeds what you authored
   (contests the spec's owner's zones), escalate to that owner. Without an
   explicit door, agents never propose large improvements and quality decays.

Also, one wording defer (Owner decision Q-b): the B1 questionnaire's option 3
(shared background service) is marked **deferred** — shown as "not supported
yet, ask when you need it", not offered as a pickable option.

## Acceptance criteria

- [x] `chisel update` on a v1-layout fixture exits non-zero with a message
      naming `upgrade-v2`; on a v2 layout it behaves as before (tested)
      — and a refused update writes nothing at all (also asserted)
- [x] A foreign file/dir planted in `.agents/skills/` survives `update`
      untouched and un-adopted, with a warning; `check` does not flag it
      (tested with a `beads/`-like directory planted on a fresh install)
- [x] Referential integrity: a suite-wide test walks every internal socle
      pointer (installed tree) and fails on any target that does not exist —
      it FAILS on a planted dangling pointer, one per pointer shape
      (mutation-tested); the two pre-existing holes in `methodology.md` are
      waived in a printed, self-retiring table (slice 07 owns that file)
- [x] `bash test/run.sh` prints one `PROTECTS:` line per group and a final
      `N scenarios, M assertions` summary; `test/TESTS.md` exists, one page,
      current; the suite stays green throughout
- [x] `socle/agents/formulas/chisel-supervised.formula.toml` ships and is
      installed by `init`; three-way invariants green; the no-tooling
      walkthrough stops exactly once (spec gate) and runs through the rest
      (trace in Notes)
- [x] `mason.md` and `architect.md` carry the proposal door — as ruled by the
      Owner mid-slice: every discovery reported, the reporter evaluates and
      the receiver decides, and a report blocks only when clean delivery is
      impossible; renders carry it verbatim; wording ledger- and vendor-neutral
- [x] B1 option 3 displayed as deferred; questionnaire tests updated

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

Fixed point: `499b49c`. Sources: the audit report
(`../factory-bench/research/audit-fable-v2.md`, findings A2/T1/T2/T3/T4/T6),
the Owner's audit-round decisions (parent Notes). Nine decisions, then the
file tree.

### D1 — `update` refuses a v1 layout; `init` does not

`cmd_update` stops before it copies anything when `.agents/rules/` or
`.agents/workflows.md` is present: `die` with a message naming `upgrade-v2`
(exit 1, nothing written). Rationale: the bug the audit proved is that
`update` leaves two normative discourses side by side, and the refusal has to
land BEFORE the copy or the incoherence ships anyway.

`init` is deliberately NOT guarded: it is the bootstrap command, and
`upgrade-v2` (slice 06) will want to run the installer on a repo it is in the
middle of migrating. `check` is not guarded either — it writes nothing, and a
guard there would only add noise to a repo already refused by `update`.

### D2 — the manifest tracks what chisel COPIED, not what `find` finds

`managed_relative_files` derived the `.agents/{skills,formulas,profiles}`
entries from a `find` over the TARGET, which is why a foreign file dropped in
`.agents/skills/` (what `bd init` does) got adopted as managed and then
reported `DIVERGED` when its owner edited it. It now derives them from a
`find` over the SOCLE SOURCE, rewritten to target-relative paths: the manifest
claims exactly the files `copy_managed_files` copies. Same discipline
`.claude/agents/` already applies through `GEN_MARKER`, reached by the other
available road — the socle list is the marker for files chisel owns wholesale.

Consequences, all wanted: a foreign skill dir is neither managed, nor
re-rendered, nor flagged by `check`; a user-added profile (an advertised
extension point) is the user's file, while the definition chisel renders from
it stays managed through its marker; a file retired upstream stops being
tracked instead of being tracked forever.

`copy_managed_files` also WARNS, once per foreign top-level entry, on
`.agents/skills/` only — `.agents/profiles/` and `.agents/formulas/` are
documented extension points where a user file is normal, and a warning there
would be noise, not information.

### D3 — the suite is read by group, not by line

Every group opens through one `group "<n>. <title>" "<what it protects>"`
helper that prints the header and a `PROTECTS:` line and counts one scenario.
The tail prints `N scenarios, M assertions passed, K failed`. Thirteen groups:
the nine existing ones (7 keeps the formula shape, 8 the profiles, 9 the
tiers, 10 the setup) plus **11. installer guards**, **12. referential
integrity**, **13. neutrality** — the last one absorbing the scans that were
scattered across 7, 8, 9 and 10.

Pruned, with the reason for each:

- `assert_full_layout` on the boilerplate fixture (~50 assertions) → ONE
  comparison of the installed path tree against the brownfield fixture's,
  plus the three assertions that are really about boilerplate (title created,
  `apps/documentation` and `package.json` intact). Strictly stronger: tree
  equality also catches a file that should NOT be there.
- `render: the source $role points at exists` (×3) — the existence of a
  profile is already asserted by `assert_full_layout`; this re-asserted it.
- `render: codex definition of $role declares developer_instructions` (×3) —
  the TOML parse test asserts the field AND its content byte for byte; the
  `name = ` grep already proves the render ran.

Kept deliberately: `assert_full_layout` on the brownfield fixture (the
black-box seam of `init`, and the place a missing file must be NAMED), and
the duplicated step bodies of the formulas (they are duplication protected by
a test — the audit's own verdict).

Neutrality unified: one alphabet (`model_name_re`, `tool_name_re`,
`ledger_name_re`, W labels), one group, each scan at its widest honest
perimeter — labels and model names socle-wide (the parent AC, which no group
scanned socle-wide before: audit T6), tool names over the profile layer's
prose with code spans stripped (adapter paths are filesystem facts), ledger
backends over all three formulas, and the same two scans over the installed
renders.

`test/TESTS.md` is the one-pager: one row per group — what it protects, what
a failure means. That page is the Owner's review surface; the shell script is
not.

### D4 — referential integrity, with a self-retiring waiver

New group 12. `dangling_pointers <target>` walks every `*.md`, `*.toml`,
`*.tpl` of the INSTALLED tree (`.agents/`, `.claude/agents/`,
`.codex/agents/`, `AGENTS.md`) and prints `pointer<TAB>file` for each pointer
whose target does not exist. A pointer is, precisely — the rule is in
`TESTS.md` because a test nobody can state is a test nobody can review:

1. any `.agents/...` path found in the text, trailing punctuation and
   trailing `/` stripped;
2. any markdown link to a SIBLING file (`](name.md)` or `](./name.md)`, no
   remaining slash, a real extension) resolved next to the file that carries
   it.

Illustrative paths inside another project's tree (`./src/billing/CONTEXT.md`
in the domain-modeling skill) and placeholders (`](link)`) are not pointers,
and deep relative links are out of the walk rather than guessed at.

Mutation-tested: a pointer to `.agents/nope/missing.md` planted in an
installed `discipline.md` must be caught, or the group fails.

**Waiver**, in two categories, printed at run time as one `KNOWN GAP` table:

- **DEBT** — `.agents/rules/task-*.md` and `./workflows.md`, both dangling in
  `socle/agents/methodology.md` (finding A2). That file belongs to slice 07,
  not here.
- **BY DESIGN** — `.agents/user.md`, cited by the socle and deliberately never
  installed (the installer poses the template, never the personal file). Found
  while building the walk, kept as a waiver rather than special-cased in the
  extractor: one table a reader can audit beats one more rule in an awk.

The group asserts BOTH directions: no dangling pointer outside the waiver
(fails on a new one), and every waived pointer is still dangling (fails the day
slice 07 fixes one, so a debt line cannot outlive its debt). A green suite that
hides a known hole is exactly the failure this slice was created to end; a
waiver that announces itself and expires is not that.

### D5 — `chisel-supervised` = the auto bodies, one gate, on `plan`

Byte-identical bodies is only definable against ONE of the two existing files,
since they differ by the escalation lines. Supervised takes **auto's** bodies
verbatim: in supervised the Owner approves the SPEC and nothing else — the
plan is the Architect's (self-check, escalate on a 🧑 zone) and the review is
the Inspector's (arbitrates, escalates what touches scope). Those are auto's
words already; rewriting them would create a third dialect for no decision.

The single `[steps.gate] type = "human"` sits on the `plan` step — the step
that WAITS on the spec being approved (chantier lesson: the gate belongs to
the step that waits, not to the step that produced the thing being approved).

Invariants become three-way, and the gate test now says WHERE, not how many:
an awk walk pairs each gate with the step id it hangs under — controlled
`plan type close`, supervised `plan`, auto empty. Plus: the three declare the
same ordered step ids; supervised's step bodies are byte-identical to auto's;
auto only ADDS to controlled (kept, untouched).

Degraded mode without ledger tooling is stated in the header: stop at the
gate, status `awaiting approval` in the spec file, a FRESH session resumes
after the human has edited it — no daemon, no notification, nothing to poll.

Not renamed here: the delivered file is `chisel-controlled.formula.toml`, and
the Owner's "default + options" vocabulary (`chisel-default`) is slice 07's
pass. Routing texts (AGENTS-block, glue §B3) do not name the third preset yet
for the same reason — both are out of this slice's grip.

### D6 — the proposal door lives INSIDE `## Escalation`

Not a sixth section: `profiles/README.md` declares the five-part contract and
is out of grip, and the door IS an upward channel — it belongs where the other
upward channels are. Ledger- and vendor-neutral throughout; the renders inherit
it verbatim (asserted).

**Rewritten twice mid-slice on the Owner's rulings** (received while this
session was in the review round; both are recorded in Notes). The first
wording over-escalated — "anything bigger than what you authored → escalate" —
and the two-channel version that replaced it still discriminated on the wrong
axis. The rule as shipped, from the Owner's final message (source added: the
Cursor agent-swarm article, whose "intentional breakage" is REJECTED here — we
have no swarm to absorb the damage, we have human review; what is kept is
their signalling mechanism, which lands as a dedicated refactoring task):

- `mason.md` — **every** discovered refactor, useful or necessary, goes up one
  rung, always: the information is never swallowed and never acted on quietly.
  The report carries three evaluations — size, risk (core code? outside my
  scope? broad impact?), and "can I deliver cleanly without it, or will the
  result be ugly?". Reporting is NOT waiting: if the task is still cleanly
  deliverable the Mason carries on while the report travels; it stops only when
  clean delivery is impossible without a decision. Hard rule: very core code,
  out of scope, or broad impact → hands up, never on its own initiative.
- `architect.md` — the receiver decides, never the reporter. Small and inside
  what the Architect signed → fold it into the task, or create a refactoring
  task BEFORE the Mason's. Too big or risky → it does not do it either, and
  passes it up in turn with its own opinion. One verdict is always available:
  "noted, later — the current task matters more, carry on".

The acceptance criterion moves with the rule: the test now asserts the three
properties (reported / evaluator ≠ decider / blocks only when clean delivery
is impossible) rather than the retracted "escalate what you did not author".

### D7 — B1 option 3 shown, not offered

The §B1 screen keeps two numbered options; the shared background service
becomes an italic line under them: not supported yet, ask when you need it.
The branch lines that read "option 2 or 3" become "option 2". The glue
(`project.md.tpl`) still documents all three cases and is untouched — it is
out of grip, and a file documenting what exists is not the same surface as a
questionnaire offering a choice. The option count assertion goes 8 → 7
(2 + 3 + 2).

### D8 — one word fixed beyond the assigned change, disclosed

`chisel-setup/SKILL.md` l.9 points at `.agents/project.md.tpl`, which does
not exist in an equipped repo (the socle's `.tpl` lands as `.agents/project.md`)
— a third dangling pointer, found by D4's test, in a file this slice already
edits for D7. Fixed to `.agents/project.md`, one word, no behaviour. Recorded
here rather than done quietly: it is the door D6 installs, walked.

### File tree

```
bin/chisel.sh                                    D1 guard, D2 manifest + warning
socle/agents/formulas/chisel-supervised.formula.toml   NEW (D5)
socle/agents/profiles/mason.md                   D6 (Escalation only)
socle/agents/profiles/architect.md               D6 (Escalation only)
socle/agents/skills/chisel-setup/SKILL.md        D7 (+ D8, one word)
test/run.sh                                      D3 D4 + the new groups
test/TESTS.md                                    NEW (D3)
test/fixtures/brownfield-v1/                     NEW — v1 leftovers (D1)
project-management/CHANGELOG.md                  one dated entry
```

Order of work (each step leaves the suite green): D5 formula → D2/D1
installer + their group → D3 restructure → D4 integrity → D6/D7/D8 texts →
TESTS.md → review.

Departure from this tree, recorded: no `test/fixtures/foreign-skill/` was
committed. The realistic sequence is `init` → another tool plants its skill →
`update`, which needs an already-installed tree; the foreign directory is
therefore planted at run time on a fresh install, as the dangling pointer of
D4 is. Same coverage, one fewer committed fixture whose only content would be
a file chisel must ignore.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

Sources: the audit report (`../factory-bench/research/audit-fable-v2.md`), the
Owner's audit-round decisions in the parent's Notes. Out of scope here: beads
enforcement (hooks anti---mirror, post-claim verify, push verification, exit
plan) → slice 05 ; digest/escalation/ownership WORDING in discipline & docs →
slice 07.

### Owner rulings received mid-slice (proposal door)

Three messages, during the review round; each replaced the previous one. Kept
in full because the shipped wording is the third, and the first two explain why
it says what it says.

1. **Correction.** "Anything bigger than what you authored → escalate to that
   zone's owner" OVER-ESCALATES: everything would climb, all the time. Two
   channels instead — non-blocking (the majority): file it as candidate work,
   note it in the spec, FINISH as planned, nobody waits; blocking (rare):
   escalate one rung.
2. **Refinement.** The discriminant between the channels is NOT the magnitude
   of the change, it is NECESSITY: "can I deliver THIS task correctly without
   it?" A Mason never judges magnitude; ownership decides who rules.
3. **Final rule** (replaces 1 and 2; source added: the Cursor agent-swarm
   article — their "intentional breakage" is rejected here, we have no swarm to
   absorb the damage, we have human review; their signalling mechanism is kept
   and lands as a dedicated refactoring task). EVERY discovery goes up one
   rung, always, even when the agent could do without: the information is never
   swallowed. The report carries three evaluations — size; risk (core code?
   outside my scope? broad impact?); can I deliver cleanly without it, or will
   the result be ugly. The receiver decides, never the reporter. Architect:
   small and inside what you signed → into the task, or a refactoring task
   BEFORE the Mason's; too big or risky → you do not do it either, you pass it
   up with your opinion. "Noted, later — your task is urgent, carry on" is
   always among the available verdicts. Hard rule: very core code, out of
   scope, broad impact → hands up, never on one's own initiative. Reporting is
   not waiting: the agent stops only if delivering cleanly is impossible
   without a decision.

The acceptance criterion moved with it (AC6 below): the test asserts the three
properties, not the retracted escalation wording.

### AC5, second half — the no-tooling walkthrough of `chisel-supervised`

Walked the installed file as an ordered checklist, `needs` giving the order,
with no ledger tooling of any kind — the way a fresh session with nothing but
the repo would:

| # | step | `needs` | what a plain reader does |
|---|---|---|---|
| 1 | `interview` | — | runs; no gate declared |
| 2 | `spec` | interview | runs; no gate |
| 3 | `plan` | spec | **STOP** — `[steps.gate] type = "human"`: the spec awaits the Owner's approval. Status of the spec file → `awaiting approval`; the session ends here. Resumed in a FRESH session after the human's edit. |
| 4 | `type` | plan | runs; no gate (the plan is the Architect's) |
| 5 | `verify` | type | runs; no gate |
| 6 | `review` | verify | runs; no gate (the Inspector arbitrates, escalates what touches scope or a 🧑 zone) |
| 7 | `close` | review | runs; no gate (the closing summary goes to the Owner's digest) |

One stop, at the spec approval, and the six other steps run through — which is
what the suite asserts mechanically as `gated_steps` = `plan` (group 7), on
both the text and the parsed TOML.

### Review round (two axes, fixed point `499b49c`)

**Standards.** Four findings taken: (1) the boilerplate tree comparison could
pass on two EMPTY listings — a positive control now asserts the compared tree
is a real install (>40 paths); (2) every neutrality scan asserts an empty
result, which a mistyped path also returns — a control now asserts the socle
perimeter is non-empty before the scans run; (3+4) `write_manifest` still skips
a managed file missing from the target (so `check`'s MISSING branch stays
mostly dead), and `init` is not guarded against a v1 layout — both left as
they are, deliberately: the first is audit finding T5 (untested error branches,
not this slice's ACs), the second is D1's written decision. Handed on rather
than silently kept.
Not taken: the duplication between the awk gate assertion and the TOML one —
two independent implementations of the same invariant, one running on the bare
python3 floor and one parsing real TOML, is defence, not repetition.

**Spec.** Five findings, four taken: the door's over-escalation (the Owner's
ruling arrived on the same point — rewritten, see above); the waiver's third
line, present in the code but not in the persisted Design (Design updated, and
the table now separates BY DESIGN from DEBT); `test/fixtures/foreign-skill/`
planned as a committed fixture and planted at run time instead (departure now
recorded in the Design); the mutation test covering only one of the walk's two
pointer shapes (a sibling-link mutation added — both branches now proven to
have teeth). The fifth, AC5's missing walkthrough, is the table above.
