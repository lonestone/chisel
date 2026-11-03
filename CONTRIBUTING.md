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
says so in its description: "No intention: <why>." The "Intention gate"
check (`deno task release-check gate origin/main`) fails a pull request that
changes `socle/`, outside `socle/intentions/`, without adding a file under
`unreleased/`. When such a change truly leaves a repo nothing to act on, add
the label `no-intention` with that line.

## Commits and pull request titles

Every commit is conventional: `type(scope): description`, in lower case,
without a full stop. The types and the scopes are listed once, in
`scripts/commit-lint.ts`. Run `deno task hooks` once in a clone: it installs
a commit-msg hook that refuses any other message. The "Commits" check lints
every commit of a pull request (the history before `b7f121c` is exempt).

Pull requests are squash-merged, and the squash commit is the pull request's
title and description: release-please reads it on `main` to choose the next
version and write `CHANGELOG.md`. `feat` raises the minor version, `fix` the
patch, and `type(scope)!:` marks a breaking change, which also raises the
minor while chisel is in 0.x. The "PR title and description" check lints the
title like a commit header, and asks for a description in prose, without an
image or a task list.

## At a release

release-please keeps a **Release PR** open on `main`, titled
`chore(release): release X.Y.Z`. It carries the version in `deno.json` and
`.release-please-manifest.json`, and `CHANGELOG.md`, which nobody edits by
hand. A maintainer prepares it with the `chisel-release` skill, last, just
before merging, because every push to `main` rewrites its branch:

```sh
deno task promote-intentions <version>
```

It moves each `unreleased/<slug>.md` to `<version>/NN-<slug>.md`, numbered
after the files already there, rewrites its id, and updates
`src/socle-files.ts`. It refuses, moving nothing, when the version is not
the one in `deno.json` or when `unreleased/` is empty. A repo that recorded
the unreleased id is not asked again: the record counts for the promoted
one. The "Intention promote" check fails the Release PR until every
intention is promoted, and its message is the command to run.

A human merges the Release PR. The same CI run tags `vX.Y.Z`, adds the
release's intentions to the GitHub Release (`deno task release-check notes
X.Y.Z`), refuses to publish when the tag and `deno.json` disagree or when an
intention is left unreleased, and publishes to JSR by OIDC. Nobody runs
`deno publish` by hand. The repository settings this needs are in
`scripts/github-repo-settings.md`.

## Gates

`deno task check` and `deno task test` pass before any pull request is
opened. `deno fmt` covers `src/`, `test/` and `scripts/` only; never run it
on markdown.
