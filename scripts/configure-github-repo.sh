#!/usr/bin/env bash
# The GitHub settings chisel's release machinery needs, after the Lonestone
# boilerplate's script of the same name (see scripts/github-repo-settings.md).
# Dry run by default: prints the gh api calls, changes nothing. --apply makes
# them. Run it from the repo root, with gh authenticated as a repo admin.

set -euo pipefail

apply=false

for arg in "$@"; do
  case "$arg" in
    --apply)
      apply=true
      ;;
    -h|--help)
      echo "Usage: $0 [--apply]"
      echo "  Default: print the gh api calls (dry run)."
      echo "  --apply: squash-only merges with the PR title and description as the commit,"
      echo "           the no-intention label, Actions allowed to create pull requests,"
      echo "           and the protection of main (refused when main already has one)."
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--apply]" >&2
      exit 1
      ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is required. Install the GitHub CLI and authenticate." >&2
  exit 1
fi

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"

# The job names of .github/workflows/: the checks a pull request into main
# must pass. Keep them in step with the workflows.
required_checks=(
  "Check and test"
  "PR title and description"
  "Commits"
  "Intention gate"
  "Intention promote"
)

run_or_print() {
  if [[ "${apply}" == true ]]; then
    "$@"
  else
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
  fi
}

echo "Repository: ${repo}"

echo
echo "1. Squash merge only; the squash commit is the PR title and description."
run_or_print gh api --silent -X PATCH "repos/${repo}" \
  -F allow_merge_commit=false \
  -F allow_squash_merge=true \
  -F allow_rebase_merge=false \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY

echo
echo "2. Label no-intention (skip the intention gate)."
if gh api "repos/${repo}/labels/no-intention" >/dev/null 2>&1; then
  echo "Label no-intention already exists."
else
  run_or_print gh api --silent -X POST "repos/${repo}/labels" \
    -f name=no-intention \
    -f color=C5DEF5 \
    -f description="Skip the intention gate"
fi

echo
echo "3. Actions may create pull requests (release-please opens the Release PR)."
run_or_print gh api --silent -X PUT "repos/${repo}/actions/permissions/workflow" \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=true

echo
echo "4. Protect main: a pull request, the required checks, no force-push, no deletion."
existing_rulesets="$(gh api "repos/${repo}/rulesets" --jq length)"
if gh api "repos/${repo}/branches/main/protection" >/dev/null 2>&1 \
  || [[ "${existing_rulesets}" != "0" ]]; then
  echo "main already has a protection or the repo has rulesets: refusing to"
  echo "overwrite them. Compare with scripts/github-repo-settings.md in the UI."
else
  checks_json="[$(printf '"%s",' "${required_checks[@]}")"
  checks_json="${checks_json%,}]"
  protection="$(cat <<JSON
{
  "required_status_checks": { "strict": false, "contexts": ${checks_json} },
  "enforce_admins": false,
  "required_pull_request_reviews": { "required_approving_review_count": 0 },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
)"
  if [[ "${apply}" == true ]]; then
    gh api --silent -X PUT "repos/${repo}/branches/main/protection" \
      --input - <<<"${protection}"
    echo "main protected."
  else
    printf 'dry-run: gh api -X PUT repos/%s/branches/main/protection --input - <<<\n%s\n' \
      "${repo}" "${protection}"
  fi
fi

echo
if [[ "${apply}" == true ]]; then
  echo "Settings applied. Read them back:"
  gh api "repos/${repo}" --jq '{allow_merge_commit, allow_squash_merge, allow_rebase_merge, squash_merge_commit_title, squash_merge_commit_message}'
  gh api "repos/${repo}/actions/permissions/workflow"
  gh api "repos/${repo}/branches/main/protection" \
    --jq '{checks: .required_status_checks.contexts, reviews: .required_pull_request_reviews.required_approving_review_count, force_push: .allow_force_pushes.enabled, deletion: .allow_deletions.enabled}' \
    || echo "main has no branch protection (its rulesets, if any, are not read here)."
else
  echo "No changes made. Re-run with --apply to make them."
fi

echo
echo "Not done here (see scripts/github-repo-settings.md):"
echo "  - Link @lonestone/chisel to ${repo} on jsr.io (package settings, a scope admin)."
