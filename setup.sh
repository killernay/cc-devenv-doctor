#!/usr/bin/env bash
# ===================================================================
# cc-devenv-doctor — macOS setup
# Usage: bash setup.sh
#        AGENTS=both PLUGIN_SCOPE=user bash setup.sh   # skip both prompts
#        AGENTS=claude | codex | both
# Safe to re-run (idempotent) — skips anything already installed.
#
# COMPATIBILITY: macOS ships bash 3.2, and a bare machine has no newer
# one on PATH yet — which is exactly the machine this script targets.
# Keep it bash-3.2 compatible:
#   - no negative array indices   ${arr[-1]}
#   - no associative arrays       declare -A
#   - never expand "${arr[@]}" without a length check while `set -u` is on
# `bash -n` does NOT catch these; they only fail at runtime.
# ===================================================================
set -uo pipefail

RESULTS=()
has() { command -v "$1" >/dev/null 2>&1; }
report() {
  local step="$1" ok="$2" note="${3:-}" line
  if [ "$ok" = "1" ]; then
    line="[v] $step $note"
  else
    line="[!] $step $note"
  fi
  RESULTS+=("$line")
  echo "$line"
}

echo "=== cc-devenv-doctor — macOS setup ==="
echo ""

# --- Which coding agent(s) to set up ---
AGENTS="${AGENTS:-}"
if [ -z "$AGENTS" ]; then
  agent_choice=""
  if [ -t 0 ]; then
    echo "Which coding agent should this machine be ready for?"
    echo "  1) both Claude Code and Codex   [recommended]"
    echo "  2) Claude Code only"
    echo "  3) Codex only"
    printf "Choose 1, 2 or 3 [1]: "
    read -r agent_choice
  fi
  case "$agent_choice" in
    2) AGENTS="claude" ;;
    3) AGENTS="codex" ;;
    *) AGENTS="both" ;;
  esac
fi
case "$AGENTS" in
  claude|codex|both) ;;
  *) echo "Unknown AGENTS '$AGENTS' — using 'both' instead"; AGENTS="both" ;;
esac
WANT_CLAUDE=0
WANT_CODEX=0
[ "$AGENTS" != "codex" ] && WANT_CLAUDE=1
[ "$AGENTS" != "claude" ] && WANT_CODEX=1
echo "Agents: $AGENTS"
echo ""

# --- Claude Code plugin scope — your choice, because it decides where plugins work ---
# 'project' writes .claude/settings.json into the CURRENT folder, so the
# plugins only load while you're inside it. For a bootstrap run that folder
# is usually this download, which is not where you'll actually be working.
# (Codex has no plugin scope — its plugins are always enabled per user.)
PLUGIN_SCOPE="${PLUGIN_SCOPE:-}"
if [ "$WANT_CLAUDE" = "1" ]; then
  if [ -z "$PLUGIN_SCOPE" ]; then
    scope_choice=""
    if [ -t 0 ]; then
      echo "Where should the Claude Code plugins be enabled?"
      echo "  1) user    - every project on this machine (~/.claude/settings.json)   [recommended]"
      echo "  2) project - only this folder ($PWD/.claude/settings.json)"
      printf "Choose 1 or 2 [1]: "
      read -r scope_choice
    fi
    case "$scope_choice" in
      2) PLUGIN_SCOPE="project" ;;
      *) PLUGIN_SCOPE="user" ;;
    esac
  fi
  case "$PLUGIN_SCOPE" in
    user|project|local) ;;
    *) echo "Unknown PLUGIN_SCOPE '$PLUGIN_SCOPE' — using 'user' instead"; PLUGIN_SCOPE="user" ;;
  esac
  echo "Claude Code plugin scope: $PLUGIN_SCOPE"
  echo ""
fi

# --- ~/.local/bin on PATH ---
# Both native installers (claude, codex) put their binary there. Claude's does
# not add it to your shell profile, so without this a new terminal still says
# "command not found: claude". Persist it once, and use it for this run too.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *)
    export PATH="$HOME/.local/bin:$PATH"
    profile="$HOME/.zprofile"
    case "${SHELL:-}" in */bash) profile="$HOME/.bash_profile" ;; esac
    if ! grep -qsF '.local/bin' "$profile"; then
      printf '\n# added by cc-devenv-doctor: claude and codex install here\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$profile"
    fi
    ;;
esac

# --- Homebrew ---
if ! has brew; then
  echo "Homebrew not found — installing (will ask for your password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
report "Homebrew" "$(has brew && echo 1 || echo 0)"

# --- Git ---
if has git; then
  report "Git" 1
else
  brew install git
  report "Git" "$(has git && echo 1 || echo 0)"
fi

# --- Node.js (needed to run npx claude-mem install later) ---
if has node; then
  report "Node.js" 1
else
  brew install node
  report "Node.js" "$(has node && echo 1 || echo 0)"
fi

# --- VS Code ---
if has code; then
  report "VS Code" 1
else
  brew install --cask visual-studio-code
  report "VS Code" "$(has code && echo 1 || echo 0)" "if 'code' still isn't found: open VS Code once, then Cmd+Shift+P > 'Shell Command: Install code command in PATH'"
fi

# --- VS Code extensions ---
if has code; then
  exts="ms-azuretools.vscode-containers"
  names="Container Tools"
  [ "$WANT_CLAUDE" = "1" ] && exts="$exts anthropic.claude-code" && names="$names, Claude Code"
  [ "$WANT_CODEX" = "1" ] && exts="$exts openai.chatgpt" && names="$names, Codex"
  ext_ok=1
  for ext in $exts; do
    code --install-extension "$ext" --force >/dev/null 2>&1 || ext_ok=0
  done
  report "VS Code extensions" "$ext_ok" "($names)"
else
  report "VS Code extensions" 0 "skipped — 'code' not found"
fi

# --- Claude Code CLI (native installer) ---
if [ "$WANT_CLAUDE" = "1" ]; then
  if has claude; then
    report "Claude Code CLI" 1
  else
    curl -fsSL https://claude.ai/install.sh | bash
    report "Claude Code CLI" "$(has claude && echo 1 || echo 0)" "if still not found, open a new terminal and re-run this script"
  fi
fi

# --- Codex CLI (native installer) ---
if [ "$WANT_CODEX" = "1" ]; then
  if has codex; then
    report "Codex CLI" 1
  else
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
    report "Codex CLI" "$(has codex && echo 1 || echo 0)" "if still not found, open a new terminal and re-run this script"
  fi
fi

# --- devenv-doctor plugin (ships as part of this repo — no download needed) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.claude-plugin/marketplace.json" ]; then
  if [ "$WANT_CLAUDE" = "1" ]; then
    if ! has claude; then
      report "devenv-doctor (Claude Code)" 0 "skipped — Claude Code CLI not found"
    else
      # Two steps rather than `install --marketplace`, which needs Claude Code 2.1.275+.
      # 'marketplace add' is non-fatal on re-runs — it may already be registered.
      claude plugin marketplace add "$SCRIPT_DIR" >/dev/null 2>&1 || true
      if claude plugin install devenv-doctor@ngernthongdee --scope "$PLUGIN_SCOPE" >/dev/null 2>&1; then
        report "devenv-doctor (Claude Code)" 1 "(scope: $PLUGIN_SCOPE)"
      else
        report "devenv-doctor (Claude Code)" 0 "install failed — run: claude plugin marketplace add \"$SCRIPT_DIR\" && claude plugin install devenv-doctor@ngernthongdee --scope $PLUGIN_SCOPE"
      fi
    fi
  fi
  if [ "$WANT_CODEX" = "1" ]; then
    # Codex reads this repo's .claude-plugin/marketplace.json as-is.
    if ! has codex; then
      report "devenv-doctor (Codex)" 0 "skipped — Codex CLI not found"
    elif codex plugin marketplace add "$SCRIPT_DIR" >/dev/null 2>&1 \
      && codex plugin add devenv-doctor@ngernthongdee >/dev/null 2>&1; then
      report "devenv-doctor (Codex)" 1
    else
      report "devenv-doctor (Codex)" 0 "install failed — run: codex plugin marketplace add \"$SCRIPT_DIR\" && codex plugin add devenv-doctor@ngernthongdee"
    fi
  fi
else
  report "devenv-doctor plugin" 0 ".claude-plugin/marketplace.json not found next to this script — make sure you cloned/downloaded the full repo"
fi

# --- Optional: mattpocock-skills (grilling, tdd, code-review) ---
if [ "$WANT_CLAUDE" = "1" ]; then
  if ! has claude; then
    report "mattpocock-skills (Claude Code, optional)" 0 "skipped — Claude Code CLI not found"
  else
    claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
    if claude plugin install mattpocock-skills@claude-plugins-official --scope "$PLUGIN_SCOPE" >/dev/null 2>&1; then
      report "mattpocock-skills (Claude Code, optional)" 1 "(scope: $PLUGIN_SCOPE)"
    else
      report "mattpocock-skills (Claude Code, optional)" 0 "install failed — run: claude plugin marketplace add anthropics/claude-plugins-official && claude plugin install mattpocock-skills@claude-plugins-official"
    fi
  fi
fi
if [ "$WANT_CODEX" = "1" ]; then
  if ! has codex; then
    report "mattpocock-skills (Codex, optional)" 0 "skipped — Codex CLI not found"
  elif codex plugin marketplace add mattpocock/skills >/dev/null 2>&1 \
    && codex plugin add mattpocock-skills@mattpocock >/dev/null 2>&1; then
    report "mattpocock-skills (Codex, optional)" 1
  else
    report "mattpocock-skills (Codex, optional)" 0 "install failed — run: codex plugin marketplace add mattpocock/skills && codex plugin add mattpocock-skills@mattpocock"
  fi
fi

# --- Docker Desktop ---
if has docker; then
  report "Docker" 1
else
  brew install --cask docker-desktop
  report "Docker" 0 "installed — open Docker.app once to start the engine (macOS may ask for a Privacy/Security permission the first time)"
fi

echo ""
echo "=== Summary ==="
if [ ${#RESULTS[@]} -gt 0 ]; then
  for r in "${RESULTS[@]}"; do echo "$r"; done
fi

echo ""
echo "=== What's left that truly can't be automated ==="
echo "1) Open a new terminal (important if anything was installed for the first time) and log in — it opens your browser:"
[ "$WANT_CLAUDE" = "1" ] && echo "     claude   -> sign in with your Claude account"
[ "$WANT_CODEX" = "1" ] && echo "     codex    -> choose 'Sign in with ChatGPT'"
echo "2) Optional, after logging in: npx claude-mem install   -> memory across sessions; it detects Claude Code and Codex and installs its own runtime (Bun, uv)."
echo "   The provider it pre-selects (CMEM Pro) becomes paid after a 30-day trial — pick another provider in the prompt if you don't want that."
echo ""
echo "Anything marked [!] above prints the exact command to retry, or just re-run this script — it skips what already succeeded."
echo "Then check the whole setup from inside your agent:"
[ "$WANT_CLAUDE" = "1" ] && echo "  Claude Code: /devenv-doctor:environment-doctor   (if a session was already open during this script, run /reload-plugins first)"
[ "$WANT_CODEX" = "1" ] && echo "  Codex:       \$environment-doctor  or just ask \"check my setup\"   (start a new codex session if one was already open)"
exit 0
