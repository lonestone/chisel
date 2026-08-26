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
  assert_file_contains "[$target] project.md §E: claude agent definitions ticked" \
    "$target/.agents/project.md" '- [x] `.claude/agents`'
  assert_file_contains "[$target] project.md §E: codex agent definitions ticked" \
    "$target/.agents/project.md" '- [x] `.codex/agents`'
  # The personal file's TEMPLATE is installed (any dev poses their own from
  # it); the personal file itself never is.
  assert_file_exists "[$target] .agents/user.md.tpl" "$target/.agents/user.md.tpl"
  assert_path_absent "[$target] no personal .agents/user.md" "$target/.agents/user.md"
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

# The model-identifier alphabet, used BOTH by the narrow scan below and by the
# socle-wide scan in group 8 — one list, kept in one place. It deliberately
# carries `claude-` rather than a bare vendor word: `CLAUDE.md` and
# `.claude/skills` are adapter PATHS, which the neutrality rule excepts.
model_name_re='cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai|copilot|claude-|llama|mistral|deepseek|qwen'

# Neutrality, over the socle SOURCES this recomposition ships. This narrow list
# is the regression guard on the recomposed layer specifically; the socle-wide
# scan lives in group 8. `PHILOSOPHY.md` still carries v1 wording and belongs
# to slice 07.
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
  if grep -Eiq "$model_name_re" "$f"; then
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

# ---------------------------------------------------------------------------
# 9. model tiers: the socle names tiers, never models — and the user.md
#    cascade. Neutrality is scanned over EVERY socle source here (this slice's
#    AC is socle-wide, unlike group 7's deliberately narrow list, which guards
#    the recomposed layer against regression). Both scans share the one
#    `model_name_re` defined in group 7.
# ---------------------------------------------------------------------------
printf '\n-- 9. model tiers: neutrality, cascade, user.md --\n'

model_name_hits="$(grep -rliE "$model_name_re" "$REPO_ROOT/socle" || true)"
assert_eq "tiers: no model identifier anywhere in the socle (adapter paths excepted)" \
  "" "$model_name_hits"

methodology_src="$REPO_ROOT/socle/agents/methodology.md"
user_tpl="$REPO_ROOT/socle/agents/user.md.tpl"
code_review_src="$REPO_ROOT/socle/agents/skills/code-review/SKILL.md"

# One normative place, and the assertion names WHICH one: a second copy of the
# resolution rule anywhere under socle/ fails here.
tier_rule_files="$(grep -rlF '## Model tiers (and how they resolve)' "$REPO_ROOT/socle" || true)"
assert_eq "tiers: the resolution rule is written in exactly one socle file" \
  "$methodology_src" "$tier_rule_files"

# The three tiers the delivered formulas already speak are defined there.
assert_file_contains "tiers: frontier is defined" "$methodology_src" '**frontier**'
assert_file_contains "tiers: mid is defined" "$methodology_src" '**mid**'
assert_file_contains "tiers: cheap is defined" "$methodology_src" '**cheap**'

# The cascade, in order, plus the fallthrough that keeps a fresh dev working.
assert_file_contains "cascade: level 1 is the personal user.md" \
  "$methodology_src" '1. **`.agents/user.md`**'
assert_file_contains "cascade: level 2 is the versioned glue" \
  "$methodology_src" '2. **`.agents/project.md`**'
assert_file_contains "cascade: level 3 is the socle default" \
  "$methodology_src" '3. **The socle default**'
assert_file_contains "cascade: a dev with no user.md is not blocked" \
  "$methodology_src" 'A dev with no `user.md` is never blocked'

# Texts that need a model choice ask for a tier and point here. (That they name
# no model is covered by the socle-wide scan above, not by this needle.)
assert_file_contains "code-review: asks for a tier" \
  "$code_review_src" 'frontier'
assert_file_contains "code-review: points at the one normative place" \
  "$code_review_src" 'methodology.md#model-tiers-and-how-they-resolve'
assert_file_not_contains "code-review: no pointer left to the retired workflows.md" \
  "$code_review_src" 'workflows.md'

# The template ships, points at the rule, and is INERT: everything outside an
# HTML comment must be headings only, so that an untouched copy overrides
# nothing and resolution falls through to the glue and then the socle default.
assert_file_exists "user.md: the socle ships a template" "$user_tpl"
assert_file_contains "user.md: the template points at the one normative place" \
  "$user_tpl" 'Model tiers (and how they resolve)'
assert_file_contains "user.md: the template says the file is never committed" \
  "$user_tpl" 'NEVER committed'
# awk, not python3: a failed command substitution in an assignment aborts the
# whole suite under `set -e`, with no FAIL line and no tally. awk is part of
# the same POSIX floor bin/chisel.sh already stands on.
strip_html_comments() {
  awk '
    BEGIN { inc = 0 }
    {
      line = $0
      out = ""
      while (length(line) > 0) {
        if (inc) {
          i = index(line, "-->")
          if (i == 0) { line = ""; break }
          line = substr(line, i + 3)
          inc = 0
        } else {
          i = index(line, "<!--")
          if (i == 0) { out = out line; line = ""; break }
          out = out substr(line, 1, i - 1)
          line = substr(line, i + 4)
          inc = 1
        }
      }
      print out
    }
  ' "$1"
}
if strip_html_comments "$user_tpl" | grep -qwiE 'frontier|mid|cheap'; then
  fail "user.md: the example mapping is commented out (an untouched copy overrides nothing)"
else
  pass "user.md: the example mapping is commented out (an untouched copy overrides nothing)"
fi

# `user.md` is personal: a shared installer never writes one. The TEMPLATE, on
# the other hand, is socle text and IS installed — that is what lets the setup
# and every later dev pose their own copy with no package and no network
# (slice 04, D0.3; slice 03 had assumed the setup could reach the socle's own
# copy, which a repo equipped by `npx` cannot).
assert_path_absent "init: no personal .agents/user.md posed (brownfield)" "$t1/.agents/user.md"
assert_path_absent "init: no personal .agents/user.md posed (boilerplate)" "$t3/.agents/user.md"
assert_file_exists "init: the user.md template is installed to copy from" "$t1/.agents/user.md.tpl"
assert_files_identical "init: the installed template is the socle's, byte for byte" \
  "$t1/.agents/user.md.tpl" "$REPO_ROOT/socle/agents/user.md.tpl"

# `update` does not create a personal file either — t4 was init'ed and updated
# above and never had one: a dev who has written none still has none after an
# upgrade, and still resolves through the glue and the socle default.
assert_path_absent "update: no personal .agents/user.md conjured up" "$t4/.agents/user.md"
assert_file_exists "update: the user.md template is still there" "$t4/.agents/user.md.tpl"

# ...and once a dev HAS written theirs, update never touches it and check
# never flags it (it is not a managed file).
t8="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t8"
assert_eq "user.md fixture: init exits 0" "0" "$rc"
printf '# Personal agent settings\n\n## Model tiers\n\n- **frontier:** my-own-model-id\n' \
  >"$t8/.agents/user.md"
cp "$t8/.agents/user.md" "$WORK_ROOT/t8-user-md-before-update"

run_chisel "$CHISEL" update "$t8"
assert_eq "user.md: update exits 0" "0" "$rc"
assert_files_identical "user.md: update leaves the personal file byte-intact" \
  "$WORK_ROOT/t8-user-md-before-update" "$t8/.agents/user.md"

run_chisel "$CHISEL" check "$t8"
assert_eq "user.md: check stays clean with a personal file present" "0" "$rc"

# ---------------------------------------------------------------------------
# 10. setup v2: the case is chosen in the glue (§B1/B2/B3), the adapters are
#     fully inventoried (§E), the team tier mapping exists (§H), and the
#     questionnaire asks all of it in the user's language. The glue shape is
#     read off the INSTALLED tree (what an equipped repo gets); the wording
#     rule is read off the skill source, which is the same file byte for byte.
# ---------------------------------------------------------------------------
printf '\n-- 10. setup v2: the case, the glue, the personal file --\n'

glue="$t1/.agents/project.md"
setup_skill="$REPO_ROOT/socle/agents/skills/chisel-setup/SKILL.md"

# What a reader of a DEFAULT `project.md` actually sees: the glue with its HTML
# comments removed (strip_html_comments is group 9's). The rules that bind
# every reader — the refusal, the open list, the mechanism — must survive this
# stripping; the "what to write instead when you pick the other case" guidance
# may stay in a comment.
strip_html_comments "$glue" >"$WORK_ROOT/glue-visible.txt"

# §B keeps its letter — both formulas and discipline.md point at "§B" — and
# carries the three decisions as sub-sections.
assert_file_contains "glue: §B is still one section, by letter" "$glue" '## B · Coordination'
assert_file_contains "glue: B1 asks where statuses live" "$glue" '### B1 · Where task statuses live'
assert_file_contains "glue: B2 is the external-tracker bridge" "$glue" \
  '### B2 · Link to an external tracker'
assert_file_contains "glue: B3 is the autonomous-run switch" "$glue" '### B3 · Autonomous runs'

# The three documented defaults, on a fixture where the user accepted
# everything (an untouched init IS that case).
assert_file_contains "defaults: B1 = statuses in the task files" "$glue" \
  '**Statuses: in the task files.**'
assert_file_contains "defaults: B2 = no external tracker" "$glue" \
  '**External tracker: none.**'
assert_file_contains "defaults: B3 = autonomous runs disabled" "$glue" \
  '**Autonomous runs: disabled.**'

# B1 documents all three cases, and the server case is pitched for ONE machine
# with several agents — never as the answer to "we are several people". The
# existence of the two other cases is VISIBLE (a reader of the default file
# knows there is a choice); their full wording is guidance, and may be a comment.
assert_file_contains "B1: the other two cases are visible, not buried in a comment" \
  "$WORK_ROOT/glue-visible.txt" '- **Other cases:**'
assert_file_contains "B1: the visible line scopes the served case to one machine" \
  "$WORK_ROOT/glue-visible.txt" 'running at once on ONE'
assert_file_contains "B1: the committed-database case is documented" "$glue" \
  'a database committed next to the files'
assert_file_contains "B1: the server case is scoped to one machine" "$glue" \
  'machine running several agents at the same time'
assert_file_contains "B1: the server case is disclaimed for multi-dev" "$glue" \
  'It is NOT the answer to "we are several people"'
assert_file_contains "B1: the prerequisite version is named" "$glue" '1.2.2 or newer'

# The choice and the state on disk are two facts: the default says outright
# there is nothing to initialise, and the database cases carry a checkbox that
# only the initialisation step ticks.
assert_file_contains "B1: the default states there is nothing to initialise" "$glue" \
  '- **State:** the task files ARE the state'
assert_file_contains "B1: a database case carries an unticked initialised line" "$glue" \
  '`- [ ] initialised`'
assert_file_contains "B1: creating the database is a separate, named step" "$glue" \
  'is a separate, named step of the setup'

# B2 is a MECHANISM plus an open list, not a menu of three — and the open-list
# rule is the part every reader must see, so it is asserted on the visible text.
assert_file_contains "B2: the open list is visible, not buried in a comment" \
  "$WORK_ROOT/glue-visible.txt" '**The list of trackers is open.**'
assert_file_contains "B2: adding one is one adapter page, no toolkit change" \
  "$WORK_ROOT/glue-visible.txt" 'writing one adapter page'
assert_file_contains "B2: an adapter page has a declared home" \
  "$WORK_ROOT/glue-visible.txt" '- **Adapter page:**'
assert_file_contains "B2: the link travels in external_ref when there is a database" \
  "$glue" 'external_ref'
assert_file_contains "B2: the link travels in the task file otherwise" "$glue" \
  '**Ticket:** <url>'

# B3 is the authorization: the glue REFUSES in the imperative while it reads
# disabled, says what enabling changes, and the two delivered texts that route
# an autonomous run send the reader here. Both halves of the switch are visible
# prose — this is the one line an agent must be able to read at a glance.
assert_file_contains "B3: the glue refuses an autonomous run when disabled" \
  "$WORK_ROOT/glue-visible.txt" 'must **refuse**'
assert_file_contains "B3: the glue says what enabling changes" \
  "$WORK_ROOT/glue-visible.txt" 'and such a run **proceeds**'
assert_file_contains "B3: enabled is still never the default posture" \
  "$WORK_ROOT/glue-visible.txt" 'it never becomes'
assert_file_contains "B3: nobody may grant it in-session" \
  "$WORK_ROOT/glue-visible.txt" 'Nobody may grant themselves the'
assert_file_contains "B3: the router defers to the project glue" "$t1/AGENTS.md" \
  'project glue allows it'
assert_file_contains "B3: the auto pipeline defers to the project glue" \
  "$t1/.agents/formulas/chisel-auto.formula.toml" 'project glue enables it'

# --- AC 2, mechanised: the wording the USER is shown -----------------------
# Everything the questionnaire puts on screen is a blockquote in the skill (the
# skill says so itself). Extract exactly that, strip code spans — a command or
# an adapter path is a fact, not jargon — and hold the rest to plain language.
grep '^>' "$setup_skill" | sed -e 's|`[^`]*`||g' >"$WORK_ROOT/setup-shown.txt" || true
shown_lines="$(wc -l <"$WORK_ROOT/setup-shown.txt" | tr -d ' ')"
if [ "$shown_lines" -gt 30 ]; then
  pass "setup: the user-facing screens are extractable (blockquote convention)"
else
  fail "setup: the user-facing screens are extractable (blockquote convention) (got $shown_lines lines)"
fi
assert_file_contains "setup: the blockquote convention is stated in the skill" \
  "$setup_skill" 'quoted as a **blockquote**'
# grep -c counts matching LINES, not occurrences — only the comparison to zero
# is meaningful here, which is exactly the assertion being made.
jargon_hits="$(grep -ciE 'ledger|formula|bead' "$WORK_ROOT/setup-shown.txt" || true)"
assert_eq "setup: no toolkit jargon on screen (ledger / formula / bead)" "0" "$jargon_hits"
# ...and no section letters or internal file names either: the letters are for
# the file, not for the reader.
letter_hits="$(grep -cE '§[A-H]|project\.md|\.agents/project' "$WORK_ROOT/setup-shown.txt" || true)"
assert_eq "setup: no section letters or glue paths on screen" "0" "$letter_hits"

# Every option the user is offered explains itself: a bolded choice, then an em
# dash, then what it buys and what it costs — all on the option's own line. The
# needle is `** — ` (the bold CLOSING), so a dash inside the label alone does
# not satisfy it. The count is over the whole questionnaire; only §B offers
# numbered options today, and that is 3 + 3 + 2.
grep -E '^> *[0-9]+\. \*\*' "$WORK_ROOT/setup-shown.txt" >"$WORK_ROOT/setup-options.txt" || true
option_count="$(wc -l <"$WORK_ROOT/setup-options.txt" | tr -d ' ')"
assert_eq "setup: the questionnaire offers exactly 8 numbered options (3 + 3 + 2)" \
  "8" "$option_count"
unexplained=""
while IFS= read -r opt_line; do
  [ -n "$opt_line" ] || continue
  case "$opt_line" in
    *'** — '*) ;;
    *) unexplained="$unexplained|$opt_line" ;;
  esac
done <"$WORK_ROOT/setup-options.txt"
assert_eq "setup: every option carries its one-line explanation" "" "$unexplained"

# --- the questionnaire's shape --------------------------------------------
assert_file_contains "setup: walks A through H" "$setup_skill" 'sections A through H'
assert_file_contains "setup: one section per message, still" "$setup_skill" \
  'Never present two sections in the same message.'
assert_file_contains "setup: §B is three messages, not one screen" "$setup_skill" \
  'are three separate messages, not one screen'
assert_file_contains "setup: §E stays read-back only" "$setup_skill" \
  '§E is read-back only, never asked'
assert_file_contains "setup: §E reads back all five adapters" "$setup_skill" \
  'which of the five adapters are present'
assert_file_contains "setup: a sub-section write span is bounded" "$setup_skill" \
  'whichever comes first'
assert_file_contains "setup: answering one sub-question leaves the others alone" \
  "$setup_skill" 'must leave B1 and B3 byte-identical'
assert_file_contains "setup: still never rewrites the whole file" "$setup_skill" \
  '**Never rewrite the whole file.**'
# The open list has no built-in exceptions: choosing a listed tracker writes an
# adapter page exactly like choosing an unlisted one — the socle ships none.
assert_file_contains "B2 branch: every tracker, listed or not, needs its adapter page" \
  "$setup_skill" 'means writing the adapter page'
assert_file_contains "B2 branch: the page is written before the next question" \
  "$setup_skill" 'now, before moving to §B3'
assert_file_contains "B2 branch: never a path to a page that does not exist" \
  "$setup_skill" 'never as a path to a page that does not exist'

# --- B1 = a database: check, never install, never execute ------------------
assert_file_contains "B1 branch: a minimum version is checked" "$setup_skill" \
  'the minimum version is'
assert_file_contains "B1 branch: that minimum is 1.2.2" "$setup_skill" '**1.2.2**'
assert_file_contains "B1 branch: the setup never installs the tool" "$setup_skill" \
  'never install it yourself'
assert_file_contains "B1 branch: it shows the install command instead" "$setup_skill" \
  'install.sh'
assert_file_contains "B1 branch: it offers the task files as the fallback" "$setup_skill" \
  'keep the statuses in the task files for now'
assert_file_contains "B1 branch: it says the upgrade is tooled" "$setup_skill" \
  'Moving to the database later is tooled'
assert_file_contains "B1 branch: it records the choice and stops" "$setup_skill" \
  'Record the choice, and stop there'
# The execution belongs to the coordination-convention slice: this
# questionnaire must not run a command that creates state.
assert_file_not_contains "B1 branch: the questionnaire never initialises anything" \
  "$setup_skill" 'bd init'
assert_file_not_contains "B1 branch: the questionnaire creates no records" \
  "$setup_skill" 'bd create'

# --- the personal file ------------------------------------------------------
assert_file_contains "user.md: the setup poses it from the installed template" \
  "$setup_skill" 'copy `.agents/user.md.tpl` to `.agents/user.md`'
assert_file_contains "user.md: an existing one is never clobbered" "$setup_skill" \
  'it is never overwritten'
assert_file_contains "user.md: the setup adds the ignore rule" "$setup_skill" \
  '`.gitignore`'
assert_file_contains "user.md: the ignore line is appended once, not per run" \
  "$setup_skill" 'never a duplicate line'
assert_file_contains "user.md: the next dev's path is documented and light" \
  "$setup_skill" 'This step stands alone.'

# --- §H, the cascade's middle rung -----------------------------------------
assert_file_contains "glue: §H exists" "$glue" '## H · Model tiers'
assert_file_contains "glue: §H is unset by default" "$glue" '**Team mapping:** _(not set'
assert_file_contains "glue: §H points at the one normative place" "$glue" \
  'Model tiers (and how they resolve)'
# ...and does NOT become a second normative source: the heading that carries
# the rule stays methodology.md's alone (group 9 asserts the other direction).
assert_file_not_contains "glue: §H does not restate the rule" "$glue" \
  '## Model tiers (and how they resolve)'
assert_file_contains "setup: §H is asked, with 'unset' as the recommendation" \
  "$setup_skill" 'Recommended: **leave it unset**'

# --- neutrality of the two files this slice rewrites -------------------------
# Same two accumulators as groups 7 and 8, so a hit reads the same way
# everywhere. Relative literals joined to their root inside the loop — a repo
# path containing a space must not word-split the list.
setup_label_hits=""
setup_model_hits=""
for rel in socle/agents/project.md.tpl \
  socle/agents/skills/chisel-setup/SKILL.md; do
  f="$REPO_ROOT/$rel"
  if grep -Eq 'W0|W1|W2' "$f"; then
    setup_label_hits="$setup_label_hits $rel"
  fi
  if grep -Eiq "$model_name_re" "$f"; then
    setup_model_hits="$setup_model_hits $rel"
  fi
done
assert_eq "neutrality: no W0/W1/W2 mode label in the glue or the questionnaire" \
  "" "$setup_label_hits"
assert_eq "neutrality: no model name in the glue or the questionnaire" \
  "" "$setup_model_hits"

printf '\n=== %d passed, %d failed ===\n' "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
