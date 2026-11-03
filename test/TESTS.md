# What the test suite protects

One page. The suite is a CLI-seam suite: build a throwaway repo from a
fixture, run `init`, `update`, `record` or `check` on it as a real process,
read the file tree and the report that come out. No mocks, no framework
beyond `Deno.test`. A case no release ships yet, such as a pending
intention that needs judgement, runs a copy of the package built in the
test (`packageWith`). Helpers live in `test/helpers.ts`; every group is one or more
`*.test.ts` file.

Run it: `deno task test` (everything), `deno test -A test/check.test.ts` (one
file), or `deno test -A test/ --filter journal` (one group by name). A test
that fails **keeps its throwaway repo** and prints the path — the evidence is
still on disk when you go looking.

`deno task check` type-checks `src/`, `test/` and `scripts/`, lints, and checks the
formatting. Both tasks are green before a commit.

## The groups

| Group | What it protects | What a failure means |
|---|---|---|
| `init` | Every socle file lands in a repo that predates chisel (tree matches `test/fixtures/golden-tree.txt`), user content survives verbatim, the rendered managed block matches the source template, and an import appended to a file with no trailing newline still gets its own line. | The installer stopped shipping a file, damaged a repo it does not own, or drifted from its own template. |
| `arrange` | A first `init` (no manifest) takes an inventory: OpenSpec, Spec Kit (`.specify/` or a `specs/<name>/` with its plan or tasks), a task folder holding a file, decision records, a `CONTEXT.md`, another agent's rules, an `AGENTS.md` with text beyond its title or a `CLAUDE.md` with more than the import, `.beads/`, the first chisel version, a linked path. On any of them it stages `.chisel-workspace/` with an install session and the reference tree, names each kind and path and the setup skill, writes nothing else and exits 3; a repo with none of them, or with a manifest, installs and exits 0; an existing workspace makes `init`, `--arranged` included, refuse; `--arranged` skips the inventory and still refuses a linked path. Tests install the fixtures with `--arranged`. | A first install started talking over a method the repo already had, or staging a repo that had nothing to arrange. |
| `idempotence` | Running `init` again changes nothing: no second managed block, a §E line a human unticked stays unticked, and every file hashes the same. | `init` is no longer safe to re-run — and it runs again on every version bump. |
| `boilerplate` | A repo with no `AGENTS.md` gets exactly the golden tree too. | Two equipped repos would drift apart from day one. |
| `journal` | `init` writes `JOURNAL.md` once, dated today, with one entry; a repo that already has its own journal, under either older name (`CHANGELOG.md`, `LOG.md`), keeps it, is told why, and gets its brand-new glue pointed at the file that exists; an existing journal is never rewritten. | An installer started inventing or overwriting a project's own narration. |
| `update` | `update` refreshes every managed file, naming on an `overwritten:` line each one someone edited, and never touches `project.md`, the journal, or a personal `user.md`; a file that left the managed set is removed when its content still matches what was installed and named on an `orphaned:` line when it does not; a 0.1.1 install (formulas, profiles, definitions rendered into `.claude/agents/` and `.codex/agents/`, all in its manifest) comes out with each of them reported `removed:` and gone, the emptied directories with them, and the glue's retired §E lines on `stale:` lines; a definition the user wrote is left alone and stays out of the manifest; outside `.agents/`, a template or the task id script is written only when the last manifest listed it and it is still on disk, so no second workspace grows, while a page deleted inside `.agents/` comes back. | An upgrade stopped propagating, started overwriting the project's own decisions, left its own retired files behind forever, or planted a tree the project did not keep. |
| `check` | `check` exits 0 clean and 1 on drift in a skill, `discipline.md` or `workflow.md`, naming the file; a `.claude/skills` link pointing at another directory is a missing adapter, not an adapter; a retired glue subsection or adapter line is reported on a `stale:` line and the glue is left byte-identical. | Drift detection is blind, noisy, or has started editing a file the project owns. |
| `intentions` | `init` records every shipped intention as applied, and keeps the record of a manifest that exists; `update` with nothing pending that needs judgement copies, names what it overwrote and records what it closed, counting a release up to an older manifest's version as applied; a pending `migration` or `breaking-manual` (shipped by a copy of the package built in the test) stages `.chisel-workspace/` with the checklist, the intention and the reference tree, writes nothing else and exits 3; a workspace is never overwritten and git ignores it; `record` writes an applied or skipped result and ticks the checklist, and refuses an unknown id, a misuse and a repo without manifest; `check` reports a pending intention and exits 1. | The update stopped knowing what a repo applied, copied over a change that needed judgement, wrote outside its workspace, or lost the record of a session. |
| `symlink` | chisel finds its own socle when it is reached through a symlinked package directory — what an installed package looks like. | Works from the repo, broken for every real user. |
| `guards` | `update` stages a workspace instead of copying over a repo still carrying the retired v1 layer, a repo with no manifest, or a path it would write that is a symbolic link or sits under one, naming the baseline intention, the update skill and each linked path, and exits 3; `init --arranged` refuses a linked path, naming it; a linked skill of the project's own stops neither; a repo whose method lives elsewhere with its skills linked in (built in the test, never committed) is staged by `update` and by `init`; each leaves the target, outside the workspace, and the link's destination byte-identical; a file chisel did not install is never adopted, overwritten, or flagged as drift. | A refusal started writing, chisel wrote through a link into a file it never installed, or one of the bugs the v2 audit proved is back. |
| `integrity` | Every internal pointer of the installed socle resolves, with a two-way waiver (BY DESIGN / DEBT) for the ones that are meant to dangle, mutation-tested against itself, and no installed page names the pieces the first version's layer carried; the socle file list the package ships names exactly the files that are there; every shipped intention parses under the id its path gives it, and the parser refuses a broken one; the installed tree carries no renamed skill name and no invented numeric limit. | A reader is sent to a file that is not there, the waiver is silently hiding a hole, a file stopped shipping, or an intention would break every update. |
| `promote-intentions` | At a release, the maintainer's script moves each `unreleased/` intention to the release folder, numbered after the files already there, as a git rename, with its id rewritten and the shipped list renamed and kept sorted; a version `deno.json` does not declare and an empty `unreleased/` move nothing. | A release shipped intentions under the wrong id or folder, or stopped shipping one. |
| `usage` | `--help` names the commands, `record` among them, the exit codes, 3 among them, and the prerequisite; `--version` prints what the package declares; an unknown command and an argument too many exit 2 naming the offender. | The command line lies about itself, or a typo passes for a command. |

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
