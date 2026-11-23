# How coding-agent tools expose a project's commands, and what each costs in context

Question: how do coding-agent tools expose a project's commands (build, test, lint, regenerate a client, create a migration, start/stop the dev stack) to the agent, what does each tool officially recommend, and is each mechanism loaded in every conversation or on demand?

Access date: 2026-11-23. Most pages show no date; only the VS Code prompt-files page shows one (11/18/2026). Pages are read through a fetch tool that summarises them, so quotes are those the tool returned; re-check any quote before citing it in a decision record.

## Findings in three sentences

Every tool has an always-loaded instruction file (AGENTS.md, CLAUDE.md, GEMINI.md, `.github/copilot-instructions.md`, Cursor "Always Apply" rules) and an on-demand mechanism (Agent Skills, which Claude Code, Codex, Cursor, Gemini CLI and Copilot all document as following the agentskills.io standard). Claude Code and agents.md say to put build and test commands in the always-loaded file, while Claude Code says multi-step procedures belong in skills, and Cursor says not to document commands the agent already knows (npm, git, pytest). Custom prompts and commands are being folded into skills (Claude Code: merged; Codex and VS Code Copilot: deprecated in favour of skills), and for task runners (just, mise, package.json scripts) no primary source says anything about agents.

## 1. agents.md (open format)

- Mechanism: a plain Markdown file, "No fields are required". Nearest file in the tree wins; chat prompts override everything.
- Location: repo root, plus optional AGENTS.md per package (nested).
- Commands: "Popular sections include a project overview, build and test commands, code style guidelines, testing instructions, and security considerations". The sample lists `pnpm install`, `pnpm dev`, `pnpm test`. If test commands are listed the agent "attempts to run the relevant checks".
- Context cost: the format does not define it; each tool decides. Gemini CLI and Aider need a setting to read it, per the page.
- Source: https://agents.md (no date shown).

## 2. Claude Code

- CLAUDE.md (memory). Locations: `./CLAUDE.md` or `./.claude/CLAUDE.md`, user and managed scopes. Cost: "Loaded into: Every session"; "Claude reads them at the start of every session". Subdirectory CLAUDE.md files load on demand when Claude touches files there. Target "under 200 lines per CLAUDE.md file". `@path` imports "help you organize a long file but don't reduce its context cost".
- Recommendation: "Keep it to facts Claude should hold in every session: build commands, conventions, project layout, 'always do X' rules. If an entry is a multi-step procedure or only matters for one part of the codebase, move it to a skill or a path-scoped rule." Best-practices page: "if you have [a test or typecheck], the single most useful line in your CLAUDE.md is the command that runs it" (paraphrase of: "If your repo already has one of these, the single most useful line in your `CLAUDE.md` is the command that runs it."). Also: do not describe architecture Claude can read itself.
- AGENTS.md: read by default only when no CLAUDE.md exists in the working directory or above (v2.1.277+); otherwise import it from CLAUDE.md with `@AGENTS.md`.
- `.claude/rules/`: rules without `paths` frontmatter load at launch; with `paths` they load when matching files are opened. "Rules load into context every session or when matching files are opened."
- Skills: `.claude/skills/<name>/SKILL.md` (project), `~/.claude/skills/` (user). "skill descriptions are loaded into context so Claude knows what's available, but full skill content only loads when invoked." Description plus `when_to_use` truncated at 1,536 characters in the listing. "Keep `SKILL.md` under 500 lines." Best-practices: "Put team procedures in skills"; skills are "lighter on context than CLAUDE.md": name and description every session, full file only when the task calls for it. `disable-model-invocation: true` makes a skill user-invoked only (example: `/release`).
- Custom slash commands: "Custom commands have been merged into skills. Your existing `.claude/commands/` files keep working." A skill file at `.claude/skills/deploy/SKILL.md` and a command file both give `/deploy`.
- Standard: "Claude Code skills follow the Agent Skills open standard, which works across multiple AI tools." Claude Code adds extensions (invocation control, subagents, dynamic context injection).
- Hooks: deterministic, run by the harness, not the model. "If something has to happen every time, make it a hook, a deny rule, or a managed setting. CLAUDE.md is for guidelines." Example: a `Stop` hook that runs the typecheck; a `PostToolUse` hook for the formatter.
- Sources: https://code.claude.com/docs/en/memory ; https://code.claude.com/docs/en/skills ; https://code.claude.com/docs/en/best-practices (no dates shown).

## 2b. Agent Skills open standard (agentskills.io)

- Layout: `skill-name/SKILL.md` (required) plus optional `scripts/`, `references/`, `assets/`. Frontmatter: `name` (max 64 chars, matches directory), `description` (max 1024 chars, "what the skill does and when to use it").
- Cost, three levels: "Metadata (~100 tokens): name and description loaded at startup for all skills"; "Instructions (< 5000 tokens recommended)" loaded on activation; "Resources (as needed)". Keep SKILL.md under 500 lines.
- `scripts/` holds "executable code that agents can run" (a place for a project's command wrappers).
- Source: https://agentskills.io/specification (no date shown).

## 3. OpenAI Codex

- AGENTS.md: built once per run. Global `~/.codex/AGENTS.md` (or `AGENTS.override.md`), then each directory from the project root down to the current one; concatenated root to leaf; stops at `project_doc_max_bytes` (32 KiB default). Fallback names via `project_doc_fallback_filenames`. Cost: always loaded, capped at 32 KiB. The page gives no recommendation on commands.
- Skills: repo `.agents/skills` (cwd up to repo root), `$HOME/.agents/skills`, `/etc/codex/skills`. "It first sees each skill's name and description, plus its file path. It reads the full `SKILL.md` only after it decides to use that skill." The initial list has a budget of about 2% of the context window (8,000 characters if unknown). Explicit (`$`, `/skills`) or implicit invocation; `allow_implicit_invocation: false` disables implicit. Built on agentskills.io.
- Custom prompts: `~/.codex/prompts/*.md`, user-level only, invoked `/prompts:name`. Marked deprecated: "Use skills for reusable instructions".
- Sources: https://learn.chatgpt.com/docs/agent-configuration/agents-md ; https://learn.chatgpt.com/docs/build-skills ; https://learn.chatgpt.com/docs/custom-prompts (the developers.openai.com/codex URLs return a 308 redirect to these; no dates shown). The openai/codex repo itself was not read.

## 4. Cursor

- Rules: `.cursor/rules/*.mdc` (plain `.md` ignored per the page). Modes: Always Apply, Apply Intelligently (agent decides from the description), Apply to Specific Files (glob), Apply Manually (@-mention). "Always Apply rules are included in every chat, so they carry the most ongoing context cost." Keep rules under 500 lines.
- AGENTS.md: supported as a rule source, root and subdirectories, nested files combine with the more specific ones taking precedence.
- Recommendation: "Avoid documenting common commands such as npm, git, or pytest, since Agent already knows them." Use a linter rather than copying style guides. Referenced files are not inlined; the agent reads them only when needed.
- Skills: `.agents/skills/`, `.cursor/skills/`, user-level equivalents; also reads `.claude/skills/` and `.codex/skills/`. "Agent sees the list of available skills and decides when each one is relevant"; `scripts/`, `references/`, `assets/` "are loaded only when needed"; `paths` frontmatter and `disable-model-invocation: true` supported; follows agentskills.io.
- Commands: the commands page fetched says nothing on location or cost; the skills page mentions a `/migrate-to-skills` built-in (Cursor 2.4+) that converts commands, so commands appear to be on the way to skills. Treat the command location as not verified.
- Sources: https://cursor.com/docs/context/rules ; https://cursor.com/docs/context/skills ; https://cursor.com/docs/context/commands (no dates shown).

## 5. Gemini CLI

- GEMINI.md: `~/.gemini/GEMINI.md`, workspace files and parents, plus just-in-time files found when a tool touches a directory. "Global and workspace files are sent to the model with every prompt"; JIT files load only when needed. `@file.md` imports. `context.fileName` in settings.json accepts a list, for example `["AGENTS.md", "CONTEXT.md", "GEMINI.md"]`.
- Custom commands (TOML): `~/.gemini/commands/` or `<project>/.gemini/commands/`; required field `prompt`; path gives name (`git/commit.toml` becomes `/git:commit`); `!{...}` runs a shell command, after confirmation, and inserts its output into the prompt. Cost: loaded only when typed.
- Extensions: bundle "prompts, MCP servers, custom commands, themes, hooks, sub-agents, and agent skills". The page read does not describe an extension context file.
- Skills: `.gemini/skills/` or `.agents/skills/` (workspace), `~/.gemini/skills/` or `~/.agents/skills/` (user). "At session start, Gemini CLI loads only each enabled skill's name and description into the system prompt"; body loads when the model calls `activate_skill` and the user approves. Follows agentskills.io.
- Sources (repo docs, raw files on main, no commit date read): https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/gemini-md.md ; .../docs/cli/custom-commands.md ; .../docs/cli/skills.md ; .../docs/extensions/index.md

## 6. GitHub Copilot

- `.github/copilot-instructions.md`: "Repository-wide custom instructions apply to all requests made in the context of a repository", "automatically added to requests". Always loaded for those requests.
- Path-specific: `.github/instructions/NAME.instructions.md` with `applyTo` globs and optional `excludeAgent`; applies only when matched files are in play.
- AGENTS.md: "the nearest AGENTS.md file in the directory tree will take precedence". Support depends on surface: yes for cloud agent, Copilot CLI, VS Code chat; no for Copilot Chat on GitHub.com, Visual Studio chat, VS Code code review, and others (table in the support reference).
- Recommendation for commands: the page's example prompt for generating the file asks for "Build, test, run, and lint steps, with the tool and runtime versions and the order to run them", commands verified by running, and the checks run before check-in; no more than two pages.
- Prompt files: `.github/prompts/*.prompt.md`, invoked `/name` in chat (VS Code docs, dated 11/18/2026). They run only in the Local harness, which is deprecated and removed in February 2027; the page recommends skills for new reusable workflows. The GitHub Docs prompt-files page fetched had no detail.
- Agent skills: `.github/skills`, `.claude/skills` or `.agents/skills`; personal `~/.copilot/skills` or `~/.agents/skills`. "Resources are loaded only when needed". Supported in the Copilot app, CLI, cloud agent, code review, and VS Code, Visual Studio and JetBrains agent mode (version-dependent).
- copilot-setup-steps: `.github/workflows/copilot-setup-steps.yml`, one job named `copilot-setup-steps`, only effective on the default branch. It prepares the cloud agent's environment (install dependencies, for example `npm ci`) before the agent starts, deterministically; it is an environment mechanism, not a command catalogue. Honoured keys: `steps`, `permissions`, `runs-on`, `services`, `snapshot`, `timeout-minutes` (max 59).
- Sources: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions ; https://docs.github.com/en/copilot/reference/custom-instructions-support ; https://docs.github.com/en/copilot/concepts/agents/about-agent-skills ; https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/customize-the-agent-environment ; https://code.visualstudio.com/docs/copilot/customization/prompt-files (dated 11/18/2026).

## 7. Task runners as the agent's entry point

- just: the manual front page says only "Recipes can be listed from the command line." Nothing about agents or `just --list` by name on that page. No primary source found for agents. (https://just.systems/man/en/)
- mise: tasks page says "Run `mise tasks ls` to list tasks and `mise tasks info hello` to see where a task is defined." Nothing about agents or MCP on that page. No primary source found for agents. (https://mise.jdx.dev/tasks/)
- package.json scripts: no primary source found (none fetched). Claude Code's own example only names the command in CLAUDE.md (the typecheck line).
- No agent tool's docs read here recommend `just --list` or `mise tasks` as discovery. The documented pattern is to write the command in the always-loaded file or a skill.

## Comparison

| Tool | Always-loaded place | On-demand place | What it recommends for commands |
|---|---|---|---|
| agents.md | AGENTS.md (tool decides) | none defined | "build and test commands" as a popular section |
| Claude Code | CLAUDE.md (or AGENTS.md if no CLAUDE.md), rules without `paths` | skills (name+description listed), `paths` rules, subdirectory CLAUDE.md, commands (merged into skills) | build/test commands in CLAUDE.md; multi-step procedures in skills; hard rules in hooks |
| Codex | AGENTS.md chain (32 KiB cap) | skills (name+description+path, about 2% budget); prompts deprecated | not stated on the AGENTS.md page; skills for reusable instructions |
| Cursor | Always Apply rules, AGENTS.md | Apply Intelligently, file-scoped and manual rules; skills; commands | skip commands the agent already knows (npm, git, pytest) |
| Gemini CLI | GEMINI.md (or AGENTS.md via `context.fileName`) | skills (name+description), TOML commands, JIT GEMINI.md | not stated; `!{...}` in commands injects shell output |
| Copilot | copilot-instructions.md, AGENTS.md (surface-dependent) | path `.instructions.md`, skills, prompt files (deprecated path) | "Build, test, run, and lint steps" with versions and order |
| Runners (just, mise, scripts) | none | none | no primary source found on agents |

## Not verified or not read

- Codex: openai/codex repo not read; docs pages are on learn.chatgpt.com after redirect. No page showed a date except VS Code prompt files.
- Cursor commands location and context cost: page silent.
- Gemini extension context-file loading: page read silent. Gemini docs read from raw files on main; no release or commit date captured.
- Copilot prompt files on docs.github.com: page had no detail; VS Code page used instead.
- package.json scripts: not searched in a primary source.
- Re-checked on 2026-11-23 by a second fetch: the memory page's "Keep it to facts…" sentence (it ends "…or a path-scoped rule instead."), and on the best-practices page the "single most useful line" sentence, the heading "Put team procedures in skills" and "If something has to happen every time, make it a hook, a deny rule, or a managed setting." are on the pages verbatim.

## Sources

- https://agents.md
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/best-practices
- https://agentskills.io/specification
- https://learn.chatgpt.com/docs/agent-configuration/agents-md
- https://learn.chatgpt.com/docs/build-skills
- https://learn.chatgpt.com/docs/custom-prompts
- https://cursor.com/docs/context/rules
- https://cursor.com/docs/context/skills
- https://cursor.com/docs/context/commands
- https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/gemini-md.md
- https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/custom-commands.md
- https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/cli/skills.md
- https://raw.githubusercontent.com/google-gemini/gemini-cli/main/docs/extensions/index.md
- https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
- https://docs.github.com/en/copilot/reference/custom-instructions-support
- https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
- https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/customize-the-agent-environment
- https://code.visualstudio.com/docs/copilot/customization/prompt-files
- https://just.systems/man/en/
- https://mise.jdx.dev/tasks/
