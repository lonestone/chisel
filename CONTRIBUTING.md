# Contributing to chisel

Chisel ships a socle that other repos install and update. A change to
`socle/` reaches those repos through `chisel update`, so every change a repo
must act on carries an **intention**: the page an agent reads, in that
repo, to bring it to the new state. This file is the canon for writing one.
The format itself is [socle/intentions/TEMPLATE.md](socle/intentions/TEMPLATE.md).

## Intention authoring, in the change's own pull request

Write the intention **in the same pull request as the change**, while the
reason is fresh. Whoever cuts the release does not reconstruct five pull
requests' worth of "why".

1. Copy `socle/intentions/TEMPLATE.md` to
   `socle/intentions/unreleased/<slug>.md`. No `NN-` prefix: the file is
   `<slug>.md`, its frontmatter `id:` is `unreleased/<slug>`. The slug
   names the change in a few words, lowercase with dashes, unique across
   every release.
2. Add the file to `src/socle-files.ts`, or it does not ship.
3. Choose its classification: `automatic` when the copy `update` makes is
   the whole change; `informational` when the repo has nothing to do but
   should know; `migration` when an agent must act on the project's own
   files; `breaking-manual` when a human decides before anything moves.
4. Fill every section: **Goal**, **Why**, **Applies When**, **Do Not Apply
   When**, **Observable Gaps** (each with a signal to observe and a binary
   "Done when"), **Out of Scope**, **Reference Paths** (`copy` or `adapt`
   on each), **Validation**, **Record Result**. **Why is required**: it is
   the decision nobody can invent later.
5. Keep it narrow: one bounded change, never "update the method".

Not every pull request needs one. A refactor, a test, or a change to
chisel's own docs or tasks that leaves `socle/` as installed repos see it
says so in its description: "No intention: <why>."

## At a release

Before publishing, with `deno.json` already at the new version:

```sh
deno task promote-intentions <version>
```

It moves each `unreleased/<slug>.md` to `<version>/NN-<slug>.md`, numbered
after the files already there, rewrites its id, and updates
`src/socle-files.ts`. It refuses, moving nothing, when the version is not
the one in `deno.json` or when `unreleased/` is empty. A repo that recorded
the unreleased id is not asked again: the record counts for the promoted
one. Then run the gates (`deno task check`, `deno task test`).

## Gates

`deno task check` and `deno task test` pass before any pull request is
opened. `deno fmt` covers `src/`, `test/` and `scripts/` only; never run it
on markdown.
