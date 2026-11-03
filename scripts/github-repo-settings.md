# GitHub and JSR settings of chisel's repo

Chisel's release machinery (`.github/workflows/`, `release-please-config.json`)
assumes settings that cannot live in code. `scripts/configure-github-repo.sh`
makes the GitHub ones; the JSR one is done by hand.

```bash
./scripts/configure-github-repo.sh          # dry run: prints the calls
./scripts/configure-github-repo.sh --apply  # makes them
```

Run it from the repo root, with `gh` authenticated as an admin of the repo.

## What the script sets

1. **Squash merge only**, with the pull request's title and description as the
   squash commit (`PR_TITLE`, `PR_BODY`). release-please reads the commits on
   `main`: the PR title, linted by the "PR title and description" check, is
   what picks the next version. Merge commits and rebase merges are off.
2. **The label `no-intention`.** It exempts a pull request from the intention
   gate when a change under `socle/` truly leaves a repo nothing to act on.
   release-please creates its own labels (`autorelease: pending`,
   `autorelease: tagged`).
3. **Actions may create pull requests.** release-please cannot open the
   Release PR without it. GitHub's single setting also lets Actions approve
   pull requests; no workflow of chisel does.
4. **The protection of `main`**: changes arrive by pull request (no approving
   review is required, since a maintainer merges their own PRs), no force-push,
   no deletion, and these checks pass first:
   - `Check and test` (CI);
   - `PR title and description` and `Commits` (PR lint);
   - `Intention gate`, which passes without running under `no-intention` or on
     the Release PR;
   - `Intention promote`, which passes without running on any PR but the
     Release PR.

   Admins are not held by the protection (`enforce_admins: false`), as GitHub's
   default: they see a bypass box at merge. The script refuses to write a
   protection when `main` already has one or the repo has rulesets: compare
   with this list in the UI (Settings → Branches) instead of overwriting.

   release-please pushes the Release PR with `GITHUB_TOKEN`, which starts no
   workflow: these checks run on it only once a maintainer pushes to its
   branch, which the `chisel-release` skill always does, with the promotion
   or an empty commit.

   Apply it once a pull request has run every check above, so that GitHub
   knows their names, and never in a way that blocks the pull request bringing
   the workflows themselves.

## Done by hand: link the package on JSR

On jsr.io, in the settings of `@lonestone/chisel`, a scope admin links the
package to the GitHub repository `lonestone/chisel`. JSR then accepts the
OIDC token of that repo's Actions, and the `publish` job of `release.yml`
needs no secret. Do it before the first Release PR is merged: without the
link, the publish fails after the tag is created, and is retried with
**Run workflow** on `Release`, with the tag.

## Never

- No workflow merges the Release PR. A human merges it from the UI, as
  themselves: green checks are not consent to ship, and a merge by
  `GITHUB_TOKEN` would not start the run that tags and publishes.
- No publish token stored in the repo: OIDC replaces it.
