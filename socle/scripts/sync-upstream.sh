#!/usr/bin/env bash
# Check Pocock-forked skills for upstream drift, and print the raw diff for
# one skill so an agent can propose a merge. Purely mechanical: judgment
# (reading diffs, proposing merges) and validation belong to the
# sync-upstream skill and the human — this script never applies anything.
#
# Usage:
#   sync-upstream.sh [--check] [--lock <path>] [--skills-dir <path>]
#   sync-upstream.sh --diff <skill-name> [--lock <path>] [--skills-dir <path>]
#
# --check (default mode): for each lock entry, compares the recorded sha
#   against origin/main and reports a drift table; entries locked to the
#   literal string "none" are listed separately as unplugged and skipped.
#   Zero writes anywhere except the upstream cache (see below). Exit 0 if
#   nothing drifted, exit 1 if anything did.
#
# --diff <skill-name>: prints `git diff <recorded-sha>..origin/main` for that
#   skill's upstream path — the raw material a human/agent reads before
#   proposing a merge. Errors if the skill is unknown or unplugged.
#
# The sole side effect this script ever performs, in any mode, is cloning or
# fetching the upstream cache under ${XDG_CACHE_HOME:-$HOME/.cache}/chisel/.
# Requires python3 to parse the JSON lock file.
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: sync-upstream.sh [--check] [--lock <path>] [--skills-dir <path>]
       sync-upstream.sh --diff <skill-name> [--lock <path>] [--skills-dir <path>]
EOF
}

mode="check"
diff_skill=""
lock_path="./upstream.lock.json"
skills_dir=""
skills_dir_explicit=0

while [ $# -gt 0 ]; do
  case "$1" in
    --check)
      mode="check"
      shift
      ;;
    --diff)
      if [ $# -lt 2 ]; then
        echo "sync-upstream.sh: --diff requires a skill name" >&2
        usage
        exit 1
      fi
      mode="diff"
      diff_skill="$2"
      shift 2
      ;;
    --lock)
      if [ $# -lt 2 ]; then
        echo "sync-upstream.sh: --lock requires a path" >&2
        usage
        exit 1
      fi
      lock_path="$2"
      shift 2
      ;;
    --skills-dir)
      if [ $# -lt 2 ]; then
        echo "sync-upstream.sh: --skills-dir requires a path" >&2
        usage
        exit 1
      fi
      skills_dir="$2"
      skills_dir_explicit=1
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "sync-upstream.sh: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [ "$skills_dir_explicit" -eq 0 ]; then
  if [ -d "socle/agents/skills" ]; then
    skills_dir="socle/agents/skills"
  else
    skills_dir=".agents/skills"
  fi
fi

command -v python3 >/dev/null 2>&1 || {
  echo "sync-upstream.sh: python3 is required to parse $lock_path (not found on PATH)" >&2
  exit 1
}

if [ ! -f "$lock_path" ]; then
  echo "sync-upstream.sh: lock file not found: $lock_path" >&2
  exit 1
fi

cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/chisel"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

tab="$(printf '\t')"

# Parse the lock into TSV: name<TAB>repo<TAB>path<TAB>sha
# A lock value of the literal string "none" becomes name<TAB>none<TAB><TAB>
lock_tsv() {
  python3 - "$lock_path" <<'PY'
import json
import sys

with open(sys.argv[1]) as f:
    data = json.load(f)

for name, entry in data.items():
    if entry == "none":
        print(f"{name}\tnone\t\t")
    else:
        print(f"{name}\t{entry['repo']}\t{entry['path']}\t{entry['sha']}")
PY
}

if ! lock_tsv >"$tmp_dir/lock.tsv"; then
  echo "sync-upstream.sh: failed to parse lock file: $lock_path" >&2
  exit 1
fi

# Cache dir for a given "<owner>/<repo>" lock repo string.
cache_dir_for() {
  printf '%s/%s\n' "$cache_root" "$(printf '%s' "$1" | tr '/' '-')"
}

# Ensure the upstream cache is cloned and up to date; print its path.
# This is the sole allowed write, in any mode.
ensure_cache() {
  repo="$1"
  dir="$(cache_dir_for "$repo")"
  # Clone/fetch a given upstream at most once per run (15 lock entries
  # usually share one repo — don't hit the network 15 times).
  marker="$tmp_dir/fetched-$(printf '%s' "$repo" | tr '/' '-')"
  if [ ! -f "$marker" ]; then
    if [ ! -d "$dir/.git" ]; then
      mkdir -p "$cache_root"
      git clone --quiet "https://github.com/${repo}.git" "$dir" >&2
    else
      git -C "$dir" fetch --quiet origin >&2
    fi
    : >"$marker"
  fi
  printf '%s\n' "$dir"
}

# Extract the `sha:` value from a skill's `x-upstream:` frontmatter block.
# Prints nothing if the file is missing, has no frontmatter, or the skill's
# `x-upstream:` is the literal `none` (no nested `sha:` line to find).
frontmatter_sha() {
  skill_md="$1"
  [ -f "$skill_md" ] || return 0
  sed -n '2,/^---$/p' "$skill_md" | grep -m1 '^  sha:' | sed 's/^  sha:[[:space:]]*//' || true
}

run_check() {
  drifted=0
  printf 'sync-upstream --check\n'
  printf '%-28s %-8s %s\n' "SKILL" "BEHIND" "LATEST SUBJECTS (max 3)"

  while IFS="$tab" read -r name repo path sha; do
    if [ "$repo" = "none" ]; then
      printf '%s\n' "$name" >>"$tmp_dir/unplugged.txt"
      continue
    fi

    cache_dir="$(ensure_cache "$repo")"

    if ! log_output="$(git -C "$cache_dir" log --oneline "${sha}..origin/main" -- "$path" 2>"$tmp_dir/log.err")"; then
      printf 'WARN: %s could not compute upstream log (%s)\n' "$name" "$(cat "$tmp_dir/log.err")" >&2
      log_output=""
    fi

    behind=0
    if [ -n "$log_output" ]; then
      behind="$(printf '%s\n' "$log_output" | wc -l | tr -d ' ')"
    fi

    subjects="-"
    if [ "$behind" -gt 0 ]; then
      subjects="$(printf '%s\n' "$log_output" | head -3 | sed 's/^[0-9a-f]* //' | paste -sd';' -)"
      drifted=1
    fi

    printf '%-28s %-8s %s\n' "$name" "$behind" "$subjects"

    skill_md="${skills_dir}/${name}/SKILL.md"
    if [ ! -f "$skill_md" ]; then
      printf 'WARN mismatch: %s SKILL.md not found under %s\n' "$name" "$skills_dir"
    else
      fm_sha="$(frontmatter_sha "$skill_md")"
      if [ -z "$fm_sha" ]; then
        printf 'WARN mismatch: %s frontmatter has no x-upstream sha (lock expects %s)\n' "$name" "$sha"
      elif [ "$fm_sha" != "$sha" ]; then
        printf 'WARN mismatch: %s frontmatter sha=%s lock sha=%s\n' "$name" "$fm_sha" "$sha"
      fi
    fi
  done <"$tmp_dir/lock.tsv"

  if [ -f "$tmp_dir/unplugged.txt" ]; then
    printf '\nunplugged (x-upstream: none) — skipped\n'
    while IFS= read -r name; do
      printf '%s\n' "$name"
    done <"$tmp_dir/unplugged.txt"
  fi

  return "$drifted"
}

run_diff() {
  name="$1"
  tsv_line="$(awk -F'\t' -v n="$name" '$1==n{print; exit}' "$tmp_dir/lock.tsv")"
  if [ -z "$tsv_line" ]; then
    echo "sync-upstream.sh: unknown skill: $name (not in $lock_path)" >&2
    exit 1
  fi

  repo="$(printf '%s' "$tsv_line" | cut -f2)"
  path="$(printf '%s' "$tsv_line" | cut -f3)"
  sha="$(printf '%s' "$tsv_line" | cut -f4)"

  if [ "$repo" = "none" ]; then
    echo "sync-upstream.sh: $name is unplugged (x-upstream: none) — nothing to diff" >&2
    exit 1
  fi

  cache_dir="$(ensure_cache "$repo")"
  git -C "$cache_dir" diff "${sha}..origin/main" -- "$path"
}

case "$mode" in
  check)
    run_check
    ;;
  diff)
    run_diff "$diff_skill"
    ;;
esac
