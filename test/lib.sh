# test/lib.sh — helpers only. Sourced by test/run.sh before test/installer.sh.
# No test bodies live here: assert_*, run_chisel, fresh_copy/fresh_install,
# installed_tree. Every fixture is copied into a fresh temp directory before
# use — committed fixtures under test/fixtures/ are never mutated.

pass_count=0
fail_count=0
scenario_count=0

# A SCENARIO is a group: one situation, protected end to end. An ASSERTION is
# one line of evidence inside it. The two numbers answer different questions —
# "how many situations does this suite hold down?" and "how much detail does it
# check?" — and only the first one is a measure of coverage.
group() {
  scenario_count=$((scenario_count + 1))
  printf '\n-- %s --\n' "$1"
  printf 'PROTECTS: %s\n' "$2"
}

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

# Structural-marker checks only (a begin/end comment, a checklist tick, a
# routed path) — never a needle that pins a sentence of prose. See TESTS.md.
assert_file_contains() {
  desc="$1"
  path="$2"
  needle="$3"
  if [ -f "$path" ] && grep -qF -- "$needle" "$path"; then
    pass "$desc"
  else
    fail "$desc (text not found in $path: $needle)"
  fi
}

assert_file_not_contains() {
  desc="$1"
  path="$2"
  needle="$3"
  if [ -f "$path" ] && ! grep -qF -- "$needle" "$path"; then
    pass "$desc"
  else
    fail "$desc (text unexpectedly found in $path: $needle)"
  fi
}

assert_path_absent() {
  desc="$1"
  path="$2"
  if [ ! -e "$path" ]; then
    pass "$desc"
  else
    fail "$desc (path unexpectedly present: $path)"
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

# fresh_copy <fixture-name> -> echoes the path to a new temp copy of it, raw
# (chisel has not touched it).
fresh_copy() {
  fixture_name="$1"
  dest="$(mktemp -d "$WORK_ROOT/${fixture_name}.XXXXXX")"
  cp -R "$FIXTURES_DIR/$fixture_name/." "$dest/"
  printf '%s\n' "$dest"
}

# fresh_install <fixture-name> -> echoes the path to a new temp copy of a
# PRISTINE `chisel init` install of that fixture. The install itself runs
# once per fixture per suite run (cached under $WORK_ROOT), then every caller
# gets its own `cp -R` — so a group that just needs "an already-installed
# repo" never shares a mutable fixture with another group, and groups stay
# order-independent.
fresh_install() {
  fixture_name="$1"
  cache_dir="$WORK_ROOT/.cache-${fixture_name}"
  if [ ! -d "$cache_dir" ]; then
    src="$(fresh_copy "$fixture_name")"
    run_chisel "$CHISEL" init "$src"
    if [ "$rc" -ne 0 ]; then
      printf 'fresh_install: priming `chisel init` failed for fixture %s\n' "$fixture_name" >&2
      cat "$WORK_ROOT/last.log" >&2
      exit 1
    fi
    mv "$src" "$cache_dir"
  fi
  dest="$(mktemp -d "$WORK_ROOT/${fixture_name}-install.XXXXXX")"
  cp -R "$cache_dir/." "$dest/"
  printf '%s\n' "$dest"
}

# The installed layout, path by path — the tree chisel is responsible for,
# with root files (README, package.json, the fixture's own content) left out.
# An exact tree comparison catches a file that should NOT be there too, which
# a list of existence asserts never does.
installed_tree() {
  ( cd "$1" && find .agents .claude .codex scripts project-management -print 2>/dev/null || true ) |
    LC_ALL=C sort
}
