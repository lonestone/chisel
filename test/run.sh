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

# ...and two managed files, to prove update refreshes them.
printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.agents/skills/tdd/SKILL.md"
printf '\n# local edit that update must overwrite\n' \
  >>"$t4/.agents/formulas/chisel-controlled.formula.toml"

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
# 8. model tiers: the socle names tiers, never models — and the user.md
#    cascade. Neutrality is scanned over EVERY socle source here (this slice's
#    AC is socle-wide, unlike group 7's deliberately narrow list, which guards
#    the recomposed layer against regression). Both scans share the one
#    `model_name_re` defined in group 7.
# ---------------------------------------------------------------------------
printf '\n-- 8. model tiers: neutrality, cascade, user.md --\n'

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

# `user.md` is personal: a shared installer never writes one, and never ships
# the template into the equipped repo either.
assert_path_absent "init: no personal .agents/user.md posed (brownfield)" "$t1/.agents/user.md"
assert_path_absent "init: no personal .agents/user.md posed (boilerplate)" "$t3/.agents/user.md"
assert_path_absent "init: the user.md template stays in the socle" "$t1/.agents/user.md.tpl"

# `update` does not create one either — t4 was init'ed and updated above and
# never had a personal file: a dev who has written none still has none after
# an upgrade, and still resolves through the glue and the socle default.
assert_path_absent "update: no personal .agents/user.md conjured up" "$t4/.agents/user.md"
assert_path_absent "update: the user.md template stays in the socle" "$t4/.agents/user.md.tpl"

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

printf '\n=== %d passed, %d failed ===\n' "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
