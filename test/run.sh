#!/usr/bin/env bash
# CLI-seam tests for bin/chisel.sh: file tree in, file tree out. Plain sh
# asserts, no bats dependency. Read test/TESTS.md first — this file is the
# runner only.
#
# STEP 1 of the rebuild (slice 09): the old monolith's helpers now live in
# test/lib.sh and its group bodies in test/installer.sh, unmodified — this
# file just wires them together. Selective run-by-name and the line-count
# cap land once the groups themselves are reduced.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
CHISEL="$REPO_ROOT/bin/chisel.sh"
FIXTURES_DIR="$REPO_ROOT/test/fixtures"

WORK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/chisel-test.XXXXXX")"
trap 'rm -rf "$WORK_ROOT"' EXIT

# shellcheck source=test/lib.sh
. "$REPO_ROOT/test/lib.sh"

printf '=== chisel test/run.sh ===\n'

# shellcheck source=test/installer.sh
. "$REPO_ROOT/test/installer.sh"

printf '\n=== %d scenarios, %d assertions passed, %d failed ===\n' \
  "$scenario_count" "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
