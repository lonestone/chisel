# What the test suite protects

One page. The suite is a CLI-seam suite: build a throwaway repo from a
fixture, run `init`, `update` or `check` on it as a real process, read the
file tree and the report that come out. No mocks, no framework beyond
`Deno.test`. Helpers live in `test/helpers.ts`; every group is one or more
`*.test.ts` file.

Run it: `deno task test` (everything), `deno test -A test/check.test.ts` (one
file), or `deno test -A test/ --filter journal` (one group by name). A test
that fails **keeps its throwaway repo** and prints the path — the evidence is
still on disk when you go looking.

`deno task check` type-checks `src/` and `test/`, lints, and checks the
formatting. Both tasks are green before a commit.

## The groups

| Group | What it protects | What a failure means |
|---|---|---|
| `init` | Every socle file lands in a repo that predates chisel (tree matches `test/fixtures/golden-tree.txt`), user content survives verbatim, the rendered managed block matches the source template, and an import appended to a file with no trailing newline still gets its own line. | The installer stopped shipping a file, damaged a repo it does not own, or drifted from its own template. |
| `idempotence` | Running `init` again changes nothing: no second managed block, a §E line a human unticked stays unticked, and every file hashes the same. | `init` is no longer safe to re-run — and it runs again on every version bump. |
| `boilerplate` | A repo with no `AGENTS.md` gets exactly the golden tree too. | Two equipped repos would drift apart from day one. |
| `journal` | `init` writes `LOG.md` once, dated today, with one entry; a repo that already has its own journal keeps it, is told why, and gets its brand-new glue pointed at the file that exists; an existing journal is never rewritten. | An installer started inventing or overwriting a project's own narration. |
| `update` | `update` refreshes every managed file and never touches `project.md`, the journal, or a personal `user.md`; a file that left the managed set is removed when its content still matches what was installed and named on an `orphaned:` line when it does not; a 0.1.1 install (formulas, profiles, definitions rendered into `.claude/agents/` and `.codex/agents/`, all in its manifest) comes out with each of them reported `removed:` and gone, the emptied directories with them, and the glue's retired §E lines on `stale:` lines; a definition the user wrote is left alone and stays out of the manifest. | An upgrade stopped propagating, started overwriting the project's own decisions, or left its own retired files behind forever. |
| `check` | `check` exits 0 clean and 1 on drift in a skill, `discipline.md` or `workflow.md`, naming the file; a `.claude/skills` link pointing at another directory is a missing adapter, not an adapter; a retired glue subsection or adapter line is reported on a `stale:` line and the glue is left byte-identical. | Drift detection is blind, noisy, or has started editing a file the project owns. |
| `symlink` | chisel finds its own socle when it is reached through a symlinked package directory — what an installed package looks like. | Works from the repo, broken for every real user. |
| `guards` | `update` refuses a repo still carrying the retired v1 layer and writes nothing when it refuses; a file chisel did not install is never adopted, overwritten, or flagged as drift. | The two bugs the v2 audit proved are back. |
| `integrity` | Every internal pointer of the installed socle resolves, with a two-way waiver (BY DESIGN / DEBT) for the ones that are meant to dangle, mutation-tested against itself, and only the migration skill names the pieces it retires; the socle file list the package ships names exactly the files that are there; the installed tree carries no renamed skill name and no invented numeric limit. | A reader is sent to a file that is not there, the waiver is silently hiding a hole, or a file stopped shipping. |
| `usage` | `--help` names the commands, the exit codes and the prerequisite; `--version` prints what the package declares; an unknown command and an argument too many exit 2 naming the offender. | The command line lies about itself, or a typo passes for a command. |

## Two standing rules

1. **Behavior only.** A test verifies the CLI seam (what the CLI writes,
   overwrites, or reports) or a parsed structure (a tree listing, a
   manifest). It never pins a sentence of the socle's own prose — that prose
   is the project's normal editorial surface, and a grep on it just proves
   the editor also edited the test. An acceptance criterion written as a
   wording check is verified once at review time, not committed.
2. **The fixtures are the oracle.** `test/fixtures/` is never mutated: every
   use goes through a copy under a temp root, and a golden file is compared,
   never regenerated from the code under test. `golden-tree.txt` exists
   precisely because nothing produced it.

**What counts as a pointer** (`integrity` group): (1) any `.agents/...` path
in the text; (2) a markdown link to a sibling file — `](name.md)` or
`](./name.md)`. Deliberately not pointers: deep relative links, illustrative
paths inside another project's tree, placeholders.
