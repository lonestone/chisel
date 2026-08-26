# test/lib.sh — helpers only (assert_*, run_chisel, fresh_copy/fresh_install,
# installed_tree). No test bodies here. Sourced by test/run.sh before
# test/installer.sh. Fixtures under test/fixtures/ are never mutated — every
# use goes through a fresh temp copy.

pass_count=0
fail_count=0
scenario_count=0

# A SCENARIO is a group: one situation, protected end to end. An ASSERTION is
# one line of evidence inside it — only the scenario count is a coverage
# measure; a big assertion count is not a big safety net.
group() {
  scenario_count=$((scenario_count + 1))
  printf '\n-- %s --\n' "$1"
  printf 'PROTECTS: %s\n' "$2"
}
pass() { pass_count=$((pass_count + 1)); printf 'PASS: %s\n' "$1"; }
fail() { fail_count=$((fail_count + 1)); printf 'FAIL: %s\n' "$1"; }

assert_file_exists() { if [ -f "$2" ]; then pass "$1"; else fail "$1 (missing file: $2)"; fi; }
assert_dir_exists() { if [ -d "$2" ]; then pass "$1"; else fail "$1 (missing dir: $2)"; fi; }
assert_executable() { if [ -x "$2" ]; then pass "$1"; else fail "$1 (not executable: $2)"; fi; }
assert_path_absent() { if [ ! -e "$2" ]; then pass "$1"; else fail "$1 (path unexpectedly present: $2)"; fi; }
assert_eq() { if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (expected [$2] got [$3])"; fi; }
assert_files_identical() {
  if diff -q "$2" "$3" >/dev/null 2>&1; then pass "$1"; else fail "$1 (files differ: $2 vs $3)"; fi
}

# A structural-marker or routing-path check, never a needle pinning a sentence
# of prose. See TESTS.md's rules for what belongs behind this assert.
assert_file_contains() {
  if [ -f "$2" ] && grep -qF -- "$3" "$2"; then pass "$1"; else fail "$1 (text not found in $2: $3)"; fi
}
assert_file_not_contains() {
  if [ -f "$2" ] && ! grep -qF -- "$3" "$2"; then pass "$1"; else fail "$1 (text unexpectedly found in $2: $3)"; fi
}

assert_symlink_resolves() {
  desc="$1"; path="$2"; expected="$3"
  if [ -L "$path" ] && [ -e "$path" ] && [ "$(readlink "$path")" = "$expected" ]; then
    pass "$desc"
  else
    fail "$desc (not a resolving symlink to $expected: $path)"
  fi
}

# Runs a command, capturing stdout+stderr to $WORK_ROOT/last.log and the exit
# code into $rc — never triggers `set -e`, even on nonzero exit.
run_chisel() {
  if "$@" >"$WORK_ROOT/last.log" 2>&1; then rc=0; else rc=$?; fi
}

# fresh_copy <fixture-name> -> echoes the path to a new temp copy of it, raw
# (chisel has not touched it).
fresh_copy() {
  dest="$(mktemp -d "$WORK_ROOT/${1}.XXXXXX")"
  cp -R "$FIXTURES_DIR/$1/." "$dest/"
  printf '%s\n' "$dest"
}

# fresh_install <fixture-name> -> echoes the path to a new temp copy of a
# PRISTINE `chisel init` install of that fixture. The install runs once per
# fixture per suite run (cached under $WORK_ROOT), then every caller gets its
# own `cp -R` — so a group never shares a mutable fixture with another group,
# and groups stay order-independent.
fresh_install() {
  cache_dir="$WORK_ROOT/.cache-${1}"
  if [ ! -d "$cache_dir" ]; then
    src="$(fresh_copy "$1")"
    run_chisel "$CHISEL" init "$src"
    if [ "$rc" -ne 0 ]; then
      printf 'fresh_install: priming `chisel init` failed for fixture %s\n' "$1" >&2
      cat "$WORK_ROOT/last.log" >&2
      exit 1
    fi
    mv "$src" "$cache_dir"
  fi
  dest="$(mktemp -d "$WORK_ROOT/${1}-install.XXXXXX")"
  cp -R "$cache_dir/." "$dest/"
  printf '%s\n' "$dest"
}

# The installed layout, path by path — the tree chisel is responsible for,
# root files left out. An exact comparison also catches an extra file, which
# a list of existence asserts never does.
installed_tree() {
  ( cd "$1" && find .agents .claude .codex scripts project-management -print 2>/dev/null || true ) |
    LC_ALL=C sort
}
