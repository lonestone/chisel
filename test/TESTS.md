# What the test suite protects

One page. `test/run.sh` is a CLI-seam suite: it builds a throwaway repo from a
fixture, runs `chisel init|update|check` on it, and reads the resulting file
tree. No mocks, no framework — file tree in, file tree out.

Run it: `bash test/run.sh`. It prints a `PROTECTS:` line per group, then
`N scenarios, M assertions passed, K failed`. **Scenarios are the coverage
number** — one situation held down end to end. Assertions are how much detail
each situation is checked in; a big assertion count is not a big safety net.

## The groups

| # | Group | What it protects | What a failure means |
|---|---|---|---|
| 1 | brownfield init | Every socle file lands in a repo that predates chisel, and nothing the project already had is touched — user headings, notes and files survive verbatim. | Either the installer stopped shipping a file, or it damaged a repo it does not own. Both are release blockers. |
| 2 | idempotence | Running `init` again changes nothing: no second managed block, and a §E line a human deliberately unticked stays unticked. | `init` is no longer safe to re-run — and it is run again on every version bump. |
| 3 | boilerplate init | A repo with no `AGENTS.md` and its own layout gets exactly the same installed tree as a brownfield one, and keeps its own files. | The result of `init` depends on what the repo looked like before. Two equipped repos would drift apart from day one. |
| 4 | update | `update` brings every managed file back to the socle's version — including the definitions re-rendered from the profiles — and never touches `project.md` or the changelog. | Either an upgrade stopped propagating, or it started overwriting the project's own decisions. |
| 5 | check | `check` exits 0 on a fresh install, exits 1 on any local edit to a managed file, and names the file that drifted. | Drift detection is blind or noisy: an edited socle file ships unnoticed, or a clean repo looks dirty. |
| 6 | symlink resolution | chisel finds its own socle when the binary is reached through a symlink — how every `npx` install runs it. | Works from the repo, broken for every real user. |
| 7 | formulas | The three presets are the same seven steps in the same order; the ONLY difference is which steps wait for a human — `chisel-controlled` waits at `plan`, `type`, `close`; `chisel-supervised` waits once, at `plan` (that is the spec approval); `chisel-auto` never waits. Bodies: supervised carries auto's byte for byte, auto only ADDS to controlled. | The presets have started diverging in their prose, or a gate moved. A gate on the wrong step means a human is asked at the wrong moment — or not at all. |
| 8 | profiles | Every role states its mission, tier, prohibitions, escalation and inputs; each tool's definition carries the profile body verbatim; a role named by a step has a contract. And the proposal door holds its three properties: every refactor found is REPORTED (never swallowed, never done quietly), the reporter EVALUATES (size, risk, can the task still be delivered cleanly) while the receiver DECIDES, and reporting blocks only when clean delivery is impossible without a decision. | A role contract lost a section, or a paraphrase crept into a generated definition. If the door lost a property: agents stop reporting improvements and quality decays quietly, or agents act on core code alone, or every good idea becomes an interruption that stops the work. |
| 9 | model tiers | The socle asks for a LEVEL of work, resolves it in exactly one documented place, and never writes, reads or flags a dev's personal `user.md`. | Either a second resolution rule appeared (two sources, one question), or the installer touched a personal, gitignored file. |
| 10 | setup v2 | The questionnaire speaks plain human language on screen (no jargon, no section letters), offers only what is actually supported, explains every option in one line, and writes back one section at a time. | The setup started leaking toolkit vocabulary, offering an unsupported case, or rewriting sections the user did not answer. |
| 11 | installer guards | `update` refuses a repo still carrying the retired v1 layer (`.agents/rules/`, `.agents/workflows.md`) and writes nothing when it refuses; a file chisel did not install is never adopted, never overwritten, never reported as drift. | The two bugs the v2 audit proved are back: a repo with two normative discourses side by side, or another tool's file adopted by chisel and then flagged as "diverged" when its owner edits it. |
| 12 | referential integrity | Every internal pointer of the INSTALLED socle resolves to a file that exists. | A reader — human or agent — is being sent to a file that is not there. This is the class of bug that shipped in v2's first commits. |
| 13 | neutrality | The socle names no model, no vendor tool in prose, no coordination backend in a formula, and no retired mode label — anywhere under `socle/`, and in the generated definitions too. | A vendor has been welded into the socle. Every equipped repo would have to edit socle files to change tool, model or database. |

## Two rules worth knowing before you read the code

**What counts as a pointer (group 12).** Only two shapes, so that the walk is
honest about what it checks: (1) any `.agents/...` path in the text, trailing
punctuation and trailing `/` cut; (2) a markdown link to a **sibling** file —
`](name.md)` or `](./name.md)`, no remaining slash, real extension — resolved
next to the file carrying it. Deliberately NOT pointers: deep relative links,
illustrative paths inside some other project's tree (`./src/billing/CONTEXT.md`
in the domain-modeling skill), and placeholders. The group also mutation-tests
itself: it plants a broken pointer in an installed file and fails if the walk
misses it.

**The waiver, and why it expires (group 12).** Pointers that dangle on purpose
or on someone else's clock are listed in one table, printed at every run as
`KNOWN GAP`, in two categories:

- **BY DESIGN** — a path that is meant not to exist. `.agents/user.md`: the
  personal file an installer must never write. It will never stop dangling, and
  that is the correct state.
- **DEBT** — a hole someone else's slice will close. `.agents/rules/task-*.md`
  and `.agents/workflows.md`, still cited by `methodology.md`, whose text
  belongs to slice 07.

Both are asserted in both directions: anything dangling that is not listed
fails, and anything listed that has stopped dangling fails too, asking for the
line to be deleted. A debt line therefore cannot outlive its debt, and a green
run never hides a known hole in silence.
