# test/installer.sh — behavioral groups (CLI-seam tests for bin/chisel.sh).
# Sourced by test/run.sh after test/lib.sh. Every group is a function, called
# by name from run.sh, self-contained via fresh_copy/fresh_install — no group
# reads another group's fixture, so they run in any order.

# ---------------------------------------------------------------------------
group_init() {
  group "init: full layout + content preservation" \
    "init on a repo that predates chisel installs every socle file and touches nothing the project already had."
  t1="$(fresh_copy brownfield)"

  run_chisel "$CHISEL" init "$t1"
  assert_eq "brownfield: init exits 0" "0" "$rc"

  # Layout: a committed golden tree instead of ~50 existence asserts.
  installed_tree "$t1" >"$WORK_ROOT/t1-tree.txt"
  tree_size="$(wc -l <"$WORK_ROOT/t1-tree.txt" | tr -d ' ')"
  if [ "$tree_size" -gt 40 ]; then
    pass "init: the compared tree is a real install, not an empty listing"
  else
    fail "init: the compared tree is a real install, not an empty listing (got $tree_size paths)"
  fi
  assert_files_identical "init: installed tree matches the golden layout" \
    "$FIXTURES_DIR/golden-tree.txt" "$WORK_ROOT/t1-tree.txt"

  assert_symlink_resolves "init: .claude/skills symlink" "$t1/.claude/skills" "../.agents/skills"
  assert_executable "init: scripts/task-id.sh is executable" "$t1/scripts/task-id.sh"
  assert_file_contains "init: CLAUDE.md imports AGENTS.md" "$t1/CLAUDE.md" "@AGENTS.md"
  assert_file_contains "init: AGENTS.md has begin marker" "$t1/AGENTS.md" "<!-- chisel:begin -->"
  assert_file_contains "init: AGENTS.md has end marker" "$t1/AGENTS.md" "<!-- chisel:end -->"

  assert_file_contains "brownfield: AGENTS.md keeps user heading" "$t1/AGENTS.md" \
    "# Acme Bookkeeper — agent instructions"
  assert_file_contains "brownfield: AGENTS.md keeps user note" "$t1/AGENTS.md" \
    "Do not touch \`legacy/\` without asking Jane first."
  assert_file_contains "brownfield: CLAUDE.md keeps user content" "$t1/CLAUDE.md" \
    "this project uses Ruby 3.2 and Sidekiq"
  assert_file_contains "brownfield: README.md untouched" "$t1/README.md" \
    "Internal payroll tool."

  awk '/<!-- chisel:begin -->/{f=1;next}/<!-- chisel:end -->/{f=0}f' "$t1/AGENTS.md" \
    >"$WORK_ROOT/t1-block.md"
  assert_files_identical "brownfield: rendered block matches AGENTS-block.md" \
    "$WORK_ROOT/t1-block.md" "$REPO_ROOT/socle/templates/AGENTS-block.md"
  assert_file_contains "brownfield: block routes to discipline.md" "$t1/AGENTS.md" \
    ".agents/discipline.md"
  assert_file_contains "brownfield: block routes to the controlled formula" "$t1/AGENTS.md" \
    ".agents/formulas/chisel-controlled.formula.toml"
  assert_file_not_contains "brownfield: block no longer routes to the retired rules" \
    "$t1/AGENTS.md" ".agents/rules/"
}

# ---------------------------------------------------------------------------
group_idempotence() {
  group "idempotence: init twice" \
    "running init again changes nothing — no second managed block, no re-ticked project.md line a human deliberately unticked."
  t2="$(fresh_copy brownfield)"
  run_chisel "$CHISEL" init "$t2"
  assert_eq "idempotence: first init exits 0" "0" "$rc"
  cp -R "$t2" "$WORK_ROOT/t2-after-first-init"

  run_chisel "$CHISEL" init "$t2"
  assert_eq "idempotence: second init exits 0" "0" "$rc"

  if diff -r "$WORK_ROOT/t2-after-first-init" "$t2" >"$WORK_ROOT/t2-idempotence.diff" 2>&1; then
    pass "idempotence: init twice produces zero diff"
  else
    fail "idempotence: init twice produces zero diff (see $WORK_ROOT/t2-idempotence.diff)"
  fi

  assert_eq "idempotence: single managed block after two inits" "1" \
    "$(grep -c -- '<!-- chisel:begin -->' "$t2/AGENTS.md")"

  # Re-init must not re-tick a §E line a human deliberately unticked.
  awk 'BEGIN{done=0} !done && /^- \[x\] `\.claude\/skills`/ { sub(/^- \[x\]/, "- [ ]"); done=1 } { print }' \
    "$t2/.agents/project.md" >"$WORK_ROOT/t2-project-md-edited"
  cat "$WORK_ROOT/t2-project-md-edited" >"$t2/.agents/project.md"

  run_chisel "$CHISEL" init "$t2"
  assert_eq "idempotence: third init exits 0" "0" "$rc"
  assert_file_contains "idempotence: hand-unticked §E line survives re-init" \
    "$t2/.agents/project.md" '- [ ] `.claude/skills`'
}

# ---------------------------------------------------------------------------
group_boilerplate() {
  group "boilerplate init: the same tree, whatever the repo was" \
    "a repo with no AGENTS.md gets exactly the same installed tree as a brownfield one, and keeps its own files."
  t3="$(fresh_copy boilerplate)"

  run_chisel "$CHISEL" init "$t3"
  assert_eq "boilerplate: init exits 0" "0" "$rc"

  installed_tree "$t3" >"$WORK_ROOT/t3-tree.txt"
  tree_size="$(wc -l <"$WORK_ROOT/t3-tree.txt" | tr -d ' ')"
  if [ "$tree_size" -gt 40 ]; then
    pass "boilerplate: the compared tree is a real install, not an empty listing"
  else
    fail "boilerplate: the compared tree is a real install, not an empty listing (got $tree_size paths)"
  fi
  assert_files_identical "boilerplate: installs the same tree as the golden layout" \
    "$FIXTURES_DIR/golden-tree.txt" "$WORK_ROOT/t3-tree.txt"
  assert_file_contains "boilerplate: AGENTS.md created with project title" "$t3/AGENTS.md" \
    "agent instructions"
  assert_file_exists "boilerplate: apps/documentation untouched" "$t3/apps/documentation/README.md"
  assert_file_contains "boilerplate: package.json untouched" "$t3/package.json" "\"lint\""
}

# ---------------------------------------------------------------------------
group_update() {
  group "update: managed refresh, glue and personal file left alone" \
    "update brings every managed file back to the socle's version — including the rendered definitions — and never touches project.md, the journal, or a personal user.md."
  t4="$(fresh_copy brownfield)"
  run_chisel "$CHISEL" init "$t4"
  assert_eq "update fixture: init exits 0" "0" "$rc"

  printf '\n<!-- hand-edited by a human, must survive update -->\n' >>"$t4/.agents/project.md"
  printf '\n## 2099-01-01\n\n- hand-edited entry, must survive update\n' >>"$t4/project-management/LOG.md"
  printf '# Personal agent settings\n\n## Model tiers\n\n- **frontier:** my-own-model-id\n' \
    >"$t4/.agents/user.md"
  cp "$t4/.agents/project.md" "$WORK_ROOT/t4-project-md-before-update"
  cp "$t4/project-management/LOG.md" "$WORK_ROOT/t4-journal-before-update"
  cp "$t4/.agents/user.md" "$WORK_ROOT/t4-user-md-before-update"

  # ...and three managed files (a render comes back from the profile, so a
  # pristine copy is kept to compare against, not a re-copy).
  cp "$t4/.claude/agents/mason.md" "$WORK_ROOT/t4-mason-def-before-edit"
  cp "$t4/.codex/agents/inspector.toml" "$WORK_ROOT/t4-inspector-def-before-edit"
  printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.agents/skills/tdd/SKILL.md"
  printf '\n# local edit that update must overwrite\n' \
    >>"$t4/.agents/formulas/chisel-controlled.formula.toml"
  printf '\n<!-- local edit that update must overwrite -->\n' >>"$t4/.claude/agents/mason.md"
  printf '\n# local edit that update must overwrite\n' >>"$t4/.codex/agents/inspector.toml"

  run_chisel "$CHISEL" update "$t4"
  assert_eq "update: exits 0" "0" "$rc"

  assert_files_identical "update: .agents/project.md untouched" \
    "$WORK_ROOT/t4-project-md-before-update" "$t4/.agents/project.md"
  assert_files_identical "update: the journal is untouched" \
    "$WORK_ROOT/t4-journal-before-update" "$t4/project-management/LOG.md"
  assert_files_identical "update: a personal user.md is untouched" \
    "$WORK_ROOT/t4-user-md-before-update" "$t4/.agents/user.md"
  assert_file_exists "update: the user.md template is still installed" "$t4/.agents/user.md.tpl"
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
}

# ---------------------------------------------------------------------------
group_check() {
  group "check: exit codes" \
    "check exits 0 on a fresh install and 1 on any local edit to a managed file, naming the file that drifted."

  t5="$(fresh_install brownfield)"
  run_chisel "$CHISEL" check "$t5"
  assert_eq "check: exit 0 immediately after init" "0" "$rc"

  printf '\n<!-- diverged -->\n' >>"$t5/.agents/skills/code-review/SKILL.md"
  run_chisel "$CHISEL" check "$t5"
  assert_eq "check: exit 1 after hand-editing a managed skill" "1" "$rc"
  assert_file_contains "check: reports the diverged skill" "$WORK_ROOT/last.log" \
    ".agents/skills/code-review/SKILL.md"

  # The recomposed normative layer is managed too: check must see it drift.
  t5b="$(fresh_install brownfield)"
  printf '\n<!-- diverged -->\n' >>"$t5b/.agents/discipline.md"
  run_chisel "$CHISEL" check "$t5b"
  assert_eq "check: exit 1 after hand-editing discipline.md" "1" "$rc"
  assert_file_contains "check: reports the diverged discipline.md" "$WORK_ROOT/last.log" \
    ".agents/discipline.md"

  # So are the rendered agent definitions: hand-editing one is drift too.
  t5c="$(fresh_install brownfield)"
  printf '\n<!-- diverged -->\n' >>"$t5c/.claude/agents/architect.md"
  printf '\n# diverged\n' >>"$t5c/.codex/agents/mason.toml"
  run_chisel "$CHISEL" check "$t5c"
  assert_eq "check: exit 1 after hand-editing a generated agent definition" "1" "$rc"
  assert_file_contains "check: reports the diverged agent definition" "$WORK_ROOT/last.log" \
    ".claude/agents/architect.md"
  assert_file_contains "check: reports the diverged codex definition too" "$WORK_ROOT/last.log" \
    ".codex/agents/mason.toml"
}

# ---------------------------------------------------------------------------
group_symlink() {
  group "symlink resolution" \
    "chisel finds its own socle when the binary is reached through a symlink — which is how every npx install runs it."
  link_dir="$(mktemp -d "$WORK_ROOT/symlink-bin.XXXXXX")"
  ln -s "$REPO_ROOT/bin/chisel.sh" "$link_dir/chisel"
  t6="$(fresh_copy brownfield)"

  run_chisel "$link_dir/chisel" init "$t6"
  assert_eq "symlinked chisel: init exits 0" "0" "$rc"
  assert_file_exists "symlinked chisel: resolved socle content copied" \
    "$t6/.agents/skills/tdd/SKILL.md"
}

# ---------------------------------------------------------------------------
group_render() {
  group "render: formulas parse as TOML, profile renders carry the body verbatim" \
    "the three formula presets parse as TOML with the right gate count per preset (3/1/0), and every generated agent definition carries its profile's body byte for byte."

  t7="$(fresh_install brownfield)"
  controlled="$t7/.agents/formulas/chisel-controlled.formula.toml"
  supervised="$t7/.agents/formulas/chisel-supervised.formula.toml"
  auto="$t7/.agents/formulas/chisel-auto.formula.toml"

  # Structure by PARSING, never by grep: version integer, 9 unique step ids, gates 3/1/0.
  if python3 -c 'import tomllib' >/dev/null 2>&1; then
    if python3 - "$controlled" "$supervised" "$auto" <<'PY'
import sys, tomllib
for path in sys.argv[1:]:
    with open(path, "rb") as f:
        data = tomllib.load(f)
    assert isinstance(data["version"], int), path
    ids = [s["id"] for s in data["steps"]]
    assert len(ids) == len(set(ids)) == 9, path
    gated = [s["id"] for s in data["steps"] if s.get("gate", {}).get("type") == "human"]
    expected = {
        "chisel-controlled": ["plan", "design-check", "close"],
        "chisel-supervised": ["plan"],
        "chisel-auto": [],
    }[data["formula"]]
    assert gated == expected, (path, gated)
PY
    then
      pass "formulas: all three parse as TOML (version integer, 9 unique step ids, gates 3/1/0)"
    else
      fail "formulas: all three parse as TOML (version integer, 9 unique step ids, gates 3/1/0)"
    fi
  else
    printf 'SKIP: TOML parse check (this python3 has no tomllib — needs 3.11+)\n'
  fi

  # The renders are thin: profile body -> generated body, byte for byte.
  for role in architect mason inspector; do
    awk 'NR == 1 && $0 == "---" { h = 1; next }
         h && $0 == "---" { h = 0; next }
         h { next }
         !s && $0 == "" { next }
         { s = 1; print }' "$t7/.agents/profiles/$role.md" >"$WORK_ROOT/profile-body-$role.txt"
    awk 'f { print } /^<!-- chisel:generated /  { f = 1 }' \
      "$t7/.claude/agents/$role.md" |
      awk '!s && $0 == "" { next } { s = 1; print }' >"$WORK_ROOT/claude-body-$role.txt"
    assert_files_identical "render: claude definition of $role carries the profile body verbatim" \
      "$WORK_ROOT/profile-body-$role.txt" "$WORK_ROOT/claude-body-$role.txt"
    assert_file_contains "render: claude definition of $role has a name in frontmatter" \
      "$t7/.claude/agents/$role.md" "name: \"$role\""
    assert_file_contains "render: codex definition of $role declares its name" \
      "$t7/.codex/agents/$role.toml" "name = \"$role\""
    assert_file_contains "render: claude definition of $role points at its source" \
      "$t7/.claude/agents/$role.md" "from .agents/profiles/$role.md"
    assert_file_contains "render: codex definition of $role points at its source" \
      "$t7/.codex/agents/$role.toml" "from .agents/profiles/$role.md"
  done

}

# ---------------------------------------------------------------------------
group_guards() {
  group "guards: refusing the v1 layout, ignoring foreign files" \
    "update refuses a repo that still carries the retired v1 layer, and a file chisel did not install is never adopted, overwritten, or reported as drift."

  # (a) A repo still holding `.agents/rules/` — updating it would leave two
  # normative discourses in one repo, with `check` silent about the old one.
  t11_v1="$(fresh_copy brownfield-v1)"
  cp "$t11_v1/.agents/workflows.md" "$WORK_ROOT/t11-workflows-before"
  run_chisel "$CHISEL" update "$t11_v1"
  assert_eq "v1 layout: update refuses (exit 1)" "1" "$rc"
  assert_file_contains "v1 layout: the refusal names the migration skill" \
    "$WORK_ROOT/last.log" "upgrade-v2"
  assert_file_contains "v1 layout: the refusal names what it found" \
    "$WORK_ROOT/last.log" ".agents/rules/"
  assert_path_absent "v1 layout: refused update installed no discipline.md" \
    "$t11_v1/.agents/discipline.md"
  assert_path_absent "v1 layout: refused update installed no formulas" \
    "$t11_v1/.agents/formulas"
  assert_path_absent "v1 layout: refused update wrote no manifest" \
    "$t11_v1/.agents/.chisel.json"
  assert_files_identical "v1 layout: the v1 files are byte-intact" \
    "$WORK_ROOT/t11-workflows-before" "$t11_v1/.agents/workflows.md"

  # ...same command on a v2 layout still works: the guard refuses a situation, not a command.
  t11_v2="$(fresh_install brownfield)"
  run_chisel "$CHISEL" update "$t11_v2"
  assert_eq "v2 layout: update still exits 0" "0" "$rc"

  # (b) A directory a third party planted in `.agents/skills/` — chisel manages what it copied, nothing else.
  t11_foreign="$(fresh_install brownfield)"
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

  # The point of not adopting it: its owner edits their own file and chisel stays quiet.
  printf '\n<!-- edited by its owner, not by chisel -->\n' \
    >>"$t11_foreign/.agents/skills/beads/SKILL.md"
  run_chisel "$CHISEL" check "$t11_foreign"
  assert_eq "foreign skill: check stays clean after its owner edits it" "0" "$rc"

  # A socle skill in the same tree is still managed — the guard narrows the claim, not the coverage.
  printf '\n<!-- diverged -->\n' >>"$t11_foreign/.agents/skills/tdd/SKILL.md"
  run_chisel "$CHISEL" check "$t11_foreign"
  assert_eq "foreign skill: a socle skill next to it is still checked" "1" "$rc"
}

# ---------------------------------------------------------------------------
group_integrity() {
  group "integrity: no pointer into thin air" \
    "every file the installed socle points a reader at actually exists in the installed tree."

  # What counts as a pointer — also written in TESTS.md: (1) any `.agents/...`
  # path in the text; (2) a markdown link to a SIBLING file. Deliberately NOT
  # pointers: deep relative links, illustrative paths, placeholders.
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

  t12="$(fresh_install brownfield)"

  # Waiver: BY DESIGN never resolves; DEBT is someone else's slice. Asserted
  # both ways — a new dangler not listed fails, a listed one that resolved fails too.
  cat >"$WORK_ROOT/pointer-waiver.txt" <<'WAIVER'
.agents/user.md	BY DESIGN — personal file, deliberately never installed (the template is)
.agents/rules/task-*.md	BY DESIGN (upgrade-v2 must name the layer it retires) + DEBT (still cited by methodology.md — slice 07)
.agents/workflows.md	BY DESIGN (upgrade-v2 must name the layer it retires) + DEBT (still cited by methodology.md — slice 07)
WAIVER
  cut -f1 "$WORK_ROOT/pointer-waiver.txt" | LC_ALL=C sort >"$WORK_ROOT/waived.txt"

  dangling_pointers "$t12" >"$WORK_ROOT/dangling-raw.txt"
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

  # ...and WHO is allowed to cite the retired v1 layer today.
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

  printf 'KNOWN GAP (waived, still open):\n'
  while IFS= read -r waiver_line; do
    [ -n "$waiver_line" ] || continue
    printf '  %s\n' "$(printf '%s' "$waiver_line" | tr '\t' ' ')"
  done <"$WORK_ROOT/pointer-waiver.txt"

  # Mutation test: plant one broken pointer of each shape, demand both are caught.
  t12_mutant="$(fresh_install brownfield)"
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
}
