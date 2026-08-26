#!/usr/bin/env bash
# chisel — install, update, and check the Lonestone dev-workflow socle
# (this package's socle/) in a target repo.
#
# Usage:
#   chisel init [target-dir]   copy the socle + adapters (default target-dir: .)
#   chisel update [target-dir] re-render managed files + AGENTS.md block (default: .)
#   chisel check [target-dir]  report version + local divergences, zero writes (default: .)
#   chisel --version           print the installed chisel version
#   chisel --help              show this message
#
# Portable macOS (bash 3.2, BSD userland) + Linux (bash 4/5, GNU userland):
# no `sed -i`, no GNU-only flags, no `realpath`, no bash-4+ features (no
# associative arrays, no [[ ]], no process substitution — same conservative
# style as socle/scripts/sync-upstream.sh). Two external dependencies beyond
# a POSIX toolchain: `sha256sum` or `shasum` (file hashing) and `python3`
# (reading/writing the JSON manifest only — same precedent as
# socle/scripts/sync-upstream.sh's lock parsing).
#
# Package root resolution: `$0` is followed through symlinks with a manual
# `readlink` loop (npx installs the bin as a symlink), then the package root
# is `<dir containing the resolved script>/..`.
set -euo pipefail

# ---------------------------------------------------------------------------
# Package root resolution
# ---------------------------------------------------------------------------

resolve_script_path() {
  target="$1"
  while [ -L "$target" ]; do
    dir="$(cd -P "$(dirname "$target")" && pwd -P)"
    link="$(readlink "$target")"
    case "$link" in
      /*) target="$link" ;;
      *) target="$dir/$link" ;;
    esac
  done
  dir="$(cd -P "$(dirname "$target")" && pwd -P)"
  printf '%s/%s\n' "$dir" "$(basename "$target")"
}

SCRIPT_PATH="$(resolve_script_path "$0")"
BIN_DIR="$(dirname "$SCRIPT_PATH")"
PKG_ROOT="$(cd "$BIN_DIR/.." && pwd -P)"

SOCLE="$PKG_ROOT/socle"
AGENTS_BLOCK_SRC="$SOCLE/templates/AGENTS-block.md"
TASK_TEMPLATE_SRC="$SOCLE/templates/000-task-file-template.md"
TASK_ID_SRC="$SOCLE/scripts/task-id.sh"
PROJECT_MD_TPL="$SOCLE/agents/project.md.tpl"
USER_MD_TPL="$SOCLE/agents/user.md.tpl"
AGENTS_SKILLS_SRC="$SOCLE/agents/skills"
AGENTS_FORMULAS_SRC="$SOCLE/agents/formulas"
AGENTS_PROFILES_SRC="$SOCLE/agents/profiles"
DISCIPLINE_SRC="$SOCLE/agents/discipline.md"
FOREMAN_SRC="$SOCLE/agents/foreman.md"
METHODOLOGY_SRC="$SOCLE/agents/methodology.md"

BLOCK_BEGIN='<!-- chisel:begin -->'
BLOCK_END='<!-- chisel:end -->'

# Stamped into every per-tool agent definition chisel renders. It is what
# tells a render apart from a definition of the user's own that happens to
# carry the same role name: chisel only ever overwrites its own.
GEN_MARKER='chisel:generated'

# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------

die() {
  printf 'chisel: %s\n' "$*" >&2
  exit 1
}

require_python3() {
  command -v python3 >/dev/null 2>&1 ||
    die "python3 is required to read/write .agents/.chisel.json (not found on PATH)"
}

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    die "no sha256sum or shasum found on PATH"
  fi
}

sha256_stdin() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 | awk '{print $1}'
  else
    die "no sha256sum or shasum found on PATH"
  fi
}

# Reads the flat "version" field straight out of package.json — no python3
# needed for this one, since it is a single top-level string field.
package_version() {
  grep -m1 '"version"' "$PKG_ROOT/package.json" |
    sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/'
}

agents_block_hash() {
  awk -v begin="$BLOCK_BEGIN" -v end="$BLOCK_END" '
    $0 == begin { inblock = 1; next }
    $0 == end   { inblock = 0; next }
    inblock     { print }
  ' "$1" | sha256_stdin
}

manifest_version() {
  require_python3
  python3 -c '
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    print(json.load(f).get("version", ""))
' "$1"
}

# Prints "name<TAB>sha" for every entry in a manifest's "managed" map,
# sorted by name.
manifest_managed_tsv() {
  require_python3
  python3 -c '
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
for name, sha in sorted(data.get("managed", {}).items()):
    print(name + "\t" + sha)
' "$1"
}

# Relative-to-target-dir paths of every file the manifest tracks (excluding
# the AGENTS.md block, which is not a file — see agents_block_hash).
#
# The rendered agent definitions live in directories chisel shares with the
# user (`.claude/agents/`, `.codex/agents/`), so only the files carrying the
# generated marker are claimed as managed — a definition of the user's own is
# neither re-rendered nor reported as drift.
#
# `|| true` on both finds: find exits nonzero when any operand is missing, and
# under `set -euo pipefail` that would abort this function mid-body — silently
# dropping the trailing entries and leaving the caller with a truncated
# manifest. A missing directory here means "nothing to track", not a failure.
managed_relative_files() {
  target_dir="$1"
  ( cd "$target_dir" && find .agents/skills .agents/formulas .agents/profiles -type f 2>/dev/null || true ) |
    LC_ALL=C sort
  ( cd "$target_dir" && find .claude/agents .codex/agents -type f 2>/dev/null || true ) |
    LC_ALL=C sort |
    while IFS= read -r rel; do
      [ -n "$rel" ] || continue
      if grep -qF "$GEN_MARKER" "$target_dir/$rel" 2>/dev/null; then
        printf '%s\n' "$rel"
      fi
    done
  printf '.agents/discipline.md\n'
  printf '.agents/foreman.md\n'
  printf '.agents/methodology.md\n'
  printf '.agents/user.md.tpl\n'
  printf 'scripts/task-id.sh\n'
  printf 'project-management/000-task-file-template.md\n'
}

# ---------------------------------------------------------------------------
# Renderers — each is idempotent: running it twice with unchanged inputs
# produces byte-identical output.
# ---------------------------------------------------------------------------

# Create-or-update the AGENTS.md managed block. `project_title` is only used
# when the file does not exist yet.
render_agents_md() {
  agents_md="$1"
  project_title="$2"
  tmp="$(mktemp)"
  if [ ! -f "$agents_md" ]; then
    {
      printf '# %s — agent instructions\n\n' "$project_title"
      printf '%s\n' "$BLOCK_BEGIN"
      cat "$AGENTS_BLOCK_SRC"
      printf '%s\n' "$BLOCK_END"
    } >"$tmp"
  elif grep -qF "$BLOCK_BEGIN" "$agents_md" && grep -qF "$BLOCK_END" "$agents_md"; then
    awk -v begin="$BLOCK_BEGIN" -v end="$BLOCK_END" -v blockfile="$AGENTS_BLOCK_SRC" '
      BEGIN {
        while ((getline bline < blockfile) > 0) {
          block = block bline "\n"
        }
        close(blockfile)
      }
      $0 == begin { print begin; printf "%s", block; skip = 1; next }
      $0 == end   { print end; skip = 0; next }
      skip        { next }
      { print }
    ' "$agents_md" >"$tmp"
  else
    cp "$agents_md" "$tmp"
    {
      printf '\n%s\n' "$BLOCK_BEGIN"
      cat "$AGENTS_BLOCK_SRC"
      printf '%s\n' "$BLOCK_END"
    } >>"$tmp"
  fi
  # cat-into-place (not mv): mktemp files are mode 600, and mv would stamp
  # that onto an existing AGENTS.md; redirection keeps the target's perms.
  cat "$tmp" >"$agents_md"
  rm -f "$tmp"
}

# Ensure CLAUDE.md has a literal `@AGENTS.md` line; never touch anything else.
render_claude_md() {
  claude_md="$1"
  if [ ! -f "$claude_md" ]; then
    printf '@AGENTS.md\n' >"$claude_md"
    return
  fi
  if grep -qxF '@AGENTS.md' "$claude_md"; then
    return
  fi
  printf '@AGENTS.md\n' >>"$claude_md"
}

# Ensure .claude/skills -> ../.agents/skills. If something else is already
# there and isn't that exact symlink, warn and leave it alone.
link_claude_skills() {
  target_dir="$1"
  skills_link="$target_dir/.claude/skills"
  link_value="../.agents/skills"
  mkdir -p "$target_dir/.claude"
  if [ -L "$skills_link" ]; then
    current_link="$(readlink "$skills_link")"
    if [ "$current_link" != "$link_value" ]; then
      printf 'chisel: warning: %s is a symlink to %s, not %s — leaving it alone\n' \
        "$skills_link" "$current_link" "$link_value" >&2
    fi
  elif [ -e "$skills_link" ]; then
    printf 'chisel: warning: %s exists and is not a symlink — leaving it alone\n' \
      "$skills_link" >&2
  else
    ln -s "$link_value" "$skills_link"
  fi
}

# Copy every managed file into target_dir. Safe to call repeatedly
# (cp merges into existing directories; content that hasn't changed upstream
# stays byte-identical).
copy_managed_files() {
  target_dir="$1"

  mkdir -p "$target_dir/.agents"
  cp -R "$AGENTS_SKILLS_SRC" "$target_dir/.agents/"
  cp -R "$AGENTS_FORMULAS_SRC" "$target_dir/.agents/"
  cp -R "$AGENTS_PROFILES_SRC" "$target_dir/.agents/"
  cp "$DISCIPLINE_SRC" "$target_dir/.agents/discipline.md"
  cp "$FOREMAN_SRC" "$target_dir/.agents/foreman.md"
  cp "$METHODOLOGY_SRC" "$target_dir/.agents/methodology.md"
  # The TEMPLATE of the personal file, not the personal file itself: it is
  # socle text, committed like the rest, and it is what lets any dev — the
  # first one or the fifth — pose their own `.agents/user.md` with a copy, no
  # package and no network. `init` never writes `.agents/user.md`: a shared
  # installer has no business creating a personal, gitignored file.
  cp "$USER_MD_TPL" "$target_dir/.agents/user.md.tpl"

  mkdir -p "$target_dir/scripts"
  cp "$TASK_ID_SRC" "$target_dir/scripts/task-id.sh"
  chmod +x "$target_dir/scripts/task-id.sh"

  mkdir -p "$target_dir/project-management"
  cp "$TASK_TEMPLATE_SRC" "$target_dir/project-management/000-task-file-template.md"
}

# --- Per-tool agent definitions, rendered from the canonical profiles ------
#
# No tool can import a shared definition, so chisel generates one per tool
# from the same source: the profile body IS the contract, the renders are
# thin. Claude Code's format also covers Cursor >= 2.4 (it reads
# `.claude/agents/` natively); Codex needs TOML. Tools with no definition
# format at all use the fallback documented in `.agents/profiles/README.md`.

# Value of a flat frontmatter key ("name: mason" -> "mason"). Empty when the
# file has no frontmatter or no such key — which is how a documentation page
# dropped in `profiles/` (its README) stays invisible to the renderer.
profile_field() {
  awk -v key="$2" '
    NR == 1 && $0 != "---" { exit }
    NR == 1 { next }
    $0 == "---" { exit }
    index($0, key ": ") == 1 { print substr($0, length(key) + 3); exit }
  ' "$1"
}

# Everything after the frontmatter, leading blank lines trimmed.
profile_body() {
  awk '
    NR == 1 && $0 == "---" { inhead = 1; next }
    inhead && $0 == "---"  { inhead = 0; next }
    inhead                 { next }
    !started && $0 == ""   { next }
    { started = 1; print }
  ' "$1"
}

# Escape a one-line value for a double-quoted scalar. YAML's double-quoted
# style and TOML's basic string agree on the two characters that can occur
# here, so one helper serves both renders — and quoting is what keeps a
# description containing `: `, a leading `[`, or a `#` from breaking the
# frontmatter it lands in.
escape_double_quoted() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# Write rendered content over a definition chisel owns. A file that exists
# without the generated marker belongs to the user (their own sub-agent of
# the same name): warn and leave it alone rather than destroy it — the same
# stance link_claude_skills takes on a foreign `.claude/skills`.
install_generated() {
  dest="$1"
  rendered="$2"
  if [ -e "$dest" ] && ! grep -qF "$GEN_MARKER" "$dest" 2>/dev/null; then
    printf 'chisel: warning: %s exists and was not generated by chisel — leaving it alone\n' \
      "$dest" >&2
    return 0
  fi
  cat "$rendered" >"$dest"
}

render_agent_definitions() {
  target_dir="$1"
  profiles_dir="$target_dir/.agents/profiles"
  [ -d "$profiles_dir" ] || return 0

  mkdir -p "$target_dir/.claude/agents" "$target_dir/.codex/agents"

  for profile in "$profiles_dir"/*.md; do
    [ -f "$profile" ] || continue
    name="$(profile_field "$profile" name)"
    [ -n "$name" ] || continue
    description="$(profile_field "$profile" description)"
    # The generated files are named after the role (`name` is the identity
    # every tool addresses it by), but the provenance pointer names the file
    # it actually came from — so it stays true even if the two ever differ.
    source_rel=".agents/profiles/$(basename "$profile")"

    body="$(mktemp)"
    profile_body "$profile" >"$body"

    # TOML multi-line LITERAL strings do no escape processing at all, which
    # is what keeps a markdown body byte-identical through the render. The
    # single sequence they cannot carry is the delimiter itself.
    if grep -qF "'''" "$body"; then
      rm -f "$body"
      die "profile $profile contains ''' — it cannot be rendered as TOML; rephrase it"
    fi

    tmp="$(mktemp)"
    {
      printf -- '---\n'
      printf 'name: "%s"\n' "$(escape_double_quoted "$name")"
      printf 'description: "%s"\n' "$(escape_double_quoted "$description")"
      printf -- '---\n\n'
      printf '<!-- %s from %s — do not edit: `chisel update` re-renders it. -->\n\n' \
        "$GEN_MARKER" "$source_rel"
      cat "$body"
    } >"$tmp"
    install_generated "$target_dir/.claude/agents/$name.md" "$tmp"

    : >"$tmp"
    {
      printf '# %s from %s — do not edit: `chisel update` re-renders it.\n' \
        "$GEN_MARKER" "$source_rel"
      printf 'name = "%s"\n' "$(escape_double_quoted "$name")"
      printf 'description = "%s"\n' "$(escape_double_quoted "$description")"
      printf "developer_instructions = '''\n"
      cat "$body"
      printf "'''\n"
    } >"$tmp"
    install_generated "$target_dir/.codex/agents/$name.toml" "$tmp"

    rm -f "$tmp" "$body"
  done
}

# True when a directory holds at least one definition chisel rendered (a file
# carrying the generated marker). Used by the §E inventory: the directory
# existing proves nothing — the user may own everything in it.
generated_definitions_present() {
  defs_dir="$1"
  [ -d "$defs_dir" ] || return 1
  defs_found=1
  for def_file in "$defs_dir"/*; do
    [ -f "$def_file" ] || continue
    if grep -qF "$GEN_MARKER" "$def_file" 2>/dev/null; then
      defs_found=0
      break
    fi
  done
  return "$defs_found"
}

# Project-owned: written once, never again. Prints "created" when this run
# wrote the file, so init knows it may fill the §E adapter inventory below.
ensure_project_md() {
  target_dir="$1"
  project_md="$target_dir/.agents/project.md"
  if [ ! -f "$project_md" ]; then
    cp "$PROJECT_MD_TPL" "$project_md"
    printf 'created\n'
  fi
}

# Fill §E (Adapters) of a project.md THIS init run just created: tick each
# adapter line whose adapter is actually in place. Never called on a
# pre-existing project.md — that file is project-owned.
tick_adapter_inventory() {
  target_dir="$1"
  project_md="$target_dir/.agents/project.md"
  [ -f "$project_md" ] || return 0

  agents_ok=0
  claude_ok=0
  link_ok=0
  claude_defs_ok=0
  codex_defs_ok=0
  if [ -f "$target_dir/AGENTS.md" ] &&
     grep -qF "$BLOCK_BEGIN" "$target_dir/AGENTS.md" &&
     grep -qF "$BLOCK_END" "$target_dir/AGENTS.md"; then
    agents_ok=1
  fi
  if [ -f "$target_dir/CLAUDE.md" ] &&
     grep -qxF '@AGENTS.md' "$target_dir/CLAUDE.md"; then
    claude_ok=1
  fi
  if [ -L "$target_dir/.claude/skills" ] &&
     [ "$(readlink "$target_dir/.claude/skills")" = "../.agents/skills" ]; then
    link_ok=1
  fi
  # Ticked when chisel actually RENDERED something there, not merely when the
  # directory exists: `.claude/agents/` is shared with the user's own
  # sub-agents, and a directory holding only foreign files is not an adapter
  # chisel installed.
  if generated_definitions_present "$target_dir/.claude/agents"; then
    claude_defs_ok=1
  fi
  if generated_definitions_present "$target_dir/.codex/agents"; then
    codex_defs_ok=1
  fi

  tmp="$(mktemp)"
  awk -v a="$agents_ok" -v c="$claude_ok" -v l="$link_ok" \
      -v cdefs="$claude_defs_ok" -v xdefs="$codex_defs_ok" '
    /^## / { ine = ($0 ~ /^## E · /) ? 1 : 0 }
    ine && a && /^- \[ \] `AGENTS\.md`/           { sub(/^- \[ \]/, "- [x]") }
    ine && c && /^- \[ \] `CLAUDE\.md`/           { sub(/^- \[ \]/, "- [x]") }
    ine && l && /^- \[ \] `\.claude\/skills`/     { sub(/^- \[ \]/, "- [x]") }
    ine && cdefs && /^- \[ \] `\.claude\/agents`/ { sub(/^- \[ \]/, "- [x]") }
    ine && xdefs && /^- \[ \] `\.codex\/agents`/  { sub(/^- \[ \]/, "- [x]") }
    { print }
  ' "$project_md" >"$tmp"
  cat "$tmp" >"$project_md"
  rm -f "$tmp"
}

# Project-owned: tasks/archive created if missing; CHANGELOG.md written
# once, never again.
ensure_project_management_skeleton() {
  target_dir="$1"
  pm_root="$target_dir/project-management"
  mkdir -p "$pm_root/tasks" "$pm_root/archive"
  changelog="$pm_root/CHANGELOG.md"
  if [ ! -f "$changelog" ]; then
    {
      printf '# Changelog\n\n'
      printf 'Project history, newest first.\n\n'
      printf '## %s\n\n' "$(date +%Y-%m-%d)"
      printf '%s\n' "- chisel init: installed the dev-workflow socle."
    } >"$changelog"
  fi
}

# Rewrite .agents/.chisel.json from the current state of target_dir: chisel
# package version + sha256 of every managed file + the AGENTS.md block hash.
write_manifest() {
  target_dir="$1"
  require_python3

  manifest_file="$target_dir/.agents/.chisel.json"
  version="$(package_version)"

  agents_md="$target_dir/AGENTS.md"
  if [ -f "$agents_md" ]; then
    block_hash="$(agents_block_hash "$agents_md")"
  else
    block_hash=""
  fi

  hash_list="$(mktemp)"
  managed_relative_files "$target_dir" | while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    file_path="$target_dir/$rel"
    if [ -f "$file_path" ]; then
      printf '%s\t%s\n' "$rel" "$(sha256_file "$file_path")"
    fi
  done >"$hash_list"

  python3 - "$manifest_file" "$version" "$block_hash" "$hash_list" <<'PY'
import json
import sys

manifest_path, version, block_hash, list_path = sys.argv[1:5]

managed = {}
with open(list_path, encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\n")
        if not line:
            continue
        name, sha = line.split("\t", 1)
        managed[name] = sha

if block_hash:
    managed["AGENTS.md#block"] = block_hash

data = {"version": version, "managed": managed}

with open(manifest_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, sort_keys=True)
    f.write("\n")
PY

  rm -f "$hash_list"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_init() {
  target_dir="${1:-.}"
  [ -d "$target_dir" ] || die "target dir does not exist: $target_dir"

  project_title="$(basename "$(cd "$target_dir" && pwd -P)")"

  copy_managed_files "$target_dir"
  render_agent_definitions "$target_dir"
  project_md_state="$(ensure_project_md "$target_dir")"
  render_agents_md "$target_dir/AGENTS.md" "$project_title"
  render_claude_md "$target_dir/CLAUDE.md"
  link_claude_skills "$target_dir"
  if [ "$project_md_state" = "created" ]; then
    tick_adapter_inventory "$target_dir"
  fi
  ensure_project_management_skeleton "$target_dir"
  write_manifest "$target_dir"

  printf 'chisel init: %s ready (.agents/, AGENTS.md, CLAUDE.md, .claude/skills, .claude/agents, .codex/agents, project-management/, scripts/task-id.sh)\n' \
    "$target_dir"
}

cmd_update() {
  target_dir="${1:-.}"
  [ -d "$target_dir" ] || die "target dir does not exist: $target_dir"
  [ -d "$target_dir/.agents" ] || die "$target_dir/.agents not found — run 'chisel init' first"

  manifest_file="$target_dir/.agents/.chisel.json"
  old_tsv="$(mktemp)"
  if [ -f "$manifest_file" ]; then
    manifest_managed_tsv "$manifest_file" >"$old_tsv"
  else
    : >"$old_tsv"
  fi

  copy_managed_files "$target_dir"
  render_agent_definitions "$target_dir"
  if [ -f "$target_dir/AGENTS.md" ]; then
    render_agents_md "$target_dir/AGENTS.md" ""
  else
    printf 'chisel update: warning: %s/AGENTS.md not found — skipping (run chisel init first)\n' \
      "$target_dir" >&2
  fi
  write_manifest "$target_dir"

  new_tsv="$(mktemp)"
  manifest_managed_tsv "$manifest_file" >"$new_tsv"

  names_tsv="$(mktemp)"
  cut -f1 "$new_tsv" >"$names_tsv"

  printf 'chisel update: %s\n' "$target_dir"
  changed=0
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    old_sha="$(awk -F'\t' -v n="$rel" '$1==n{print $2; exit}' "$old_tsv")"
    new_sha="$(awk -F'\t' -v n="$rel" '$1==n{print $2; exit}' "$new_tsv")"
    if [ "$old_sha" != "$new_sha" ]; then
      printf '  changed: %s\n' "$rel"
      changed=1
    fi
  done <"$names_tsv"
  [ "$changed" -eq 1 ] || printf '  (no managed files changed)\n'

  rm -f "$old_tsv" "$new_tsv" "$names_tsv"
}

cmd_check() {
  target_dir="${1:-.}"
  [ -d "$target_dir" ] || die "target dir does not exist: $target_dir"

  manifest_file="$target_dir/.agents/.chisel.json"
  [ -f "$manifest_file" ] || die "no manifest at $manifest_file — run 'chisel init' first"

  exit_code=0

  pkg_ver="$(package_version)"
  man_ver="$(manifest_version "$manifest_file")"

  printf 'chisel check: %s\n' "$target_dir"
  printf '  package version:  %s\n' "$pkg_ver"
  printf '  manifest version: %s\n' "$man_ver"
  if [ "$pkg_ver" != "$man_ver" ]; then
    printf '  MISMATCH: manifest was written by a different chisel version (run chisel update)\n'
    exit_code=1
  fi

  managed_tsv="$(mktemp)"
  manifest_managed_tsv "$manifest_file" >"$managed_tsv"

  while IFS= read -r line; do
    [ -n "$line" ] || continue
    rel="$(printf '%s\n' "$line" | cut -f1)"
    expected="$(printf '%s\n' "$line" | cut -f2)"
    if [ "$rel" = "AGENTS.md#block" ]; then
      agents_md="$target_dir/AGENTS.md"
      if [ ! -f "$agents_md" ]; then
        printf '  MISSING: AGENTS.md (expected managed block)\n'
        exit_code=1
        continue
      fi
      actual="$(agents_block_hash "$agents_md")"
    else
      file_path="$target_dir/$rel"
      if [ ! -f "$file_path" ]; then
        printf '  MISSING: %s\n' "$rel"
        exit_code=1
        continue
      fi
      actual="$(sha256_file "$file_path")"
    fi
    if [ "$actual" != "$expected" ]; then
      printf '  DIVERGED: %s (local edit since last init/update)\n' "$rel"
      exit_code=1
    fi
  done <"$managed_tsv"
  rm -f "$managed_tsv"

  skills_link="$target_dir/.claude/skills"
  if [ -L "$skills_link" ] && [ -e "$skills_link" ]; then
    printf '  OK adapter: .claude/skills\n'
  else
    printf '  MISSING adapter: .claude/skills symlink\n'
    exit_code=1
  fi

  if [ -f "$target_dir/CLAUDE.md" ] && grep -qxF '@AGENTS.md' "$target_dir/CLAUDE.md"; then
    printf '  OK adapter: CLAUDE.md @AGENTS.md import\n'
  else
    printf '  MISSING adapter: CLAUDE.md @AGENTS.md import\n'
    exit_code=1
  fi

  if [ -f "$target_dir/AGENTS.md" ] && grep -qF "$BLOCK_BEGIN" "$target_dir/AGENTS.md" &&
    grep -qF "$BLOCK_END" "$target_dir/AGENTS.md"; then
    printf '  OK adapter: AGENTS.md managed block markers\n'
  else
    printf '  MISSING adapter: AGENTS.md managed block markers\n'
    exit_code=1
  fi

  if [ "$exit_code" -eq 0 ]; then
    printf '  clean — no divergence\n'
  fi

  exit "$exit_code"
}

usage() {
  cat <<EOF
chisel — install, update, and check the Lonestone dev-workflow socle

Usage:
  chisel init [target-dir]    copy the socle + adapters (default target-dir: .)
  chisel update [target-dir]  re-render managed files + AGENTS.md block (default: .)
  chisel check [target-dir]   report version + local divergences, zero writes (default: .)
  chisel --version            print the installed chisel version
  chisel --help               show this message
EOF
}

print_version() {
  printf '%s\n' "$(package_version)"
}

main() {
  cmd="${1:-}"
  case "$cmd" in
    init)
      shift
      cmd_init "$@"
      ;;
    update)
      shift
      cmd_update "$@"
      ;;
    check)
      shift
      cmd_check "$@"
      ;;
    --version | version)
      print_version
      ;;
    -h | --help | help | "")
      usage
      ;;
    *)
      printf 'chisel: unknown command: %s\n' "$cmd" >&2
      usage
      exit 1
      ;;
  esac
}

main "$@"
