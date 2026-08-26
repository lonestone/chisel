# test/installer.sh — behavioral groups (CLI-seam tests for bin/chisel.sh).
# Sourced by test/run.sh after test/lib.sh. STEP 1 of the rebuild: old group
# bodies relocated unmodified so the split runs green before any content
# changes. Reduced to behavior-only groups in the next commit.

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
  assert_file_exists "[$target] .agents/formulas/chisel-supervised.formula.toml" \
    "$target/.agents/formulas/chisel-supervised.formula.toml"
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
  # The journal, under its v2 name — and NOT under the v1 one: a fresh install
  # must never lay down a `CHANGELOG.md` again (that name belongs to releases).
  assert_file_exists "[$target] project-management/LOG.md" "$target/project-management/LOG.md"
  assert_path_absent "[$target] no project-management/CHANGELOG.md" \
    "$target/project-management/CHANGELOG.md"
  assert_file_exists "[$target] scripts/task-id.sh" "$target/scripts/task-id.sh"
  assert_executable "[$target] scripts/task-id.sh is executable" "$target/scripts/task-id.sh"
}

# ---------------------------------------------------------------------------
# 1. brownfield: init produces the full target layout, preserves user
#    content byte-for-byte outside the managed block.
# ---------------------------------------------------------------------------
group "1. brownfield init: full layout + content preservation" \
  "init on a repo that predates chisel installs every socle file and touches nothing the project already had."
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
group "2. idempotence: init twice" \
  "running init again changes nothing — no second managed block, no re-ticked project.md line a human deliberately unticked."
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
# 3. boilerplate: same installed tree as brownfield, plus the two things that
#    are actually specific to a repo with no AGENTS.md and its own layout.
# ---------------------------------------------------------------------------
group "3. boilerplate init: the same tree, whatever the repo was" \
  "a repo with no AGENTS.md gets exactly the same installed tree as a brownfield one, and keeps its own files."
t3="$(fresh_copy boilerplate)"

run_chisel "$CHISEL" init "$t3"
assert_eq "boilerplate: init exits 0" "0" "$rc"

# One comparison instead of the ~50 existence asserts of assert_full_layout: the
# layout itself is group 1's subject, and re-listing it here proved only that
# `cp` works twice. Tree equality is the stronger claim — an extra file on
# either side fails it.
installed_tree "$t1" >"$WORK_ROOT/t1-tree.txt"
installed_tree "$t3" >"$WORK_ROOT/t3-tree.txt"
# The positive control first: two identical EMPTY listings would satisfy the
# comparison below and prove nothing — that is how a tree-equality test rots
# into a tautology. A real install is well over 40 paths.
tree_size="$(wc -l <"$WORK_ROOT/t3-tree.txt" | tr -d ' ')"
if [ "$tree_size" -gt 40 ]; then
  pass "boilerplate: the compared tree is a real install, not an empty listing"
else
  fail "boilerplate: the compared tree is a real install, not an empty listing (got $tree_size paths)"
fi
assert_files_identical "boilerplate: installs the same tree as the brownfield fixture" \
  "$WORK_ROOT/t1-tree.txt" "$WORK_ROOT/t3-tree.txt"
assert_file_contains "boilerplate: AGENTS.md created with project title" "$t3/AGENTS.md" \
  "agent instructions"
assert_file_exists "boilerplate: apps/documentation untouched" "$t3/apps/documentation/README.md"
assert_file_contains "boilerplate: package.json untouched" "$t3/package.json" "\"lint\""

# ---------------------------------------------------------------------------
# 4. update: re-renders managed files, never touches project.md/LOG.md.
# ---------------------------------------------------------------------------
group "4. update: managed refresh, glue left alone" \
  "update brings every managed file back to the socle's version — including the rendered definitions — and never touches project.md or the journal."
t4="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t4"
assert_eq "update fixture: init exits 0" "0" "$rc"

# Hand-edit project-owned files...
printf '\n<!-- hand-edited by a human, must survive update -->\n' >>"$t4/.agents/project.md"
printf '\n## 2099-01-01\n\n- hand-edited entry, must survive update\n' >>"$t4/project-management/LOG.md"
cp "$t4/.agents/project.md" "$WORK_ROOT/t4-project-md-before-update"
cp "$t4/project-management/LOG.md" "$WORK_ROOT/t4-journal-before-update"

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
assert_files_identical "update: the journal is untouched" \
  "$WORK_ROOT/t4-journal-before-update" "$t4/project-management/LOG.md"
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
group "5. check: exit codes" \
  "check exits 0 on a fresh install and 1 on any local edit to a managed file, naming the file that drifted."
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
group "6. symlink resolution" \
  "chisel finds its own socle when the binary is reached through a symlink — which is how every npx install runs it."
link_dir="$(mktemp -d "$WORK_ROOT/symlink-bin.XXXXXX")"
ln -s "$REPO_ROOT/bin/chisel.sh" "$link_dir/chisel"
t6="$(fresh_copy brownfield)"

run_chisel "$link_dir/chisel" init "$t6"
assert_eq "symlinked chisel: init exits 0" "0" "$rc"
assert_file_exists "symlinked chisel: resolved socle content copied" \
  "$t6/.agents/skills/tdd/SKILL.md"

# ---------------------------------------------------------------------------
# 7. the recomposed normative layer: three presets, one pipeline. The shape
#    checks read the INSTALLED tree (what an equipped repo gets). Neutrality
#    is not here — it is group 13, once, for the whole socle.
# ---------------------------------------------------------------------------
group "7. formulas: one pipeline, three gate-sets" \
  "the three presets are the same seven steps in the same order, and the ONLY difference between them is which steps wait for a human."
controlled="$t1/.agents/formulas/chisel-controlled.formula.toml"
supervised="$t1/.agents/formulas/chisel-supervised.formula.toml"
auto="$t1/.agents/formulas/chisel-auto.formula.toml"

# `version` must be an integer, not a semver string — the ledger tooling
# refuses to parse it otherwise (chantier lesson).
for f in "$controlled" "$supervised" "$auto"; do
  preset="$(basename "$f" .formula.toml)"
  assert_file_contains "formulas: $preset declares version = 1 (integer)" "$f" 'version = 1'
  assert_file_not_contains "formulas: $preset version is not a quoted string" "$f" 'version = "'
done

# WHERE the gates sit, not how many there are. A count says "three gates" and
# passes even if all three moved to the wrong steps; this pairs every gate with
# the step id it hangs under, which is the thing a human misreads (the gate
# belongs to the step that WAITS — "spec approved" sits on `plan`).
gated_steps() {
  awk '
    /^id = "/ { id = $0; sub(/^id = "/, "", id); sub(/"$/, "", id) }
    /^type = "human"$/ { printf "%s ", id }
  ' "$1"
}
assert_eq "formulas: the default preset waits at plan, type and close" \
  "plan type close " "$(gated_steps "$controlled")"
assert_eq "formulas: supervised waits exactly once, on plan (= the spec approval)" \
  "plan " "$(gated_steps "$supervised")"
assert_eq "formulas: auto waits nowhere" "" "$(gated_steps "$auto")"

# Same steps in the same order — the three files are one pipeline in three
# postures.
grep '^id = ' "$controlled" >"$WORK_ROOT/controlled-steps.txt" || true
grep '^id = ' "$supervised" >"$WORK_ROOT/supervised-steps.txt" || true
grep '^id = ' "$auto" >"$WORK_ROOT/auto-steps.txt" || true
assert_eq "formulas: the default preset declares step ids at all" "7" \
  "$(wc -l <"$WORK_ROOT/controlled-steps.txt" | tr -d ' ')"
assert_files_identical "formulas: supervised declares the same ordered step ids" \
  "$WORK_ROOT/controlled-steps.txt" "$WORK_ROOT/supervised-steps.txt"
assert_files_identical "formulas: auto declares the same ordered step ids" \
  "$WORK_ROOT/controlled-steps.txt" "$WORK_ROOT/auto-steps.txt"
assert_eq "formulas: seven steps in the default preset" "7" \
  "$(grep -c '^\[\[steps\]\]' "$controlled" || true)"

# The difference between the presets is EXACTLY the gates plus escalation
# wording: every step body of Auto is the default body with lines appended and
# none removed, and Supervised's bodies are Auto's byte for byte (in supervised
# the Owner approves the spec and nothing else — the plan is the Architect's
# and the arbitration is the Inspector's, which is what Auto's bodies already
# say). Extract the description blocks per file, then compare.
extract_descriptions() {
  awk '
    /^description = """$/ { inblock = 1; next }
    inblock && /^"""$/    { inblock = 0; print "---"; next }
    inblock               { print }
  ' "$1"
}
extract_descriptions "$controlled" >"$WORK_ROOT/controlled-desc.txt"
extract_descriptions "$supervised" >"$WORK_ROOT/supervised-desc.txt"
extract_descriptions "$auto" >"$WORK_ROOT/auto-desc.txt"
removed_lines="$(diff "$WORK_ROOT/controlled-desc.txt" "$WORK_ROOT/auto-desc.txt" |
  grep -c '^<' || true)"
assert_eq "formulas: auto only ADDS to the shared step bodies (gates + escalation)" \
  "0" "$removed_lines"
assert_files_identical "formulas: supervised carries auto's step bodies byte for byte" \
  "$WORK_ROOT/supervised-desc.txt" "$WORK_ROOT/auto-desc.txt"

# Supervised is the degraded-run preset: it must say what happens when there is
# nothing to hold a queue, or a stopped run looks like a crashed one.
assert_file_contains "supervised: the stop is a status a human can find" \
  "$supervised" 'awaiting approval'
assert_file_contains "supervised: a fresh session resumes after the approval" \
  "$supervised" 'FRESH session resumes'

# A real TOML parse when the interpreter has one; the repo's floor is a bare
# python3, so this check says so out loud rather than silently passing.
if python3 -c 'import tomllib' >/dev/null 2>&1; then
  if python3 - "$controlled" "$supervised" "$auto" <<'PY'
import sys, tomllib
for path in sys.argv[1:]:
    with open(path, "rb") as f:
        data = tomllib.load(f)
    assert isinstance(data["version"], int), path
    ids = [s["id"] for s in data["steps"]]
    assert len(ids) == len(set(ids)) == 7, path
    gated = [s["id"] for s in data["steps"] if s.get("gate", {}).get("type") == "human"]
    expected = {
        "chisel-controlled": ["plan", "type", "close"],
        "chisel-supervised": ["plan"],
        "chisel-auto": [],
    }[data["formula"]]
    assert gated == expected, (path, gated)
PY
  then
    pass "formulas: all three parse as TOML (version integer, 7 unique step ids, gates where declared)"
  else
    fail "formulas: all three parse as TOML (version integer, 7 unique step ids, gates where declared)"
  fi
else
  printf 'SKIP: TOML parse check (this python3 has no tomllib — needs 3.11+)\n'
fi

# ---------------------------------------------------------------------------
# 8. the role profiles: contract shape, the proposal door, and the per-tool
#    definitions rendered from them (the renders are thin — the profile body
#    is the source, byte for byte).
# ---------------------------------------------------------------------------
group "8. profiles: the role contracts and their renders" \
  "every role states its mission, tier, prohibitions, escalation and inputs — and each tool's definition carries that contract verbatim, never a paraphrase."

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

# The proposal door. Three properties, and a profile that loses any one of them
# has lost the door: every discovery is REPORTED (never swallowed, never done
# quietly); the reporter EVALUATES and the receiver DECIDES; and reporting only
# blocks when the task cannot be delivered cleanly without a decision. Without
# a door, agents stop proposing large improvements and quality decays quietly;
# with a door that always blocks, every good idea becomes an interruption.
mason_profile="$t1/.agents/profiles/mason.md"
architect_profile="$t1/.agents/profiles/architect.md"
assert_file_contains "door: every refactor found goes up one rung, always" \
  "$mason_profile" 'Every such discovery goes up one rung, always'
assert_file_contains "door: never swallowed, never acted on quietly" \
  "$mason_profile" 'never swallowed, and it is never acted on quietly'
assert_file_contains "door: the report carries the size of the change" "$mason_profile" '**Size**'
assert_file_contains "door: the report carries the risk (core, scope, impact)" \
  "$mason_profile" '**Risk**'
assert_file_contains "door: the report says whether the task is still deliverable cleanly" \
  "$mason_profile" 'Can I deliver cleanly without it'
assert_file_contains "door: reporting is not waiting" "$mason_profile" 'Reporting is not waiting'
assert_file_contains "door: it stops only when clean delivery is impossible" \
  "$mason_profile" 'You stop only when delivering cleanly is impossible'
assert_file_contains "door: the reporter evaluates and never decides" \
  "$mason_profile" 'You evaluate; you never decide'
assert_file_contains "door: core, out-of-scope or broad-impact work is hands up, never solo" \
  "$mason_profile" 'never your own initiative'
assert_file_contains "door: the architect rules on the report" \
  "$architect_profile" 'Rule on a report'
assert_file_contains "door: the receiver decides, never the reporter" \
  "$architect_profile" 'The receiver decides, never the reporter'
assert_file_contains "door: small and signed for → into the plan or a task before the mason's" \
  "$architect_profile" "BEFORE the Mason's"
assert_file_contains "door: too big or risky → the architect does not do it either" \
  "$architect_profile" 'you do not do it either'
assert_file_contains "door: 'noted, later — carry on' is always an available verdict" \
  "$architect_profile" 'noted, later'
assert_file_contains "door: silence is the one forbidden answer" \
  "$architect_profile" 'Answering nothing'

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
  assert_file_contains "render: codex definition of $role declares its name" \
    "$t1/.codex/agents/$role.toml" "name = \"$role\""
  # The provenance pointer names the file the render actually came from — it is
  # also the marker that tells chisel's own renders apart from a definition of
  # the user's, so it is a behaviour, not a decoration.
  assert_file_contains "render: claude definition of $role points at its source" \
    "$t1/.claude/agents/$role.md" "from .agents/profiles/$role.md"
  assert_file_contains "render: codex definition of $role points at its source" \
    "$t1/.codex/agents/$role.toml" "from .agents/profiles/$role.md"
done

# Every role a formula step names must have a profile: the formulas say
# "Role: Architect", "Role: Architect or Mason", and nothing else may appear
# there. Derived from ALL THREE formulas rather than from a hardcoded list, so
# a role added to a step without a contract fails here — then compared to the
# explicit list, so a role QUIETLY DROPPED fails here too.
#
# The filter is one rule: on a line opening with "Role: ", a word in Capital
# case is a role name. Tiers and prose ("cheap or mid tier", "in a FRESH
# session") are lowercase or full caps, and fall out on their own.
: >"$WORK_ROOT/formula-roles.txt"
for formula in chisel-controlled chisel-supervised chisel-auto; do
  awk '
    index($0, "Role: ") == 1 {
      n = split(substr($0, 7), words, /[^A-Za-z]+/)
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

# A definition chisel did not write is never destroyed: `.claude/agents/` is
# shared with the user's own sub-agents, and a role name can collide.
t8_foreign_def="$(fresh_copy brownfield)"
mkdir -p "$t8_foreign_def/.claude/agents"
printf '# my own architect, hand written\n' >"$t8_foreign_def/.claude/agents/architect.md"
run_chisel "$CHISEL" init "$t8_foreign_def"
assert_eq "foreign definition: init still exits 0" "0" "$rc"
assert_file_contains "foreign definition: left untouched by init" \
  "$t8_foreign_def/.claude/agents/architect.md" "my own architect, hand written"
assert_file_contains "foreign definition: init warns about it" "$WORK_ROOT/last.log" \
  "was not generated by chisel"
assert_file_exists "foreign definition: the other roles are still rendered" \
  "$t8_foreign_def/.claude/agents/mason.md"

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
# 9. model tiers: one resolution rule, one cascade, and a personal file the
#    installer never touches. (That the socle names no model at all is group
#    13's scan, not this one's needle.)
# ---------------------------------------------------------------------------
group "9. model tiers: the cascade and the personal file" \
  "the socle asks for a level of work, resolves it in one documented place, and never writes or reads a dev's personal file for them."

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
t9_user_md="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t9_user_md"
assert_eq "user.md fixture: init exits 0" "0" "$rc"
printf '# Personal agent settings\n\n## Model tiers\n\n- **frontier:** my-own-model-id\n' \
  >"$t9_user_md/.agents/user.md"
cp "$t9_user_md/.agents/user.md" "$WORK_ROOT/t9-user-md-before-update"

run_chisel "$CHISEL" update "$t9_user_md"
assert_eq "user.md: update exits 0" "0" "$rc"
assert_files_identical "user.md: update leaves the personal file byte-intact" \
  "$WORK_ROOT/t9-user-md-before-update" "$t9_user_md/.agents/user.md"

run_chisel "$CHISEL" check "$t9_user_md"
assert_eq "user.md: check stays clean with a personal file present" "0" "$rc"

# ---------------------------------------------------------------------------
# 10. setup v2: the case is chosen in the glue (§B1/B2/B3), the adapters are
#     fully inventoried (§E), the team tier mapping exists (§H), and the
#     questionnaire asks all of it in the user's language. The glue shape is
#     read off the INSTALLED tree (what an equipped repo gets); the wording
#     rule is read off the skill source, which is the same file byte for byte.
# ---------------------------------------------------------------------------
group "10. setup v2: the case, the glue, the personal file" \
  "the questionnaire asks in plain human language, offers only what is actually supported, and writes back one section at a time without disturbing the others."

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
# numbered options today, and that is 2 + 3 + 2 — the shared background service
# is deferred, and a deferred case is NOT a numbered option (see below).
grep -E '^> *[0-9]+\. \*\*' "$WORK_ROOT/setup-shown.txt" >"$WORK_ROOT/setup-options.txt" || true
option_count="$(wc -l <"$WORK_ROOT/setup-options.txt" | tr -d ' ')"
assert_eq "setup: the questionnaire offers exactly 7 numbered options (2 + 3 + 2)" \
  "7" "$option_count"
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

# --- B1 option 3 is deferred: shown as a fact, never offered as a choice ----
# The shared background service exists in the glue's documentation (a file may
# describe the whole field) but is not something the user can pick today. It is
# named on screen so nobody has to guess whether it was forgotten, and named as
# unsupported so nobody picks it.
assert_file_contains "B1: the background service is announced as not supported yet" \
  "$WORK_ROOT/setup-shown.txt" 'not supported yet'
assert_file_contains "B1: and it says what to do about that" \
  "$WORK_ROOT/setup-shown.txt" 'ask when you need it'
assert_file_not_contains "B1: it is never a third numbered option" \
  "$WORK_ROOT/setup-options.txt" 'background service'
assert_file_contains "B1: the branch that follows a database choice names option 2 alone" \
  "$setup_skill" 'If the answer is option 2, run'

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

# ---------------------------------------------------------------------------
# 11. installer guards: the two paths where chisel must refuse to act rather
#     than act wrongly. Both were proven live by the v2 audit.
# ---------------------------------------------------------------------------
group "11. installer guards: refusing the v1 layout, ignoring foreign files" \
  "update refuses a repo that still carries the retired v1 layer, and a file chisel did not install is never adopted, overwritten, or reported as drift."

# (a) A repo still holding `.agents/rules/` and `.agents/workflows.md`.
# Updating it would copy the current socle in beside the retired one and leave
# two normative discourses in one repo — with `check` silent, since chisel
# never managed the old files.
t11_v1="$(fresh_copy brownfield-v1)"
cp "$t11_v1/.agents/workflows.md" "$WORK_ROOT/t11-workflows-before"
run_chisel "$CHISEL" update "$t11_v1"
assert_eq "v1 layout: update refuses (exit 1)" "1" "$rc"
assert_file_contains "v1 layout: the refusal names the migration skill" \
  "$WORK_ROOT/last.log" "upgrade-v2"
assert_file_contains "v1 layout: the refusal names what it found" \
  "$WORK_ROOT/last.log" ".agents/rules/"
# A refused update writes NOTHING — the guard runs before the copy, so the repo
# is exactly as it was and no half-migrated state exists.
assert_path_absent "v1 layout: refused update installed no discipline.md" \
  "$t11_v1/.agents/discipline.md"
assert_path_absent "v1 layout: refused update installed no formulas" \
  "$t11_v1/.agents/formulas"
assert_path_absent "v1 layout: refused update wrote no manifest" \
  "$t11_v1/.agents/.chisel.json"
assert_files_identical "v1 layout: the v1 files are byte-intact" \
  "$WORK_ROOT/t11-workflows-before" "$t11_v1/.agents/workflows.md"

# ...and the same command on a v2 layout still works: the guard refuses a
# situation, not a command.
t11_v2="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t11_v2"
run_chisel "$CHISEL" update "$t11_v2"
assert_eq "v2 layout: update still exits 0" "0" "$rc"

# (b) A directory a third party planted in `.agents/skills/` — precisely what
# initialising the status database does with its own skill. It must survive
# update untouched, stay out of the manifest, and leave `check` clean: chisel
# manages what chisel copied, and nothing else.
t11_foreign="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t11_foreign"
assert_eq "foreign skill: init exits 0" "0" "$rc"
mkdir -p "$t11_foreign/.agents/skills/beads"
printf '# A skill installed by another tool, not by chisel.\n' \
  >"$t11_foreign/.agents/skills/beads/SKILL.md"
cp "$t11_foreign/.agents/skills/beads/SKILL.md" "$WORK_ROOT/t11-foreign-skill-before"

run_chisel "$CHISEL" update "$t11_foreign"
assert_eq "foreign skill: update exits 0" "0" "$rc"
assert_files_identical "foreign skill: survives update byte-intact" \
  "$WORK_ROOT/t11-foreign-skill-before" "$t11_foreign/.agents/skills/beads/SKILL.md"
assert_file_contains "foreign skill: update warns that chisel does not manage it" \
  "$WORK_ROOT/last.log" "was not installed by chisel"
assert_file_not_contains "foreign skill: never adopted into the manifest" \
  "$t11_foreign/.agents/.chisel.json" "skills/beads"

# The whole point of not adopting it: its owner edits their own file and chisel
# stays quiet. Under the old `find`-based manifest this was a DIVERGED report.
printf '\n<!-- edited by its owner, not by chisel -->\n' \
  >>"$t11_foreign/.agents/skills/beads/SKILL.md"
run_chisel "$CHISEL" check "$t11_foreign"
assert_eq "foreign skill: check stays clean after its owner edits it" "0" "$rc"

# And a socle skill is still managed in that same tree — the guard narrows what
# chisel claims, it does not make it claim less than it must.
printf '\n<!-- diverged -->\n' >>"$t11_foreign/.agents/skills/tdd/SKILL.md"
run_chisel "$CHISEL" check "$t11_foreign"
assert_eq "foreign skill: a socle skill next to it is still checked" "1" "$rc"

# ---------------------------------------------------------------------------
# 12. referential integrity: every internal pointer of the INSTALLED socle
#     resolves. This is the test whose absence let a shipped commit route
#     agents to files that had been deleted.
# ---------------------------------------------------------------------------
group "12. referential integrity: no pointer into thin air" \
  "every file the installed socle points a reader at actually exists in the installed tree."

# What counts as a pointer, exactly — the rule is also written in TESTS.md,
# because a test nobody can state is a test nobody can review:
#   1. any `.agents/...` path in the text (trailing punctuation and `/` cut);
#   2. any markdown link to a SIBLING file — `](name.md)` or `](./name.md)`,
#      no remaining slash, real extension — resolved next to its own file.
# Deliberately NOT pointers: deep relative links (`](../../x.md)`), illustrative
# paths inside some other project's tree (`./src/billing/CONTEXT.md` in the
# domain-modeling skill), and placeholders (`](link)`). Prints "pointer<TAB>the
# file that carries it" for each one that does not resolve.
dangling_pointers() {
  target="$1"
  ( cd "$target" && find AGENTS.md .agents .claude/agents .codex/agents \
      -type f \( -name '*.md' -o -name '*.toml' -o -name '*.tpl' \) 2>/dev/null || true ) |
    LC_ALL=C sort |
    while IFS= read -r src; do
      [ -n "$src" ] || continue
      src_dir="$(dirname "$src")"
      {
        grep -oE '\.agents/[A-Za-z0-9._*/-]+' "$target/$src" || true
        grep -oE '\]\((\./)?[A-Za-z0-9._-]+\.(md|toml|sh|tpl)\)' "$target/$src" |
          sed -e 's|^](||' -e 's|)$||' -e 's|^\./||' -e "s|^|$src_dir/|" -e 's|^\./||' || true
      } |
        sed -e 's|[.,;:)`]*$||' -e 's|/$||' |
        LC_ALL=C sort -u |
        while IFS= read -r pointer; do
          [ -n "$pointer" ] || continue
          [ -e "$target/$pointer" ] || printf '%s\t%s\n' "$pointer" "$src"
        done
    done
}

# The waiver, and why each line is on it. Two categories, and the difference is
# the point: BY DESIGN is a path that is meant not to exist (it will never stop
# dangling); DEBT is a hole someone else's slice will close. Both are asserted
# in BOTH directions: anything dangling that is not listed here fails, AND
# anything listed here that stops dangling fails ("delete this line") — so a
# debt line cannot outlive its debt. A green suite that quietly carries a known
# hole is the failure mode this group exists to end.
cat >"$WORK_ROOT/pointer-waiver.txt" <<'WAIVER'
.agents/user.md	BY DESIGN — personal file, deliberately never installed (the template is)
.agents/rules/task-*.md	BY DESIGN (upgrade-v2 must name the layer it retires) + DEBT (still cited by methodology.md — slice 07)
.agents/workflows.md	BY DESIGN (upgrade-v2 must name the layer it retires) + DEBT (still cited by methodology.md — slice 07)
WAIVER
cut -f1 "$WORK_ROOT/pointer-waiver.txt" | LC_ALL=C sort >"$WORK_ROOT/waived.txt"

dangling_pointers "$t1" >"$WORK_ROOT/dangling-raw.txt"
cut -f1 "$WORK_ROOT/dangling-raw.txt" | LC_ALL=C sort -u >"$WORK_ROOT/dangling.txt"
LC_ALL=C comm -23 "$WORK_ROOT/dangling.txt" "$WORK_ROOT/waived.txt" >"$WORK_ROOT/dangling-new.txt"
LC_ALL=C comm -13 "$WORK_ROOT/dangling.txt" "$WORK_ROOT/waived.txt" >"$WORK_ROOT/waiver-stale.txt"

if [ -s "$WORK_ROOT/dangling-new.txt" ]; then
  fail "integrity: every pointer of the installed socle resolves"
  while IFS= read -r bad; do
    printf '        dangling: %s (in %s)\n' "$bad" \
      "$(awk -F'\t' -v p="$bad" '$1==p{print $2; exit}' "$WORK_ROOT/dangling-raw.txt")"
  done <"$WORK_ROOT/dangling-new.txt"
else
  pass "integrity: every pointer of the installed socle resolves"
fi

# ...and WHO is allowed to cite the retired v1 layer. The waiver above is keyed
# on the pointer alone, so from the day the migration skill legitimately names
# the layer it retires, "this pointer stopped dangling" can never fire for those
# two lines again — their DEBT half would stop expiring, which is exactly the
# silent-known-hole failure the group exists to end. This assertion is the
# replacement forcing function: it names the files allowed to cite the retired
# layer TODAY. `methodology.md` is on the list because slice 07 has not
# rewritten it yet; the day it does, this fails and asks for the line to go.
v1_citers="$(awk -F'\t' '$1 == ".agents/rules/task-*.md" || $1 == ".agents/workflows.md" { print $2 }' \
  "$WORK_ROOT/dangling-raw.txt" | LC_ALL=C sort -u | tr '\n' ' ')"
assert_eq "integrity: only the files allowed to name the retired v1 layer name it" \
  ".agents/methodology.md .agents/skills/upgrade-v2/SKILL.md " "$v1_citers"

if [ -s "$WORK_ROOT/waiver-stale.txt" ]; then
  fail "integrity: the waiver has no stale line (a fixed pointer must leave it)"
  while IFS= read -r stale; do
    printf '        now resolves, delete its waiver line: %s\n' "$stale"
  done <"$WORK_ROOT/waiver-stale.txt"
else
  pass "integrity: the waiver has no stale line (a fixed pointer must leave it)"
fi

# The waived holes are printed at every run, by name and by owner. Known is not
# the same as fixed, and the suite says so out loud rather than staying green
# and silent.
printf 'KNOWN GAP (waived, still open):\n'
while IFS= read -r waiver_line; do
  [ -n "$waiver_line" ] || continue
  printf '  %s\n' "$(printf '%s' "$waiver_line" | tr '\t' ' ')"
done <"$WORK_ROOT/pointer-waiver.txt"

# Mutation test: the walk above is worth nothing unless it actually fails on a
# broken pointer. Plant one of EACH shape — a `.agents/...` path and a sibling
# markdown link — and demand both catches. One mutation would leave the other
# branch free to rot into a no-op.
t12_mutant="$(fresh_copy brownfield)"
run_chisel "$CHISEL" init "$t12_mutant"
printf '\nSee `.agents/nope/missing-page.md` for the rest.\n' >>"$t12_mutant/.agents/discipline.md"
printf '\nAnd [the other half](./missing-sibling.md) of it.\n' >>"$t12_mutant/.agents/discipline.md"
dangling_pointers "$t12_mutant" >"$WORK_ROOT/mutant-dangling.txt"
if grep -q '^\.agents/nope/missing-page\.md	' "$WORK_ROOT/mutant-dangling.txt"; then
  pass "integrity: a planted .agents/ pointer IS caught (that branch has teeth)"
else
  fail "integrity: a planted .agents/ pointer IS caught (that branch has teeth)"
fi
if grep -q '^\.agents/missing-sibling\.md	' "$WORK_ROOT/mutant-dangling.txt"; then
  pass "integrity: a planted sibling link IS caught (that branch has teeth too)"
else
  fail "integrity: a planted sibling link IS caught (that branch has teeth too)"
fi

# ---------------------------------------------------------------------------
# 13. neutrality: one alphabet, one perimeter, one group. Three scans used to
#     live in three groups with three overlapping lists — you had to read the
#     regexes to know which one guarded what.
# ---------------------------------------------------------------------------
group "13. neutrality: the socle names no vendor, no model, no backend" \
  "the socle asks for a LEVEL of work and a coordination convention — never a named model, tool or database — so a repo can change any of them without editing the socle."

# The one alphabet. `claude-` carries the hyphen on purpose: `CLAUDE.md` and
# `.claude/skills` are adapter PATHS, which the rule excepts, while
# `claude-3-something` is a model identifier.
model_name_re='cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai|copilot|claude-|llama|mistral|deepseek|qwen'
tool_name_re='cursor|codex|claude|copilot|windsurf'
ledger_name_re='(^|[^a-z])(bd|beads|dolt|linear|jira)([^a-z]|$)'

# Socle-wide, both scans — the parent task's acceptance criterion is the whole
# of `socle/`, and until now no scan covered it whole.
#
# The positive control first. Every scan below asserts an EMPTY result, and an
# empty result is also what a mistyped path returns (grep exits 2, `|| true`
# flattens it): the perimeter has to be proven non-empty, or the whole group
# passes by scanning nothing.
socle_files="$(find "$REPO_ROOT/socle" -type f | wc -l | tr -d ' ')"
if [ "$socle_files" -gt 30 ]; then
  pass "neutrality: the scans have a socle to scan ($socle_files files)"
else
  fail "neutrality: the scans have a socle to scan (found $socle_files files — wrong path?)"
fi
assert_eq "neutrality: no W0/W1/W2 mode label anywhere in the socle" "" \
  "$(grep -rlE 'W0|W1|W2' "$REPO_ROOT/socle" || true)"
assert_eq "neutrality: no model identifier anywhere in the socle (adapter paths excepted)" \
  "" "$(grep -rliE "$model_name_re" "$REPO_ROOT/socle" || true)"

# Tool names in PROSE, over the layer that describes roles and routing: a tool
# name inside a code span is a filesystem fact (`.claude/agents/`), a tool name
# in a sentence is a coupling. Code spans stripped before grepping.
prose_tool_hits=""
for rel in socle/agents/profiles/README.md \
  socle/agents/profiles/architect.md \
  socle/agents/profiles/mason.md \
  socle/agents/profiles/inspector.md \
  socle/agents/foreman.md \
  socle/agents/discipline.md; do
  if sed -e 's|`[^`]*`||g' "$REPO_ROOT/$rel" | grep -Eiq "$tool_name_re"; then
    prose_tool_hits="$prose_tool_hits $rel"
  fi
done
assert_eq "neutrality: no tool name in the prose of the role layer (paths excepted)" \
  "" "$prose_tool_hits"

# A formula step never names a coordination backend: every write goes through
# the glue convention, which is what lets the same step run with or without a
# status database.
ledger_hits=""
for rel in socle/agents/formulas/chisel-controlled.formula.toml \
  socle/agents/formulas/chisel-supervised.formula.toml \
  socle/agents/formulas/chisel-auto.formula.toml; do
  if grep -Eiq "$ledger_name_re" "$REPO_ROOT/$rel"; then
    ledger_hits="$ledger_hits $rel"
  fi
done
assert_eq "neutrality: no coordination backend named in a formula" "" "$ledger_hits"

# The renders are what a tool actually loads: assert their neutrality rather
# than inferring it from the sources they came from.
render_hits=""
for rel in .claude/agents/architect.md .claude/agents/mason.md .claude/agents/inspector.md \
  .codex/agents/architect.toml .codex/agents/mason.toml .codex/agents/inspector.toml; do
  if grep -Eq 'W0|W1|W2' "$t1/$rel" ||
    { sed -e 's|`[^`]*`||g' "$t1/$rel" | grep -Eiq "$model_name_re"; }; then
    render_hits="$render_hits $rel"
  fi
done
assert_eq "neutrality: no mode label and no model name in the generated definitions" \
  "" "$render_hits"

# ---------------------------------------------------------------------------
# 14. upgrade-v2: the migration a refused `update` sends people to. A test
#     cannot run an agent, so it proves the two halves and couples them: the
#     skill is asserted to PRESCRIBE each mechanical step, and those steps are
#     then replayed on the v1 fixture and their result read off the tree.
# ---------------------------------------------------------------------------
group "14. upgrade-v2: the v1 repo that comes out the other side" \
  "the migration retires the v1 layer, renames the journal and installs v2 — and every task file and archived file survives it byte-intact."

upgrade_skill="$REPO_ROOT/socle/agents/skills/upgrade-v2/SKILL.md"

assert_file_exists "upgrade-v2: the skill ships in the socle" "$upgrade_skill"
assert_file_exists "upgrade-v2: init installs it (that is how it reaches a repo)" \
  "$t1/.agents/skills/upgrade-v2/SKILL.md"
assert_file_contains "upgrade-v2: it is user-invoked, never model-invoked" \
  "$upgrade_skill" 'disable-model-invocation: true'

# The prose half. Anchored on the two things a rewording cannot take away — the
# step HEADINGS, which are the migration's shape, and the fenced COMMANDS, which
# are what the replay below actually runs — plus the three sentences that carry
# a rule the skill would have to delete to break. Not on subordinate clauses:
# this is a document meant to be edited, and a test that fails on "so that"
# teaches people to stop editing it.
for heading in \
  '## Step 0 — Preconditions' \
  '## Step 1 — Inventory' \
  '## Step 2 — Retire the v1 layer' \
  '## Step 3 — Rename the journal' \
  '## Step 4 — Install the v2 layer' \
  '## Step 5 — Complete the glue' \
  '## Step 6 — Verify' \
  '## Step 7 — Hand over'; do
  assert_file_contains "upgrade-v2: shape — $heading" "$upgrade_skill" "$heading"
done
assert_file_contains "upgrade-v2: command — the retired rules and guide are removed" \
  "$upgrade_skill" 'git rm .agents/rules/task-*.md .agents/workflows.md'
assert_file_contains "upgrade-v2: command — the journal is MOVED, history kept" \
  "$upgrade_skill" 'git mv project-management/CHANGELOG.md project-management/LOG.md'
assert_file_contains "upgrade-v2: command — the installer poses the v2 layer" \
  "$upgrade_skill" 'npx @lonestone/chisel init .'
assert_file_contains "upgrade-v2: command — verification is a clean check" \
  "$upgrade_skill" 'npx @lonestone/chisel check'
assert_file_contains "upgrade-v2: command — and an update that is finally accepted" \
  "$upgrade_skill" 'npx @lonestone/chisel update'
assert_file_contains "upgrade-v2: the glue questions are the setup's, not a second wording" \
  "$upgrade_skill" '.agents/skills/chisel-setup/SKILL.md'
assert_file_contains "upgrade-v2: rule — the retired directory may not survive either" \
  "$upgrade_skill" '**The rules directory itself must not survive**'
assert_file_contains "upgrade-v2: rule — the journal's content is not touched" \
  "$upgrade_skill" "Do not touch the file's CONTENT"
assert_file_contains "upgrade-v2: rule — the journal stays handwritten, never generated" \
  "$upgrade_skill" 'never generated'
assert_file_contains "upgrade-v2: rule — what is never touched is stated up front" \
  "$upgrade_skill" '## What is never touched'

# The mechanical half, replayed on a real v1 repo. `mv`/`rm` stand in for the
# skill's `git mv`/`git rm` — the fixture copies are not git repos, and history
# preservation is the skill's business (asserted above), file movement is this
# test's.
t14="$(fresh_copy brownfield-v1)"

# The positive control: without it, every "is gone" assertion below would also
# pass on a fixture that never had a v1 layer.
assert_file_exists "migration: the fixture really carries the v1 rules first" \
  "$t14/.agents/rules/task-creation.md"
assert_file_exists "migration: ...and the v1 visual guide" "$t14/.agents/workflows.md"
assert_file_exists "migration: ...and a v1-named journal" \
  "$t14/project-management/CHANGELOG.md"

cp -R "$t14/project-management/tasks" "$WORK_ROOT/t14-tasks-before"
cp -R "$t14/project-management/archive" "$WORK_ROOT/t14-archive-before"
cp "$t14/project-management/CHANGELOG.md" "$WORK_ROOT/t14-journal-before"

# Step 2 — retire the v1 layer, directory included (the skill says the
# directory itself must not survive: `update`'s guard looks for the directory,
# not for its contents). `rm -rf`, not `rmdir`: a bare rmdir on a directory that
# still holds something exits nonzero and, under `set -e`, would abort the whole
# run mid-group — no FAIL line, no tally, just silence.
rm -f "$t14"/.agents/rules/task-*.md "$t14/.agents/workflows.md"
rm -rf "$t14/.agents/rules"
# Step 3 — rename the journal, then point §A at the new name.
mv "$t14/project-management/CHANGELOG.md" "$t14/project-management/LOG.md"
sed -e 's|project-management/CHANGELOG.md|project-management/LOG.md|' \
  "$t14/.agents/project.md" >"$WORK_ROOT/t14-glue.md"
cat "$WORK_ROOT/t14-glue.md" >"$t14/.agents/project.md"
# Step 4 — install v2.
run_chisel "$CHISEL" init "$t14"
assert_eq "migration: init on the half-migrated repo exits 0" "0" "$rc"

assert_path_absent "migration: the v1 rules are gone" "$t14/.agents/rules"
assert_path_absent "migration: the v1 visual guide is gone" "$t14/.agents/workflows.md"

# The journal is MOVED, not regenerated: the entries a project wrote by hand are
# its memory, and an installer that "creates" a journal has erased it.
assert_file_exists "migration: the journal is there under its v2 name" \
  "$t14/project-management/LOG.md"
assert_path_absent "migration: and not under its v1 name" \
  "$t14/project-management/CHANGELOG.md"
assert_files_identical "migration: the journal's entries survive the rename byte for byte" \
  "$WORK_ROOT/t14-journal-before" "$t14/project-management/LOG.md"

# The whole point of the migration: the work already in the repo is not touched.
if diff -r "$WORK_ROOT/t14-tasks-before" "$t14/project-management/tasks" \
  >"$WORK_ROOT/t14-tasks.diff" 2>&1; then
  pass "migration: every open task file is byte-intact"
else
  fail "migration: every open task file is byte-intact (see $WORK_ROOT/t14-tasks.diff)"
fi
if diff -r "$WORK_ROOT/t14-archive-before" "$t14/project-management/archive" \
  >"$WORK_ROOT/t14-archive.diff" 2>&1; then
  pass "migration: the archive is byte-intact"
else
  fail "migration: the archive is byte-intact (see $WORK_ROOT/t14-archive.diff)"
fi

# The v2 layer is posed — the files the retired ones were replaced by.
assert_file_exists "migration: discipline.md posed" "$t14/.agents/discipline.md"
assert_file_exists "migration: the default preset posed" \
  "$t14/.agents/formulas/chisel-controlled.formula.toml"
assert_file_exists "migration: the profiles posed" "$t14/.agents/profiles/mason.md"
assert_file_exists "migration: the per-tool definitions rendered" \
  "$t14/.claude/agents/mason.md"
assert_file_exists "migration: the codex definitions rendered too" \
  "$t14/.codex/agents/mason.toml"
assert_file_exists "migration: the personal-file template posed" "$t14/.agents/user.md.tpl"
assert_path_absent "migration: but never the personal file itself" "$t14/.agents/user.md"

# The v1 router went with it: AGENTS.md's managed block is rewritten by `init`,
# which is why the skill does not edit that file by hand.
assert_file_not_contains "migration: AGENTS.md no longer routes to the retired rules" \
  "$t14/AGENTS.md" ".agents/rules/"
assert_file_contains "migration: AGENTS.md routes to the ambient core instead" \
  "$t14/AGENTS.md" ".agents/discipline.md"
assert_file_contains "migration: the repo's own words above the block survive" \
  "$t14/AGENTS.md" "# Ledgerly — agent instructions"

# The glue is the project's file: `init` finds one and leaves it entirely alone,
# including the line the migration just rewrote.
assert_file_contains "migration: the project's own glue is not clobbered by init" \
  "$t14/.agents/project.md" "# Project glue (v1)"
assert_file_contains "migration: its journal line now names LOG.md" \
  "$t14/.agents/project.md" "project-management/LOG.md"
# ...and no longer names the old one. Without this, a glue carrying BOTH lines
# would pass: §A is a single declaration, and two of them is a repo where half
# the socle writes to one journal and half to the other.
assert_file_not_contains "migration: and the old name is gone from the glue" \
  "$t14/.agents/project.md" "project-management/CHANGELOG.md"

run_chisel "$CHISEL" check "$t14"
assert_eq "migration: check is clean afterwards" "0" "$rc"

# And the refusal that started all this is lifted — the migration is complete
# exactly when the guard stops firing.
run_chisel "$CHISEL" update "$t14"
assert_eq "migration: update is accepted again on the migrated repo" "0" "$rc"

# ---------------------------------------------------------------------------
# 15. the journal: one name for new repos, one declared path, one hand.
# ---------------------------------------------------------------------------
group "15. the journal: LOG.md by default, written by hand" \
  "a new repo gets project-management/LOG.md and never a second journal beside an existing one, and no socle text says the journal can be generated."

# The default, in the two places that decide it: the skeleton the installer
# writes (group 1's layout asserts the file) and the glue line every writer
# resolves through.
assert_file_contains "journal: the glue declares LOG.md by default" \
  "$t1/.agents/project.md" '- **Changelog:** `/project-management/LOG.md`'
assert_file_contains "journal: the skeleton says it is written by hand" \
  "$t1/project-management/LOG.md" 'Written by hand'

# A repo equipped before the default changed keeps ITS name: the installer must
# not quietly add a second journal next to it. It says so, and names the skill
# that does the rename properly.
t15_legacy="$(fresh_copy brownfield)"
mkdir -p "$t15_legacy/project-management"
printf '# Changelog\n\n## 2026-01-01\n\n- the journal this repo already had.\n' \
  >"$t15_legacy/project-management/CHANGELOG.md"
cp "$t15_legacy/project-management/CHANGELOG.md" "$WORK_ROOT/t15-legacy-journal-before"

run_chisel "$CHISEL" init "$t15_legacy"
assert_eq "legacy journal: init exits 0" "0" "$rc"
assert_path_absent "legacy journal: no second journal created beside it" \
  "$t15_legacy/project-management/LOG.md"
assert_files_identical "legacy journal: the existing one is byte-intact" \
  "$WORK_ROOT/t15-legacy-journal-before" "$t15_legacy/project-management/CHANGELOG.md"
assert_file_contains "legacy journal: init says so and names the migration skill" \
  "$WORK_ROOT/last.log" "upgrade-v2"
# ...and the glue it just wrote points at the journal that EXISTS. Without this,
# `init` hands a fresh repo a §A naming a file it deliberately did not create —
# a glue that is wrong the second it is written, and every text that resolves
# the journal through §A follows it there.
assert_file_contains "legacy journal: the new glue declares the journal that is really there" \
  "$t15_legacy/.agents/project.md" '- **Changelog:** `/project-management/CHANGELOG.md`'
assert_file_not_contains "legacy journal: and does not declare the one that is not" \
  "$t15_legacy/.agents/project.md" '- **Changelog:** `/project-management/LOG.md`'

# No socle text sends a NEW project to a `CHANGELOG.md`. The two files that may
# name one are listed here by name, not excused by a regex: `sync-upstream` runs
# in the chisel repo itself, which keeps its own journal under the old name, and
# `upgrade-v2` has to name the file it renames. A third one appearing is the
# default leaking back.
changelog_citers="$( (cd "$REPO_ROOT" && grep -rlF 'project-management/CHANGELOG.md' socle || true) |
  LC_ALL=C sort | tr '\n' ' ')"
assert_eq "journal: only the two socle files that must name a CHANGELOG.md do" \
  "socle/agents/skills/sync-upstream/SKILL.md socle/agents/skills/upgrade-v2/SKILL.md " \
  "$changelog_citers"
assert_file_contains "journal: ...and the sync skill says whose journal that is" \
  "$REPO_ROOT/socle/agents/skills/sync-upstream/SKILL.md" "the chisel repo's own"
assert_file_contains "journal: ...and the migration skill names it only to rename it" \
  "$upgrade_skill" 'git mv project-management/CHANGELOG.md'

# The journal is never generated from a coordination database's audit trail
# (fb-3kk.13). Asserted as an invariant rather than as one needle in one file:
# every socle text that raises the SUBJECT — an audit trail, or generating the
# journal at all — must also rule the generation out. So the day someone writes
# "we could generate the log from the trail", the suite says no. The trigger
# list is prose-shaped and therefore not exhaustive; it catches the phrasings
# the decision was actually argued in.
journal_source_re='audit trail|generate the (journal|log|changelog)|generated (journal|log|changelog)'
# The rule itself, in the one place the journal's path is declared — that is the
# assertion that says it EXISTS.
assert_file_contains "journal: the rule is written where the journal's path is declared" \
  "$REPO_ROOT/socle/agents/project.md.tpl" 'never generated'
# The sweep is the other half: it says nothing ELSE in the socle raises the
# subject without ruling it out. `while read`, not `for` over an unquoted
# variable — a checkout under a path with a space would otherwise split into
# nonsense filenames and pass.
generation_hits=""
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  grep -qF 'never generated' "$rel" || generation_hits="$generation_hits $rel"
done <<EOF
$(grep -rliE "$journal_source_re" "$REPO_ROOT/socle" || true)
EOF
assert_eq "journal: no socle text raises generating the journal without ruling it out" \
  "" "$generation_hits"

