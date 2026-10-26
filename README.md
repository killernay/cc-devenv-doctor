# cc-devenv-doctor

Get a Mac or Windows computer ready for **Claude Code** or **Codex** (AI coding assistants) by pasting one command — plus a built-in checkup that tells you what's still missing.

> ภาษาไทย: [README.th.md](./README.th.md)

No computer experience needed. Follow the steps below one at a time.

---

## Before you start

- **A computer:** Mac (macOS 13 or newer) or Windows 10 / 11, with at least 4 GB of RAM
- **Internet** — several programs get downloaded, some of them large (Docker especially), so this can take a while
- **Your computer's login password** — the Mac asks for it during setup; Windows shows a pop-up asking you to click "Yes"
- **An account** for at least one AI assistant:

| Assistant | Account you need |
|---|---|
| Claude Code | A paid Claude plan (Pro, Max, Team or Enterprise) — **the free Claude plan does not work** |
| Codex | Any ChatGPT plan, including the free one (the free plan has lower limits) |

Not sure which? Install both — that's what the script does by default.

---

## Install on a Mac

### Step 1 — Open the Terminal app

Press **⌘ Command + Space** together. A search box appears. Type `Terminal` and press **Enter**.

A window with text appears — this is where you type commands.

### Step 2 — Copy this command, paste it, press Enter

```bash
cd ~ && curl -fsSL -o cc.zip https://github.com/killernay/cc-devenv-doctor/archive/refs/heads/main.zip && unzip -oq cc.zip && rm cc.zip && cd cc-devenv-doctor-main && bash setup.sh
```

To paste in Terminal: press **⌘ Command + V**, then **Enter**.

### Step 3 — Answer the questions

- **"Which coding agent…"** — just press **Enter** (= install both Claude Code and Codex)
- **"Where should the Claude Code plugins be enabled?"** — just press **Enter**
- **"Password:"** — type your computer's login password and press **Enter**.
  **Nothing shows on screen while you type — no letters, no dots. That's normal.** Type it fully and press Enter.
- **"Press RETURN…"** — press **Enter**

Wait until you see **`=== Summary ===`**, then go to [Step 4](#step-4--read-the-result).

---

## Install on Windows

### Step 1 — Open PowerShell

Press the **Windows** key, type `PowerShell`, press **Enter**.
(You don't need "Run as administrator".)

### Step 2 — Copy this command, paste it, press Enter

```powershell
cd ~; Invoke-WebRequest https://github.com/killernay/cc-devenv-doctor/archive/refs/heads/main.zip -OutFile cc.zip; Expand-Archive cc.zip -DestinationPath . -Force; Remove-Item cc.zip; cd cc-devenv-doctor-main; powershell -ExecutionPolicy Bypass -File setup.ps1
```

To paste in PowerShell: **right-click** inside the window (or press **Ctrl + V**), then **Enter**.

### Step 3 — Answer the questions

- **"Which coding agent…"** — just press **Enter** (= install both Claude Code and Codex)
- **"Where should the Claude Code plugins be enabled?"** — just press **Enter**
- A pop-up asks **"Do you want to allow this app to make changes to your device?"** — click **Yes**
- If the script says you **must restart** (it installed WSL2 for Docker) — restart, then do Steps 1–2 again. The script skips whatever is already installed.

Wait until you see **`=== Summary ===`**.

---

## Step 4 — Read the result

At the end the script prints a list:

- **`[v]`** = installed fine
- **`[!]`** = not done yet; the text after it says what to do

A `[!]` is nothing to worry about. Most of them go away if you **close the window, open a new one, and paste the Step 2 command again** — the script can be run as many times as you like and skips whatever already worked.

The first time, Docker almost always shows `[!]` — open the **Docker Desktop** app once and wait 1–2 minutes until it's ready.

## Step 5 — Log in

**Close the Terminal / PowerShell window and open a new one first.** (Important — the old window can't see the programs that were just installed.)

Then type one of these and press Enter:

| Assistant | Type | What happens |
|---|---|---|
| Claude Code | `claude` | Your browser opens the Claude login page. Log in, then come back to the window. |
| Codex | `codex` | Choose **Sign in with ChatGPT** and log in in your browser. |

If it asks anything else (a colour theme, whether you trust this folder), press **Enter** to accept what's already selected.

To quit: press **Ctrl + C** twice.

## Step 6 — Let it check your computer

Once logged in, inside `claude` or `codex`, type:

| Assistant | Type |
|---|---|
| Claude Code | `/devenv-doctor:environment-doctor` |
| Codex | `$environment-doctor` |

Or just type `check my setup`. It checks everything and shows a ✅ / ❌ table. Anything missing comes with the exact command to paste for your computer.

In Codex it sometimes asks permission to run a check — allow it. Every check only reads information; none of them change anything.

All ✅ — **you're ready** 🎉

---

## Something went wrong

| What you see | What to do |
|---|---|
| `command not found: claude` or `'claude' is not recognized` (or `codex`) | Close the window and open a new one. Still failing? Paste the Step 2 command again. |
| Nothing appears when typing your password | Normal. Type it fully and press Enter. |
| Docker shows `[!]` | Open the Docker Desktop app once and wait 1–2 minutes. |
| Windows asks you to restart | Restart, then paste the Step 2 command again. |
| Windows says `winget not found` | Update Windows, or install **App Installer** from the Microsoft Store, then paste the command again. |
| Claude says you don't have access after logging in | The free Claude plan can't use Claude Code — you need Pro or higher. Or use Codex instead. |
| `/devenv-doctor:environment-doctor` does nothing | Quit (Ctrl + C twice) and start it again. |
| Mac: `VS Code` shows `[!]` | Open VS Code once, press ⌘ Command + Shift + P, type `Shell Command: Install 'code' command in PATH`, press Enter, then paste the command again. |

Still stuck? [Open an issue](https://github.com/killernay/cc-devenv-doctor/issues) and paste the `=== Summary ===` part.

### Don't delete the `cc-devenv-doctor-main` folder

The script puts it in your user folder (Mac: `/Users/yourname/cc-devenv-doctor-main`, Windows: `C:\Users\yourname\cc-devenv-doctor-main`). Claude Code reads the checkup straight from that folder — delete it and the checkup disappears from Claude Code.

### Getting a newer version

Paste the Step 2 command again. It downloads the latest version over the old one.

---

## For people comfortable with computers

### What it installs

- **Homebrew** (Mac), **Git**, **Node.js** (LTS on Windows, Homebrew's `node` on macOS)
- **Claude Code CLI** and/or **Codex CLI** — via their official native installers
- **[devenv-doctor](./devenv-doctor)** — the checkup plugin in this repo, installed into whichever agent you picked
- **Docker Desktop**, including WSL2 on Windows if it's missing
- **VS Code** + extensions: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) / [Codex](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt) and [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers)
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — grilling, TDD, code review and more
- On macOS: adds `~/.local/bin` to `~/.zprofile` (or `~/.bash_profile`) once, because the Claude Code installer doesn't

The VS Code extensions and mattpocock-skills are **examples** of what a ready machine looks like, not recommendations. Swap them for whatever you actually use — that's the intended way to fork this. (On VS Code: I haven't opened it since October 2025, but for a beginner an editor with the agent's extension already in it is a friendlier landing spot than a bare terminal. If you have an editor you like, delete that block from the script; nothing else depends on it.)

### Skip the questions with variables

| Variable | Values | Effect |
|---|---|---|
| `AGENTS` | `claude` / `codex` / `both` | Which agent(s) to set up (default `both`) |
| `PLUGIN_SCOPE` | `user` / `project` / `local` | Where Claude Code plugins work (default `user`) |

```bash
AGENTS=both PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:AGENTS="both"; $env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

`user` writes `~/.claude/settings.json`, so plugins work in every project. `project` writes `.claude/settings.json` into the folder you ran the script from, so plugins only load inside that folder — run from a downloads folder, that means "only in the downloads folder", which is almost never what you want. Codex has no such setting; its plugins are always per user.

### Using git clone instead of the ZIP

```bash
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
bash setup.sh                                          # macOS
powershell -ExecutionPolicy Bypass -File setup.ps1     # Windows
```

### Just the devenv-doctor plugin

Already have the agent **and git**? No clone needed — the marketplace commands do it.

```
# Claude Code (2.1.275 or later)
claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor

# Codex
codex plugin marketplace add killernay/cc-devenv-doctor
codex plugin add devenv-doctor@ngernthongdee
```

If a session was already open: `/reload-plugins` in Claude Code; start a new session in Codex. Without git you get *"Failed to clone marketplace repository"* — use the setup script instead; it installs git.

### Installing by hand (no script)

Order matters: git before any plugin (marketplaces are cloned with git), Node before claude-mem.

| # | What | macOS | Windows (PowerShell) |
|---|---|---|---|
| 1 | Homebrew (Mac only) | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` | — |
| 2 | Git | `brew install git` | `winget install --id Git.Git -e` |
| 3 | Node.js ≥ 20 | `brew install node` | `winget install --id OpenJS.NodeJS.LTS -e` |
| 4a | Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` | `irm https://claude.ai/install.ps1 \| iex` |
| 4b | Codex | `curl -fsSL https://chatgpt.com/codex/install.sh \| sh` | `irm https://chatgpt.com/codex/install.ps1 \| iex` |
| 5 | Docker Desktop (macOS 14+) | `brew install --cask docker-desktop` | `wsl --install --no-distribution`, restart, then `winget install --id Docker.DockerDesktop -e` |
| 6 | VS Code (optional) | `brew install --cask visual-studio-code` | `winget install --id Microsoft.VisualStudioCode -e` |

- **macOS:** the Claude Code installer leaves `~/.local/bin` off your PATH: `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile`
- **Windows:** install Git before Claude Code — Claude Code uses Git Bash as its shell and falls back to PowerShell without it.
- Open a new terminal after each install, and open the Docker app once so the engine starts.

Then: log in (`claude` / `codex`) → [install devenv-doctor](#just-the-devenv-doctor-plugin) → extras:

- VS Code extensions: `code --install-extension anthropic.claude-code` / `openai.chatgpt` / `ms-azuretools.vscode-containers`
- mattpocock-skills: Claude Code `claude plugin marketplace add anthropics/claude-plugins-official` then `claude plugin install mattpocock-skills@claude-plugins-official`; Codex `codex plugin marketplace add mattpocock/skills` then `codex plugin add mattpocock-skills@mattpocock`
- Check: `claude doctor` / `codex doctor --summary`, then run devenv-doctor inside the agent

### Memory across sessions (claude-mem, optional)

```
npx claude-mem install
```

Run it after logging in. It detects Claude Code and Codex and installs Bun and uv itself. Needs Node ≥ 20 and, for Claude Code, 2.1.139 or later. The memory provider it pre-selects (CMEM Pro) **becomes paid after a 30-day trial** — pick another one in the prompt if you don't want that.

### Removing it

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```
```
codex plugin remove devenv-doctor@ngernthongdee
codex plugin marketplace remove ngernthongdee
```

Use the full `name@marketplace` id that `claude plugin list` / `codex plugin list` shows, and remove the marketplace as a separate step.

### What devenv-doctor checks

git, Node, the Claude Code and Codex CLIs including whether you're logged in (`claude doctor`, `codex doctor`), VS Code extensions, Docker (installed and engine running), claude-mem, installed plugins — then exact fix commands for your OS.

- **Claude Code:** every check is read-only and pre-approved, so there are no permission prompts.
- **Codex:** Codex's sandbox can block a few checks (the Docker socket, for one). The skill treats that as the sandbox rather than a broken machine, and asks to rerun the check with permission instead of reporting a false failure.

Example on a machine where the script has run:

| Check | Status | Detail |
|---|---|---|
| git | ✅ | 2.55.0 |
| Node.js | ✅ | v26.12.1 (≥20) |
| VS Code | ✅ | 1.143.1 |
| Docker | ✅ | 29.9.2, engine running |
| Claude Code CLI | ✅ | 2.1.310 native, signed in |
| Codex CLI | ✅ | 0.163.0, auth configured |
| Claude / Codex plugins | ✅ | devenv-doctor enabled in both |
| claude-mem | ✅ | `~/.claude-mem` present, launcher on PATH, Bun 1.3.10 |
| anthropic.claude-code | ✅ | |
| openai.chatgpt | ✅ | |
| ms-azuretools.vscode-containers | ✅ | |

It also knows the failures that look like success: a session started before the plugin was installed, a Claude Code plugin in the wrong scope, a plugin whose marketplace was never added, and `codex plugin install` (the Codex subcommand is `add`).

---

## Why this exists

This started at an **AI Agentic Engineering for IT** exam.

The material was not the hard part. Getting everyone's machine ready was. Installing git, then Node, then VS Code, then Docker, then the Claude Code CLI — one command at a time, across Windows and Mac at once, with PATH not refreshing, with installers that stop to ask a question nobody in the room knows how to answer. Hours went into that. Hours that were supposed to go into the actual subject.

The frustrating part is that none of it was interesting. It was the same handful of commands every time, in the same order, failing in the same few ways. That is exactly the kind of problem worth solving once and giving away, so nobody else has to spend their morning on it.

So: one script per OS, and a plugin that can tell you what's still broken afterwards.

Why not just `npm install -g @anthropic-ai/claude-code` (or `@openai/codex`)? That installs the agent itself and leaves you to install git, Node, VS Code and Docker separately, and to work out the plugin syntax on your own — which is exactly where the morning goes.

## Development

macOS ships **bash 3.2**, and a bare machine has no newer one on `PATH` — which is precisely the machine `setup.sh` targets. Keep it bash-3.2 compatible: no negative array indices (`${arr[-1]}`), no associative arrays, and never expand `"${arr[@]}"` without a length check while `set -u` is on. `bash -n` will not catch any of these; they fail only at runtime.

In PowerShell, native commands (`winget`, `claude`, `codex`, `code`) don't raise terminating errors, so `try`/`catch` around them never fires. Test `$LASTEXITCODE` instead.

There is one plugin manifest set, in Claude Code's format (`.claude-plugin/`). Codex reads it as-is, so don't add a `.codex-plugin/` copy unless you need Codex-only metadata. The skill's frontmatter `description` carries the trigger phrases, because Codex reads only `name` and `description`.

Validate the plugin manifests before pushing:

```bash
claude plugin validate . --strict
claude plugin validate ./devenv-doctor --strict
```

And check Codex still sees the plugin, without touching your own Codex config:

```bash
CODEX_HOME=$(mktemp -d) sh -c 'codex plugin marketplace add "$PWD" && codex plugin list -m ngernthongdee'
```

Issues and PRs welcome — especially anything that removes a step a beginner currently has to do by hand.

## License

MIT — see [LICENSE](./LICENSE). Take it, fork it, swap the extension list for your own.
