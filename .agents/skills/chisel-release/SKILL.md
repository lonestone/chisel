---
name: chisel-release
description: Prepare chisel's open Release PR, in chisel's own repo — promote the unreleased intentions, check them against the diff, run the gates, push. Use when asked to prepare a chisel release or work its Release PR.
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

## Stops at a green Release PR

The human merges the Release PR; CI tags it and publishes. This skill ends
when the checks are green and the human has been told. Green checks are not
consent to ship.

`CHANGELOG.md` is release-please's. The narrative goes in
`project-management/JOURNAL.md`.

## Preflight

1. Work in chisel's own repo: `scripts/promote-intentions.ts` exists. In any
   other repo, this skill does not apply.
2. Find the Release PR: `gh pr list --label "autorelease: pending"`. If none
   is open, there is nothing to prepare: say so and stop.
3. Check out its branch and read the version from
   `.release-please-manifest.json` there. `deno.json` declares the same one.
4. Find the previous tag: `git tag --list 'v*' --sort=-v:refname | head -1`.

## Steps

1. **Promote.**

   ```sh
   deno task promote-intentions <version>
   ```

   It moves each `unreleased/<slug>.md` to `<version>/NN-<slug>.md`,
   rewrites its id and updates `src/socle-files.ts`. When `unreleased/` is
   empty it refuses: the release ships no new intention, so skip to step 3.
   Done when `socle/intentions/unreleased/` is empty.

2. **Check each promoted intention against the diff.** For each file in
   `socle/intentions/<version>/` that this release added, read it beside
   `git diff --name-status v<previous>..HEAD -- socle/`:
   - every path its Reference Paths names still exists;
   - its Observable Gaps describe what the diff changed, not an earlier draft;
   - a change to `socle/` that no intention covers is listed for the human,
     with the pull request that made it.

   A stale intention is fixed on the Release PR, in its own commit
   (`docs(intentions): …`), before the human merges.
   Done when every promoted intention passes the three checks and every
   change no intention covers is listed.

3. **Gates.**

   ```sh
   deno task release-check promoted origin/main
   deno task check
   deno task test
   ```

   Done when all three exit 0. A failure stops the release: report the
   command and its output.

4. **Push and stop.** Commit the promotion as
   `chore(release): promote the intentions of <version>` and push the
   branch. With nothing to promote, push an empty commit instead
   (`git commit --allow-empty -m "chore(release): run the checks of
   <version>"`): release-please pushes with `GITHUB_TOKEN`, which starts no
   workflow, so the required checks run on the Release PR only after a push
   of yours. Watch them with `gh pr checks <n> --watch`. When they are
   green, tell the human that the Release PR is ready to merge, with the
   list of intentions it ships (`deno task release-check notes <version>`),
   and stop.

   release-please rewrites the Release PR's branch on every push to `main`.
   If `main` moved after your push, start again from step 3 of the
   preflight.

## After the merge

If the publish fails after the tag exists, retry it with **Run workflow**
on `Release`, with the tag. The first publish
needs `@lonestone/chisel` linked to `lonestone/chisel` on jsr.io
(`scripts/github-repo-settings.md`).
