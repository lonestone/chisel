---
name: chisel-release
description: Prepare a chisel release on the open release-please Release PR, in chisel's own repo — promote the unreleased intentions, check each against the diff since the last tag, run the gates, push, stop. Use when the maintainer asks to "prepare the release", "work the Release PR" or "préparer la release de chisel". Never tags, never merges, never publishes.
disable-model-invocation: true
---

# Prepare a chisel release

Chisel releases through a **Release PR**. On every push to `main`,
release-please (`.github/workflows/release.yml`) opens or updates a pull
request titled `chore(release): release X.Y.Z`, labelled
`autorelease: pending`. It carries the new version in `deno.json` and
`.release-please-manifest.json`, and the generated `CHANGELOG.md`. Each
change already wrote its intention under `socle/intentions/unreleased/`, in
its own pull request (CONTRIBUTING.md).

This skill readies that pull request: it moves those intentions into the
release's folder and checks them. A human then merges the Release PR, and the
same CI run tags it, adds the release's intentions to the GitHub Release and
publishes to JSR.

## Never

- Never tag, never merge the Release PR, never run `deno publish`: they
  are the human's act and CI's. Green checks are not consent to ship.
- Never edit `CHANGELOG.md`: release-please writes it. The narrative goes
  in `project-management/JOURNAL.md`.
- Never pick the version: release-please did, from the commit titles on
  `main`.

## Preflight

1. Work in chisel's own repo: `scripts/promote-intentions.ts` exists. In any
   other repo, this skill does not apply.
2. Find the Release PR: `gh pr list --label "autorelease: pending"`. If none
   is open, stop and say so: nothing to prepare.
3. Check out its branch and read the version from
   `.release-please-manifest.json` there. `deno.json` declares the same one.
4. Find the previous tag: `git tag --list 'v*' --sort=-v:refname | head -1`.

## Steps

1. **Promote, last.** release-please rewrites the Release PR's branch on
   every push to `main`. Promote just before the human merges, and promote
   again if the branch was rewritten since.

   ```sh
   deno task promote-intentions <version>
   ```

   It moves each `unreleased/<slug>.md` to `<version>/NN-<slug>.md`,
   rewrites its id and updates `src/socle-files.ts`. When `unreleased/` is
   empty it refuses: the release ships no new intention, so skip to step 3.

2. **Check each promoted intention against the diff.** For each file in
   `socle/intentions/<version>/` that this release added, read it beside
   `git diff --name-status v<previous>..HEAD -- socle/`:
   - every path its Reference Paths names still exists;
   - its Observable Gaps describe what the diff changed, not an earlier draft;
   - a change to `socle/` that no intention covers is listed for the human,
     with the pull request that made it.

   A stale intention is fixed on the Release PR, in its own commit
   (`docs(intentions): …`), before the human merges.

3. **Gates.**

   ```sh
   deno task release-check promoted origin/main
   deno task check
   deno task test
   ```

4. **Push and stop.** Commit the promotion as
   `chore(release): promote the intentions of <version>` and push the
   branch. The "Intention promote" check turns green. Tell the human that
   the Release PR is ready to merge, with the list of intentions it ships
   (`deno task release-check notes <version>`), and stop.

## After the merge

CI tags `v<version>`, appends the intentions to the GitHub Release and
publishes to JSR by OIDC. If the publish fails after the tag exists, it is
retried with **Run workflow** on `Release`, with the tag. The first publish
needs `@lonestone/chisel` linked to `lonestone/chisel` on jsr.io
(`scripts/github-repo-settings.md`).
