#!/usr/bin/env bash
# CLI-seam tests for bin/chisel.sh: file tree in, file tree out. Plain sh
# asserts, no bats dependency. Every fixture is copied into a fresh temp
# directory before use — committed fixtures under test/fixtures/ are never
# mutated. Temp copies live under $TMPDIR (or /tmp if unset) and are removed
# on exit.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
CHISEL="$REPO_ROOT/bin/chisel.sh"
FIXTURES_DIR="$REPO_ROOT/test/fixtures"

WORK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/chisel-test.XXXXXX")"
trap 'rm -rf "$WORK_ROOT"' EXIT

pass_count=0
fail_count=0

pass() {
  pass_count=$((pass_count + 1))
  printf 'PASS: %s\n' "$1"
}

fail() {
  fail_count=$((fail_count + 1))
  printf 'FAIL: %s\n' "$1"
}

assert_file_exists() {
  desc="$1"
  path="$2"
  if [ -f "$path" ]; then
    pass "$desc"
  else
    fail "$desc (missing file: $path)"
  fi
}

assert_dir_exists() {
  desc="$1"
  path="$2"
  if [ -d "$path" ]; then
    pass "$desc"
  else
    fail "$desc (missing dir: $path)"
  fi
}

assert_executable() {
  desc="$1"
  path="$2"
  if [ -x "$path" ]; then
    pass "$desc"
  else
    fail "$desc (not executable: $path)"
  fi
}

assert_symlink_resolves() {
  desc="$1"
  path="$2"
  expected="$3"
  if [ -L "$path" ] && [ -e "$path" ]; then
    actual="$(readlink "$path")"
    if [ "$actual" = "$expected" ]; then
      pass "$desc"
    else
      fail "$desc (points at $actual, expected $expected)"
    fi
  else
    fail "$desc (not a resolving symlink: $path)"
  fi
}

assert_file_contains() {
  desc="$1"
  path="$2"
  needle="$3"
  if [ -f "$path" ] && grep -qF "$needle" "$path"; then
    pass "$desc"
  else
    fail "$desc (text not found in $path: $needle)"
  fi
}

assert_file_not_contains() {
  desc="$1"
  path="$2"
  needle="$3"
  if [ -f "$path" ] && ! grep -qF "$needle" "$path"; then
    pass "$desc"
  else
    fail "$desc (text unexpectedly found in $path: $needle)"
  fi
}

assert_eq() {
  desc="$1"
  expected="$2"
  actual="$3"
  if [ "$expected" = "$actual" ]; then
    pass "$desc"
  else
    fail "$desc (expected [$expected] got [$actual])"
  fi
}

assert_files_identical() {
  desc="$1"
  a="$2"
  b="$3"
  if diff -q "$a" "$b" >/dev/null 2>&1; then
    pass "$desc"
  else
    fail "$desc (files differ: $a vs $b)"
  fi
}

# Runs a command, capturing stdout+stderr to $WORK_ROOT/last.log and the
# exit code into $rc — never triggers `set -e`, even on nonzero exit.
run_chisel() {
  if "$@" >"$WORK_ROOT/last.log" 2>&1; then
    rc=0
  else
    rc=$?
  fi
}

# fresh_copy <fixture-name> -> echoes the path to a new temp copy of it.
fresh_copy() {
  fixture_name="$1"
  dest="$(mktemp -d "$WORK_ROOT/${fixture_name}.XXXXXX")"
  cp -R "$FIXTURES_DIR/$fixture_name/." "$dest/"
  printf '%s\n' "$dest"
}

assert_full_layout() {
  target="$1"
  assert_file_exists "[$target] AGENTS.md exists" "$target/AGENTS.md"
  assert_file_exists "[$target] CLAUDE.md exists" "$target/CLAUDE.md"
  assert_file_contains "[$target] CLAUDE.md imports AGENTS.md" "$target/CLAUDE.md" "@AGENTS.md"
  assert_file_contains "[$target] AGENTS.md has begin marker" "$target/AGENTS.md" "<!-- chisel:begin -->"
  assert_file_contains "[$target] AGENTS.md has end marker" "$target/AGENTS.md" "<!-- chisel:end -->"
  assert_symlink_resolves "[$target] .claude/skills symlink" "$target/.claude/skills" "../.agents/skills"
  assert_dir_exists "[$target] .agents/skills" "$target/.agents/skills"
  assert_file_exists "[$target] .agents/skills/tdd/SKILL.md" "$target/.agents/skills/tdd/SKILL.md"
  assert_dir_exists "[$target] .agents/rules" "$target/.agents/rules"
  assert_file_exists "[$target] .agents/rules/task-creation.md" "$target/.agents/rules/task-creation.md"
  assert_file_exists "[$target] .agents/rules/task-progressing.md" "$target/.agents/rules/task-progressing.md"
  assert_file_exists "[$target] .agents/rules/task-completion.md" "$target/.agents/rules/task-completion.md"
  assert_file_exists "[$target] .agents/workflows.md" "$target/.agents/workflows.md"
  assert_file_exists "[$target] .agents/methodology.md" "$target/.agents/methodology.md"
  assert_file_exists "[$target] .agents/project.md" "$target/.agents/project.md"
  assert_file_exists "[$target] .agents/.chisel.json manifest" "$target/.agents/.chisel.json"
  assert_dir_exists "[$target] project-management/tasks" "$target/project-management/tasks"
  assert_dir_exists "[$target] project-management/archive" "$target/project-management/archive"
  assert_file_exists "[$target] project-management/000-task-file-template.md" \
    "$target/project-management/000-task-file-template.md"
  assert_file_exists "[$target] project-management/CHANGELOG.md" "$target/project-management/CHANGELOG.md"
  assert_file_exists "[$target] scripts/task-id.sh" "$target/scripts/task-id.sh"
  assert_executable "[$target] scripts/task-id.sh is executable" "$target/scripts/task-id.sh"
}

printf '=== chisel test/run.sh ===\n\n'

# ---------------------------------------------------------------------------
# 1. brownfield: init produces the full target layout, preserves user
#    content byte-for-byte outside the managed block.
# ---------------------------------------------------------------------------
printf '%s\n' '-- 1. brownfield init: full layout + content preservation --'
t1="$(fresh_copy brownfield)"

run_chisel "$CHISEL" init "$t1"
assert_eq "brownfield: init exits 0" "0" "$rc"

assert_full_layout "$t1"

assert_file_contains "brownfield: AGENTS.md keeps user heading" "$t1/AGENTS.md" \
  "# Acme Bookkeeper — agent instructions"
assert_file_contains "brownfield: AGENTS.md keeps user note" "$t1/AGENTS.md" \
  "Do not touch \`legacy/\` without asking Jane first."
assert_file_contains "brownfield: CLAUDE.md keeps user content" "$t1/CLAUDE.md" \
  "this project uses Ruby 3.2 and Sidekiq"
assert_file_contains "brownfield: README.md untouched" "$t1/README.md" \
  "Internal payroll tool."

# The block content itself must match the source template verbatim.
awk '/<!-- chisel:begin -->/{f=1;next}/<!-- chisel:end -->/{f=0}f' "$t1/AGENTS.md" \
  >"$WORK_ROOT/t1-block.md"
assert_files_identical "brownfield: rendered block matches AGENTS-block.md" \
  "$WORK_ROOT/t1-block.md" "$REPO_ROOT/socle/templates/AGENTS-block.md"

# ---------------------------------------------------------------------------
# 2. idempotence: init twice = no diff.
# ---------------------------------------------------------------------------
printf '\n-- 2. idempotence: init twice --\n'
cp -R "$t1" "$WORK_ROOT/t1-after-first-init"

run_chisel "$CHISEL" init "$t1"
assert_eq "brownfield: second init exits 0" "0" "$rc"

if diff -r "$WORK_ROOT/t1-after-first-init" "$t1" >"$WORK_ROOT/t1-idempotence.diff" 2>&1; then
  pass "brownfield: init twice produces zero diff"
else
  fail "brownfield: init twice produces zero diff (see $WORK_ROOT/t1-idempotence.diff)"
fi

assert_eq "brownfield: single managed block after two inits" "1" \
  "$(grep -c -- '<!-- chisel:begin -->' "$t1/AGENTS.md")"

# ---------------------------------------------------------------------------
# 3. boilerplate: init also produces the full target layout.
# ---------------------------------------------------------------------------
printf '\n-- 3. boilerplate init: full layout --\n'
t3="$(fresh_copy boilerplate)"

run_chisel "$CHISEL" init "$t3"
assert_eq "boilerplate: init exits 0" "0" "$rc"

assert_full_layout "$t3"
assert_file_contains "boilerplate: AGENTS.md created with project title" "$t3/AGENTS.md" \
  "agent instructions"
assert_file_exists "boilerplate: apps/documentation untouched" "$t3/apps/documentation/README.md"
assert_file_contains "boilerplate: package.json untouched" "$t3/package.json" "\"lint\""

# ---------------------------------------------------------------------------
# 4. update: re-renders managed files, never touches project.md/CHANGELOG.md.
# ---------------------------------------------------------------------------
printf '\n-- 4. update: managed refresh, glue left alone --\n'
t4="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t4"
assert_eq "update fixture: init exits 0" "0" "$rc"

# Hand-edit project-owned files...
printf '\n<!-- hand-edited by a human, must survive update -->\n' >>"$t4/.agents/project.md"
printf '\n## 2099-01-01\n\n- hand-edited entry, must survive update\n' >>"$t4/project-management/CHANGELOG.md"
cp "$t4/.agents/project.md" "$WORK_ROOT/t4-project-md-before-update"
cp "$t4/project-management/CHANGELOG.md" "$WORK_ROOT/t4-changelog-before-update"

# ...and a managed file, to prove update refreshes it.
printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.agents/skills/tdd/SKILL.md"

run_chisel "$CHISEL" update "$t4"
assert_eq "brownfield: update exits 0" "0" "$rc"

assert_files_identical "update: .agents/project.md untouched" \
  "$WORK_ROOT/t4-project-md-before-update" "$t4/.agents/project.md"
assert_files_identical "update: CHANGELOG.md untouched" \
  "$WORK_ROOT/t4-changelog-before-update" "$t4/project-management/CHANGELOG.md"
assert_file_not_contains "update: hand-edited SKILL.md reverted" \
  "$t4/.agents/skills/tdd/SKILL.md" "local edit that update must overwrite"
assert_files_identical "update: SKILL.md matches socle source" \
  "$t4/.agents/skills/tdd/SKILL.md" "$REPO_ROOT/socle/agents/skills/tdd/SKILL.md"
assert_file_contains "update: prints a summary header" "$WORK_ROOT/last.log" "chisel update:"
if grep -qE '^  (changed: |\(no managed files changed\))' "$WORK_ROOT/last.log"; then
  pass "update: summary reports changed-or-unchanged per the manifest"
else
  fail "update: summary reports changed-or-unchanged per the manifest"
fi

# ---------------------------------------------------------------------------
# 5. check: exit 0 fresh, exit 1 after hand-editing a managed skill.
# ---------------------------------------------------------------------------
printf '\n-- 5. check: exit codes --\n'
t5="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t5"
assert_eq "check fixture: init exits 0" "0" "$rc"

run_chisel "$CHISEL" check "$t5"
assert_eq "check: exit 0 immediately after init" "0" "$rc"

printf '\n<!-- diverged -->\n' >>"$t5/.agents/skills/code-review/SKILL.md"
run_chisel "$CHISEL" check "$t5"
assert_eq "check: exit 1 after hand-editing a managed skill" "1" "$rc"
assert_file_contains "check: reports the diverged skill" "$WORK_ROOT/last.log" \
  ".agents/skills/code-review/SKILL.md"

# ---------------------------------------------------------------------------
# 6. package-root resolution follows a symlinked bin (npx installs a
#    symlink) — same code path Decision 2 describes, exercised directly.
# ---------------------------------------------------------------------------
printf '\n-- 6. symlink resolution --\n'
link_dir="$(mktemp -d "$WORK_ROOT/symlink-bin.XXXXXX")"
ln -s "$REPO_ROOT/bin/chisel.sh" "$link_dir/chisel"
t6="$(fresh_copy brownfield)"

run_chisel "$link_dir/chisel" init "$t6"
assert_eq "symlinked chisel: init exits 0" "0" "$rc"
assert_file_exists "symlinked chisel: resolved socle content copied" \
  "$t6/.agents/skills/tdd/SKILL.md"

printf '\n=== %d passed, %d failed ===\n' "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
