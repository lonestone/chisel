# Code review: a third axis, Simplicity — the simplest code, in the shape the codebase already uses

**Status:** draft — waits on Pierrick's answers to the four open questions

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

Pierrick, 27/11, relayed by Olympe: « il faudrait peut-être faire passer à
Prométhée le fait que les reviews doivent poser la question de : est-ce que
c'est simple, et est-ce que ça respecte la façon de faire de la codebase
existante. Effectivement, peut-être moins ancré dans les specs, parce que là
c'est un trou dans la raquette. »

What happened. Olympe's API step 2 (19,227 lines, pull requests closed
without merge) ran the `code-review` skill on every lot, with its two axes.
**Standards** judges the diff against the written rules and a baseline of
Fowler smells. **Spec** judges it against the spec, and the spec itself
carried the complexity. Nothing asked whether the code had the shape of the
modules already there, or whether it was the simplest that does the job.
The same day, in his crit review of Olympe pull request #143, Pierrick
wrote « T'as plein de types et tout, ça me paraît tellement compliqué » and
« tu as écrit un million de tests ».

The wisdom Pierrick pointed to the same day is « Cognitive load is what
matters » (https://github.com/zakirullin/cognitive-load): reduce the load
above what the task itself demands; « familiarity is not the same as
simplicity »; « a little copying is better than a little dependency »; and a
newcomer's confusion as the measure of the code. A fresh reviewer is that
newcomer.

## Scope

**Included:**
- A third axis in the `code-review` skill, **Simplicity**, run as a third
  fresh sub-agent in parallel with the other two. It asks two questions:
  is this the simplest code that does the job, and does it follow the way
  the existing code already does it?
- A bounded method for the reviewer to find "the way the code already does
  it" without reading the whole repo.
- A finding format that always carries the simpler version, and says
  whether the complexity comes from the code or from the spec.
- The route of a finding that comes from the spec: to the Architect, never
  fixed by the Mason on its own (step 6 of `workflow.md`).
- The axis's reasons in `methodology.md`, and the intention that ships the
  change to equipped repos.

**Not Included:**
- Any change to the Standards and Spec axes, their briefs or the smell
  baseline.
- A check of the spec's simplicity at the spec step: the spec stays the
  human's to approve. The plan step is open question 3.
- A new glue line naming reference modules: open question 4.
- Measuring cognitive load with a tool or a metric.

## Acceptance Criteria

- [ ] **three-axes** — `socle/agents/skills/code-review/SKILL.md` describes
  three axes (Standards, Spec, Simplicity), its `description` frontmatter
  says so, and its step 4 spawns three sub-agents in one turn.
- [ ] **simplicity-brief** — the skill carries the Simplicity sub-agent's
  prompt: the two questions, the checklist of "The checklist" below, the
  method of "Finding the existing way" below, and the finding format of
  "What a finding says" below.
- [ ] **spec-read-last** — the Simplicity brief tells the reviewer to judge
  the diff and its references first, and to open the spec only to say, for
  each finding, whether its source is the code or the spec.
- [ ] **spec-route** — step 6 of `socle/agents/workflow.md` says that a
  finding whose source is the spec goes to the Architect, who rules or
  brings it to the human; the Mason does not simplify against the spec on
  its own.
- [ ] **aggregate-three** — the skill's aggregate step presents three
  sections, never merged or reranked, with one summary line per axis.
- [ ] **why-three** — `socle/agents/methodology.md`'s section on the review
  axes says why Simplicity is an axis of its own.
- [ ] **upstream-note** — the skill's `x-upstream.changes` names the third
  axis as a chisel adaptation.
- [ ] **copies-identical** — `.agents/` holds the same text as `socle/agents/`
  for every file touched.
- [ ] **intention** — an intention under `socle/intentions/unreleased/` is
  listed in `src/socle-files.ts`, classification `informational`.
- [ ] **dry-run-olympe** — the new axis, run by hand on a lot of Olympe's
  `api-etape2` branch of at most 3,000 changed lines, returns at least one
  finding on types or on test volume, each with its simpler version; the
  report and its real token count are written in the work document.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

## Seams

- **The `code-review` skill**: its input is unchanged (a fixed point); its
  output gains a `## Simplicity` section beside `## Standards` and
  `## Spec`.
- **The Mason's step 6**: a Simplicity finding is fixed like any finding
  when its source is the code; reported to the Architect when its source is
  the spec.

## Architecture

**System design.** One more parallel sub-agent in the skill, same tier
(frontier), same freshness, its own brief. It reads three things in this
order: the diff, a few reference files it picks itself at the fixed point,
then the spec. No new file, script or glue line.

```
code-review ─┬─ Standards  (written rules + smell baseline)  ─┐
             ├─ Spec       (spec document)                    ├─ three sections, side by side
             └─ Simplicity (diff → neighbours → spec, last)   ─┘
```

### The form: a third axis, not a wider Standards

Each axis judges against one source of truth. Standards' source is what the
repo **wrote**; Spec's is the **spec**. Simplicity's source is the **code
already there**, plus a judgement that can find the spec itself too heavy.
That is a different source, a different reading (it must open files outside
the diff), and a verdict the other two cannot give. Folded into Standards,
it would be read against the written rules again, and would inherit the
anchor the hole came from. The skill's own reason for separate axes holds
here: kept apart, one axis cannot mask another. The price is one more
sub-agent per review (see "Cost").

### Finding the existing way

The reviewer finds its references itself, bounded:

1. From `git diff --stat`, take each file the diff **adds**, and each file
   it changes heavily.
2. For each, look at the fixed point (`git ls-tree -r --name-only
   <fixed-point>`) for its **neighbours**: same directory first, then the
   same kind of file elsewhere (same suffix or name pattern, as
   `*.service.ts`, `*.routes.ts`, `*.test.ts`). Pick the one closest in
   role, the most recently changed when several fit.
3. Add any model the repo names in writing: "follow module X" in
   `AGENTS.md`, `CONTRIBUTING.md` or the reading list of
   `.agents/project.md`.
4. Read **at most three** reference files, at the fixed point
   (`git show <fixed-point>:<path>`), with their tests when the diff adds
   tests: about 1,000 lines in all. For a file the diff only changes, its
   unchanged part is the reference.
5. Name the references used at the top of the report. A diff with no
   neighbour (the first module of its kind) says so, and the second
   question is then not asked.

### The checklist

Each item is a judgement call, read as *what it is → the simpler version*.
The smell baseline of Standards already covers Speculative Generality,
Middle Man and Duplicated Code; this list does not repeat them.

- **Off the pattern** — the diff does something a neighbour already does,
  in another way: layout, naming, error handling, validation, data access,
  wiring, test style, a new library. → do it the neighbour's way; cite the
  file.
- **Reinvented** — a helper, type or component that exists already. →
  reuse it.
- **Type ceremony** — types, interfaces, generics or enums beyond what the
  neighbours declare for the same need; a type that mirrors another; a
  type per call site. → derive from the canonical type, or inline.
- **Too many pieces** — files, functions, classes or layers that only pass
  through (the deletion test of the `codebase-design` skill); a seam with
  one adapter. → merge them, inline them.
- **Test volume** — more tests than the neighbours have for the same
  weight of code; several tests of one behaviour; tests below the agreed
  seams; tests of the framework. → keep the seam tests; name the ones to
  delete.
- **Tangled conditions** — a compound condition with no named
  intermediates; nesting where an early return reads flat. → named
  booleans, early returns.
- **Shared too early** — a shared abstraction made to remove a small
  repetition, tying modules that change apart. → a little copying.
- **Clever** — framework magic or a non-idiomatic trick the reviewer had
  to decode. → the plain idiom.

### What a finding says

At most seven findings, ordered by what they would remove, the heaviest
first. Each one:

- **where**: the file and hunk;
- **what it costs**: what a reader must hold in mind to follow it;
- **against**: the reference file it compares with, or "no neighbour";
- **simpler**: the simpler version itself, a sketch of ten lines at most
  or the exact moves (delete X, inline Y into Z, reuse W from V), and the
  lines it would remove, roughly;
- **source**: `code`, or `spec` with the spec line quoted and the simpler
  requirement proposed.

"This is complicated" with no simpler version is not a finding. The report
ends with one line: *simplest that does the job: yes, or no*, and the
finding that weighs most.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

1. **A third axis** (proposed): see "The form". Open question 1.
2. **The spec is read last** (proposed). Pierrick: « peut-être moins ancré
   dans les specs ». The reviewer forms its findings from the diff and the
   neighbours, then opens the spec only to give each its source. Read
   first, the spec would make its complexity look like a requirement.
3. **A spec-source finding is the Architect's** (proposed). Step 5 already
   says reality that contradicts the spec is reported; a simpler
   requirement is a change of spec, which belongs to the Architect and, for
   a decision of the human, to the human.
4. **Frontier tier** (proposed), as the two other axes: telling the simplest
   version apart is judgement, the work the cheaper tiers do worst.
5. **Seven findings at most, under 500 words plus sketches** (proposed): a
   flood of nitpicks is itself load. The other axes ask under 400 words; the
   sketches need the room.
6. **When the two questions disagree**: open question 2.
7. **Writing**: the skill and the intention go through the
   `writing-for-agents` skill, as `CONTRIBUTING.md` asks.

## Open questions for Pierrick

1. **The form.** a) A third axis, Simplicity, a third sub-agent
   (recommended: its own source of truth, cannot be masked, can judge the
   spec). b) Standards widened with the two questions: no extra sub-agent,
   but read again against the written rules, where the hole came from.
2. **When the existing way is not the simplest.** a) The existing way wins
   inside the diff; a simpler pattern than the neighbours' is reported once
   as a note about the codebase, not a finding to fix in the task
   (recommended: two ways of doing one thing cost more than one heavy way).
   b) Simplicity wins: the finding asks for the simpler way even against the
   neighbours.
3. **Ask the same two questions at the plan reading too?** a) Yes, one
   sentence in step 4 of `workflow.md`: the Architect asks them of the
   plan, where 19,000 lines are still a page (recommended: the cheapest
   place to catch it, and Olympe's step 2 would have been stopped there).
   b) No, the code review only, as asked.
4. **Where the reference code comes from.** a) The neighbours the reviewer
   finds, plus what the repo already names in writing (recommended: no new
   setting to keep up). b) Also a new optional line in `.agents/project.md`
   naming the model modules (the boilerplate's examples, say), asked by the
   setup questionnaire: a sure reference, but one more glue line and an
   intention of kind `migration`.

## Cost

An estimate, not measured: the dry run of the `dry-run-olympe` criterion
measures it.

One review sub-agent holds, at its largest: its own runtime prompt and
tools (about 15,000 tokens), the brief (about 2,000), the diff (about 13
tokens a line: 40,000 for Olympe's 3,000-line `api-lot2`, 7,000 to 20,000
for a usual 500-to-1,500-line task), the references (about 1,000 lines,
13,000 tokens), and its searches (about 3,000). For a usual task that is
40,000 to 55,000 tokens at the peak, over about a dozen calls: some 400,000
to 550,000 input tokens read, most of them from the cache, and 4,000 to
6,000 out. Against the Standards sub-agent, which reads no references, that
is about 40 % more; since the Spec sub-agent costs about what Standards
does, the third axis adds about two thirds to today's two-axis review.

## Testing Strategy

- The gate commands (`deno task check`, `deno task test`): the socle files
  list, the identical copies, the intention's format.
- The dry run of `dry-run-olympe`: the brief run by hand on a real lot whose
  review missed what Pierrick saw. Read-only on Olympe's repo.

## Slices & Dependencies

- **Slices:** one pass (blocked by: Pierrick's answers to the open
  questions).
- **Files to modify:** `socle/agents/skills/code-review/SKILL.md`,
  `socle/agents/workflow.md` (step 6; step 4 if question 3 is a),
  `socle/agents/methodology.md`, their copies in `.agents/`, a new
  `socle/intentions/unreleased/<slug>.md`, `src/socle-files.ts`,
  `PHILOSOPHY.md` (its line on the review: "two-axis").
- **Files to avoid:** the `chisel-lead-ux` task's files, on review on their
  own branch; the Standards and Spec briefs and the smell baseline.

## Deliverables

- [ ] The skill, the workflow and methodology changes, the intention.
- [ ] The dry run's report and token count, in the work document.

## References

- `.agents/skills/code-review/SKILL.md`, "Why two axes": the reason the axes
  stay separate.
- `.agents/skills/codebase-design/SKILL.md`, "Principles": the deletion test
  and "one adapter means a hypothetical seam".
- `.agents/workflow.md`, steps 5 and 6: reality that contradicts the spec is
  reported; the Mason fixes or answers each finding.
- https://github.com/zakirullin/cognitive-load: the sections "Complex
  conditionals", "Nested ifs", "Too many small methods, classes or modules",
  "Abusing DRY principle", "Tight coupling with a framework", "Layered
  architecture", "Cognitive load in familiar projects".

## Notes

- Architect, 27/11 15:48: the spec is written from Pierrick's words relayed
  by the secondmate `promethee`; no grilling yet. The four open questions go
  to Pierrick through it.

## Retrospective

Added at the close.
