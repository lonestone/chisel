# 02 — Formulas rewrite

**Status:** 🟢 Complete — closed 2026-08-27.
**Blocked by:** 01 — roles remodel (closed 2026-08-27; the step bodies below
point at the profile contracts that slice froze, and this slice reopens three
of them where the rulings reach them).

**What to build:** the pipeline presets, rewritten on Foreman orchestration
and renamed after what they act on. The invoking session IS the Foreman; it
leads the interview itself — a spawned role cannot interview the human — and
every other role step is a fresh sub-agent spawned with that role's profile.
Step bodies are slimmed to the role name, the pointer to its profile as the
contract, and what is proper to the step; the fixed escalation ladder and the
"digest" leave the headers and the bodies of `chisel-auto` and
`chisel-supervised`; "Then STOP" survives only where a human relaunches; the
`spec` step ends by committing the spec, because the task may then sit at
"spec done" for a long time; at `close` the Foreman is named as the one who
commits and pushes.

The three reviews take the name of their object — `spec-review`,
`plan-review` (was `design-check`) and `diff-review` (was `review`) — and the
`plan` step says at last what it produces, the **program design**, and who
writes it: the session that implements. The CREATE / WORK separator drops one
step, since reviewing the spec is upstream of production. Two presets are
written from scratch: `chisel-light` (the validation sub-agents removed, two
human gates — the spec, and the diff review the human holds in the
Inspector's place) and `chisel-auto-light` (neither gates nor sub-agents, and
no `diff-review` at all — the floor of the pipeline, built to be measured,
with the mechanical `verify` as its only signal). The five are read as two
axes, said once. The sizing check gains its second question, "light or full?".
With that authorship comes the boundary it moves: what the Mason never decides
is no longer "the plan" but the **system design** — architecture, scope and
seams, settled upstream and approved at the human gate — and every sentence in
the socle that still puts the boundary at the plan is rewritten. The Architect
and Mason profiles follow the authorship change, the Mason gains the shape of
the summary it presents at the human gate on its plan, and the Foreman gains
the interview duty plus the two reporting rules the Owner added after the
first shapes were in use. The installer suite stays green: golden
tree and formula parse check cover five presets.

## Acceptance criteria

Cite these by name. The first seven restate the parent criteria this slice
fully satisfies; the rest are this slice's own share of the parent's final
greps and of the deliverables routed here. An amended criterion is never
erased: strike the original, date the new version below it.

- [ ] ~~**light-formula-exists** — `test -f
  socle/agents/formulas/chisel-light.formula.toml` passes; the file contains
  no `spec-review` and no `design-check` step; a `review` step exists and
  names the **human** as the reviewer of the diff; and there are exactly two
  `[steps.gate] type = "human"` gates — spec approved (before `plan`), and
  the review itself.~~
  *Superseded 2026-08-27 by the Owner's ruling that renames the reviews after
  their object; the parent criterion of the same name was amended twice.*
- [x] **light-formula-exists** (amended twice, 2026-08-27) — `test -f
  socle/agents/formulas/chisel-light.formula.toml` passes; the file contains
  no `spec-review` and no `plan-review` step; a `diff-review` step exists and
  names the **human** as its actor (no Inspector sub-agent); and there are
  exactly two `[steps.gate] type = "human"` gates — spec approved (before
  `plan`), and the diff review itself. No human gate sits on the Mason's plan.
- [x] **benchmark-floor-exists** — `test -f
  socle/agents/formulas/chisel-auto-light.formula.toml` passes; the file
  carries no `[steps.gate] type = "human"`, no `spec-review`, no
  `plan-review` and no `diff-review` step at all; and its header says plainly
  what it is — the pipeline with neither net, built to be measured against the
  others, per the Owner's "je serais curieux de l'avoir quand même pour faire
  du benchmark" — and says that the mechanical `verify` is the only signal
  left, rather than leaving the missing review unexplained.
- [x] **reviews-named-after-their-object** — `grep -rn "design-check" socle/`
  and `grep -rn 'id = "review"' socle/agents/formulas/` both return nothing;
  Given each formula, When read, Then the review steps it runs are named
  `spec-review`, `plan-review` and `diff-review`, and the `plan` step names
  the program design as what it produces and the implementing session as its
  author.
- [x] **create-work-separator-sits-right** — Given each formula's section
  separators, When read, Then `spec-review` sits on the CREATE side: the WORK
  separator falls after it, not before — and in a preset that runs no
  `spec-review`, it falls after `spec`.
- [x] **stop-only-where-humans-relaunch** — `grep -l "Then STOP"
  socle/agents/formulas/*.toml` lists only `chisel-default.formula.toml` and
  `chisel-light.formula.toml`; Given the auto, supervised and auto-light
  formulas, When a step ends, Then the Foreman spawns the next step fresh
  instead of stopping.
- [x] **foreman-closes** — Given each of the five formulas' `close` step, When
  read, Then the Foreman is named explicitly as the one who commits and pushes.
- [x] **slim-step-bodies** — Given any step body of the five formulas that a
  spawned role executes, When read, Then it contains the role name, a pointer
  to that role's profile as the contract, and only step-specific instruction
  (order, artifacts, gates) — no restatement of the profile's prohibitions,
  inputs or escalation rules; and Given a step no spawned role executes (the
  `interview`, the mechanical `verify`, the `close`, the light formula's
  human-held `diff-review`), When read, Then it names its actor and carries
  only step-specific instruction.
- [x] **foreman-leads-the-interview** — Given each of the five formulas'
  `interview` step, When read, Then the Foreman is named as its actor, with
  the reason: a spawned role cannot interview the human, so the thread owner
  runs it and spawns an Architect for the spec that follows; and Given
  `socle/agents/profiles/foreman.md` and `socle/agents/profiles/architect.md`,
  When read, Then the interview is the Foreman's duty and the Architect claims
  it nowhere.
- [x] **spec-step-saves-the-spec** — Given each of the five formulas' `spec`
  step, When read, Then the step ends with the spec committed, and says why:
  the task may then sit at "spec done" for a long time, which is the same
  reason the program design is written late.
- [x] **formulas-orchestrated-by-the-foreman** — Given each of the five
  formulas, When its header is read, Then the invoking session is named as the
  Foreman, with `.agents/profiles/foreman.md` as its contract, and a role step
  is described as a fresh sub-agent spawned with that role's profile body plus
  a brief composed from the profile's `Inputs` section, the steps the Foreman
  holds itself named as the exception.
- [x] **two-axes-said-once** — `grep -rln "two axes" socle/agents/formulas/`
  lists exactly one file; Given that file's header, When read, Then the human
  gates and the validation sub-agents are described as two independent axes
  and the five presets are placed on them; and Given the other four headers,
  When read, Then each names its own position in one clause and points at the
  full reading rather than repeating it.
- [x] **profiles-follow-the-plan-authorship** — Given
  `socle/agents/profiles/architect.md` and `socle/agents/profiles/mason.md`,
  When read, Then the Mason is the author of the program design at the `plan`
  step and the Architect validates it at `plan-review`, neither profile
  naming `design-check`, and neither claiming the authorship the other holds.
- [x] **the-boundary-is-the-system-design** — `grep -rn "delegation boundary
  is the plan" socle/`, `grep -rn "below the plan is typing" socle/` and
  `grep -rn "already-planned" socle/` all return nothing; Given
  `socle/agents/profiles/mason.md` in full — frontmatter, Mission, Tier,
  Speed contract, Prohibitions, Escalation, proposal door and Inputs — and the
  section "The two designs" of `socle/agents/methodology.md`, When read, Then
  what the Mason never decides is the system design (architecture, scope and
  the seams the work is tested through, settled upstream and approved at the
  human gate), the program design is stated as the Mason's own, and no
  sentence anywhere puts the boundary at the plan.
- [x] **mason-presents-a-go-summary** — Given
  `socle/agents/profiles/mason.md`, When read, Then it declares the shape of
  the condensed view of its program design that the Mason presents at the
  human gate on its plan, and states that the summary points at the file
  rather than replacing it.
- [x] **formulas-shed-ladder-and-digest** — `grep -rin "digest"
  socle/agents/formulas/`, `grep -rn "Mason → Architect"
  socle/agents/formulas/` and `grep -rn "Architect → Inspector"
  socle/agents/formulas/` all return nothing. (The parent's **no-digest-left**
  and **no-fixed-ladder** close over all of `socle/` at slice 3; the formulas
  are their last carriers outside `methodology.md` and `discipline.md`.)
- [x] **sizing-asks-light-or-full** — `grep -l "light or full"
  socle/agents/formulas/*.toml` lists `chisel-default.formula.toml`,
  `chisel-supervised.formula.toml` and `chisel-auto.formula.toml` and no
  other, and `grep -n "light or full" socle/agents/methodology.md` matches
  inside the section "Why slicing is conditional (the sizing check)".
- [x] **foreman-report-rules-complete** — Given the section "Reporting to the
  Owner" of `socle/agents/profiles/foreman.md`, When read, Then it states that
  a report never repeats what is already settled, that the Foreman never
  re-asks for an authorization already given, and that a section with nothing
  in it is dropped rather than filled. (Parent Implementation Decisions,
  point 10, routed here.)
- [x] **suite-green** — `bash test/run.sh` passes with `chisel-light` and
  `chisel-auto-light` present in the golden tree and covered by the formula
  parse check.

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan.

## Design — persisted at plan time

Persisted 2026-08-27 by the plan step of the parent task
`project-management/archive/20260827-1459-remodel-roles-and-formulas.md`, and
revised twice the same day. Read the parent's 🧑 zones first and its
Implementation Decisions in full, point 12 in particular; read too the ruling
G6 and the reference pipeline recorded as the second addendum of
`project-management/review-360-decisions.md`, which is the target sequence for
all five presets. Every decision below applies a ruling recorded in one of
those two places, or a ruling the thread owner made on this plan's own
escalations. What remains flagged is what extends a ruling by its logic.

### Decisions locked (plan level)

1. **The Foreman leads the interview; it spawns an Architect for the spec.**
   The reference sequence opens that way and says why: a sub-agent cannot
   interview the human. The `interview` step therefore names the Foreman as
   its actor in all five presets, with the clause that where no spawning tool
   exists the thread simply carries on in the conversation. Two profiles
   follow: the Foreman gains the duty, the Architect loses the claim. Ruled by
   the thread owner, 2026-08-27, on the Owner's recorded sequence.
2. **The `spec` step ends with the spec committed.** Same source: "La spec est
   prête. Commit pour save. On peut rester dans ce stade pendant un moment."
   That waiting state is the whole reason the program design is written late,
   so the step says both together. The Foreman commits it, as it does at
   `close` — commits belong to the thread owner. One clause in all five.
3. **`chisel-auto-light` has no `diff-review` step at all**, and its header
   explains the absence instead of leaving a hole: inserting a self-review
   would put a net back and make the benchmark measure something else; the
   mechanical `verify` is the signal that remains. Ruled by the thread owner,
   2026-08-27, closing the reading this plan had raised.
4. **The orchestration is stated once, in the header of each formula, and
   never repeated in a step body.** The header says: the invoking session IS
   the Foreman (contract `.agents/profiles/foreman.md`); it holds `interview`,
   `verify` and `close` itself, and every other step runs as a fresh sub-agent
   spawned with the step role's profile body plus a brief composed from that
   profile's `Inputs` section. Repeating it per step would rebuild the
   paraphrase surface the slimming ruling kills, on the one file that is read
   as a checklist.
5. **The handoff is a header rule too.** In `chisel-default` and
   `chisel-light`, the header says the human relaunches every step; the
   literal "Then STOP" survives in the `spec` step body of both, where it also
   carries the create-does-not-implement split, and nowhere else. In
   `chisel-supervised`, `chisel-auto` and `chisel-auto-light` the header says
   the Foreman spawns the next step fresh, and neither the phrase nor the word
   STOP appears anywhere in those three files — the criterion
   **stop-only-where-humans-relaunch** greps whole files.
6. **The two-axis reading lives in the header of `chisel-default`**, in full,
   once: the human gates are one axis, the validation sub-agents the other,
   and the five presets are placed on both. The four other headers name their
   own position in one clause and point at that header for the reading. Said
   once, not five times; default is where it belongs, because it is the preset
   the installed AGENTS block routes to and the one the others are described
   against.
7. **Tiers leave the step bodies.** A step names the role and points at its
   profile; the tier is the profile's own first section. This is the slimming
   ruling applied literally, and it dissolves in passing the minor recorded in
   `project-management/review-360-decisions.md` (F1, third point: the old
   design-check step called the Mason "cheap tier" where the profile says
   "cheap or mid"). The header keeps the naming rule without the enumeration:
   roles are roster names, and a vendor or model name never appears here.
8. **The `close` step's actor is the Foreman, in all five presets.** The
   ruling names the Foreman only for the commit and the push ("Au step
   `close`, le Foreman commit/push, nommé explicitement"); this plan makes the
   whole step the thread owner's, because the rest of it — status, criteria
   and deliverables ticked against reality, the move to the archive, the dated
   changelog entry, the coordination state, the `retro` proposals put to each
   zone's owner — is the bookkeeping of the thread the Foreman owns, and the
   surviving "Role: Architect or Mason" wording predates the Foreman role
   entirely. Anything that must be typed at close — a finding to apply, an
   evergreen page to write — goes through the Mason contract, in one clause.
   **Flagged: this extends the ruling's letter by its logic.**
9. **The `verify` step names the Foreman as its actor**, in all five presets.
   It is mechanical — running the gate commands declared in
   `.agents/project.md` §F is neither typing code nor reviewing, the two
   things the Foreman profile forbids it — and the amended parent criterion
   demands that a step no spawned role executes names its actor. The
   red-twice-stop clause stays in the step: it governs the Foreman here, and
   is therefore not a restatement of the executing role's profile.
10. **The middle human gate of `chisel-default` moves from the plan review
    onto `type`.** A gate reads "stop and ask the human before starting this
    step", so where it sits follows from who produces what. With the program
    design authored by the Mason at `plan` and validated by the Architect at
    `plan-review`, the human's "go" belongs after both — the reference
    sequence puts it exactly there, the Mason asking for the go once the
    Architect has validated. Default's gates therefore become `plan` (spec
    approved), `type` (plan approved) and `close` (review arbitration). This
    is the only gate that moves anywhere, and it changes what the installer's
    parse check expects for that preset. Accepted by the thread owner,
    2026-08-27, as planned.
11. **A `plan-review` that does not converge is a finding against the spec.**
    The old rule sent a stuck design-check "back to the owner of the plan as a
    finding AGAINST THE PLAN, never against the Mason" — written when the plan
    was the Architect's. Now the program design is the Mason's own, so what a
    second failed round proves is that the system design did not settle enough
    to be designed against: two rounds max, then it escalates as a finding
    against the spec, never against the Mason. Accepted by the thread owner,
    2026-08-27, as planned.
12. **The sizing question is asked in each preset's own voice, and
    `chisel-auto-light` does not ask it.** Default asks the human. Supervised
    records the recommendation in the spec and lets the spec gate settle it.
    Auto records the answer in the spec as an assumption, the way it already
    records the slicing answer. Light does not carry the question — a run
    already under light has answered it. Neither does the benchmark floor: it
    is an instrument someone chooses deliberately to measure the pipeline, not
    a preset a sizing check arrives at.
13. **Intermediate inconsistency between slices is accepted**, per the
    parent's Implementation Decisions, point 9. Between this slice and slice 3,
    `methodology.md` still claims three presets in its preset table and a
    nine-step pipeline, and `discipline.md` still wires rule 10 to two presets.
    This slice touches those two files for the mechanical rename of the review
    steps and for the sizing passage, and for nothing else. Inside the slice,
    the formulas name the Foreman at `interview` for one commit before the two
    profiles follow; the interim does not survive the slice.
14. **The delegation boundary rises one rung: it is the system design.** Ruled
    in the parent's Implementation Decisions, point 13, on the Owner's reading
    of the Mason profile against point 12 ("si je dis que le maçon fait son
    propre programming design et son plan d'implémentation… on est d'accord
    que ça change ça ?"). The boundary does not disappear: what the Mason never
    decides is the architecture, the scope and the seams the work is tested
    through — settled upstream, approved at the human gate. The program design
    is explicitly its own, the "how" of what was already decided. Same fault
    line as point 12's ageing rationale: the "what" settles early and ages
    well, the "how" is written late because it ages badly. Two consequences
    this plan draws from it, both flagged as consequences rather than rulings:
    a design that reality contradicts is **revised in writing** by the Mason
    who owns it — re-persisted, and re-validated where the preset runs a
    `plan-review` — while a *system design* that reality contradicts stops and
    goes up; and an open question is sorted by which side of the boundary it
    falls on — an open "how" is the Mason's to close at `plan`, an open "what"
    goes back to the spec.

### Writing order — and how the suite stays green

The order is driven by one constraint: the integrity group of the suite fails
on any `.agents/...` path named in an installed file that does not exist in
the installed tree. The rewritten presets name their siblings in their
headers, so the two new files must exist first.

**Commit 1 — the two new presets, atomic.** Create
`socle/agents/formulas/chisel-light.formula.toml` and
`socle/agents/formulas/chisel-auto-light.formula.toml`; add their two lines to
`test/fixtures/golden-tree.txt`; extend the formula parse check in
`test/installer.sh` to five presets. Splitting any of these across commits
leaves either a tree mismatch (the init and boilerplate groups compare the
installed tree to the golden fixture) or a parse check that does not know the
new files. Run `bash test/run.sh`: green.

**Commit 2 — the three existing formulas rewritten.** Headers and step bodies
of `chisel-default`, `chisel-supervised` and `chisel-auto`; renames, moved
separator, interview actor and spec commit included. The golden tree does not
move. One parse expectation does: default's middle gate lands on `type` (plan
decision 10) and the gate ids of the whole table are the new names, so the
parse block written in commit 1 must already carry the post-rewrite
expectations — it does, and that is why commit 1 comes first even though it
does not touch these three files. Run `bash test/run.sh`: green.

**Commit 3 — the profiles and the doctrine file.**
`socle/agents/profiles/foreman.md` (the interview duty, the two reporting
rules), `architect.md` and `mason.md` (the authorship change, the boundary
raised to the system design across the whole Mason profile, the rename, the go
summary); `socle/agents/methodology.md` (the boundary sentences, the mechanical
rename and the sizing passage). The boundary and the authorship are one edit,
not two: a profile that moves the plan to the Mason while still forbidding it
to plan contradicts itself in the reader's hands, so they land together or not
at all. The render group re-derives the expected agent definitions
from the profiles themselves, so editing a profile cannot break it. Run `bash
test/run.sh`: green, then run every named criterion above.

### The shared step-body shape

Every step body of every formula is built from the same three parts, in this
order, and carries nothing else:

1. **The actor line.** `Role: <Name> — contract `.agents/profiles/<name>.md`.`
   for a step a spawned role executes; `Actor: the Foreman.` for `interview`,
   `verify` and `close`; `Actor: the human (the Owner).` for the light
   formula's `diff-review`.
2. **The step-specific instruction** — the order inside the step, the skills
   it follows, the artifacts it reads and the artifacts it writes, and the
   glue sections those artifacts resolve through.
3. **The preset-specific clause**, when the preset changes what the step does
   — and only then.

What a body never contains, per the slimming ruling: the role's prohibitions,
its inputs, its escalation rules, its tier, or a paraphrase of its mission.
Those live in the profile the actor line points at, and the Foreman pastes
that profile at spawn time.

### The spine, and where each preset departs

One pipeline, five cuts of it. The step ids, their actors and their gates:

| Step | Actor | default | light | supervised | auto | auto-light |
|---|---|---|---|---|---|---|
| `interview` | the Foreman | ✓ | ✓ | ✓ | ✓ | ✓ |
| `spec` | Architect | ✓ | ✓ | ✓ | ✓ | ✓ |
| `spec-review` | Checker | ✓ | — | ✓ | ✓ | — |
| `plan` | Mason | **gate** | **gate** | **gate** | ✓ | ✓ |
| `plan-review` | Architect | ✓ | — | ✓ | ✓ | — |
| `type` | Mason | **gate** | ✓ | ✓ | ✓ | ✓ |
| `verify` | the Foreman | ✓ | ✓ | ✓ | ✓ | ✓ |
| `diff-review` | Inspector | ✓ | the human, **gate** | ✓ | ✓ | — |
| `close` | the Foreman | **gate** | ✓ | ✓ | ✓ | ✓ |

Gate counts, which the installer's parse check asserts: three for default
(`plan`, `type`, `close`), two for light (`plan`, `diff-review`), one for
supervised (`plan`), none for auto and none for auto-light. Step counts: nine,
seven, nine, nine and six.

**The CREATE / WORK separator falls after `spec-review`** — before `plan`, in
every preset. Reviewing the spec is upstream of production; the fresh session
starts where the work does. In light and auto-light, which run no
`spec-review`, it falls after `spec`, at the same place in the sequence.

**What each step does**, once, for every preset that runs it — the
preset-specific clauses are listed under each formula below:

- `interview` — **the Foreman runs it itself**: a spawned role cannot
  interview the human, so the thread owner asks and the Architect is spawned
  for the spec that follows; where the tool cannot spawn at all, the thread
  carries on in the conversation. Follows `grilling` with `domain-modeling`
  underneath; out of it: context, scope, acceptance criteria and the seams the
  work will be tested through, preferring existing seams, the fewer the
  better; domain terms to the glossary and hard-to-reverse decisions to an
  ADR, both declared in `.agents/project.md` §G; a design question that cannot
  be settled on paper detours through `prototype`.
- `spec` — writes `{{spec}}` from the task file template declared in §A, named
  with the task id script declared there; reading gradient respected — 🧑
  zones short and decision-rich, detail in the 🤖 zone; the sizing check OUT
  LOUD, in its two questions; a cut goes through `slice-task`, one file per
  slice with its blocking edges; then the dated changelog entry (§A) and the
  coordination state (§B). **The step ends with the spec committed** — the
  Foreman commits it, as at `close` — because a task can then sit at "spec
  done" for a long time, and what is not saved does not survive that wait.
- `spec-review` — fresh session, never the author of `{{spec}}`; verdict GO,
  or blocking findings written into the Notes of `{{spec}}`.
- `plan` — **the program design, written by the session that will implement
  it**: the target file tree, the seam signatures, the state and migration
  notes, the TDD order, the decisions the spec left to the implementation, and
  the evergreen doc pages (§D) to write at close. PERSISTED into the Design
  section of `{{spec}}` before any code — a plan that lives only in the
  conversation does not exist. It is written when the work starts, not when
  the spec is written: a task can sit at "spec done" for a long time, and
  pseudo-code ages badly while the system design ages well, the architecture
  moving far less than the code. The step reads the ambient layer (§C) and
  `{{spec}}` in full plus what it links to, and updates its status.
- `plan-review` — the Architect reads the slice and the program design only,
  and answers VALIDATED or corrections; two rounds max, then the finding goes
  against the spec, never against the Mason (plan decision 11). Typing needs
  VALIDATED.
- `type` — executes the program design persisted at `plan`, ticking the
  implementation checkboxes in `{{spec}}`; the full suite belongs to the next
  step.
- `verify` — mechanical, not a decision: the gate commands declared in §F —
  lint, tests, build, plus a browser check when UI behaviour changed; evidence
  first, red output reported as red; red twice on the same cause → stop.
- `diff-review` — follows `code-review`; the diff and its pinned fixed point
  are handed over with the path to `{{spec}}`, whose 🧑 zones are the
  requirements of the Spec axis; the two axes are reported side by side.
- `close` — applies the arbitrated findings, anything to be typed going
  through the Mason contract; sets the status of `{{spec}}`, ticks criteria
  and deliverables against reality, moves it to the archive (§A); dated
  changelog entry (§A) and closing coordination state (§B); the roadmap (§A)
  only when it exists AND a roadmap-level change was made; promotes the
  evergreen material into the living docs (§D), starting from the architecture
  index; runs `retro` and puts its proposals to each touched zone's owner;
  **then the Foreman commits and pushes.**

Where the program design lands is the task template's Design section, as
today. The `-work` file that will eventually hold it belongs to the spec/work
split of chantier 2 and is not planned here.

### `socle/agents/formulas/chisel-default.formula.toml` — the rewrite

**Header.** Keep the opening promise (readable without any ledger tooling;
`needs` gives the order; each `[steps.gate] type = "human"` reads "stop and
ask the human before starting this step") and the ownership paragraph (this
file owns the order and the gates; the content and the progress belong to the
spec file; the know-how of a step to the skill it names; every write goes
through the glue `.agents/project.md`). Changes:

- Add the orchestration paragraph (plan decision 4) — including the three
  steps the Foreman holds itself — and the handoff sentence (the human
  relaunches every step).
- Add the **two-axis paragraph in full** (plan decision 6): the human gates
  are one axis and the validation sub-agents the other; default holds both;
  `chisel-light` drops the sub-agents; `chisel-auto` drops the gates;
  `chisel-supervised` sits midway on the gates axis; `chisel-auto-light` drops
  both and is an instrument, not a notch. This paragraph replaces today's
  single closing line about `chisel-auto`.
- The ownership paragraph gains one clause: the contract of each role belongs
  to its profile in `.agents/profiles/`. The tier enumeration goes; the
  no-vendor-name rule stays.

**Steps.** The nine of the spine, gates on `plan`, `type` and `close`.
Preset-specific clauses: none beyond the gates — default is the preset the
others are described against.

**Gate comments.**

- On `plan`, gate "spec approved": the Owner validates scope, acceptance
  criteria, seams and the system design before anything is designed against
  the code — after the `spec-review` loop, so the human approves a spec two
  roles already agree on.
- On `type`, gate "plan approved": the Mason presents the condensed view of
  its program design declared in `.agents/profiles/mason.md` and asks for the
  go, once the Architect has answered VALIDATED at `plan-review`. Nothing
  half-decided crosses this line. (The old wording "plan approved + typist
  chosen" loses its second half: typing goes through the Mason contract in
  every preset now, and there is no choice left to gate.)
- On `close`, gate "review arbitration": the Owner arbitrates the findings of
  the two axes before anything is closed or archived.

**The sizing question.** In the `spec` step, after the one-pass question: and
does this run light or full? Light drops the validation sub-agents and leaves
the spec approval and the diff review to the human
(`.agents/formulas/chisel-light.formula.toml`); full keeps the Checker, the
`plan-review` and the Inspector. The human chooses; the agent recommends and
never decides it silently.

### `socle/agents/formulas/chisel-supervised.formula.toml` — the rewrite

**Header.** Same skeleton, with its own first line (one human gate: the Owner
approves the spec, and nothing else — the big picture is the Owner's, the
program design is not) and its one-clause position on the two axes: midway on
the gates axis, all the validation sub-agents kept; the full reading is in
default's header. Keep the degraded-run paragraph, whose value is unchanged:
at the gate the run stops, the status of the spec file becomes `awaiting
approval`, the session ends, nothing polls and nothing notifies, and a fresh
session resumes at the next step. Rewrite the paragraph that today says the
step bodies are `chisel-auto`'s byte for byte and that a doubting step
escalates one rung up the ladder: what replaces it is the handoff sentence
(the Foreman spawns the next step, fresh) and the escalation doctrine without
the ladder — a step that cannot decide blocks the task and reports to the
Foreman, which decides within what it owns and hands anything above that to
the human, full stop. **The word "digest" and both ladder arrows die here.**

**Steps.** The nine of the spine, single gate on `plan`. Every "No human …"
paragraph goes: the `plan` self-check and the `diff-review` arbitration
restate the profiles' own escalation rules (the Architect's "a plan that
contradicts a 🧑 zone stops and escalates, in any mode"; the Inspector's
"where there is no human to arbitrate, it applies the findings it has
confirmed itself"). The sizing question is asked in the supervised voice of
plan decision 12: the recommendation is written into `{{spec}}` and the spec
gate settles it.

### `socle/agents/formulas/chisel-auto.formula.toml` — the rewrite

**Header.** Same skeleton. First line: the same pipeline with no human gate;
the Brief stays human and sits upstream, as in every mode. Its one-clause
position on the axes: the gates axis emptied, every validation sub-agent kept.
The paragraph that today reads "where the default waits, Auto ESCALATES …
(Mason → Architect → Inspector → the Owner's digest)" is replaced by the same
ladder-free doctrine as supervised's and by the handoff sentence. Keep the
opt-in paragraph: auto runs only when the human explicitly asks for it AND
`.agents/project.md` permits it (§B3 · Autonomous runs).

**Steps.** The nine of the spine, no gate. Two preset-specific clauses survive
because they are step-specific and not profile restatements: at `interview`,
there is no human to interview, so what would have been a question is written
into the Notes of `{{spec}}` as an assumption; at `spec`, the sizing answer —
one pass or sliced, light or full — is written into `{{spec}}` the same way.
Every other "No human …" paragraph goes, and the `close` one carries the dying
word.

### `socle/agents/formulas/chisel-light.formula.toml` — new file, full outline

**Header.** Same skeleton, with:

- First line: the same pipeline as `chisel-default` **without the validation
  sub-agents** — no Checker on the spec, no `plan-review`, no Inspector on the
  diff. Human reading is the net, and the Owner placed the two gates himself:
  "Chisel-light devrait avoir une gate au design, mais pas au plan du maçon.
  Et une autre au moment de la review en place de l'inspector."
- Its one-clause position on the axes — sub-agents axis emptied, gates kept
  where the human reads — pointing at default's header for the full reading.
- The orchestration paragraph and the handoff sentence: the human relaunches
  every step, as in default.
- One line on what light is chosen by: the human, at the sizing check — not a
  per-case elision decided by an agent.
- One line on what light is NOT: an autonomous run. The "Autonomous runs"
  switch of `.agents/project.md` §B3 does not govern it, and the glue template
  needs no change for it.
- The ownership paragraph, identical to the others.

**Steps** — seven: `interview`, `spec`, `plan`, `type`, `verify`,
`diff-review`, `close`. `spec-review` and `plan-review` do not exist in this
file. Preset-specific clauses:

- `spec` — the sizing question's second half is dropped (being here answers
  it); **Then STOP** stays, and so does the commit that saves the spec.
- `type` — this preset runs no `plan-review`: the design typed from is the one
  persisted at `plan`, and no VALIDATED verdict is coming.
- `diff-review` — `Actor: the human (the Owner).` This preset runs no
  Inspector: the diff is handed over with its fixed point pinned — the review
  compares `<fixed point>...HEAD`, three-dot, against the merge base —
  together with the path to `{{spec}}`, whose 🧑 zones are the requirements;
  the `code-review` skill is available to whoever wants its shape, and nothing
  here spawns it.

**Gate comments.** On `plan`, gate "spec approved": the Owner validates scope,
acceptance criteria, seams and the system design before anything is designed
against the code; in this preset no Checker read it first, so this reading IS
the spec review. On `diff-review`, gate "the human reviews the diff": the run
stops and the Owner reviews in the Inspector's place. No gate sits between
`plan` and `type`, and none at `close`.

**Frontmatter fields**, in the shape the siblings use: `formula =
"chisel-light"`; a one-sentence `description` — the Chisel task pipeline,
light: the validation sub-agents removed, two human gates (the spec, and the
diff review the human holds in place of the Inspector); `version = 1`; `type =
"workflow"`; the two `[vars]`, `task` and `spec`, copied from the siblings.

### `socle/agents/formulas/chisel-auto-light.formula.toml` — new file, full outline

**Header.** Same skeleton, and it says what it is without dressing:

- First line: both axes emptied — no human gate and no validation sub-agent.
  This is the **floor of the pipeline**, an instrument built to be measured
  against the other four, per the Owner's "je serais curieux de l'avoir quand
  même pour faire du benchmark". Not a lighter way to work: the preset with
  neither net. Whoever runs it accepts that nothing between the Brief and the
  commit is read by anyone.
- The sentence that explains the missing review rather than leaving a hole:
  there is no `diff-review` step at all, because a self-review would put a net
  back and the benchmark would stop measuring the floor; the mechanical
  `verify` is the only signal this preset produces.
- Its position on the axes in one clause, pointing at default's header.
- The orchestration paragraph and the handoff sentence (the Foreman spawns the
  next step, fresh).
- The same opt-in paragraph as auto: it runs only when the human explicitly
  asks for it AND `.agents/project.md` permits it (§B3 · Autonomous runs).
- The ownership paragraph, identical to the others.

**Steps** — six: `interview`, `spec`, `plan`, `type`, `verify`, `close`. No
`spec-review`, no `plan-review`, no `diff-review`, no gate. Preset-specific
clauses: the two assumption-writing clauses of auto at `interview` and `spec`,
minus the sizing question's second half (plan decision 12); at `type`, the
same clause as light — no `plan-review` runs, the design typed from is the one
persisted at `plan`.

**Frontmatter fields:** `formula = "chisel-auto-light"`; a one-sentence
`description` naming it for what it is — the pipeline with neither human gate
nor validation sub-agent, the measurable floor, requiring the glue to enable
autonomous runs; `version = 1`; `type = "workflow"`; the two `[vars]`.

### `socle/agents/profiles/foreman.md` — the interview duty and the reporting rules

- **Mission, "What it does" list** — one bullet added: the Foreman **leads the
  interview itself**, following `grilling`, because a spawned role cannot
  interview the human; it then spawns an Architect to write the spec from what
  the interview produced. Placed before the spawning bullet, which it feeds.
- **Reporting to the Owner** — the two rules the Owner added on 2026-08-27
  once the first shapes were in use (parent Implementation Decisions,
  point 10, routed to this slice, "which reopens the socle anyway"):
  - **A report never repeats what is already settled.** It covers what changed
    since the last one. Self-containment governs the open items — every open
    question restated in place — and is never licence to recap what the Owner
    has already read and ruled on ("pas la peine de te répéter non plus, je
    vois pas bien l'intérêt").
  - **The Foreman never re-asks for an authorization already given.** A GO
    stands until the Owner withdraws it.
  - And the companion clause: a section of the step-delivery shape with
    nothing in it is dropped, not filled.

  Placed after the self-containment paragraph, before the closing paragraph on
  unnarrated verification.
- Nothing else in the profile moves; the frontmatter `description` gains the
  interview in its opening clause and loses nothing.

### `socle/agents/profiles/architect.md` — the interview, the authorship, the rename

- **Mission, opening list** — "It runs the `interview`, `spec` and `plan`
  steps" becomes the `spec` step alone: the Architect writes the spec from the
  interview the thread owner ran. The "Interview" bullet goes with it; the
  know-how it summarised lives in `grilling`, and the duty now sits with the
  Foreman.
- **Mission, "Plan" bullet** — deleted as an authorship claim and replaced by
  what the Architect owns at that moment: the system design is settled in the
  spec, and the program design that follows belongs to the session that
  implements it. Keep the durable reason in the Owner's terms — a task can sit
  at "spec done" for a long time, pseudo-code written early ages badly once
  other tasks have changed the code, and the system design ages well because
  the architecture moves less.
- **Reviewer duties** — `design-check` becomes `plan-review`; the Architect
  reads the slice and the Mason's program design only and answers VALIDATED or
  corrections; two rounds max, then a finding against the spec (plan
  decision 11), never against the Mason.
- **Frontmatter `description`** — "interviews to shape scope and seams …
  persists the plan into the spec before any code" becomes: writes the spec —
  scope, acceptance criteria, seams, slices and their files map — from the
  interview the thread owner ran, and validates the program design at
  `plan-review`.
- **Prohibitions, first bullet** — "Never types the code of a slice it
  planned" becomes: never types the code of a slice it specified. The
  rationale follows: the think/type split holds because the **spec** has to
  survive being read by someone who was not in the room.
- **Prohibitions, second bullet** — "Never reviews its own plan or its own
  diff" becomes: never reviews its own spec, and never reviews a diff — the
  diff is the Inspector's, and the Inspector is never the author. At
  `plan-review` the Architect reads someone else's design, which is the point.
- **Prohibitions, last bullet** — "Never leaves the plan implicit. 'The Mason
  will figure it out' is not a plan" is kept and re-pointed at the spec: what
  may never be left implicit is the *what* — scope, architecture, seams. The
  how is exactly what the Mason figures out, and saying so is not a hole.
- **Escalation, last bullet** — "A Mason that could not implement from the
  artifacts is a finding against the plan … you take the plan back" becomes a
  finding against the **spec**, taken back through the spawner as before.
- Nothing else in the file moves.

### `socle/agents/profiles/mason.md` — the authorship, the boundary, the rename, the go summary

The whole profile was audited against the new boundary, not only the two
sentences the finding named: the file leans on "someone else planned this" in
nine places, and a half-corrected profile would contradict itself in the
reader's hands. Section by section:

- **Frontmatter `description`** — "Executes one already-planned slice … from
  the persisted plan … Never plans, never reviews its own diff" becomes: works
  one slice whose system design is settled — authors its own program design at
  `plan`, types it at `type`, test-driven at the agreed seams, never from the
  planning conversation; never decides the architecture, the scope or the
  seams, and never reviews its own diff.
- **Mission, opening** — "It runs the `type` step … one slice, one fresh
  session, from the plan persisted in the spec file" becomes the `plan` and
  `type` steps: the Mason designs the how for itself at `plan`, persists it in
  the spec file, and types it at `type`. Keep "one slice, one fresh session".
- **Mission, first bullet** — "Executes the persisted plan step by step"
  becomes: executes the program design it persisted, step by step. The
  vertical-slice clause is unchanged.
- **Mission, resume-point bullet** — unchanged in substance; the checkboxes
  are still the resume point, and a fresh Mason still restarts at the first
  unticked box, now reading a design a Mason wrote.
- **Tier** — "The expensive thinking already happened: the plan is written,
  the seams are agreed" becomes: the expensive thinking already happened — the
  system design is settled and approved, the seams are agreed, the tests say
  what "done" means; what is left is the how. The closing line follows the
  boundary too: a slice that seems to need a frontier Mason means the **system
  design** is not settled, and that is a finding against the spec.
- **Speed contract, first bullet** — `design-check` becomes `plan-review`, and
  the sentence gains the case the presets now create: typing starts from a
  program design that `plan-review` has answered VALIDATED, or, in a preset
  that runs no `plan-review`, from the design persisted at `plan`. Without
  that clause the bullet is false for two of the five presets.
- **Speed contract, remaining bullets** — unchanged: zero open questions
  *while typing*, commit at every green step, keep the artifacts in the shape
  the template declares, no systematic mutation testing.
- **Prohibitions, first bullet** — "Never plans and never designs. The
  delegation boundary is the plan" is replaced, not deleted: **never decides
  the system design.** The boundary is the system design — architecture,
  scope, and the seams the work is tested through — settled upstream and
  approved at the human gate. The program design is the Mason's own: the how
  of what was already decided. A decision that changes the *what* is not the
  Mason's to make.
- **Prohibitions, "Never improvises past the persisted plan"** — reworded on
  the same fault line (plan decision 14): reality contradicting the program
  design is ordinary and the Mason owns the fix — it revises the design **in
  writing**, in the spec file, re-validated where the preset runs a
  `plan-review`, never carried in the session's head alone. Reality
  contradicting the system design is the other case: it stops and goes to the
  spawner.
- **Prohibitions, "Never accepts an open question"** — sorted by side: an open
  *how* is the Mason's to close at `plan`, which is what the step is for; an
  open *what* — a scope, an architecture choice, a missing seam — means the
  spec left something unfinished, and it goes back.
- **Prohibitions, last two bullets** — unchanged: never edits a 🧑 zone or
  re-scopes the slice; never reviews its own diff.
- **Escalation, first bullet** — "pushed outside the persisted plan" becomes
  pushed outside the system design the spec settled. The other bullets stand.
- **Proposal door** — the three evaluations and the two rules keep their
  substance; the closing sentence "Until a new plan says otherwise, the
  persisted plan governs every line you type" becomes: until the spec changes,
  the settled system design governs, and the program design typed from is the
  Mason's own — updated in writing when it moves, never in silence.
- **Inputs, item 1** — the spec file is still the brief, described from the
  new boundary: its 🧑 zones carry the settled system design and the
  definition of done; its Design section is where the Mason's own program
  design is persisted — empty when the Mason arrives at `plan`, its own work
  from then on.
- **Inputs, closing paragraph** — "If the work cannot be done from the
  artifacts alone, the plan is incomplete — that is a finding against the
  plan" becomes: a finding against the **spec**, since what the artifacts owe
  the Mason is a settled system design. The artifacts-only rule itself is
  unchanged and is still what makes a Mason resumable and parallelisable.
- **New section — the go summary.** The shape of the condensed view the Mason
  presents at the human gate on its plan, so the Owner can say go without
  opening the file: what the slice will do, in substance; the files it expects
  to touch, from the map the design declares; the seams and the TDD order in a
  line each; the decisions the program design locked that the spec had left
  open; and anything still unresolved — where there should be nothing, since
  an open question is a report, not a pause. The summary points at the
  persisted design; it never replaces it, and it is never written instead of
  it. No length is prescribed: the shape is the contract.

### `socle/agents/methodology.md` — the boundary, the rename and the sizing passage

Three edits and one addition; every other section of the file is slice 3's,
and the boundary edit in particular sits inside a corollary slice 3 rewrites —
the line between the two is drawn explicitly below so slice 2 does not swallow
that file.

- **The boundary**, in the section "The two designs — and why they do not
  happen at the same moment": the sentence "The delegation boundary is the
  plan itself: everything above it is thinking, everything below is typing"
  becomes the boundary at the system design — above it the what, settled at
  creation time and approved at the gate; below it the how, designed and typed
  by the session that implements. Two neighbouring sentences state the same
  false line and go with it: "A Mason asked to 'figure out' something the
  Design left open is a planning failure … the plan goes back to the
  Architect" — true only of the *what* now, and it goes back to the spec; and,
  in the economics paragraph below, "Everything below the plan is typing, and
  typing does not need the same tier" — reworded onto the system design, with
  the tier claim itself untouched.
- **What stays slice 3's in that same corollary**, deliberately not touched
  here: the opt-in framing ("an optional **Mason**", "The agent OFFERS this
  choice", "the user decides") which the parent criterion
  **mason-not-optional** closes; the tier-gradient paragraph and the
  economics redundancy, which the normative-extraction chantier cuts; and the
  section's other passages on persistence and on the artifacts-only brief,
  which are true as they stand.
- **The rename**, in the three places that carry the old name: the Architect
  row of "The roster" ("answers the `design-check`" → "answers the
  `plan-review`"), and the two occurrences in the sections on the nine steps
  and on the two designs. Where the sentence describing the old step also says
  who writes the program design, it follows the authorship: the Mason posts
  its program design and the Architect validates it.
- **The sizing passage**, in the section "Why slicing is conditional (the
  sizing check)": the paragraph beginning "What IS unconditional" gains the
  second question — the check asks two things out loud, does this fit one
  pass, and does it run light or full? Light drops the validation sub-agents
  and leaves the spec approval and the diff review to the human
  (`.agents/formulas/chisel-light.formula.toml`); the human answers both, and
  a silent answer to either is a review hole. The three rationale bullets, the
  dex distribution and the vertical-slice distinction stay as they are.

### `test/fixtures/golden-tree.txt` — parity

Two lines added, in C-locale sort order (the order the suite's tree helper
produces, verified): `.agents/formulas/chisel-auto-light.formula.toml` sorts
**before** `.agents/formulas/chisel-auto.formula.toml` — the hyphen precedes
the dot — and `.agents/formulas/chisel-light.formula.toml` sits between the
default and supervised entries. Net: +2 lines. No CLI change is needed or
allowed: the installer builds its manifest by walking `agents/formulas` for
files, so new presets install and are managed with no code touched (verified
against `bin/chisel.sh`, its socle-source constants and its manifest walk).

### `test/installer.sh` — the formula parse check only

In `group_render`, the block that parses the presets with `tomllib`:

- Replace the three per-formula shell variables with a glob over
  `"$t7"/.agents/formulas/*.formula.toml` in the `python3` invocation, so the
  check covers whatever presets are installed instead of a hand-listed three.
- Turn the shared step-count assertion into a per-formula expectation, keyed
  by formula name alongside the gate list already there: `chisel-default` nine
  steps and gates `["plan", "type", "close"]`; `chisel-light` seven and
  `["plan", "diff-review"]`; `chisel-supervised` nine and `["plan"]`;
  `chisel-auto` nine and none; `chisel-auto-light` six and none.
- Update the group title, the group description and the pass/fail message so
  they name five presets and their gate counts instead of three.

The edit is close to a wash on line count (three variables removed, the
expectations table gained), which matters: the suite is near the line cap
`test/run.sh` enforces on itself, and that cap is checked as an assertion like
any other. Assertion count is unchanged — the block is one assertion whatever
it parses.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Verified at plan time, 2026-08-27 — settled, do not re-check

- **Rename carriers**, by grep over `socle/` and `test/`: the three formulas
  (step ids and `needs` edges), `socle/agents/methodology.md` (three places),
  `socle/agents/profiles/architect.md`, `socle/agents/profiles/mason.md`, and
  the gates table of `test/installer.sh`.
- **`socle/agents/discipline.md` and `socle/agents/profiles/checker.md` carry
  no review step name that changes** — the discipline names none at all, and
  the Checker names only `spec-review`, which keeps its name. Neither file is
  touched by this slice. Confirmed by the thread owner, 2026-08-27; nobody
  needs to check this again.
- **The formulas are the last carriers of the ladder and the digest outside
  the two doctrine documents.** `grep -rin "digest"` over `socle/` matches
  `methodology.md`, `discipline.md` and the auto and supervised formulas only;
  the two ladder arrows match the same four files. Slice 1 cleared the
  profiles; this slice clears the formulas; slice 3 closes over the rest.
- **`chisel-default.formula.toml` carries neither word today** — its rewrite
  is orchestration, renames, the moved gate, the interview actor, the spec
  commit, slimming and the two-axis paragraph, with nothing of that pair to
  remove.
- **The installer test suite touches the formulas in four places:** the golden
  tree listing, the AGENTS.md routing assertion (default only — the AGENTS
  block is slice 3's), the update-drift scenario (default only; it compares
  the installed file against the socle source, so the rewrite is
  self-adjusting) and the parse check. Only the golden tree and the parse
  check are affected by two new files.
- **Nothing outside `socle/agents/formulas/` names a step body's content**, so
  slimming breaks no pointer.

### One wording leftover in the parent spec

The parent's Scope bullet on the Architect, rewritten when point 12 landed,
still lists "interview" among what the Architect keeps, while the interview
has since moved to the Foreman. This plan follows the ruling, not that clause;
the clause is the thread owner's to trim, and no criterion depends on it. Two
smaller leftovers of the same kind, also harmless and also not this slice's to
edit: the files map in the Architecture section still counts four formula
files with one created, and the Testing Strategy still says "the four
formulas".

### Deviation from the parent's files map — `upgrade-v2`

The parent's map puts `socle/agents/skills/**` in files-to-avoid, on the
stated grounds that no skill carries the ladder, the digest or the allotment —
true, and unaffected by this slice. But
`socle/agents/skills/upgrade-v2/SKILL.md` calls `.agents/formulas/` "(the
three presets)", a count this slice makes false twice over. The fix is one
word — "the presets" — and it is the same de-counting the minors ruling
already schedules for that file's neighbouring sentence ("three role profiles"
→ "the role profiles").

Per the doctrine this task ships, the touch is not forbidden: it is made,
noted here and in the worklog, and judged at review. No test asserts the
count, so the suite is green either way, and the Inspector can rule it out
with no rework beyond reverting one word.

### Program design

Written at the `design-check` step, 2026-08-28, from the files as they stand on
`review-360`. Nothing below reopens a decision: it turns the persisted plan
into an ordered edit list, records the constraints the real files impose, and
reports where the plan is not executable as written.

#### Findings against the plan

**Finding 1 — commit 1 cannot carry the post-rewrite gate expectations and
stay green, and the plan says it can.** The section "Writing order — and how
the suite stays green" states that the parse block written in commit 1 "must
already carry the post-rewrite expectations — it does", and that
`bash test/run.sh` is green after commit 1. Those two cannot both hold: after
commit 1 the three existing formulas are untouched, so `chisel-default` still
gates on `design-check`, while the post-rewrite expectation for that preset is
`["plan", "type", "close"]`. The parse block compares the gate list for
equality, so the assertion fails.

Verified by parsing the real file rather than by reasoning about it: the gate
ids of `socle/agents/formulas/chisel-default.formula.toml` today are `plan`,
`design-check`, `close`; against the post-rewrite expectation the assertion
reports FAIL.

Minimal resolution, and it costs one line: commit 1 writes the default's gate
list **as it is today** and commit 2 changes that one list to
`["plan", "type", "close"]` — in the same commit that moves the gate. Every
other part of the parse rewrite (the glob over the installed formulas, the
per-formula step counts, the two new entries) still belongs to commit 1,
because those are the parts the two new files need. **The commit order itself
is unaffected**: the reason commit 1 must come first is the integrity group,
which fails the moment a rewritten header names
`.agents/formulas/chisel-light.formula.toml` before that file exists — and
that group runs everywhere, which the parse check does not (Finding 2).

**Finding 2 — the acceptance evidence is thinner than it reads: the formula
parse check does not run on this machine.** `python3` here resolves to a pyenv
3.9.10, which has no `tomllib`, so the render group prints
`SKIP: TOML parse check` and the suite's 93 assertions contain none of the
gate or step-count expectations. The suite is green today with the parse block
never executed. Verified, and a runnable path exists: with the Homebrew
`python3.13` first on `PATH`, the same group runs the check and it passes
against the files as they are (render group alone: 24 assertions, the parse
one included; the whole suite would report 94 rather than 93). This is why the
verification order below runs the suite twice, and why "the suite is green"
alone would not prove `light-formula-exists`, `benchmark-floor-exists` or the
gate counts of the spine table.

**Finding 3 — the literal phrase "two axes" inside a step body defeats
`two-axes-said-once`.** The criterion greps for files containing that phrase
and demands exactly one. Today three formulas contain it, twice each, in the
`review` step body: "Follow the `code-review` skill: two axes in parallel…"
and "Report the two axes side by side". The plan's own step description keeps
that wording — "the two axes are reported side by side", in "What each step
does" — so copying it literally into the four `diff-review` bodies would break
the criterion the same plan writes. Constraint adopted, no ruling needed: only
`chisel-default` carries the literal phrase (in its header paragraph and its
`close` gate comment, both in one file); the `diff-review` bodies name the
axes instead — the Standards axis and the Spec axis, reported side by side,
never merged.

**Finding 4 — plan decision 5's "neither the phrase nor the word STOP appears
anywhere in those three files" cannot hold as written.** The same plan keeps
two passages that contain the word: supervised's degraded-run paragraph, whose
"value is unchanged" and which says the run stops at the gate, and the
`verify` clause "red twice on the same cause → stop", which plan decision 9
keeps in all five presets. Read as what the criterion actually greps: the
phrase "Then STOP" appears in none of `chisel-supervised`, `chisel-auto` and
`chisel-auto-light`. The degraded-run paragraph keeps its meaning with a
lowercase "stops", and the `verify` clause is untouched.

**Finding 5 — I am rewriting a roster cell of `socle/agents/methodology.md`
that this slice makes false in two other ways, and the plan tells me not to
touch them.** The Architect row of "The roster" reads "Interviews, writes the
spec, plans, answers the `design-check`". The rename turns its last clause
into "answers the `plan-review`", but after this slice the Architect neither
interviews (plan decision 1) nor plans (plan decision 14); and the Mason row
of the same table still reads "Types the persisted plan — never plans". Plan
decision 13 accepts intermediate inconsistency and confines this slice to the
rename, the boundary and the sizing passage in that file, so **I leave both
readings as they are** and slice 3 fixes them with the rest of the roster.
Reported because the falsehood sits inside the very cell I edit, the fix is
two words, and no criterion depends on either reading.

#### Constraints the real files impose (recorded, not decided)

- **A frontmatter `description` is one physical line.** The renderer reads the
  key off a single line, so the rewritten `description` of `mason.md` and
  `architect.md` must not wrap — same constraint slice 1 recorded for the
  Foreman profile.
- **No three consecutive apostrophes** anywhere in a profile body: the codex
  render wraps the body in a TOML multi-line literal string.
- **No invented numeric limit** in anything installed: the render group greps
  the installed tree for the known offenders. The go-summary section of
  `mason.md` therefore prescribes a shape and no length, as the plan says.
- **Every `.agents/…` path in an installed file must resolve** in the
  installed tree (integrity group). The new headers name sibling formulas, the
  profiles, `.agents/project.md` and `.agents/discipline.md`; all resolve once
  the two new files exist, which is Finding 1's ordering constraint.
- **The suite enforces its own line cap on itself.** `test/lib.sh`,
  `test/installer.sh` and `test/run.sh` total 588 lines today against a cap of
  600, so the parse-check edit has twelve lines of headroom. The planned shape
  (three shell variables removed, a five-entry expectations table gained,
  step counts folded into the same table) lands inside it; the cap is checked
  after every commit like any other assertion.
- **Pre-existing wrinkle, carried not fixed:** the auto presets tell the
  `interview` step to write its assumptions "into the Notes of `{{spec}}`",
  a file the next step creates. Today's `chisel-auto` says the same thing; the
  rewrite keeps the meaning and says the assumptions are carried into the spec
  the next step writes.

#### Commit 1 — the two new presets, atomic

Written in this order.

**1. `socle/agents/formulas/chisel-light.formula.toml`** — new file, in the
sibling skeleton (header comment, frontmatter, `[vars]`, `[[steps]]`).

*Header comment*, in this order:

- First line, naming the preset and what it removes: the same pipeline as
  `chisel-default` without the validation sub-agents — no Checker on the spec,
  no `plan-review`, no Inspector on the diff — human reading being the net,
  with the Owner's placement of the two gates quoted in French: "Chisel-light
  devrait avoir une gate au design, mais pas au plan du maçon. Et une autre au
  moment de la review en place de l'inspector."
- The readable-without-tooling paragraph, in the siblings' words: execute the
  steps as an ordered checklist, `needs` gives the order, and each
  `[steps.gate] type = "human"` reads "stop and ask the human before starting
  this step".
- The orchestration paragraph (plan decision 4): the invoking session IS the
  Foreman, contract `.agents/profiles/foreman.md`; it holds `interview`,
  `verify` and `close` itself; every other step runs as a fresh sub-agent
  spawned with the step role's profile body plus a brief composed from that
  profile's `Inputs` section.
- The handoff sentence: the human relaunches every step, as in the default.
- Its position on the axes in one clause, pointing at the full reading: the
  validation sub-agents removed, the human gates kept where the human reads —
  the reading of the axes is in the header of
  `.agents/formulas/chisel-default.formula.toml`. (The literal phrase of
  Finding 3 stays out of this file.)
- One line on what chooses light: the human, at the sizing check — not a
  per-case elision decided by an agent.
- One line on what light is not: an autonomous run; the "Autonomous runs"
  switch of `.agents/project.md` §B3 does not govern it.
- The ownership paragraph, in the siblings' words: this file owns the order
  and the gates; the content and the progress belong to the spec file; the
  know-how of a step to the skill it names; the contract of each role to its
  profile in `.agents/profiles/`; the reasoning to `.agents/methodology.md`;
  roles are roster names and a vendor or model name never appears here; every
  write goes through the glue `.agents/project.md` (§A paths, §B tracker
  convention, §D living docs, §F gate commands, §G glossary and decisions).

*Frontmatter*: `formula = "chisel-light"`; `description` on one line — the
Chisel task pipeline, light: the validation sub-agents removed, two human
gates (the spec, and the diff review the human holds in place of the
Inspector); `version = 1`; `type = "workflow"`; `[vars.task]` and `[vars.spec]`
copied from the siblings.

*Steps* — seven, with these ids, edges and gates:

| id | needs | gate |
|---|---|---|
| `interview` | — | — |
| `spec` | `interview` | — |
| `plan` | `spec` | human, "spec approved" |
| `type` | `plan` | — |
| `verify` | `type` | — |
| `diff-review` | `verify` | human, "the human reviews the diff" |
| `close` | `diff-review` | — |

The `# ── CREATE ──` separator opens the file and the
`# ── WORK (fresh session) ──` separator falls after `spec`, before `plan`.

*Bodies*, each built from the actor line, the step-specific instruction and
the preset clause where there is one:

- `interview` — `Actor: the Foreman.` It runs the interview itself: a spawned
  role cannot interview the human, so the thread owner asks and spawns an
  Architect for the spec that follows; where the tool cannot spawn at all, the
  thread carries on in the conversation. Follows `grilling` with
  `domain-modeling` underneath; out of it come context, scope, acceptance
  criteria and the seams the work will be tested through, existing seams
  preferred and the fewer the better; domain terms to the glossary and
  hard-to-reverse decisions to an ADR, both declared in `.agents/project.md`
  §G; a design question that cannot be settled on paper detours through
  `prototype`.
- `spec` — ``Role: Architect — contract `.agents/profiles/architect.md`.``
  Writes `{{spec}}` from the task file template declared in §A, named with the
  task id script declared there; reading gradient respected; the sizing check
  out loud — in this preset the one-pass question alone, being here having
  answered the other; a cut goes through `slice-task`, one file per slice with
  its blocking edges; then the dated changelog entry (§A) and the coordination
  state (§B); the Foreman commits the spec, because a task can sit at "spec
  done" for a long time and what is not saved does not survive that wait; then
  **Then STOP** — the session that creates does not implement, the build
  starts fresh from the file.
- `plan` — ``Role: Mason — contract `.agents/profiles/mason.md`.`` The program
  design, written by the session that will implement it, persisted into the
  Design section of `{{spec}}` before any code; reads the ambient layer (§C)
  and `{{spec}}` in full plus what it links to, and updates its status.
  Preset clause: this preset runs no `plan-review`, so no VALIDATED verdict is
  coming and the human gate on the next step is where the design is read.
- `type` — ``Role: Mason — contract `.agents/profiles/mason.md`.`` Executes
  the program design persisted at `plan`, ticking the implementation
  checkboxes in `{{spec}}`; the full suite belongs to the next step. Preset
  clause: the design typed from is the one persisted at `plan`.
- `verify` — `Actor: the Foreman.` Mechanical, not a decision: the gate
  commands declared in §F — lint, tests, build, plus a browser check when UI
  behaviour changed; evidence first, red output reported as red; red twice on
  the same cause → stop.
- `diff-review` — `Actor: the human (the Owner).` This preset runs no
  Inspector: the diff is handed over with its fixed point pinned — the review
  compares `<fixed point>...HEAD`, three-dot, against the merge base —
  together with the path to `{{spec}}`, whose 🧑 zones are the requirements;
  the `code-review` skill is available to whoever wants its shape, and nothing
  here spawns it.
- `close` — `Actor: the Foreman.` Applies the arbitrated findings, anything to
  be typed going through the Mason contract; sets the status of `{{spec}}`,
  ticks criteria and deliverables against reality, moves it to the archive
  (§A); dated changelog entry (§A) and closing coordination state (§B); the
  roadmap (§A) only when it exists and a roadmap-level change was made;
  promotes the evergreen material into the living docs (§D), starting from the
  architecture index; runs `retro` and puts its proposals to each touched
  zone's owner; then the Foreman commits and pushes.

*Gate comments*: on `plan`, "spec approved" — the Owner validates scope,
acceptance criteria, seams and the system design before anything is designed
against the code, and in this preset no Checker read it first, so this reading
IS the spec review. On `diff-review`, "the human reviews the diff" — the run
stops and the Owner reviews in the Inspector's place.

**2. `socle/agents/formulas/chisel-auto-light.formula.toml`** — new file, same
skeleton.

*Header comment*: first line saying both axes are emptied — no human gate and
no validation sub-agent — that this is the floor of the pipeline, an
instrument built to be measured against the other four, per the Owner's "je
serais curieux de l'avoir quand même pour faire du benchmark", not a lighter
way to work but the preset with neither net, whoever runs it accepting that
nothing between the Brief and the commit is read by anyone; then the sentence
that explains the missing review rather than leaving a hole — there is no
`diff-review` step at all, because a self-review would put a net back and the
benchmark would stop measuring the floor, and the mechanical `verify` is the
only signal this preset produces; then the readable-without-tooling paragraph
(without the gate sentence, there being no gate); its position on the axes in
one clause pointing at the default's header; the orchestration paragraph and
the handoff sentence — the Foreman spawns the next step, fresh; the opt-in
paragraph, in auto's words — it runs only when the human explicitly asks for
it AND `.agents/project.md` permits it (§B3 · Autonomous runs); and the
ownership paragraph, identical to the others.

*Frontmatter*: `formula = "chisel-auto-light"`; `description` on one line —
the pipeline with neither human gate nor validation sub-agent, the measurable
floor, requiring the glue to enable autonomous runs; `version = 1`;
`type = "workflow"`; the two `[vars]`.

*Steps* — six, no gate: `interview` (no needs), `spec` needs `interview`,
`plan` needs `spec`, `type` needs `plan`, `verify` needs `type`, `close` needs
`verify`. The WORK separator falls after `spec`.

*Bodies*: the same seven-minus-one shapes as light, with three differences —
`interview` gains auto's clause (no human to interview, so what would have
been a question is carried into the Notes of the spec the next step writes, as
an assumption; assumptions are reviewable artifacts, not silences); `spec`
gains auto's clause (the sizing answer — one pass or sliced — written into
`{{spec}}` as an assumption) and loses "Then STOP"; `close` names the Foreman
as the one who commits and pushes, with nothing said about a digest.

**3. `test/fixtures/golden-tree.txt`** — two lines added, in C-locale sort
order, verified against the order `installed_tree` produces:
`.agents/formulas/chisel-auto-light.formula.toml` immediately **before**
`.agents/formulas/chisel-auto.formula.toml`, and
`.agents/formulas/chisel-light.formula.toml` between the default and
supervised entries. Net +2 lines; no other line moves. No CLI change: the
installer walks `agents/formulas` for files, so the two presets install and
are managed with nothing touched in `bin/chisel.sh`.

**4. `test/installer.sh`, `group_render` only.** Replace, in this order:

- The group title and description, which today read "the three formula presets
  parse as TOML with the right gate count per preset (3/1/0)" — five presets,
  gate counts 3/2/1/0/0.
- The three shell variables `default_formula`, `supervised` and `auto`, and
  the `python3 - "$default_formula" "$supervised" "$auto"` invocation they
  feed: one glob over `"$t7"/.agents/formulas/*.formula.toml`, so the check
  covers whatever presets are installed.
- The shared assertion `assert len(ids) == len(set(ids)) == 9, path` and the
  gate table below it: one expectations table keyed by formula name carrying
  both numbers — `chisel-default` nine steps and gates
  `["plan", "design-check", "close"]` **in this commit** (Finding 1;
  commit 2 changes that one list to `["plan", "type", "close"]`),
  `chisel-light` seven and `["plan", "diff-review"]`, `chisel-supervised` nine
  and `["plan"]`, `chisel-auto` nine and none, `chisel-auto-light` six and
  none.
- The pass and fail messages, which name "all three" and "gates 3/1/0" today.

The block stays one assertion whatever it parses, so the assertion count does
not move.

#### Commit 2 — the three existing formulas rewritten

**5. `socle/agents/formulas/chisel-default.formula.toml`.**

- *Header.* Keep the opening promise and the ownership paragraph as they
  stand. Add the orchestration paragraph and the handoff sentence (plan
  decisions 4 and 5). Add the two-axis paragraph in full, replacing today's
  closing line "`chisel-auto.formula.toml` is this same pipeline with the
  human gates removed and escalation in their place": the human gates are one
  axis and the validation sub-agents the other; default holds both;
  `.agents/formulas/chisel-light.formula.toml` drops the sub-agents;
  `.agents/formulas/chisel-auto.formula.toml` drops the gates;
  `.agents/formulas/chisel-supervised.formula.toml` sits midway on the gates
  axis; `.agents/formulas/chisel-auto-light.formula.toml` drops both and is an
  instrument, not a notch. In the ownership paragraph, replace "Roles are
  roster names and tiers are abstract (frontier / mid / cheap)" with the
  clause that the contract of each role belongs to its profile in
  `.agents/profiles/`, keeping "a vendor or model name never appears here"
  (plan decision 7 — this also dissolves the recorded minor about the Mason
  being called "cheap tier" in the old design-check step).
- *`interview`.* Replace "Role: Architect (frontier tier)." with
  `Actor: the Foreman.` plus the reason and the spawn clause; the `grilling` /
  `domain-modeling` instruction stays.
- *`spec`.* Replace "Role: Architect." with the actor line pointing at
  `.agents/profiles/architect.md`. The sizing paragraph gains its second
  question, in the default's voice: and does this run **light or full**? —
  light drops the validation sub-agents and leaves the spec approval and the
  diff review to the human
  (`.agents/formulas/chisel-light.formula.toml`), full keeps the Checker, the
  `plan-review` and the Inspector; the human chooses, the agent recommends and
  never decides it silently. Add the commit clause before "Then STOP", which
  stays.
- *Separator.* Move `# ── WORK (fresh session) ──` from above `spec-review` to
  below it, so it falls before `plan`.
- *`spec-review`.* Slimmed to the actor line pointing at
  `.agents/profiles/checker.md`, the fresh-session-never-the-author clause and
  the verdict; the two-rounds-max escalation sentence goes, being the
  Checker's own contract.
- *`plan`.* This is where the authorship change bites. Replace the whole body
  — "Role: Architect, in a FRESH session… A plan that lives only in the
  conversation does not exist." — with the Mason actor line and the program
  design: the target file tree, the seam signatures, the state and migration
  notes, the TDD order, the decisions the spec left to the implementation, and
  the evergreen doc pages (§D) to write at close; persisted into the Design
  section of `{{spec}}` before any code; written when the work starts, not
  when the spec is written, because a task can sit at "spec done" for a long
  time and pseudo-code ages badly while the system design ages well; reads the
  ambient layer (§C) and `{{spec}}` in full plus what it links to, and updates
  its status. Its gate comment keeps its meaning and gains "and the system
  design" to what the Owner validates.
- *`design-check` → `plan-review`.* Rename the step id and the `needs` edge of
  `type`. Replace the body — "Role: Mason (cheap tier) posts its PROGRAM
  DESIGN… Duties: `.agents/profiles/architect.md`." — with the Architect actor
  line and: reads the slice and the program design only, answers VALIDATED or
  corrections, two rounds max, then the finding goes against the spec, never
  against the Mason; typing needs VALIDATED. Its gate moves off this step.
- *`type`.* The gate lands here, comment "plan approved": the Mason presents
  the condensed view of its program design declared in
  `.agents/profiles/mason.md` and asks for the go, once the Architect has
  answered VALIDATED at `plan-review`; nothing half-decided crosses this line.
  The old comment "plan approved + typist chosen" loses its second half. The
  body slims to the actor line plus: executes the program design persisted at
  `plan`, ticking the implementation checkboxes in `{{spec}}`, the full suite
  belonging to the next step — the artifacts-only paragraph, the TDD
  paragraph, the vertical-slice clause and the closing "goes back to the
  Architect" sentence all leave, being the Mason's own contract or, in the last
  case, a rule the new boundary rewrites inside the profile.
- *`verify`.* Add `Actor: the Foreman.` and the red-twice-stop clause (plan
  decision 9); the mechanical instruction stays.
- *`review` → `diff-review`.* Rename the step id and the `needs` edge of
  `close`. Body: the Inspector actor line pointing at
  `.agents/profiles/inspector.md`, then follows `code-review`; the diff and
  its pinned fixed point are handed over with the path to `{{spec}}`, whose 🧑
  zones are the requirements of the Spec axis; the Standards axis and the Spec
  axis are reported side by side, never merged (Finding 3 — the literal phrase
  stays out of the body).
- *`close`.* Replace "Role: Architect or Mason." with `Actor: the Foreman.`,
  add the clause that anything to be typed goes through the Mason contract,
  and end the body on the Foreman committing and pushing. The bookkeeping
  instruction stays as it is.

**6. `socle/agents/formulas/chisel-supervised.formula.toml`.**

- *Header.* Keep the first line (one human gate — the Owner approves the spec,
  and nothing else) and the degraded-run paragraph, with "the run STOPS"
  written lowercase (Finding 4). Delete the paragraph beginning "Everywhere
  else it behaves as `chisel-auto`… a doubting step ESCALATES one rung (Mason
  → Architect → Inspector → the Owner's digest)… The step bodies below are
  `chisel-auto`'s, byte for byte": what replaces it is the handoff sentence
  (the Foreman spawns the next step, fresh) and the ladder-free doctrine — a
  step that cannot decide blocks the task and reports to the Foreman, which
  decides within what it owns and hands anything above that to the human, full
  stop. Add the orchestration paragraph and the one-clause position on the
  axes (midway on the gates axis, every validation sub-agent kept; the full
  reading is in the default's header). Ownership paragraph as in default. Keep
  the opt-in paragraph.
- *Steps.* The same nine as default, with the same renames, the same moved
  separator, the same slimming and the same actor lines. The single gate stays
  on `plan`; its comment loses the sentence about the plan below not being
  submitted, which named the plan as the Architect's. Every "No human …"
  paragraph goes: at `plan` ("No human approves it: self-check… a plan that
  contradicts a 🧑 zone STOPS and escalates") and at `diff-review` ("No human
  arbitrates: the Inspector applies the confirmed findings itself, but a
  finding that touches scope or a 🧑 zone escalates to the Owner's digest"),
  both being profile restatements; at `close`, "No human is watching the
  close: the closing summary lands in the Owner's digest" goes with the word
  it carries. The sizing question is asked in the supervised voice: the
  recommendation on one pass or sliced and on **light or full** is written into
  `{{spec}}`, and the spec gate settles it.

**7. `socle/agents/formulas/chisel-auto.formula.toml`.**

- *Header.* Keep the first line and the opt-in paragraph. Replace the
  paragraph "There is no gate to wait on: where the default waits, Auto
  ESCALATES — a doubting step stops, writes what it doubts into the spec file,
  and hands it one rung up (Mason → Architect → Inspector → the Owner's
  digest). Auto never forces a passage." with the same ladder-free doctrine as
  supervised's, plus the handoff sentence. Add the orchestration paragraph and
  the one-clause position on the axes (the gates axis emptied, every
  validation sub-agent kept). Ownership paragraph as in default.
- *Steps.* The same nine, no gate, same renames and slimming. Two
  preset-specific clauses survive, both step-specific rather than profile
  restatements: at `interview`, no human to interview, so what would have been
  a question is carried into the Notes of the spec as an assumption; at
  `spec`, the sizing answer — one pass or sliced, **light or full** — written
  into `{{spec}}` the same way. The three "No human …" paragraphs go as in
  supervised, `close` carrying the dying word.
- *`test/installer.sh`, one line:* the default's gate expectation becomes
  `["plan", "type", "close"]` (Finding 1).

#### Commit 3 — the profiles and the doctrine file

**8. `socle/agents/profiles/foreman.md`** — two edits, nothing else moves.

- *Mission, "What it does" list.* One bullet added before the spawning bullet
  it feeds: the Foreman leads the interview itself, following `grilling`,
  because a spawned role cannot interview the human; it then spawns an
  Architect to write the spec from what the interview produced.
- *Frontmatter `description`.* The interview joins the opening clause, on the
  same physical line, losing nothing.
- *"Reporting to the Owner".* After the self-containment paragraph and before
  the closing paragraph on unnarrated verification: a report never repeats
  what is already settled — it covers what changed since the last one, and
  self-containment governs the open items, never licence to recap what the
  Owner has already read and ruled on ("pas la peine de te répéter non plus,
  je vois pas bien l'intérêt"); the Foreman never re-asks for an authorization
  already given, a GO standing until the Owner withdraws it; and a section of
  the step-delivery shape with nothing in it is dropped, not filled.

**9. `socle/agents/profiles/architect.md`** — the edits the plan lists, in file
order: the frontmatter `description` (one line); the Mission opening list,
where "It runs the `interview`, `spec` and `plan` steps of the pipeline"
becomes the `spec` step alone and the "Interview" bullet goes; the "Plan"
bullet deleted as an authorship claim and replaced by what the Architect owns
at that moment, keeping the ageing rationale in the Owner's terms; "Reviewer
duties", where "The Architect also runs the `design-check` step" and the
"**Design check**" bullet become `plan-review`, reading the slice and the
Mason's program design only, two rounds max, then a finding against the spec;
Prohibitions, first bullet ("Never types the code of a slice it planned" →
"…it specified", with the rationale moved onto the spec), second bullet
("Never reviews its own plan or its own diff" → never reviews its own spec and
never reviews a diff, with the `plan-review` clause), last bullet ("Never
leaves the plan implicit. 'The Mason will figure it out' is not a plan"
re-pointed at the *what*); Escalation, last bullet ("A Mason that could not
implement from the artifacts is a finding **against the plan** … you take the
plan back") becoming a finding against the spec, still arriving through the
spawner. Nothing else in the file moves.

**10. `socle/agents/profiles/mason.md`** — the whole-profile audit of the plan,
section by section, in file order: the frontmatter `description` (one physical
line, and the phrase "already-planned" leaves with it); the Mission opening
("It runs the `type` step of the pipeline in `.agents/formulas/`: one slice,
one fresh session, from the plan persisted in the spec file" → the `plan` and
`type` steps, keeping "one slice, one fresh session"); Mission first bullet
("Executes the persisted plan step by step" → the program design it
persisted); the resume-point bullet unchanged in substance; Tier ("The
expensive thinking already happened: the plan is written, the seams are
agreed" → the system design is settled and approved, and the closing "if a
slice seems to need one, the plan is not finished, and that is a finding
against the plan" → the system design is not settled, a finding against the
spec); Speed contract first bullet (`design-check` → `plan-review`, plus the
case the presets now create — or, in a preset that runs no `plan-review`, the
design persisted at `plan`); the new **go summary** section, placed after the
Speed contract and before the Prohibitions, the house position for a duty
section; Prohibitions first bullet ("**Never plans and never designs.** The
delegation boundary is the plan." → never decides the system design, with the
program design stated as the Mason's own), second bullet ("Never improvises
past the persisted plan… that is news for your spawner" → the design revised
in writing where reality contradicts the program design, stop-and-go-up where
it contradicts the system design), third bullet ("Never accepts an open
question") sorted by side; Escalation first bullet ("pushed outside the
persisted plan" → outside the system design the spec settled); the proposal
door's closing sentence ("Until a new plan says otherwise, the persisted plan
governs every line you type"); Inputs item 1 and the closing paragraph ("the
plan is incomplete — that is a finding against the plan" → against the spec).

**11. `socle/agents/methodology.md`** — four edits, no more, the boundary one
sitting inside a corollary slice 3 rewrites:

- "The roster", Architect row: "answers the `design-check`" → "answers the
  `plan-review`". The rest of the cell is Finding 5's, left as it is.
- "The pipeline is nine steps": "`design-check` (the Mason posts its program
  design; the plan's Architect answers VALIDATED or corrections, two rounds
  max, then a finding against the plan)" → `plan-review`, the Mason posting
  its own program design and the Architect validating it, the finding going
  against the spec.
- "The two designs", program-design paragraph: "the `design-check` loop
  validates it before any typing" → `plan-review`.
- "The two designs", the boundary: "The delegation boundary is the plan
  itself: everything above it is thinking, everything below is typing." → the
  boundary at the system design, above it the what settled at creation time
  and approved at the gate, below it the how designed and typed by the session
  that implements. Its neighbour "A Mason asked to 'figure out' something the
  Design left open is a planning failure, not an execution one — the plan goes
  back to the Architect" becomes true of the *what* only and goes back to the
  spec. In the economics paragraph, "Everything below the plan is typing, and
  typing does not need the same tier" is reworded onto the system design, the
  tier claim untouched.
- "Why slicing is conditional (the sizing check)", the paragraph beginning
  "What IS unconditional": the check asks two things out loud — does this fit
  one pass, and does it run **light or full**? Light drops the validation
  sub-agents and leaves the spec approval and the diff review to the human
  (`.agents/formulas/chisel-light.formula.toml`); the human answers both, and
  a silent answer to either is a review hole.
- Deliberately not touched, per the plan: the opt-in framing of the same
  corollary, the tier-gradient paragraph and the economics redundancy, and the
  section's passages on persistence and the artifacts-only brief.

**12. `socle/agents/skills/upgrade-v2/SKILL.md`** — one word, per the
deviation already declared in these Notes: "(the three presets)" → "(the
presets)". Noted in the worklog and judged at review; no test asserts the
count.

#### Verification order

1. **After commit 1:** `bash test/run.sh` — expect 9 scenarios, 93 assertions,
   0 failed, and the golden-tree comparison passing with the two new lines.
   Then the same run with a `tomllib`-capable `python3` first on `PATH`
   (`PATH=/opt/homebrew/bin:$PATH bash test/run.sh render`) — expect the parse
   assertion to run and pass, 24 assertions in that group. Without this second
   run the parse expectations are never executed (Finding 2).
2. **After commit 2:** both runs again. The golden tree does not move; the
   parse check is the assertion that proves the moved gate and the renamed
   step ids, so the `PATH`-prefixed run is the load-bearing one here.
3. **After commit 3:** both runs again — the render group re-derives the
   expected agent definitions from the profiles themselves, so a profile edit
   cannot break it, but the integrity group and the no-numeric-limit grep both
   read the edited files.
4. **Then the named criteria**, in this order:
   - **suite-green** — the whole-suite run above, nine groups, plus the line
     cap the runner checks on itself.
   - **light-formula-exists** — `test -f
     socle/agents/formulas/chisel-light.formula.toml`; `grep -n
     "spec-review\|plan-review" socle/agents/formulas/chisel-light.formula.toml`
     expecting nothing; then reading the `diff-review` step for its human
     actor and the two gate comments. The parse run corroborates the gate list.
   - **benchmark-floor-exists** — `test -f
     socle/agents/formulas/chisel-auto-light.formula.toml`; `grep -n
     'type = "human"'` and `grep -n "spec-review\|plan-review\|diff-review"`
     on it, both expecting nothing; then reading the header for the benchmark
     sentence and the explanation of the missing review.
   - **reviews-named-after-their-object** — `grep -rn "design-check" socle/`
     and `grep -rn 'id = "review"' socle/agents/formulas/`, both expecting
     nothing (five carriers today: the three formulas, `architect.md`,
     `mason.md`, plus three sentences of `methodology.md`), then reading the
     `plan` step of each formula for the program design and its author.
   - **create-work-separator-sits-right** — reading the separators of the five
     files.
   - **stop-only-where-humans-relaunch** — `grep -l "Then STOP"
     socle/agents/formulas/*.toml`, expecting default and light only, then
     reading the handoff sentence of the other three headers.
   - **foreman-closes**, **foreman-leads-the-interview**,
     **spec-step-saves-the-spec**, **slim-step-bodies**,
     **formulas-orchestrated-by-the-foreman** — read-throughs of the five
     files, one step at a time; no grep judges these. For
     **foreman-leads-the-interview**, add the read of `foreman.md` and
     `architect.md`.
   - **two-axes-said-once** — `grep -rln "two axes"
     socle/agents/formulas/`, expecting exactly `chisel-default` (three files
     match today, Finding 3), then reading the four other headers for their
     one-clause position and their pointer.
   - **formulas-shed-ladder-and-digest** — `grep -rin "digest"
     socle/agents/formulas/`, `grep -rn "Mason → Architect"
     socle/agents/formulas/` and `grep -rn "Architect → Inspector"
     socle/agents/formulas/`, all expecting nothing. Slice 1 recorded that the
     `Mason → Architect` form can be defeated by a line wrap, so add the
     wrap-tolerant `grep -rn "Mason →" socle/agents/formulas/`.
   - **sizing-asks-light-or-full** — `grep -l "light or full"
     socle/agents/formulas/*.toml`, expecting default, supervised and auto and
     no other, and `grep -n "light or full" socle/agents/methodology.md`
     landing in the sizing section.
   - **profiles-follow-the-plan-authorship** and
     **the-boundary-is-the-system-design** — the three greps of the second
     criterion (`delegation boundary is the plan`, `below the plan is typing`,
     `already-planned`, all over `socle/`, expecting nothing; two carriers in
     `methodology.md` and two in `mason.md` today), then a read of `mason.md`
     in full as if it were the entire instruction set of a fresh session, and
     of "The two designs" in `methodology.md`.
   - **mason-presents-a-go-summary** — reading the new section for the shape
     and for the sentence that the summary points at the file rather than
     replacing it.
   - **foreman-report-rules-complete** — reading "Reporting to the Owner" for
     the three added rules.

### Plan review

Run 2026-08-28 by an Architect that did not write this plan, against the real
files on `review-360` and against the suite run with a `tomllib`-capable
python (`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — 9 scenarios, 94
assertions, 0 failed today). Round one of two.

**Verdict: corrections.** The program design is sound where it is written:
every claim it makes about the files was re-checked and every one holds — the
gate ids of `chisel-default` are `plan`, `design-check`, `close`; the three
formulas each carry "Then STOP" and six "No human …" paragraphs; the two
ladder arrows and the six "digest" occurrences sit in supervised and auto
only; the boundary greps have two carriers in `methodology.md` and two in
`mason.md`; the golden-tree sort order is the one `installed_tree` produces
under `LC_ALL=C`; the suite is 588 lines against its own 600-line cap. The
corrections below are omissions in the edit list, not disagreements with it.

1. **The roster cells of `socle/agents/methodology.md` are fixed here, not
   left to slice 3.** Finding 5 of the program design concludes "I leave both
   readings as they are"; the thread owner has since ruled the other way, and
   the ruling governs. In the section "The roster": the Architect row's
   "Interviews, writes the spec, plans, answers the `design-check`" keeps only
   the spec and the renamed review — the interview is the Foreman's (plan
   decision 1) and the program design is the Mason's (plan decision 14) — and
   the Mason row's "Types the persisted plan — never plans" says instead that
   the Mason authors its own program design and types it. Both cells land in
   commit 3 with the rename that already touches that table. Shipping a roster
   that contradicts the profiles of the same release is the joint failure this
   task exists to close.

2. **Nothing in the edit list actually deletes "Then STOP" from
   `chisel-supervised` and `chisel-auto`.** Finding 4 asserts the outcome —
   "the phrase 'Then STOP' appears in none of `chisel-supervised`,
   `chisel-auto` and `chisel-auto-light`" — but the ordered edits for those
   two files (commit 2, the supervised and auto entries) never name the
   sentence, which sits in the `spec` step body of both today. State the
   deletion explicitly in each entry: the sentence is replaced by nothing, the
   handoff being carried by the header. The criterion
   **stop-only-where-humans-relaunch** greps the whole files and fails without
   it.

3. **The moved CREATE / WORK separator is instructed for default and
   supervised but not for auto.** The supervised entry says "the same moved
   separator"; the auto entry says only "the same nine, no gate, same renames
   and slimming". `chisel-auto` carries the separator above its `spec-review`
   step like the other two, and **create-work-separator-sits-right** covers
   all five presets. Add the move to the auto entry.

4. **`socle/agents/profiles/foreman.md` contradicts the orchestration this
   slice writes, and the edit list leaves the contradiction standing.** The
   first bullet of "What it does" reads "Runs the formula chosen at
   invocation, step by step — each step a fresh sub-agent spawned with the
   step role's profile". After this slice that is false for three steps: the
   Foreman holds `interview` (plan decision 1), `verify` (plan decision 9) and
   `close` (plan decision 8) itself, and the criterion
   **formulas-orchestrated-by-the-foreman** requires the formulas to name them
   as the exception. The added interview bullet does not repair the bullet
   above it, and `verify` and `close` are never reconciled anywhere in the
   profile. Amend that bullet with the exception — the same class of joint
   failure as correction 1, and the same commit.

5. **The "No human …" instruction for supervised and auto is blanket and
   enumeration at once, and the two disagree.** Each of the two files carries
   six such paragraphs, not the three the entries list: `interview`, `spec`,
   `plan`, `type`, `diff-review`, `close`. "Every 'No human …' paragraph goes"
   would delete the two the plan deliberately keeps in a reworded form (plan
   decision 12 and the auto interview clause). Split it: deleted at `plan`,
   `type`, `diff-review` and `close` — the `type` one, an escalation rule
   restating the Mason's own contract, is not currently named anywhere in the
   edit list — and reworded into the surviving preset clauses at `interview`
   and `spec`.

6. **The `plan` gate comment of `chisel-default` says "a spec two Architects
   already agree on", and the entry for it only adds "and the system
   design".** The two readers are the Checker and the Owner, not two
   Architects; the persisted plan already writes "a spec two roles already
   agree on" in its own default section. Carry that wording into the edit.

7. **The globbed parse check loses a tooth the hand-listed one had.** Naming
   the three files proved they existed; a glob over
   `"$t7"/.agents/formulas/*.formula.toml` passes vacuously on an empty
   directory and silently on four presets out of five. One line restores it —
   assert that the set of formula names seen is the five expected — and it
   fits the twelve lines of headroom the design measured against the suite's
   cap.

Nothing else. The commit order stands as Finding 1 revised it, the two-run
verification order stands, and the shared step-body shape, the spine table and
the per-preset outlines are executable as written.

### Worklog

**Commit 1 — the two new presets, atomic.** Typed 2026-08-28 from the program
design and the plan review's correction 7; commits 2 and 3 untouched.

- `socle/agents/formulas/chisel-light.formula.toml` — new, seven steps, gates
  on `plan` and `diff-review`, WORK separator after `spec`, `Then STOP` kept
  in the `spec` body, `diff-review` held by the human.
- `socle/agents/formulas/chisel-auto-light.formula.toml` — new, six steps, no
  gate, no `diff-review`, header saying it is the benchmark floor and why the
  review is absent.
- `test/fixtures/golden-tree.txt` — the two lines, C-locale order, +2 net.
- `test/installer.sh`, `group_render` only — the three hand-listed formula
  variables replaced by a glob over the installed presets, one expectations
  table carrying both the step count and the gate list per preset, and
  correction 7's line: the set of formula names seen must equal the five
  expected, so the glob cannot pass vacuously or on four presets. Default's
  gate list stays `["plan", "design-check", "close"]` in this commit, per
  Finding 1; commit 2 moves it.

Suite after the commit, run as the brief prescribes
(`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`): 9 scenarios, 94
assertions, 0 failed, the parse check running rather than skipping. Test files
at 592 lines against the suite's own 600-line cap.

No deviation from the files map, no blocker, nothing for the proposal door.

**Commit 2 — the three existing formulas rewritten.** Commit `063142c`. The
session that typed it left no worklog entry, and none is reconstructed here —
an entry written after the fact from the diff is not evidence. Its outcomes
were verified at review instead, independently and against the files: default's
middle gate moved onto `type`, the literal "Then STOP" and the four "No
human …" paragraphs deleted, and the CREATE / WORK separator moved after
`spec-review`.

**Commit 3 — the profiles and the doctrine file.** Typed 2026-08-28 from the
program design and the plan review's corrections 1 and 4; commits 1 and 2
untouched. Commit `2e31640`.

- `socle/agents/profiles/mason.md` — the whole-profile audit: frontmatter
  description, Mission opening and first bullet, Tier, the Speed contract's
  first bullet with the no-`plan-review` case, the three rewritten
  Prohibitions (the boundary at the system design; a contradicted program
  design revised in writing, a contradicted system design escalated; an open
  question sorted by side), the Escalation first bullet, the proposal door's
  closing sentence, and Inputs item 1 with its closing paragraph. New section
  "The go summary — what the Mason presents at the plan gate", placed after
  the Speed contract, prescribing a shape and no length.
- `socle/agents/profiles/architect.md` — the interview leaves the Mission and
  the frontmatter description, the plan authorship leaves the Mission bullet
  (replaced by what the spec settles and what it does not, keeping the ageing
  rationale), the `plan-review` rename in "Reviewer duties" with the finding
  going against the spec, and the four boundary carriers of the Prohibitions
  and the Escalation.
- `socle/agents/profiles/foreman.md` — the interview duty as its own bullet,
  correction 4 on the bullet above it, and the two late reporting rules with
  their companion clause in "Reporting to the Owner".
- `socle/agents/methodology.md` — both roster cells (plan review, correction
  1), the `plan-review` rename in the nine-steps and the two-designs sections,
  the boundary and its two neighbouring sentences in "The two designs", and
  the sizing check gaining its second question. The opt-in framing and the
  tier-gradient paragraph left to slice 3, as the plan draws the line.
- `socle/agents/skills/upgrade-v2/SKILL.md` — one word, "(the three presets)"
  → "(the presets)". **Outside the parent's files map**, declared in the plan
  under "Deviation from the parent's files map"; no test asserts the count.
  The neighbouring "three role profiles" was left alone: it belongs to the
  minors ruling, not to this slice.

Two touches beyond the plan's edit list, both reported for the reviewer:

- `socle/agents/profiles/architect.md`, the closing line of Inputs — "What it
  produces: the spec file, and the plan persisted inside it" was a fifth
  authorship carrier the plan did not name. It now reads: the spec file, and
  at `plan-review` a verdict on someone else's program design. Left standing
  it would have contradicted the Mission bullet three screens above it.
- `socle/agents/formulas/chisel-auto-light.formula.toml`, one clause — "No
  human arbitrates the cut" became "Nobody arbitrates the answer here", its
  sibling's wording in `chisel-auto`, which also retires the last "No human …"
  phrase the slice set out to remove from the formulas.

Suite after the commit, run as the brief prescribes
(`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`): 9 scenarios, 94
assertions, 0 failed, the parse check running rather than skipping. Test files
at 592 lines against the suite's own 600-line cap. Every named criterion of
this slice was run and holds; the checkboxes above are ticked accordingly.

Nothing for the proposal door beyond the two consistency calls reported to the
thread owner.

### Review

Run 2026-08-28 by an Inspector that wrote neither the plan nor the diff, from
the fixed point `289bf2e`, pinned before anything was read and never re-pinned.
Diff: `git diff 289bf2e...HEAD`; commits `290bcf5`, `063142c`, `2e31640`.
Requirements read as the Spec axis: the 🧑 zones of this slice (What to build,
the named criteria, the persisted Design), the parent spec's Scope, Acceptance
Criteria, Architecture and all thirteen Implementation Decisions, and ruling G6
with the reference pipeline of the second addendum in
`project-management/review-360-decisions.md`. Standards read as the Standards
axis: `AGENTS.md`, `socle/agents/discipline.md`, the writing rules of the
parent spec's Notes, and the smell baseline of
`socle/agents/skills/code-review/SKILL.md`.

Suite run as the brief prescribes (`PATH="/opt/homebrew/bin:$PATH" bash
test/run.sh`): **9 scenarios, 94 assertions, 0 failed**, the formula parse
check running rather than skipping, test files at 592 lines against the 600
cap. Every named criterion of this slice was re-run independently and holds —
the greps return empty where they must, and a `tomllib` parse of the five
installed presets gives step counts 9 / 7 / 9 / 9 / 6 and gate lists exactly as
the spine table declares.

The two axes below are reported side by side. They are not merged and not
re-ranked against each other.

#### Standards axis

1. **The `diff-review` body paraphrases the Inspector's mission, which the
   slimming rule forbids** — `chisel-default`, `chisel-supervised` and
   `chisel-auto`, the `diff-review` step. The body ends with "Read both axes
   from that fixed point: the Standards axis … and the Spec axis …; Report them
   side by side; never merge them and never re-rank findings across them." The
   Inspector's own profile already carries that sentence, and so does the
   `code-review` skill the same body names one line above. The standard: the
   persisted Design, section "The shared step-body shape" — "What a body never
   contains, per the slimming ruling: the role's prohibitions, its inputs, its
   escalation rules, its tier, or a paraphrase of its mission." This is the
   cost of the workaround recorded as Finding 3 of the program design: the
   literal phrase was dropped to satisfy **two-axes-said-once**, but the
   paraphrase it was replaced with is the thing the slimming rule targets. The
   body stops being a restatement at "…whose 🧑 zones are the requirements of
   the Spec axis."; everything after it is the profile's. Judgement call, and
   the same reading puts a lighter version of it on the `plan-review` body
   ("TWO rounds MAX … never against the Mason", verbatim doctrine from the
   Architect's "Reviewer duties").

2. **`chisel-auto-light`'s `close` step opens on findings that preset can
   never have** — "Apply the arbitrated findings — anything that must be typed
   goes through the Mason contract." That preset runs no `diff-review`, no
   Checker and no `plan-review`, and its own header says so twice, ending on
   "the mechanical `verify` is the only signal this preset produces." Nothing
   in the run produces a finding and nobody arbitrates one. The standard is the
   same step-body shape rule — a body carries "only step-specific instruction"
   — and, behind it, the header's promise. The clause is inherited from the
   shared spine rather than written for this preset. In `chisel-auto` and
   `chisel-supervised` the wording survives on its merits, because the
   Inspector runs and its profile says it applies what it confirmed where no
   human arbitrates; here it has no referent.

3. **`socle/agents/profiles/architect.md` still says the Architect plans, in
   two places the rewrite did not reach** — the Tier section ("every downstream
   session pays for a bad **plan**, and a bad seam is paid for as long as the
   code lives") and Inputs ("the Architect **plans** against real code, not
   against a description of it"). Both are the generic sense of the word, and
   neither is named by a criterion. But this is the file that this slice
   re-anchors on the split between a spec the Architect owns and a program
   design it does not, and in the Tier sentence "a bad plan" now names the one
   artifact the Architect no longer writes. Same class as the correction the
   plan review forced on the roster cells: a document that contradicts itself
   in the reader's hands. Two words each (`spec`, `specs`). Judgement call.

4. **`socle/agents/profiles/foreman.md`, section "Ruling on a report": "fold
   it into the current task's persisted plan."** After this slice the persisted
   plan is the Mason's own program design, and the Foreman folding a report
   into it crosses the authorship the same commit establishes. The file is
   edited by this commit, so the contradiction ships in the release that
   creates it. The honest verb is to order the change through the Mason
   contract, as the `close` step of all five formulas already words it.
   Judgement call, one clause.

5. **The suite still reports green when the check that proves the new work
   never ran** — `test/installer.sh`, `group_render`. The `tomllib` guard falls
   through to `printf 'SKIP: TOML parse check …'` and no assertion records the
   skip, so a machine without `tomllib` prints "93 assertions passed" and a
   clean bill. That mechanism predates this diff, but this diff makes it
   load-bearing: after the change, the parse block is the *only* automated
   proof of **light-formula-exists**, **benchmark-floor-exists** and every gate
   count in the spine table. Discipline rule 4 ("Verify before 'done'.
   Evidence first — red output is reported as red, never narrated as green")
   is the standard behind it; a silent skip is neither red nor green. Not
   introduced here and out of this slice's scope to fix; recorded so the gap is
   not discovered later as a surprise. Judgement call.

**Suppressed, deliberately.** The five presets now repeat the `interview`,
`plan`, `type`, `verify` and `close` bodies near-verbatim — textbook
**Duplicated Code** under the smell baseline. The repo overrides it: the parent
spec's Scope records the Owner's ruling on formula duplication — "no generation
from a common source and no identity assertions or tests", the drift risk
accepted ("revient à des checks sur des magic strings comme les greps, pas
fou"). A documented repo standard always wins over the baseline, so this is not
reported as a finding.

**Clean.** English throughout, with the Owner's words kept in French inside
quotation marks in `chisel-light`'s header, `chisel-auto-light`'s header and
the Foreman's reporting rules. No line-number reference anywhere in the diff.
No naked code: the two `§B3` mentions both carry "Autonomous runs". No invented
numeric limit — the new go summary says outright "No length is prescribed — the
shape is the contract", and the suite's own assertion on that agrees. Every
pointer added to a sibling formula says in one clause what the reader finds
there. The parse check gained the tooth correction 7 asked for: an unknown
formula name raises rather than passes, and `assert seen == set(expected)`
stops the glob passing vacuously or on four presets out of five.

#### Spec axis

1. **The ageing rationale is missing from the `plan` body of `chisel-light`
   and `chisel-auto-light`.** The persisted Design states each step's content
   "once, for every preset that runs it", and its `plan` entry carries: "It is
   written when the work starts, not when the spec is written: a task can sit
   at 'spec done' for a long time, and pseudo-code ages badly while the system
   design ages well, the architecture moving far less than the code." That
   sentence is present in `chisel-default`, `chisel-supervised` and
   `chisel-auto` and absent from the two presets written in commit 1. It is not
   decoration: it is the Owner's own durable justification for the whole
   re-ordering, recorded verbatim in ruling G6 and quoted in the parent's
   Implementation Decisions, point 12. A Mason spawned under light or
   auto-light — the two presets with the fewest readers — is the one that never
   sees why its design is written late. Three lines, copied from the sibling.
   Missing requirement.

2. **`socle/agents/methodology.md` keeps two cells of the same class the plan
   review ordered fixed, one screen below the ones that were.** Correction 1 of
   the plan review overruled the program design's Finding 5 and required both
   roster cells fixed here, on the grounds that "shipping a roster that
   contradicts the profiles of the same release is the joint failure this task
   exists to close". The roster cells are fixed. Two more say the same thing:
   the model-tiers table still reads "Architect (interview, design, plan)" on
   the frontier row and "Typing from a plan that is already persisted / A Mason
   as typist" on the cheap row; and the opt-in corollary still reads "the
   **Architect** does the thinking (interview, design, plan) with the human".
   Both survive every grep this slice's criteria run, and Implementation
   Decisions point 9 (intermediate inconsistency accepted) formally covers
   them, which is why they are reported rather than called a violation. But the
   ruling behind correction 1 does not distinguish a roster cell from a tier
   cell, and the interview claim in particular is one this slice moved to the
   Foreman. **For the Owner's arbitration:** apply correction 1's logic to
   these two cells here, or confirm they wait for slice 3.

3. **No scope creep found.** The diff touches exactly the files the slice
   planned plus the one declared deviation. Nothing was added that no
   requirement asked for; the two touches the worklog reports beyond the edit
   list (the Architect's Inputs closing line, the `chisel-auto-light` sizing
   clause) are both consequences of requirements already in the 🧑 zones, and
   both were reported rather than absorbed.

4. **Everything else asked for is there, and was verified rather than read.**
   All eighteen named criteria of this slice hold under their own greps and
   under a parse of the installed tree; the spine table's step counts and gate
   lists match the files exactly; the CREATE / WORK separator sits after
   `spec-review` in the three full presets and after `spec` in light and
   auto-light; `Then STOP` exists in `chisel-default` and `chisel-light` and
   the word STOP appears nowhere else in `socle/agents/formulas/`; the literal
   "two axes" is confined to `chisel-default`; `design-check`, `id = "review"`,
   `digest`, both ladder arrows and all three boundary phrases return nothing
   across `socle/`. The five presets express the fifteen-step reference
   sequence of the second addendum in the order it sets, including the two
   things the Owner added late — the Foreman leading the interview because a
   sub-agent cannot interview a human, and the spec committed at the end of the
   `spec` step because the task may wait there a long time. Default's middle
   gate sits on `type`, where the reference sequence puts the Mason asking for
   the go once the Architect has validated, and the Mason profile now declares
   the condensed view it presents there — the "format de sortie" step 10 of the
   sequence asked for.

#### The two declared deviations

**`socle/agents/skills/upgrade-v2/SKILL.md`, one word — validated.** The
parent's map puts `socle/agents/skills/**` in files-to-avoid on one stated
ground: no skill carries the ladder, the digest or the allotment. That ground
is untouched here, so the reason for the exclusion never applied to this edit.
"(the three presets)" became false twice over the moment this slice landed, the
file is installed into every equipped repo by `chisel init`, the fix is the
minimal one word, no test asserts the count either way, and the touch was
declared in the plan before typing and reported in the worklog. It reveals no
bad pattern. Ruled in.
One observation that changes nothing: the same file still says "three role
profiles" further up, false since slice 1 created a fifth. The worklog leaves
it to the minors ruling, which is a defensible line — but the plan's deviation
note calls it "that file's neighbouring sentence", and it is not neighbouring;
it sits over a hundred lines away. The line held is by ruling, not by
proximity.

**The `chisel-auto-light` clause edited in commit 3 — validated.** The file
belongs to commit 1, and a two-word rewording of its `spec` body ("No human
arbitrates the cut" → "Nobody arbitrates the answer here") landed with the
profiles. The change could only be seen once commits 1 and 2 sat side by side:
it retires the last "No human …" phrase in `socle/agents/formulas/`, an outcome
the persisted Design set for the formulas and which a grep now confirms. It is
named in the commit message's own body and in the worklog, so the trail is
intact, no criterion or test depends on commit attribution, and the
alternatives — a fourth commit for two words, or rewriting history — are both
worse. Ruled in.

#### The third item left for judgement

**No worklog for commit 2.** The slice file carries worklogs for commits 1 and
3 and none for the commit that rewrote the three existing presets. The typing
session did not fabricate one, which is the right call — a worklog written
after the fact from the diff is not evidence, and discipline rule 4 wants
evidence first. But the gap is real: commit 2 is the largest of the three by
churn and carries the moved gate, the deletions of "Then STOP" and of the four
"No human …" paragraphs, and the moved separator, and nothing in the file
records that they were run and checked at the time. The diff and the commit
message stand on their own, and this review re-verified every one of those
outcomes independently, so nothing is unproven — but the slice file should say
that, rather than say nothing. **For the Owner:** a one-line note under the
worklog recording that commit 2's session left no entry and that its outcomes
were verified at review, rather than a reconstructed worklog.

#### Verdict

Standards axis: five findings, all judgement calls, no hard violation of a
documented standard. Worst within the axis: **finding 1**, the `diff-review`
body paraphrasing the Inspector's mission — it is the one case where the diff
breaks a rule this very slice wrote.

Spec axis: two findings. Worst within the axis: **finding 1**, the ageing
rationale absent from two of the five `plan` bodies — a requirement of the
persisted Design, and the Owner's own reason for the re-ordering, missing from
the presets least likely to have another reader.

No finding touches scope, and none of them blocks. Both deviations are ruled
in. Everything above goes to the Owner at the arbitration gate.


### Worklog — findings applied, and close

The arbitration gate returned the Inspector's seven findings with six ruled in
by the thread owner and one left standing: the near-verbatim shared step
bodies across the five presets, which the Owner's ruling on formula
duplication already accepts. A Mason applied the six as commit `d0940c0` —
the `diff-review` and `plan-review` bodies stripped of the doctrine they were
paraphrasing, `chisel-auto-light`'s `close` reworded for a preset that reviews
nothing, the Architect's last two plan-authorship words, the Foreman's
"fold it into the persisted plan" (which crossed the authorship the same
commit created), the ageing rationale carried into the two presets that
lacked it, and the honest note that commit `063142c` left no worklog and was
verified at review instead. That commit is itself recorded here rather than in
its own entry, which is the gap finding six existed to close.

Ruled at close, not deferred silently: the two cells of `methodology.md` that
still say "Architect (interview, design, plan)" and "Typing from a plan that
is already persisted" go to slice 3. They are the same family as the roster
cells corrected here, but slice 3 rewrites that whole section, the parent
task's decision on intermediate inconsistency covers the interval, and the
final greps close it.

Suite at close, run with a `tomllib`-capable python so the formula parse check
executes rather than skipping: 9 scenarios, 94 assertions, 0 failed, test
files at 592 lines under the suite's own cap.
