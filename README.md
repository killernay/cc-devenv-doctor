# cc-devenv-doctor

One command to take a bare Windows or Mac machine to a working [Claude Code](https://claude.com/claude-code) or [Codex](https://developers.openai.com/codex/cli) setup — plus a plugin that keeps diagnosing it afterwards, from inside either agent.

> ภาษาไทย: [README.th.md](./README.th.md)

## Why this exists

This started at an **AI Agentic Engineering for IT** exam.

The material was not the hard part. Getting everyone's machine ready was. Installing git, then Node, then VS Code, then Docker, then the Claude Code CLI — one command at a time, across Windows and Mac at once, with PATH not refreshing, with installers that stop to ask a question nobody in the room knows how to answer. Hours went into that. Hours that were supposed to go into the actual subject.

The frustrating part is that none of it was interesting. It was the same handful of commands every time, in the same order, failing in the same few ways. That is exactly the kind of problem worth solving once and giving away, so nobody else has to spend their morning on it.

So: one script per OS, and a plugin that can tell you what's still broken afterwards.

## What it installs

- **Git**
- **Node.js** (LTS on Windows, Homebrew's `node` on macOS)
- **Claude Code CLI** and/or **Codex CLI** — your choice, both via their official native installers
- **[devenv-doctor](./devenv-doctor)** — the plugin bundled in this repo, installed into whichever agent you picked. It runs the real checks, then tells you exactly what to fix
- **Docker Desktop**, including WSL2 setup on Windows if it's missing
- **VS Code** + extensions: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) and/or [Codex](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt), plus [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers) for Docker
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — grilling, TDD, code review and more; from Anthropic's official marketplace for Claude Code, from Matt's own marketplace for Codex

## The last two are examples, not the point

The VS Code extensions and mattpocock-skills are here as **examples of what a ready machine looks like** — not as a claim that these are the right choices for you. The real point of the script is that once the base is working, adding the next skill or extension is a one-liner instead of an afternoon. They're in the list to show the shape of that, and to give someone brand new something that already works on day one.

Swap them for whatever you actually use. That's the intended way to fork this.

### On VS Code specifically

Straight answer: **I haven't opened VS Code since October 2025.** Not once.

It's in the script anyway, and I think that's the right call — if you're new, an editor that already has the agent's extension in it is the shortest path to something that works, and a much friendlier landing spot than a bare terminal.

But don't read its presence here as a recommendation from someone who uses it daily. If you already have an editor you like, delete that block from the script. Nothing else depends on it.

## Quick start

### If you have git

**Windows (PowerShell):**
```powershell
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**macOS:**
```bash
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
bash setup.sh
```

### If you don't have git yet

1. Go to [github.com/killernay/cc-devenv-doctor](https://github.com/killernay/cc-devenv-doctor), click **Code → Download ZIP**, and extract it
2. Open a terminal / PowerShell inside the extracted folder — GitHub names it **`cc-devenv-doctor-main`**, not `cc-devenv-doctor`
3. Run the same script as above — `bash setup.sh` (macOS) or `powershell -ExecutionPolicy Bypass -File setup.ps1` (Windows). The script installs git for you along the way.

The script is idempotent — safe to run more than once. It skips anything already installed and reports a pass/fail summary at the end. Anything that fails prints the exact command to retry it.

### Two questions the script asks you

1. **Which agent** — Claude Code, Codex, or both (press Enter for both). Everything agent-specific — CLI, VS Code extension, plugins — follows this answer.
2. **Where the Claude Code plugins should be enabled** (only asked if Claude Code is included):
   - **user** (recommended) — writes `~/.claude/settings.json`, so the plugins work in every project on this machine
   - **project** — writes `.claude/settings.json` into the folder you ran the script from, so the plugins only load while you're inside *that folder*

   Just press Enter to get `user`. Pick `project` only if you deliberately want the plugins scoped to one project — and note that if you ran the script from your downloads folder, `project` means "only in the downloads folder", which is almost certainly not what you want. Codex has no such choice: its plugins are always per user.

To skip both prompts, set the answers up front (`AGENTS` is `claude`, `codex` or `both`):

```bash
AGENTS=both PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:AGENTS="both"; $env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

### Just want the devenv-doctor plugin, not the full bootstrap?

Already have the agent **and git**? No clone, no ZIP, no `cd` — the marketplace commands do the clone for you.

**Claude Code** (2.1.275 or later — one command):

```
claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor
```

Then open `claude` and run `/devenv-doctor:environment-doctor`. It installs to **user** scope, so it works in every project on this machine. If a Claude Code session was already open while you installed, run `/reload-plugins` first.

**Codex:**

```
codex plugin marketplace add killernay/cc-devenv-doctor
codex plugin add devenv-doctor@ngernthongdee
```

Then start a new `codex` session and type `$environment-doctor`, or just ask "check my setup". Codex reads this repo's Claude-format marketplace as-is — there is no separate Codex manifest to keep in sync.

Both commands shell out to `git clone`, so git has to be installed — without it you get *"Failed to clone marketplace repository"*. No git yet? Run the setup script above instead; it installs git along the way.

### Removing it again

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```
```
codex plugin remove devenv-doctor@ngernthongdee
codex plugin marketplace remove ngernthongdee
```

Uninstall takes the full `name@marketplace` id — that's what `claude plugin list` / `codex plugin list` show. Removing the marketplace is the second, separate step; without it the marketplace stays registered with nothing installed from it.

#### ภาษาไทย

มี Claude Code หรือ Codex **กับ git** อยู่แล้ว อยากได้แค่ปลั๊กอิน ไม่ต้อง clone เอง ไม่ต้องโหลด ZIP ไม่ต้อง `cd` ไปไหน:

```
claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor
```

แล้วเปิด `claude` พิมพ์ `/devenv-doctor:environment-doctor` จบ (ต้องเป็น Claude Code 2.1.275 ขึ้นไป) — ติดตั้งเป็น scope **user** คือใช้ได้ทุกโปรเจกต์บนเครื่องนี้ ถ้ามีเซสชันเปิดค้างอยู่ตอนติดตั้ง ให้ `/reload-plugins` ก่อน

ฝั่ง Codex:

```
codex plugin marketplace add killernay/cc-devenv-doctor
codex plugin add devenv-doctor@ngernthongdee
```

แล้วเปิดเซสชัน `codex` ใหม่ พิมพ์ `$environment-doctor` หรือพิมพ์ว่า "check my setup" เฉย ๆ ก็ได้

ทั้งสองฝั่งเรียก `git clone` ข้างใน เครื่องต้องมี git ไม่งั้นขึ้น *"Failed to clone marketplace repository"* — ถ้ายังไม่มี git ให้รันสคริปต์ setup ด้านบนแทน มันลง git ให้ด้วย

ถอนออก:

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```
```
codex plugin remove devenv-doctor@ngernthongdee
codex plugin marketplace remove ngernthongdee
```

ต้องใส่ id เต็ม `name@marketplace` ตามที่ `claude plugin list` / `codex plugin list` แสดง และต้องลบ marketplace เป็นอีกขั้นแยกต่างหาก ไม่งั้น marketplace จะยังค้างอยู่ทั้งที่ไม่มีปลั๊กอินเหลือแล้ว

## What still needs a human

Three things genuinely can't be scripted, because they need you personally to prove who you are or to answer a question:

1. **Logging in** — run `claude` and/or `codex` after the script finishes; each opens your browser for you to sign in
2. **`npx claude-mem install`** (optional) — gives your agent memory that persists across sessions. It detects Claude Code and Codex, installs its own runtime (Bun, uv), and asks which memory provider to use. The pre-selected one (CMEM Pro) becomes paid after a 30-day trial — pick another in the prompt if you don't want that. Same category as the extensions above: an example of what you can bolt on once the base works
3. **A restart**, if the script had to install WSL2 on Windows for you (Docker Desktop needs it) — the script tells you clearly if this applies

On macOS the Claude Code installer puts `claude` in `~/.local/bin` but doesn't add that folder to your shell profile, so a new terminal would still say *command not found*. The script adds it to `~/.zprofile` (or `~/.bash_profile` for bash) once, so you don't have to.

## devenv-doctor

Once installed, run it from inside your agent — or just describe the problem ("my setup is broken", "why isn't docker working"), which fires the same skill:

- **Claude Code:** `/devenv-doctor:environment-doctor`. Every check is read-only and pre-approved, so it won't interrupt you with permission prompts. No response? The session was open before the plugin was installed — run `/reload-plugins`, or start a new session.
- **Codex:** `$environment-doctor`. Codex's sandbox can block a few checks (the Docker socket, for one); the skill knows to treat that as the sandbox rather than a broken machine, and asks to rerun that check with permission instead of reporting a false failure.

It runs the real checks — git, Node, the Claude Code and Codex CLIs including whether you're logged in (`claude doctor`, `codex doctor`), VS Code extensions, Docker, claude-mem, installed plugins — and gives you exact fix commands for whatever's missing, for your OS.

### What it looks like

On a machine where the setup script has already run, the report comes back like this:

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

Anything that isn't ✅ comes back with the exact command to fix it, for your OS.

It also knows the failures that look like success: a session started before the plugin was installed, a Claude Code plugin installed into the wrong scope, a plugin whose marketplace was never added, and `codex plugin install` (the Codex subcommand is `add`).

## Why not just `npm install -g @anthropic-ai/claude-code` (or `@openai/codex`)?

That installs the agent itself and leaves you to install git, Node, VS Code and Docker separately, and to work out the plugin syntax on your own — which is exactly where the morning goes.

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

## Contributing

Issues and PRs welcome — especially anything that removes a step a beginner currently has to do by hand.

## License

MIT — see [LICENSE](./LICENSE). Take it, fork it, swap the extension list for your own.
