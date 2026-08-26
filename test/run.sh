#!/usr/bin/env bash
# CLI-seam tests for bin/chisel.sh: file tree in, file tree out. Plain sh
# asserts, no bats dependency. Read test/TESTS.md first — one page, one row
# per group. This file is the runner only: helpers live in test/lib.sh, group
# bodies in test/installer.sh.
#
# Usage: bash test/run.sh          # every group
#        bash test/run.sh <group>  # one group by name, e.g. `guards`
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
CHISEL="$REPO_ROOT/bin/chisel.sh"
FIXTURES_DIR="$REPO_ROOT/test/fixtures"

WORK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/chisel-test.XXXXXX")"
trap 'rm -rf "$WORK_ROOT"' EXIT

# shellcheck source=test/lib.sh
. "$REPO_ROOT/test/lib.sh"
# shellcheck source=test/installer.sh
. "$REPO_ROOT/test/installer.sh"

ALL_GROUPS="init idempotence boilerplate update check symlink render guards integrity"

run_group() {
  case "$1" in
    init) group_init ;;
    idempotence) group_idempotence ;;
    boilerplate) group_boilerplate ;;
    update) group_update ;;
    check) group_check ;;
    symlink) group_symlink ;;
    render) group_render ;;
    guards) group_guards ;;
    integrity) group_integrity ;;
    *)
      printf 'unknown group: %s\nknown groups: %s\n' "$1" "$ALL_GROUPS" >&2
      exit 2
      ;;
  esac
}

printf '=== chisel test/run.sh ===\n'

if [ "$#" -eq 1 ]; then
  run_group "$1"
else
  for g in $ALL_GROUPS; do
    run_group "$g"
  done
fi

# The hard cap (slice 09): the whole suite stays under 600 lines. A cap the
# runner enforces itself is the only one nobody can forget to check.
suite_lines="$(wc -l "$REPO_ROOT/test/lib.sh" "$REPO_ROOT/test/installer.sh" "$REPO_ROOT/test/run.sh" |
  awk '/total/ { print $1 }')"
if [ "$suite_lines" -le 600 ]; then
  pass "suite: total test/ line count is within the 600-line cap ($suite_lines lines)"
else
  fail "suite: total test/ line count is within the 600-line cap ($suite_lines lines, over 600)"
fi

printf '\n=== %d scenarios, %d assertions passed, %d failed ===\n' \
  "$scenario_count" "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
