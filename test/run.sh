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
  assert_file_exists "[$target] .agents/discipline.md" "$target/.agents/discipline.md"
  assert_dir_exists "[$target] .agents/formulas" "$target/.agents/formulas"
  assert_file_exists "[$target] .agents/formulas/chisel-controlled.formula.toml" \
    "$target/.agents/formulas/chisel-controlled.formula.toml"
  assert_file_exists "[$target] .agents/formulas/chisel-auto.formula.toml" \
    "$target/.agents/formulas/chisel-auto.formula.toml"
  # The v1 normative prose is retired: init must never lay it down again.
  assert_path_absent "[$target] no .agents/rules" "$target/.agents/rules"
  assert_path_absent "[$target] no .agents/workflows.md" "$target/.agents/workflows.md"
  # The role contracts, and the per-tool definitions rendered from them.
  assert_dir_exists "[$target] .agents/profiles" "$target/.agents/profiles"
  assert_file_exists "[$target] .agents/profiles/README.md" "$target/.agents/profiles/README.md"
  assert_file_exists "[$target] .agents/foreman.md" "$target/.agents/foreman.md"
  for role in architect mason inspector; do
    assert_file_exists "[$target] .agents/profiles/$role.md" "$target/.agents/profiles/$role.md"
    assert_file_exists "[$target] .claude/agents/$role.md" "$target/.claude/agents/$role.md"
    assert_file_exists "[$target] .codex/agents/$role.toml" "$target/.codex/agents/$role.toml"
  done
  # The Foreman is a doc page, never a profile and never a generated agent.
  assert_path_absent "[$target] no foreman profile" "$target/.agents/profiles/foreman.md"
  assert_path_absent "[$target] no foreman agent (claude)" "$target/.claude/agents/foreman.md"
  assert_path_absent "[$target] no foreman agent (codex)" "$target/.codex/agents/foreman.toml"
  # A page without frontmatter is documentation: nothing is rendered from it.
  assert_path_absent "[$target] no agent rendered from the README" \
    "$target/.claude/agents/README.md"
  assert_file_exists "[$target] .agents/methodology.md" "$target/.agents/methodology.md"
  assert_file_exists "[$target] .agents/project.md" "$target/.agents/project.md"
  assert_file_contains "[$target] project.md §E: AGENTS.md adapter ticked" \
    "$target/.agents/project.md" '- [x] `AGENTS.md`'
  assert_file_contains "[$target] project.md §E: CLAUDE.md adapter ticked" \
    "$target/.agents/project.md" '- [x] `CLAUDE.md`'
  assert_file_contains "[$target] project.md §E: skills symlink ticked" \
    "$target/.agents/project.md" '- [x] `.claude/skills`'
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

# The v2 router: ambient core always, the formula for scoped work.
assert_file_contains "brownfield: block routes to discipline.md" "$t1/AGENTS.md" \
  ".agents/discipline.md"
assert_file_contains "brownfield: block routes to the controlled formula" "$t1/AGENTS.md" \
  ".agents/formulas/chisel-controlled.formula.toml"
assert_file_contains "brownfield: block spells out the human gate" "$t1/AGENTS.md" \
  'stop and ask the human'
assert_file_not_contains "brownfield: block no longer routes to the retired rules" \
  "$t1/AGENTS.md" ".agents/rules/"

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

# A pre-existing project.md is project-owned: re-init must not re-tick a §E
# line a human deliberately changed.
awk 'BEGIN{done=0} !done && /^- \[x\] `\.claude\/skills`/ { sub(/^- \[x\]/, "- [ ]"); done=1 } { print }' \
  "$t1/.agents/project.md" >"$WORK_ROOT/t1-project-md-edited"
cat "$WORK_ROOT/t1-project-md-edited" >"$t1/.agents/project.md"

run_chisel "$CHISEL" init "$t1"
assert_eq "brownfield: third init exits 0" "0" "$rc"
assert_file_contains "brownfield: hand-unticked §E line survives re-init" \
  "$t1/.agents/project.md" '- [ ] `.claude/skills`'

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

# ...and three managed files, to prove update refreshes them. The rendered
# agent definition is managed too: it comes back from the profile, not from a
# copy — so keep a pristine render to compare against.
cp "$t4/.claude/agents/mason.md" "$WORK_ROOT/t4-mason-def-before-edit"
cp "$t4/.codex/agents/inspector.toml" "$WORK_ROOT/t4-inspector-def-before-edit"
printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.agents/skills/tdd/SKILL.md"
printf '\n# local edit that update must overwrite\n' \
  >>"$t4/.agents/formulas/chisel-controlled.formula.toml"
printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.claude/agents/mason.md"
printf '\n# local edit that update must overwrite\n' >>"$t4/.codex/agents/inspector.toml"

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
assert_files_identical "update: controlled formula matches socle source" \
  "$t4/.agents/formulas/chisel-controlled.formula.toml" \
  "$REPO_ROOT/socle/agents/formulas/chisel-controlled.formula.toml"
assert_files_identical "update: hand-edited agent definition re-rendered from the profile" \
  "$t4/.claude/agents/mason.md" "$WORK_ROOT/t4-mason-def-before-edit"
assert_files_identical "update: the codex render comes back too" \
  "$t4/.codex/agents/inspector.toml" "$WORK_ROOT/t4-inspector-def-before-edit"
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

# The recomposed normative layer is managed too: check must see it drift.
t5b="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t5b"
assert_eq "check fixture (discipline): init exits 0" "0" "$rc"
printf '\n<!-- diverged -->\n' >>"$t5b/.agents/discipline.md"
run_chisel "$CHISEL" check "$t5b"
assert_eq "check: exit 1 after hand-editing discipline.md" "1" "$rc"
assert_file_contains "check: reports the diverged discipline.md" "$WORK_ROOT/last.log" \
  ".agents/discipline.md"

# So are the rendered agent definitions: they are managed files, not
# suggestions — a hand edit is drift, and check says which one.
t5c="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t5c"
assert_eq "check fixture (agent definition): init exits 0" "0" "$rc"
printf '\n<!-- diverged -->\n' >>"$t5c/.claude/agents/architect.md"
printf '\n# diverged\n' >>"$t5c/.codex/agents/mason.toml"
run_chisel "$CHISEL" check "$t5c"
assert_eq "check: exit 1 after hand-editing a generated agent definition" "1" "$rc"
assert_file_contains "check: reports the diverged agent definition" "$WORK_ROOT/last.log" \
  ".claude/agents/architect.md"
assert_file_contains "check: reports the diverged codex definition too" "$WORK_ROOT/last.log" \
  ".codex/agents/mason.toml"

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

# ---------------------------------------------------------------------------
# 7. the recomposed normative layer: formula shape + neutral wording.
#    Shape checks read the INSTALLED tree (what an equipped repo gets);
#    the neutrality greps read the socle sources this slice ships.
# ---------------------------------------------------------------------------
printf '\n-- 7. formulas: shape, gates, neutrality --\n'
controlled="$t1/.agents/formulas/chisel-controlled.formula.toml"
auto="$t1/.agents/formulas/chisel-auto.formula.toml"

# `version` must be an integer, not a semver string — bd refuses to parse it
# otherwise (chantier lesson).
assert_file_contains "formulas: controlled declares version = 1 (integer)" \
  "$controlled" 'version = 1'
assert_file_contains "formulas: auto declares version = 1 (integer)" \
  "$auto" 'version = 1'
assert_file_not_contains "formulas: controlled version is not a quoted string" \
  "$controlled" 'version = "'
assert_file_not_contains "formulas: auto version is not a quoted string" \
  "$auto" 'version = "'

# Controlled = exactly 3 human gates, Auto = zero. That difference IS the mode.
# Anchored: the header comment of each file quotes the gate syntax in prose.
# `|| true` on both counts, symmetrically: grep -c exits 1 on zero matches,
# which would kill the suite under `set -e` without printing a FAIL line.
assert_eq "formulas: controlled carries exactly 3 human gates" "3" \
  "$(grep -c '^type = "human"' "$controlled" || true)"
assert_eq "formulas: auto carries zero human gates" "0" \
  "$(grep -c '^type = "human"' "$auto" || true)"

# Same steps in the same order — the two files are one pipeline in two modes.
grep '^id = ' "$controlled" >"$WORK_ROOT/controlled-steps.txt" || true
grep '^id = ' "$auto" >"$WORK_ROOT/auto-steps.txt" || true
assert_eq "formulas: controlled declares step ids at all" "7" \
  "$(wc -l <"$WORK_ROOT/controlled-steps.txt" | tr -d ' ')"
assert_files_identical "formulas: both declare the same ordered step ids" \
  "$WORK_ROOT/controlled-steps.txt" "$WORK_ROOT/auto-steps.txt"
assert_eq "formulas: seven steps in controlled" "7" \
  "$(grep -c '^\[\[steps\]\]' "$controlled" || true)"

# The mode difference is EXACTLY the gates plus escalation wording: every step
# body of Auto must be the Controlled body with lines appended and none
# removed. Extract the description blocks per file, then assert the diff has
# no removed line.
extract_descriptions() {
  awk '
    /^description = """$/ { inblock = 1; next }
    inblock && /^"""$/    { inblock = 0; print "---"; next }
    inblock               { print }
  ' "$1"
}
extract_descriptions "$controlled" >"$WORK_ROOT/controlled-desc.txt"
extract_descriptions "$auto" >"$WORK_ROOT/auto-desc.txt"
removed_lines="$(diff "$WORK_ROOT/controlled-desc.txt" "$WORK_ROOT/auto-desc.txt" |
  grep -c '^<' || true)"
assert_eq "formulas: auto only ADDS to the shared step bodies (gates + escalation)" \
  "0" "$removed_lines"

# Neutrality, over the socle SOURCES this recomposition ships. Files owned by
# later slices (methodology.md, the skills, PHILOSOPHY.md) are deliberately
# out of this list — they lose their vendor wording in slices 03 and 07.
# Relative paths, joined to $REPO_ROOT inside the loop: a repo path containing
# a space must not word-split the list.
label_hits=""
vendor_hits=""
ledger_hits=""
for rel in socle/agents/discipline.md \
  socle/agents/formulas/chisel-controlled.formula.toml \
  socle/agents/formulas/chisel-auto.formula.toml \
  socle/templates/AGENTS-block.md; do
  f="$REPO_ROOT/$rel"
  if grep -Eq 'W0|W1|W2' "$f"; then
    label_hits="$label_hits $rel"
  fi
  if grep -Eiq 'cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai' "$f"; then
    vendor_hits="$vendor_hits $rel"
  fi
done
# A step never names a ledger backend: writes go through the glue convention.
for rel in socle/agents/formulas/chisel-controlled.formula.toml \
  socle/agents/formulas/chisel-auto.formula.toml; do
  if grep -Eiq '(^|[^a-z])(bd|beads|dolt|linear|jira)([^a-z]|$)' "$REPO_ROOT/$rel"; then
    ledger_hits="$ledger_hits $rel"
  fi
done
assert_eq "neutrality: no W0/W1/W2 mode label in the recomposed layer" "" "$label_hits"
assert_eq "neutrality: no vendor or model name in the recomposed layer" "" "$vendor_hits"
assert_eq "neutrality: no ledger backend named in a formula step" "" "$ledger_hits"

# A real TOML parse when the interpreter has one; the repo's floor is a bare
# python3, so this check says so out loud rather than silently passing.
if python3 -c 'import tomllib' >/dev/null 2>&1; then
  if python3 - "$controlled" "$auto" <<'PY'
import sys, tomllib
for path in sys.argv[1:]:
    with open(path, "rb") as f:
        data = tomllib.load(f)
    assert isinstance(data["version"], int), path
    ids = [s["id"] for s in data["steps"]]
    assert len(ids) == len(set(ids)) == 7, path
PY
  then
    pass "formulas: both parse as TOML (version integer, 7 unique step ids)"
  else
    fail "formulas: both parse as TOML (version integer, 7 unique step ids)"
  fi
else
  printf 'SKIP: TOML parse check (this python3 has no tomllib — needs 3.11+)\n'
fi

# ---------------------------------------------------------------------------
# 8. the role profiles: contract shape, neutral wording, and the per-tool
#    definitions rendered from them (the renders are thin — the profile body
#    is the source, byte for byte).
# ---------------------------------------------------------------------------
printf '\n-- 8. profiles: contract, neutrality, rendering --\n'

# Each profile carries the five contract sections. Grepping the INSTALLED
# tree: this is what an equipped repo's agents actually read.
for role in architect mason inspector; do
  profile="$t1/.agents/profiles/$role.md"
  assert_file_contains "profiles: $role declares a mission" "$profile" '## Mission'
  assert_file_contains "profiles: $role declares a tier" "$profile" '## Tier'
  assert_file_contains "profiles: $role declares prohibitions" "$profile" '## Prohibitions'
  assert_file_contains "profiles: $role declares escalation rules" "$profile" '## Escalation'
  assert_file_contains "profiles: $role declares what it receives" "$profile" \
    '## Inputs — what this role receives'
  assert_file_contains "profiles: $role frontmatter names the role" "$profile" \
    "name: $role"
done

# The brief is artifacts only — the one obligation this slice owes the
# formulas' `type` and `review` steps.
assert_file_contains "profiles: mason is never handed the planning conversation" \
  "$t1/.agents/profiles/mason.md" 'never the planning conversation'
assert_file_contains "profiles: inspector is handed a pinned fixed point" \
  "$t1/.agents/profiles/inspector.md" 'The fixed point'

# Tiers are abstract, and they agree with what the formulas say about each
# role: the formula step and the profile are one contract in two places.
assert_file_contains "profiles: architect tier is frontier" \
  "$t1/.agents/profiles/architect.md" 'tier: frontier'
assert_file_contains "formulas: architect step states the same tier" \
  "$t1/.agents/formulas/chisel-controlled.formula.toml" 'Architect (frontier tier)'
assert_file_contains "profiles: mason tier is cheap or mid" \
  "$t1/.agents/profiles/mason.md" 'tier: cheap or mid'
assert_file_contains "formulas: mason step states the same tier" \
  "$t1/.agents/formulas/chisel-controlled.formula.toml" 'Mason (cheap or mid tier)'
assert_file_contains "profiles: inspector tier is frontier" \
  "$t1/.agents/profiles/inspector.md" 'tier: frontier'
assert_file_contains "formulas: inspector step states the same tier" \
  "$t1/.agents/formulas/chisel-controlled.formula.toml" 'Inspector (frontier tier)'

# The universal fallback is documented where the profiles live.
assert_file_contains "profiles: the universal fallback is documented" \
  "$t1/.agents/profiles/README.md" 'fallback'
assert_file_contains "foreman: documented as routing, not as an agent" \
  "$t1/.agents/foreman.md" 'not an agent'

# The renders are thin: the body of each generated definition is the profile
# body, byte for byte. Anything else means someone paraphrased a contract.
for role in architect mason inspector; do
  awk 'NR == 1 && $0 == "---" { h = 1; next }
       h && $0 == "---" { h = 0; next }
       h { next }
       !s && $0 == "" { next }
       { s = 1; print }' "$t1/.agents/profiles/$role.md" >"$WORK_ROOT/profile-body-$role.txt"
  awk 'f { print } /^<!-- chisel:generated /  { f = 1 }' \
    "$t1/.claude/agents/$role.md" |
    awk '!s && $0 == "" { next } { s = 1; print }' >"$WORK_ROOT/claude-body-$role.txt"
  assert_files_identical "render: claude definition of $role carries the profile body verbatim" \
    "$WORK_ROOT/profile-body-$role.txt" "$WORK_ROOT/claude-body-$role.txt"
  assert_file_contains "render: claude definition of $role has a name in frontmatter" \
    "$t1/.claude/agents/$role.md" "name: \"$role\""
  assert_file_contains "render: codex definition of $role declares developer_instructions" \
    "$t1/.codex/agents/$role.toml" 'developer_instructions'
  assert_file_contains "render: codex definition of $role declares its name" \
    "$t1/.codex/agents/$role.toml" "name = \"$role\""
  # The provenance pointer names the file the render actually came from.
  assert_file_contains "render: claude definition of $role points at its source" \
    "$t1/.claude/agents/$role.md" "from .agents/profiles/$role.md"
  assert_file_contains "render: codex definition of $role points at its source" \
    "$t1/.codex/agents/$role.toml" "from .agents/profiles/$role.md"
  assert_file_exists "render: the source $role points at exists" \
    "$t1/.agents/profiles/$role.md"
done

# Every role a formula step names must have a profile: the formulas say
# "Role: Architect", "Role: Architect or Mason", and nothing else may appear
# there. Derived from BOTH formulas rather than from a hardcoded list, so a
# role added to a step without a contract fails here.
: >"$WORK_ROOT/formula-roles.txt"
for formula in chisel-controlled chisel-auto; do
  awk '
    index($0, "Role: ") == 1 {
      rest = substr($0, 7)
      sub(/[(,.—].*/, "", rest)
      n = split(rest, words, /[^A-Za-z]+/)
      for (i = 1; i <= n; i++) {
        if (words[i] ~ /^[A-Z][a-z]+$/) { print tolower(words[i]) }
      }
    }
  ' "$t1/.agents/formulas/$formula.formula.toml" >>"$WORK_ROOT/formula-roles.txt"
done
formula_roles="$(LC_ALL=C sort -u "$WORK_ROOT/formula-roles.txt" | tr '\n' ' ')"
assert_eq "formulas: the steps name exactly the three profiled roles" \
  "architect inspector mason " "$formula_roles"
missing_profiles=""
for role in $formula_roles; do
  [ -f "$t1/.agents/profiles/$role.md" ] || missing_profiles="$missing_profiles $role"
done
assert_eq "formulas: every role named in a step resolves to a profile" "" "$missing_profiles"

# Neutrality, over everything this slice ships AND everything it renders. The
# socle speaks in tiers (the tier→model mapping is slice 03's) and never names
# a tool in prose: adapter PATHS are filesystem facts and live in code spans,
# so the greps read each file with its code spans stripped. Relative literals
# joined to their root inside the loop — a repo path containing a space must
# not word-split the list.
profile_label_hits=""
profile_model_hits=""
profile_tool_hits=""
for rel in socle/agents/profiles/README.md \
  socle/agents/profiles/architect.md \
  socle/agents/profiles/mason.md \
  socle/agents/profiles/inspector.md \
  socle/agents/foreman.md; do
  f="$REPO_ROOT/$rel"
  if grep -Eq 'W0|W1|W2' "$f"; then
    profile_label_hits="$profile_label_hits $rel"
  fi
  if sed -e 's|`[^`]*`||g' "$f" |
    grep -Eiq 'grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai'; then
    profile_model_hits="$profile_model_hits $rel"
  fi
  if sed -e 's|`[^`]*`||g' "$f" | grep -Eiq 'cursor|codex|claude|copilot|windsurf'; then
    profile_tool_hits="$profile_tool_hits $rel"
  fi
done
# The renders inherit the sources' neutrality — assert it rather than assume
# it, since a render is what a tool actually loads.
for rel in .claude/agents/architect.md .claude/agents/mason.md .claude/agents/inspector.md \
  .codex/agents/architect.toml .codex/agents/mason.toml .codex/agents/inspector.toml; do
  f="$t1/$rel"
  if grep -Eq 'W0|W1|W2' "$f"; then
    profile_label_hits="$profile_label_hits $rel"
  fi
  if sed -e 's|`[^`]*`||g' "$f" |
    grep -Eiq 'grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai'; then
    profile_model_hits="$profile_model_hits $rel"
  fi
done
assert_eq "neutrality: no W0/W1/W2 mode label in the profiles or their renders" \
  "" "$profile_label_hits"
assert_eq "neutrality: no model name in the profiles or their renders" "" "$profile_model_hits"
assert_eq "neutrality: no tool name in the prose of this layer (paths excepted)" \
  "" "$profile_tool_hits"

# A definition chisel did not write is never destroyed: `.claude/agents/` is
# shared with the user's own sub-agents, and a role name can collide.
t8="$(fresh_copy brownfield)"
mkdir -p "$t8/.claude/agents"
printf '# my own architect, hand written\n' >"$t8/.claude/agents/architect.md"
run_chisel "$CHISEL" init "$t8"
assert_eq "foreign definition: init still exits 0" "0" "$rc"
assert_file_contains "foreign definition: left untouched by init" \
  "$t8/.claude/agents/architect.md" "my own architect, hand written"
assert_file_contains "foreign definition: init warns about it" "$WORK_ROOT/last.log" \
  "was not generated by chisel"
assert_file_exists "foreign definition: the other roles are still rendered" \
  "$t8/.claude/agents/mason.md"

# The Codex renders must be real TOML — the body travels as a multi-line
# literal string, which is exactly why the renderer refuses a body containing
# the delimiter. Same floor as group 7: said out loud when tomllib is absent.
if python3 -c 'import tomllib' >/dev/null 2>&1; then
  if python3 - "$t1" <<'PY'
import pathlib, sys, tomllib

target = pathlib.Path(sys.argv[1])
for role in ("architect", "mason", "inspector"):
    data = tomllib.loads((target / ".codex/agents" / (role + ".toml")).read_text(encoding="utf-8"))
    assert data["name"] == role, data
    assert data["description"].strip(), role
    body = (target / ".agents/profiles" / (role + ".md")).read_text(encoding="utf-8")
    body = body.split("---\n", 2)[2].lstrip("\n")
    assert data["developer_instructions"] == body, role
PY
  then
    pass "render: codex definitions parse as TOML and carry the profile body"
  else
    fail "render: codex definitions parse as TOML and carry the profile body"
  fi
else
  printf 'SKIP: codex TOML parse check (this python3 has no tomllib — needs 3.11+)\n'
fi

printf '\n=== %d passed, %d failed ===\n' "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
