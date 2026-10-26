---
name: environment-doctor
description: Checks the health of a Claude Code or Codex dev environment (git, Node.js, the Claude Code and Codex CLIs and their login state, VS Code + extensions, Docker, claude-mem, installed plugins) and gives exact fix commands per OS. Use when the user says "check my setup", "is my install broken", "setup isn't working", or asks why claude/codex/docker/git isn't working.
allowed-tools:
  - Bash(git --version)
  - Bash(node --version)
  - Bash(bun --version)
  - Bash(code --version)
  - Bash(code --list-extensions)
  - Bash(docker --version)
  - Bash(docker info)
  - Bash(claude --version)
  - Bash(claude doctor)
  - Bash(claude plugin list)
  - Bash(claude plugin marketplace list)
  - Bash(codex --version)
  - Bash(codex doctor --summary --no-color)
  - Bash(codex plugin list)
  - Bash(codex plugin marketplace list)
  - Bash(claude-mem --version)
  - Bash(test -d ~/.claude-mem)
---

This skill runs inside either Claude Code or Codex. Every check below is
read-only. In Claude Code they are pre-approved in `allowed-tools`, so run them
without stopping to ask. Never assume a result — always run the real command.

If a check fails with "Operation not permitted", "permission denied", or a
Docker socket connect error while you are running inside Codex, that is Codex's
sandbox, not the machine: rerun that one command with escalated permissions
before reporting it as broken.

## 1. Run these checks (one at a time)

- `git --version`
- `node --version` (needs ≥ 20 — claude-mem requires it; current LTS recommended)
- `code --version`
- `docker --version` and `docker info` (confirms the engine is actually running, not just installed)
- Claude Code, if it's installed:
  - `claude --version`
  - `claude doctor` — read-only install diagnostics; reports sign-in state, auto-update state, settings-file errors, each with a suggested fix
  - `claude plugin list` and `claude plugin marketplace list`
- Codex, if it's installed:
  - `codex --version`
  - `codex doctor --summary --no-color` — read-only; reports auth (`no Codex credentials` = not logged in), sandbox, connectivity, available updates
  - `codex plugin list` and `codex plugin marketplace list`
- claude-mem: `test -d ~/.claude-mem` (installed at all), `claude-mem --version` (the hook launcher is on PATH), `bun --version` (its hooks and worker run on Bun)
- `code --list-extensions` and check for: `anthropic.claude-code` (if Claude Code is used), `openai.chatgpt` (if Codex is used), `ms-azuretools.vscode-containers` (Docker support; the older `ms-azuretools.vscode-docker` is now just a pack that pulls it in — either counts)

At least one agent CLI must be present. Only report the other one as missing
if the user says they use it.

Summarize the results as a ✅/❌ table before suggesting any fixes.

## 2. Fix commands by OS (ask which OS if unknown)

**Windows (PowerShell):**
- Missing Git → `winget install --id Git.Git -e`
- Missing Node → `winget install --id OpenJS.NodeJS.LTS -e`
- Missing VS Code → `winget install --id Microsoft.VisualStudioCode -e`
- Missing Docker → `winget install --id Docker.DockerDesktop -e`, then note it needs a restart + first manual launch (and `wsl --install --no-distribution` first if WSL2 isn't set up yet)
- Missing Claude Code CLI → `irm https://claude.ai/install.ps1 | iex`
- Missing Codex CLI → `irm https://chatgpt.com/codex/install.ps1 | iex`

**macOS (via Homebrew):**
- Missing Git/Node → `brew install git` / `brew install node`
- Missing VS Code → `brew install --cask visual-studio-code`
- Missing Docker → `brew install --cask docker-desktop`, then note it needs to be opened manually once
- Missing Claude Code CLI → `curl -fsSL https://claude.ai/install.sh | bash`
- Missing Codex CLI → `curl -fsSL https://chatgpt.com/codex/install.sh | sh`

**Both OSes:**
- A CLI installed but not found in the terminal → almost always a PATH-not-refreshed issue; tell the user to close and reopen their terminal first. On macOS both native installers put the binary in `~/.local/bin`.
- Not logged in (`claude doctor` says not signed in / `codex doctor` says no credentials) → run `claude` or `codex` once and finish the browser sign-in.
- Outdated → `claude update` / rerun the Codex installer command above (`brew upgrade --cask codex` if it was installed with Homebrew, `npm install -g @openai/codex` if with npm).
- claude-mem not installed, or installed but Bun / the `claude-mem` launcher is missing → `npx claude-mem install`. It detects Claude Code and Codex, installs Bun and uv itself, and puts the launcher on PATH; reopen the terminal afterwards. With Claude Code it needs ≥ 2.1.139.
- Missing VS Code extension → `code --install-extension <id> --force`

## 3. Plugin problems specifically

A plugin that "installed fine" but does nothing is nearly always one of these:

- **Session started before the install.** Plugins are loaded at session start. Claude Code: `/reload-plugins` or a new session. Codex: quit and start `codex` again.
- **Claude Code: installed into the wrong scope.** `--scope project` writes `.claude/settings.json` into the folder it was run from, so the plugin only loads inside that folder. If they ran the bootstrap script from a downloads folder, that's the bug. Check `claude plugin list`, then reinstall with `--scope user`.
- **The marketplace was never added.** `<name>@<marketplace>` only resolves if that marketplace is registered — check the `marketplace list` output.
  - Claude Code: `claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor` adds the marketplace and installs in one step (Claude Code 2.1.275+; on older versions run `claude plugin marketplace add killernay/cc-devenv-doctor` first, then `claude plugin install devenv-doctor@ngernthongdee`).
  - Codex: `codex plugin marketplace add killernay/cc-devenv-doctor`, then `codex plugin add devenv-doctor@ngernthongdee`.
- **Codex: wrong subcommand.** Codex installs with `codex plugin add`, not `install`. There is no scope flag; the enabled state lives in `~/.codex/config.toml` under `[plugins."<name>@<marketplace>"]` — `enabled = false` there switches it off.

## 4. Always close with

One summary line: "You're ready ✅" or, if not fully passing, how many checks remain and the right order to fix them in (runtimes first, then agent CLIs and login, then VS Code extensions, then Docker last since it's the slowest / may need a restart).

Don't teach git/Docker theory in this skill — stay focused on "what's broken, how to fix it," not concepts.
