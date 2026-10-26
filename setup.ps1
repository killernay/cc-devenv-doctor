# ===================================================================
# cc-devenv-doctor — Windows setup
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1
#        $env:AGENTS="both"; $env:PLUGIN_SCOPE="user"; ... -File setup.ps1   # skip both prompts
#        AGENTS = claude | codex | both
# Safe to re-run (idempotent) — skips anything already installed.
#
# NOTE: native commands (winget, claude, codex, code) do NOT raise terminating
# errors, so try/catch never fires for them. Always test $LASTEXITCODE.
# ===================================================================

$ErrorActionPreference = "Continue"
$script:results = @()

function Test-Cmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

function Report($step, $ok, $note = "") {
  $mark = if ($ok) { "OK" } else { "FAIL" }
  $script:results += "$mark|$step|$note"
  Write-Host "[$mark] $step $note"
}

function Refresh-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

Write-Host "=== cc-devenv-doctor — Windows setup ===`n"

# --- Which coding agent(s) to set up ---
$agents = $env:AGENTS
if (-not $agents) {
  $agents = "both"
  if (-not [Console]::IsInputRedirected) {
    Write-Host "Which coding agent should this machine be ready for?"
    Write-Host "  1) both Claude Code and Codex   [recommended]"
    Write-Host "  2) Claude Code only"
    Write-Host "  3) Codex only"
    $agentChoice = Read-Host "Choose 1, 2 or 3 [1]"
    if ($agentChoice -eq "2") { $agents = "claude" } elseif ($agentChoice -eq "3") { $agents = "codex" }
  }
}
if ($agents -notin @("claude", "codex", "both")) {
  Write-Host "Unknown AGENTS '$agents' — using 'both' instead"
  $agents = "both"
}
$wantClaude = $agents -ne "codex"
$wantCodex = $agents -ne "claude"
Write-Host "Agents: $agents`n"

# --- Claude Code plugin scope — your choice, because it decides where plugins work ---
# 'project' writes .claude\settings.json into the CURRENT folder, so the
# plugins only load while you're inside it. For a bootstrap run that folder
# is usually this download, which is not where you'll actually be working.
# (Codex has no plugin scope — its plugins are always enabled per user.)
$pluginScope = $env:PLUGIN_SCOPE
if ($wantClaude) {
  if (-not $pluginScope) {
    if (-not [Console]::IsInputRedirected) {
      Write-Host "Where should the Claude Code plugins be enabled?"
      Write-Host "  1) user    - every project on this machine (~\.claude\settings.json)   [recommended]"
      Write-Host "  2) project - only this folder ($PWD\.claude\settings.json)"
      $scopeChoice = Read-Host "Choose 1 or 2 [1]"
      if ($scopeChoice -eq "2") { $pluginScope = "project" } else { $pluginScope = "user" }
    } else {
      $pluginScope = "user"
    }
  }
  if ($pluginScope -notin @("user", "project", "local")) {
    Write-Host "Unknown PLUGIN_SCOPE '$pluginScope' — using 'user' instead"
    $pluginScope = "user"
  }
  Write-Host "Claude Code plugin scope: $pluginScope`n"
}

# --- winget ---
if (-not (Test-Cmd "winget")) {
  Report "winget" $false "winget not found — update Windows or install 'App Installer' from the Microsoft Store, then re-run this script"
  Write-Host "`nStopping here — the next steps need winget"
  exit 1
} else {
  Report "winget" $true
}

# --- Git (Claude Code uses Git Bash for its Bash tool) ---
if (Test-Cmd "git") {
  Report "Git" $true
} else {
  winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "Git" (Test-Cmd "git")
}

# --- Node.js LTS (needed to run npx claude-mem install later) ---
if (Test-Cmd "node") {
  Report "Node.js" $true
} else {
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "Node.js" (Test-Cmd "node")
}

# --- VS Code ---
if (Test-Cmd "code") {
  Report "VS Code" $true
} else {
  winget install --id Microsoft.VisualStudioCode -e --source winget --accept-source-agreements --accept-package-agreements
  Refresh-Path
  Report "VS Code" (Test-Cmd "code") "If 'code' still isn't found, close and reopen PowerShell then re-run this script"
}

# --- VS Code extensions ---
if (Test-Cmd "code") {
  $exts = @("ms-azuretools.vscode-containers")
  $names = @("Container Tools")
  if ($wantClaude) { $exts += "anthropic.claude-code"; $names += "Claude Code" }
  if ($wantCodex) { $exts += "openai.chatgpt"; $names += "Codex" }
  $extOk = $true
  foreach ($e in $exts) {
    code --install-extension $e --force | Out-Null
    if ($LASTEXITCODE -ne 0) { $extOk = $false }
  }
  Report "VS Code extensions" $extOk "($($names -join ', '))"
} else {
  Report "VS Code extensions" $false "skipped — 'code' not found in this terminal"
}

# --- Claude Code CLI (native installer) ---
if ($wantClaude) {
  if (Test-Cmd "claude") {
    Report "Claude Code CLI" $true
  } else {
    irm https://claude.ai/install.ps1 | iex
    Refresh-Path
    # The installer may only print a "not in your PATH" hint — persist it so a new window finds claude.
    $localBin = "$env:USERPROFILE\.local\bin"
    if (-not (Test-Cmd "claude") -and (Test-Path "$localBin\claude.exe")) {
      $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
      if (-not $userPath) { $userPath = "" }
      if (($userPath -split ";") -notcontains $localBin) {
        [System.Environment]::SetEnvironmentVariable("Path", (@($localBin, $userPath) -join ";").TrimEnd(";"), "User")
      }
      Refresh-Path
    }
    Report "Claude Code CLI" (Test-Cmd "claude") "If still not found, close/reopen PowerShell and re-run this script (PATH not refreshed is the #1 cause)"
  }
}

# --- Codex CLI (native installer) ---
if ($wantCodex) {
  if (Test-Cmd "codex") {
    Report "Codex CLI" $true
  } else {
    irm https://chatgpt.com/codex/install.ps1 | iex
    Refresh-Path
    Report "Codex CLI" (Test-Cmd "codex") "If still not found, close/reopen PowerShell and re-run this script (PATH not refreshed is the #1 cause)"
  }
}

# --- devenv-doctor plugin (ships as part of this repo — no download needed) ---
$marketplaceManifest = Join-Path $PSScriptRoot ".claude-plugin\marketplace.json"
if (Test-Path $marketplaceManifest) {
  if ($wantClaude) {
    if (-not (Test-Cmd "claude")) {
      Report "devenv-doctor (Claude Code)" $false "skipped — Claude Code CLI not found"
    } else {
      # Two steps rather than `install --marketplace`, which needs Claude Code 2.1.275+.
      # 'marketplace add' is non-fatal on re-runs — it may already be registered.
      claude plugin marketplace add $PSScriptRoot 2>&1 | Out-Null
      claude plugin install devenv-doctor@ngernthongdee --scope $pluginScope 2>&1 | Out-Null
      if ($LASTEXITCODE -eq 0) {
        Report "devenv-doctor (Claude Code)" $true "(scope: $pluginScope)"
      } else {
        Report "devenv-doctor (Claude Code)" $false "install failed — run: claude plugin marketplace add `"$PSScriptRoot`"; claude plugin install devenv-doctor@ngernthongdee --scope $pluginScope"
      }
    }
  }
  if ($wantCodex) {
    # Codex reads this repo's .claude-plugin\marketplace.json as-is.
    if (-not (Test-Cmd "codex")) {
      Report "devenv-doctor (Codex)" $false "skipped — Codex CLI not found"
    } else {
      codex plugin marketplace add $PSScriptRoot 2>&1 | Out-Null
      if ($LASTEXITCODE -eq 0) { codex plugin add devenv-doctor@ngernthongdee 2>&1 | Out-Null }
      if ($LASTEXITCODE -eq 0) {
        Report "devenv-doctor (Codex)" $true
      } else {
        Report "devenv-doctor (Codex)" $false "install failed — run: codex plugin marketplace add `"$PSScriptRoot`"; codex plugin add devenv-doctor@ngernthongdee"
      }
    }
  }
} else {
  Report "devenv-doctor plugin" $false ".claude-plugin\marketplace.json not found next to this script — make sure you cloned/downloaded the full repo"
}

# --- Optional: mattpocock-skills (grilling, tdd, code-review) ---
if ($wantClaude) {
  if (-not (Test-Cmd "claude")) {
    Report "mattpocock-skills (Claude Code, optional)" $false "skipped — Claude Code CLI not found"
  } else {
    claude plugin marketplace add anthropics/claude-plugins-official 2>&1 | Out-Null
    claude plugin install mattpocock-skills@claude-plugins-official --scope $pluginScope 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Report "mattpocock-skills (Claude Code, optional)" $true "(scope: $pluginScope)"
    } else {
      Report "mattpocock-skills (Claude Code, optional)" $false "install failed — run: claude plugin marketplace add anthropics/claude-plugins-official; claude plugin install mattpocock-skills@claude-plugins-official"
    }
  }
}
if ($wantCodex) {
  if (-not (Test-Cmd "codex")) {
    Report "mattpocock-skills (Codex, optional)" $false "skipped — Codex CLI not found"
  } else {
    codex plugin marketplace add mattpocock/skills 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { codex plugin add mattpocock-skills@mattpocock 2>&1 | Out-Null }
    if ($LASTEXITCODE -eq 0) {
      Report "mattpocock-skills (Codex, optional)" $true
    } else {
      Report "mattpocock-skills (Codex, optional)" $false "install failed — run: codex plugin marketplace add mattpocock/skills; codex plugin add mattpocock-skills@mattpocock"
    }
  }
}

# --- WSL2 (required for Docker Desktop on Windows — check/install before Docker) ---
$needsRestart = $false
$wslOk = $false
wsl --status *> $null
if ($LASTEXITCODE -eq 0) { $wslOk = $true }

if ($wslOk) {
  Report "WSL2" $true
} else {
  Write-Host "WSL2 not found — installing (required for Docker Desktop on Windows)..."
  wsl --install --no-distribution
  $needsRestart = $true
  Report "WSL2" $false "installed, but you must restart your PC once before Docker's engine will start — restart, then re-run this script"
}

# --- Docker Desktop ---
if (Test-Cmd "docker") {
  Report "Docker" $true
} else {
  winget install --id Docker.DockerDesktop -e --source winget --accept-source-agreements --accept-package-agreements
  Start-Process "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe" -ErrorAction SilentlyContinue
  if ($needsRestart) {
    Report "Docker" $false "installed — restart your PC (needed because WSL2 was just installed above), then open Docker Desktop once"
  } else {
    Report "Docker" $false "installed — open Docker Desktop once to start the engine (takes 1-2 minutes)"
  }
}

Write-Host "`n=== Summary ==="
foreach ($r in $script:results) {
  $parts = $r.Split("|")
  $icon = if ($parts[0] -eq "OK") { "[v]" } else { "[!]" }
  Write-Host "$icon $($parts[1]) $($parts[2])"
}

Write-Host "`n=== What's left that truly can't be automated ==="
Write-Host "1) Open a new PowerShell window (important if anything was installed for the first time) and log in — it opens your browser:"
if ($wantClaude) { Write-Host "     claude   -> sign in with your Claude account" }
if ($wantCodex) { Write-Host "     codex    -> choose 'Sign in with ChatGPT'" }
Write-Host "2) Optional, after logging in: npx claude-mem install   -> memory across sessions; it detects Claude Code and Codex and installs its own runtime (Bun, uv)."
Write-Host "   The provider it pre-selects (CMEM Pro) becomes paid after a 30-day trial — pick another provider in the prompt if you don't want that."
Write-Host "`nAnything marked [!] above prints the exact command to retry, or just re-run this script — it skips what already succeeded."
Write-Host "Then check the whole setup from inside your agent:"
if ($wantClaude) { Write-Host "  Claude Code: /devenv-doctor:environment-doctor   (if a session was already open during this script, run /reload-plugins first)" }
if ($wantCodex) { Write-Host "  Codex:       `$environment-doctor  or just ask `"check my setup`"   (start a new codex session if one was already open)" }
