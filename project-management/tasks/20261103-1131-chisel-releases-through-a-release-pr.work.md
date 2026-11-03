# Work — Chisel releases through a Release PR, after the boilerplate

Spec: `project-management/tasks/20261103-1131-chisel-releases-through-a-release-pr.spec.md`.

## Program Design

**Approval:** approved by the Owner, 2026-11-03 (through promethee,
message 243328943825600512), I1 to I7 as proposed, with three amendments
below. Before them, the commits of v2 were not conventional.

### Amendments of the approval

- **(a) Conventional commits on every commit**, not only PR titles,
  following the boilerplate (its `commitlint.config.ts`, a `commit-msg`
  hook through lefthook, `pr-lint.yml`) in Deno, without node:
  `scripts/commit-lint.ts` holds the types and the scopes (the single
  source) and validates
  - one message (`message <file>`, the `commit-msg` hook, written into
    `.git/hooks/` by `deno task hooks`);
  - every commit of a range (`range <base>`, a CI job on each PR);
  - a PR's title and description (`pr <event.json>`, the "PR title and
    description" job).
  The history of v2 before this task is exempt: commits that are
  ancestors of `b7f121c` (the last commit written without the rule) are
  not checked. Nothing pushed is rewritten. The v2 → main PR is squashed
  under a `feat(...)` title, so `main` only ever sees conventional
  commits.
- **(b) GitHub settings in a script**, as the boilerplate's
  `scripts/configure-github-repo.sh` and `scripts/github-repo-settings.md`
  do (dry run by default, `--apply`): squash only, `PR_TITLE`/`PR_BODY`,
  the `no-intention` label. It also does what the boilerplate's script
  leaves to the UI: Actions may create pull requests (I3), and the
  protection of `main` (I5: a PR, the required checks, no force-push, no
  deletion), refused when `main` already has a protection. Applied by
  the Crewmate with the Owner's go, once the v2 → main PR is open and its
  checks are green, so that it never blocks itself.
- **(c) I1 is the Owner's**, in JSR's interface: he is told when to do it
  (before the first Release PR is merged).

**Scopes**: `cli`, `socle`, `skills`, `intentions`, `release`, `tasks`,
`tooling`. Every header is `type(scope): description`, as in the
boilerplate. The Release PR title becomes `chore(release): release
${version}`.

### 1. `scripts/release-check.ts` (tested first)

The script holds one exported function per subcommand. Each returns
`{ ok: boolean, message: string }` and runs git through `Deno.Command`, the
way `promote-intentions.ts` does. `import.meta.main` maps a result to exit
code 0 or 1.

- `gate(root, base)`: runs `git diff --name-status <base>...HEAD`.
  - It needs an intention when a path under `socle/` but outside
    `socle/intentions/` changed.
  - It is satisfied by an added (`A`) file `socle/intentions/unreleased/*.md`.
  - Its message names both ways out: add an intention (CONTRIBUTING.md) or
    apply `no-intention`.
- `promoted(root, base)`: reads the version from `deno.json`. The Release
  PR's `deno.json` already carries the new version.
  - It lists `unreleased/` at HEAD (it must be empty) and on `base` (via
    `git ls-tree`).
  - Each slug from `base` must be at `socle/intentions/<version>/NN-<slug>.md`
    with `id: <version>/<slug>`.
  - Its message is `deno task promote-intentions <version>`, followed by
    what is missing.
- `publish(root, tag)`: requires `tag === "v" + version` and an empty
  `unreleased/`.
- `notes(root, version)`: reads `socle/intentions/<version>/*.md` with the
  existing frontmatter parser from `src/intentions.ts` (id, classification),
  plus the `# ` title. It prints a Markdown list under
  "## Intentions of this release". When there is none, it prints one line
  saying the release ships no intention.
- The deno task is `release-check`: `deno run --allow-read
  --allow-run=git scripts/release-check.ts`.

Tests in `test/release-check.test.ts` reuse `copyOfRepo`. It moves from
`promote-intentions.test.ts` to `test/helpers.ts`, so both use it. Cases as
in the spec's Testing Strategy. Red first, one commit at green.

### 2. Workflows and release-please files

- `ci.yml`, on `pull_request` and `push: main`:
  - `denoland/setup-deno@v2` (2.x), then `deno task check` and
    `deno task test`;
  - on a PR, two more jobs: "PR title and description" (`commit-lint pr`)
    and "Commits" (`commit-lint range`, skipped on the Release PR).
- `intention-gate.yml`: `fetch-depth: 0`, then skip under `no-intention` or
  `autorelease: pending`, then `deno task release-check gate
  origin/${base_ref}`.
- `intention-promote.yml`: only under `autorelease: pending`; runs
  `deno task release-check promoted origin/${base_ref}`.
- `release.yml`, on `push: main` plus `workflow_dispatch(tag)` to retry a
  failed publish:
  - **job `release-please`**: `googleapis/release-please-action@v4` with
    `GITHUB_TOKEN`, which outputs `release_created` and `tag_name`;
  - **job `publish`**: needs it, and runs only when created or dispatched.
    It has `permissions: contents: write, id-token: write` (write only for
    `gh release edit`). It checks out the tag, runs `release-check publish
    $TAG`, then `deno publish`, then `release-check notes` appended to the
    release body.
  - A comment at the top: a human merges the Release PR; never auto-merge.
- `release-please-config.json`:
  - `release-type: simple`, `include-v-in-tag: true`,
    `include-component-in-tag: false`, `bump-minor-pre-major: true`;
  - `pull-request-title-pattern: "chore: release ${version}"`;
  - `extra-files: [{type: json, path: deno.json, jsonpath: $.version}]`;
  - `bootstrap-sha`: the commit `main` points at when the task lands
    (today `626b31d`, the 0.2.4 bump);
  - changelog sections as in the boilerplate.
- `.release-please-manifest.json`: `{".": "0.2.4"}`.
- `simple` also writes `version.txt`. If it does, it is kept and ignored by
  publish (`publish.include` names neither it nor `CHANGELOG.md`). To check
  at implementation in release-please's docs; if it can be avoided, it is.

### 3. Skill and docs

- `.agents/skills/chisel-release/SKILL.md`, chisel's own and not in socle.
  - Preflight: it runs in chisel itself, on the open Release PR, and reads
    the version from `.release-please-manifest.json` on that branch.
  - Steps: `deno task promote-intentions <version>`; check each promoted
    intention against `git diff v<previous>..HEAD` (that its Reference
    Paths still exist and its gaps match the diff); the gates; push; stop.
  - It never tags, merges or publishes. Promote last.
- README "To release": the Release PR, in three sentences, pointing at
  CONTRIBUTING.md.
- CONTRIBUTING.md:
  - "At a release" is rewritten around the Release PR;
  - a "Pull request titles" section;
  - the label `no-intention` is named where the "No intention" line is.
- `.agents/project.md` §I: "Publish: the human merges the Release PR; CI
  tags and publishes. Before merging: `chisel-release`."
- `test/TESTS.md`: a `release-check` row.
- `.agents/project.md` stays chisel's glue, and no socle file changes, so
  no intention is needed. The PR description says "No intention: chisel's
  own release machinery."

### Open points for the Owner (also in the spec, "Infra")

I1 to I7, and the v2 → main squash merge with a conventional title.

## Worklog

- 2026-11-03: spec and plan written from the boilerplate's workflows,
  read in `~/projects/lonestone-boilerplate`. Read-only check of the
  repo: no `.github/`, no tag, all three merge methods allowed, default
  labels only.

## Implementation Checkboxes

- [x] Plan approved
- [x] `release-check` red, then green (commit)
- [x] `commit-lint` red, then green, hook task (commit)
- [ ] Workflows and release-please files (commit)
- [ ] GitHub settings script, dry run shown (commit); applied after the PR
- [ ] Skill and docs (commit)
- [ ] code-review, findings recorded
- [ ] Close: retro, journal, archive

## Notes & Snippets

## Diff-Review Findings
