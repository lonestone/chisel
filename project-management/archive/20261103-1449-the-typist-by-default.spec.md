# The Typist by default

**Status:** done

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

On 2026-11-03 chisel's own task on intentions ran 383 calls, all at the
frontier tier, and no Typist: the workflow says "By default the Crewmate
types itself", so nothing sent the typing to a cheaper model. The Owner,
reported by the Architect: chisel has a Typist role, the tier cascade of
`.agents/reference.md` should resolve its model, and it should happen by
default. The Owner said "ok" to the new default below, in a pull request of
its own.

## Scope

**Included:**
- the new default in `socle/agents/` (workflow, methodology, reference) and
  in chisel's own copies under `.agents/`;
- chisel's own docs that state the old default: `CHARTER.md`, `README.md`,
  `PHILOSOPHY.md`;
- an `informational` intention under `socle/intentions/unreleased/`, listed
  in `src/socle-files.ts`;
- the ruling in the decisions record, and the journal entry.

**Not Included:**
- any change to the tier cascade or to the `project.md` and `user.md`
  templates;
- the archived tasks and the history of the decisions record.

## Acceptance Criteria

- [x] **typist-by-default** — `workflow.md` says the Crewmate launches a
  Typist once the plan is approved, at the *mid* tier, or *cheap* when the
  plan is mechanical, the model resolved by the cascade of `reference.md`.
- [x] **self-typing-is-the-exception** — the Crewmate types itself only for
  a retouch of a few lines, or while the plan is not settled, and says so in
  the work document.
- [x] **reviewers-frontier** — the reviewers stay at the *frontier* tier.
- [x] **no-old-default** — `grep -rn "types itself\|types its own plan\|when there is one" socle .agents CHARTER.md README.md PHILOSOPHY.md`
  finds no statement of the old default.
- [x] **copies-identical** — `socle/agents/{workflow,methodology,reference}.md`
  and `.agents/` match byte for byte.
- [x] **intention-ships** — the intention is in `src/socle-files.ts` and
  `deno task release-check gate origin/main` passes.
- [x] **suite-green** — `deno task check` and `deno task test` pass.

## Seams

- `.agents/workflow.md`, "The roles" and step 5 — what a Crewmate reads to
  decide who types.

## Architecture

**System design:** a doctrine change. `workflow.md` carries the rule,
`reference.md` the tiers per role, `methodology.md` the reason; each meaning
in one of them.

## References

- `.agents/reference.md`, "Model tiers" — the tiers and their cascade.
- `CONTRIBUTING.md`, "Intention authoring" — where the intention goes.
