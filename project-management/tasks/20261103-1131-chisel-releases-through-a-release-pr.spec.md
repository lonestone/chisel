# Chisel releases through a Release PR, after the boilerplate

**Status:** draft

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

Chisel releases by hand today. The README tells the maintainer to bump
`deno.json`, write a journal entry, commit and run `deno publish` from a
laptop. Since the task "Updates and installs read intentions", each change
also writes an intention under `socle/intentions/unreleased/`. At a release,
`deno task promote-intentions <version>` moves those into the release
folder. Nothing stops a pull request that changes `socle/` without an
intention, and nothing stops a publish that forgot the promotion: the
package would ship ids under `unreleased/`.

The Owner's direction (2026-11-03): release chisel the way the Lonestone
boilerplate releases. The boilerplate does it with these pieces:
- release-please keeps a Release PR open with the next version and a
  generated `CHANGELOG.md`;
- an "intention gate" fails a pull request that adds no intention under
  `unreleased/`, unless it carries the `no-intention` label;
- an "intention promote" check fails the Release PR while `unreleased/`
  still holds files;
- a human merges the Release PR, and the same CI run tags it and
  publishes the package through OIDC, with no stored token;
- a maintainer skill prepares the Release PR, and never tags or merges.

Chisel has no CI at all today: no `.github/`, no tag, and plain-sentence
commits rather than conventional commits.

## Scope

**Included:**
- CI on every pull request: `deno task check` and `deno task test`.
- **Intention gate**: a pull request that changes something under `socle/`
  must add a file under `socle/intentions/unreleased/`, or carry the
  `no-intention` label. The Release PR is exempt.
- **Release PR**: release-please on `main`. It bumps `deno.json`'s
  `version`, writes `CHANGELOG.md`, and opens or updates the PR titled
  `chore: release X.Y.Z`.
- **Intention promote**: on the Release PR, `unreleased/` must be empty and
  every intention that was there on `main` must sit in `<version>/` under
  its rewritten id. The error message is the command to run.
- **Publish from CI**: once the Release PR is merged, the run that tags
  it publishes to JSR through OIDC. Before publishing, it refuses when the
  tag and `deno.json` disagree or when `unreleased/` is not empty.
- **The release note**: the GitHub Release's body is the changelog section
  release-please wrote, followed by the list of that version's intentions
  (id, classification, title), generated in CI. There is no extra file to
  write.
- A **release skill** for chisel's own maintainer. It works on the Release
  PR: promote, check each intention against the diff since the last tag,
  run the gates. It never tags, merges or publishes.
- Docs: the README's "To release" paragraph, CONTRIBUTING.md ("At a
  release", "No intention"), and section I of `.agents/project.md`.

**Not Included:**
- Shipping any of this to the repos chisel equips: it is chisel's own
  release machinery, not socle.
- Any setting on GitHub or JSR. Each one is listed under "Infra, the
  Owner's" below and stays his to do; the code assumes them but does not
  make them.
- Publishing a release, or creating the first tag, inside this task.

## Infra, the Owner's (nothing is set without his go)

| # | What | Where | Why it is needed | Proposed |
|---|---|---|---|---|
| I1 | Link `@lonestone/chisel` to the GitHub repo `lonestone/chisel` | jsr.io, package settings, a scope admin | JSR accepts the OIDC token of that repo's Actions only once linked. This replaces any publish token. | Link it. |
| I2 | Secrets | GitHub repo | None needed: `GITHUB_TOKEN` plus OIDC. Exception: checks run on the Release PR only when someone pushes to it, because a PR opened by `GITHUB_TOKEN` starts no workflow. A GitHub App token or PAT would make release-please's own pushes run checks. | No secret. Checks run on the promotion push, as in the boilerplate. |
| I3 | Actions may create pull requests | Settings → Actions → General | release-please cannot open the Release PR without it. | Turn on. |
| I4 | Labels `no-intention`, `autorelease: pending`, `autorelease: tagged` | GitHub labels | `no-intention` exempts a PR from the gate. release-please creates its two labels itself if allowed, or they can be made by hand. | Create `no-intention` by hand; let release-please create its own. |
| I5 | Protect `main` | Branch rules | Without required checks, the gates only advise. | Require a PR, and require "Check and test", "Intention gate", "Intention promote". No force-push, no deletion. |
| I6 | Merge method | Repo settings | release-please reads commit titles on `main`. A squash merge makes the PR title the commit title. | Squash only, with the PR title as the commit message. |
| I7 | The JSR GitHub environment | GitHub environments | Optional: an environment with required reviewers would add a second click before publishing. | None: merging the Release PR is the consent. |

## Acceptance Criteria

- [ ] **checks-on-every-pr** — a workflow runs `deno task check` and
  `deno task test` on each pull request and each push to `main`.
- [ ] **gate-asks-an-intention** — `deno task release-check gate <base>`
  exits 1 when the diff from `<base>` changes `socle/` (outside
  `socle/intentions/`) and adds no `socle/intentions/unreleased/*.md`. It
  exits 0 otherwise. The workflow skips the check under `no-intention` or
  on the Release PR. Covered by tests on a temporary git repo.
- [ ] **promote-checked** — `deno task release-check promoted <base>` exits
  1, naming `deno task promote-intentions <version>`, while `unreleased/`
  holds a file, or while an intention present on `<base>` is missing from
  `<version>/` under `<version>/<slug>`. It exits 0 once promoted. Tested.
- [ ] **publish-refuses** — `deno task release-check publish <tag>` exits 1
  when the tag is not `v` + `deno.json`'s version or when `unreleased/` is
  not empty. The publish job runs it before `deno publish`. Tested.
- [ ] **release-note-lists-intentions** — `deno task release-check notes
  <version>` prints the version's intentions (id, classification, title),
  and the release job appends that list to the GitHub Release body. Tested.
- [ ] **release-please-wired** — `release-please-config.json` and
  `.release-please-manifest.json` exist. The manifest is at the current
  version, and the config bumps `deno.json`'s `$.version` and sets a
  bootstrap commit, so the first run does not read the whole history.
- [ ] **publish-by-oidc** — the publish job has `id-token: write`, no
  secret, and runs `deno publish` on the tagged commit only.
- [ ] **release-skill** — `.agents/skills/chisel-release/SKILL.md` exists
  in chisel's own tree, is not in `src/socle-files.ts`, and says it never
  tags, merges or publishes.
- [ ] **docs-say-it** — the README, CONTRIBUTING.md and section I of
  `.agents/project.md` describe the Release PR, and none of them still
  says to run `deno publish` by hand.
- [ ] **suite-green** — `deno task test` and `deno task check` pass.

## Seams

- `deno task release-check <gate|promoted|publish|notes> …` — one Deno
  script that holds every decision, testable on a temporary git repo. The
  workflows only call it.
- The workflows: `.github/workflows/ci.yml`, `intention-gate.yml`,
  `intention-promote.yml` and `release.yml`. They can only be proved on
  GitHub, after the Owner's infra.

## Architecture

```
PR ──► ci.yml (check + test)
   └─► intention-gate.yml ── release-check gate origin/main   (skip: no-intention, autorelease: pending)

push main ──► release.yml
   ├─ release-please: opens/updates "chore: release X.Y.Z" (deno.json, CHANGELOG.md)
   │      maintainer + chisel-release skill: promote-intentions X.Y.Z, push
   │      └─► intention-promote.yml ── release-check promoted origin/main
   └─ human merges the Release PR ──► same workflow: tag vX.Y.Z created
          ├─ release-check publish vX.Y.Z
          ├─ deno publish   (OIDC, id-token: write)
          └─ gh release edit: body += release-check notes X.Y.Z
```

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

- **Conventional titles, not conventional commits.** Branch commits keep
  chisel's plain-sentence style. Only the PR title, which becomes the
  squash commit on `main` (I6), follows `type: summary`. release-please
  reads those: `feat` bumps the minor version and `fix` the patch, and
  while chisel is in 0.x a breaking change bumps the minor version
  (`bump-minor-pre-major`).
  This needs a check on PR titles. A small step in `ci.yml` checks the
  title's form, with no dependency.
- **Which changes need an intention.** A change under `socle/`, outside
  `socle/intentions/` itself, needs one. A change to `src/` alone does
  not, as it is the CLI's behaviour, not what a repo must act on. The
  author uses the label when a `socle/` change truly needs nothing, as
  CONTRIBUTING.md already says ("No intention: <why>").
- **Promote last.** release-please rewrites the Release PR branch on every
  push to `main`. The skill and CONTRIBUTING say to promote just before
  merging, and to promote again if the branch was rewritten.
- **`CHANGELOG.md` is release-please's**, and is never edited by hand. The
  journal stays the hand-written narration. The glue already keeps the
  two apart.
- **The v2 → main merge.** For release-please to propose the next version,
  the merge has to land on `main` with a conventional title, which means a
  squash merge (for example "feat: updates read intentions, releases
  through a Release PR"). A plain merge commit would leave release-please
  with nothing to read until the next conventional title.

## Testing Strategy

- `test/release-check.test.ts`, on a temporary git repo:
  - gate: three cases (socle change without an intention, with one,
    `src/` only);
  - promoted: three cases (still in `unreleased/`, promoted, deleted
    instead of promoted);
  - publish: three cases (match, version mismatch, `unreleased/` not
    empty);
  - notes: the list for one version.
- The workflows are checked by hand at review, as YAML calling the tasks.
  Their first real run is on GitHub, after I1 to I6.

## Slices & Dependencies

One task, three commits in order: (1) `release-check` and its tests;
(2) the four workflows and the release-please files; (3) the skill and
the docs. No slice files: each step is small and reviewed together.

## Deliverables

- [ ] `scripts/release-check.ts`, `test/release-check.test.ts`, deno task.
- [ ] `.github/workflows/{ci,intention-gate,intention-promote,release}.yml`.
- [ ] `release-please-config.json`, `.release-please-manifest.json`.
- [ ] `.agents/skills/chisel-release/SKILL.md`.
- [ ] README, CONTRIBUTING.md, `.agents/project.md` §I, `test/TESTS.md`.

## References

- `lonestone-boilerplate/.github/workflows/release-please.yml`: the
  Release PR, the tag and the OIDC publish in one run, and why a human
  merges it.
- `lonestone-boilerplate/.github/workflows/intention-gate.yml` and
  `intention-promote.yml`: the two gates and their skip rules.
- `lonestone-boilerplate/.cursor/skills/boilerstone-release/SKILL.md`: the
  maintainer skill, "never tag, never merge", and "promote last".
- `CONTRIBUTING.md` in this repo, "At a release": the promotion as it
  stands.

## Notes

- Written 2026-11-03 by the Crewmate of "Updates and installs read
  intentions", on the Owner's instruction through promethee. The plan
  waits for approval in the work document.

## Retrospective

Added at the close.
