# What the test suite protects

One page. `test/run.sh` is a CLI-seam suite, split across `test/lib.sh`
(helpers), `test/installer.sh` (the group bodies), and `test/run.sh` (the
runner): build a throwaway repo from a fixture, run `chisel init|update|check`
on it, read the resulting file tree. No mocks, no framework.

Run it: `bash test/run.sh` (everything) or `bash test/run.sh <group>` (one
group by name, e.g. `bash test/run.sh guards`). It prints a `PROTECTS:` line
per group, then `N scenarios, M assertions passed, K failed`. **Scenarios are
the coverage number** — one situation held down end to end. Assertions are how
much detail each situation is checked in; a big assertion count is not a big
safety net.

## The groups

| Group | What it protects | What a failure means |
|---|---|---|
| `init` | Every socle file lands in a repo that predates chisel (tree matches `test/fixtures/golden-tree.txt`), user content survives verbatim, and the rendered managed block matches the source template. | The installer stopped shipping a file, damaged a repo it does not own, or drifted from its own template. |
| `idempotence` | Running `init` again changes nothing: no second managed block, a §E line a human unticked stays unticked. | `init` is no longer safe to re-run — and it runs again on every version bump. |
| `boilerplate` | A repo with no `AGENTS.md` gets exactly the golden tree too. | Two equipped repos would drift apart from day one. |
| `update` | `update` refreshes every managed file (including re-rendered agent definitions) and never touches `project.md`, the journal, or a personal `user.md`. | An upgrade stopped propagating, started overwriting the project's own decisions, or touched a gitignored personal file. |
| `check` | `check` exits 0 clean, exits 1 on drift in a skill, `discipline.md`, or a generated agent definition, and names the file. | Drift detection is blind or noisy. |
| `symlink` | chisel finds its own socle through a symlinked bin — how every `npx` install runs it. | Works from the repo, broken for every real user. |
| `render` | The three formula presets parse as TOML with gates at exactly 3/1/0 (by parsing, never by grep); every generated agent definition carries its profile's body byte for byte. | A gate moved to the wrong step, or a generated definition paraphrased a role contract. |
| `guards` | `update` refuses a repo still carrying the retired v1 layer and writes nothing when it refuses; a file chisel did not install is never adopted, overwritten, or flagged as drift. | The two bugs the v2 audit proved are back. |
| `integrity` | Every internal pointer of the installed socle resolves, with a two-way waiver (BY DESIGN / DEBT) for the ones that are meant to dangle. Mutation-tested against itself. | A reader is sent to a file that is not there, or the waiver is silently hiding a hole. |

## Three standing rules

1. **Behavior only.** A test verifies the CLI seam (what `bin/chisel.sh`
   writes, overwrites, or reports) or a parsed structure (TOML, a tree
   listing, a manifest). It never pins a sentence of the socle's own prose —
   that prose is the project's normal editorial surface, and a grep on it
   just proves the editor also edited the test. An acceptance criterion
   written as a wording check is verified once at review time, not committed.
2. **Net budget per slice: +10 assertions max, no new group without a
   deletion or merge.** The reviewer counts the net, not the green.
3. **600-line cap, enforced by the runner itself** (`test/run.sh` sums
   `lib.sh` + `installer.sh` + `run.sh` and fails past 600). A cap the runner
   checks is the only one nobody can forget.

**What counts as a pointer** (`integrity` group): (1) any `.agents/...` path
in the text; (2) a markdown link to a sibling file — `](name.md)` or
`](./name.md)`. Deliberately not pointers: deep relative links, illustrative
paths inside another project's tree, placeholders.
