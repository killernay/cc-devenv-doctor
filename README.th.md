# cc-devenv-doctor

ทำให้คอมพิวเตอร์ Mac หรือ Windows พร้อมใช้ **Claude Code** หรือ **Codex** (ผู้ช่วยเขียนโปรแกรมด้วย AI) ด้วยการวางคำสั่งเดียว — แล้วยังมีตัวช่วยตรวจว่าเครื่องยังขาดอะไรอยู่

> English version: [README.md](./README.md)

ไม่ต้องรู้เรื่องคอมพิวเตอร์มาก่อน ทำตามทีละขั้นด้านล่างได้เลย

---

## ก่อนเริ่ม ต้องมีอะไรบ้าง

- **คอมพิวเตอร์** Mac (macOS 13 ขึ้นไป) หรือ Windows 10 / 11 และ RAM อย่างน้อย 4 GB
- **อินเทอร์เน็ต** — ต้องดาวน์โหลดโปรแกรมหลายตัว บางตัวไฟล์ใหญ่ (โดยเฉพาะ Docker) อาจใช้เวลานาน
- **รหัสผ่านที่ใช้เข้าเครื่อง** — บน Mac จะถามระหว่างติดตั้ง บน Windows จะมีหน้าต่างเด้งถามให้กด "Yes"
- **บัญชีผู้ใช้** ของ AI อย่างน้อยหนึ่งตัว:

| ใช้ตัวไหน | ต้องมีบัญชีอะไร |
|---|---|
| Claude Code | Claude แบบเสียเงิน (Pro, Max, Team หรือ Enterprise) — **บัญชี Claude ฟรีใช้ไม่ได้** |
| Codex | ChatGPT แผนไหนก็ได้ รวมแผนฟรี (แผนฟรีใช้ได้น้อยกว่า) |

ไม่แน่ใจว่าจะใช้ตัวไหน? ติดตั้งทั้งคู่ไว้ก่อนได้ สคริปต์ตั้งค่าเริ่มต้นไว้แบบนั้นอยู่แล้ว

---

## วิธีติดตั้งบน Mac

### ขั้นที่ 1 — เปิดโปรแกรม Terminal

กดปุ่ม **⌘ Command + Space** พร้อมกัน จะมีช่องค้นหาขึ้นมา พิมพ์ว่า `Terminal` แล้วกด **Enter**

จะได้หน้าต่างสีขาวหรือดำที่มีตัวหนังสือ — นี่คือที่สำหรับพิมพ์คำสั่ง

### ขั้นที่ 2 — คัดลอกคำสั่งนี้ไปวาง แล้วกด Enter

```bash
cd ~ && curl -fsSL -o cc.zip https://github.com/killernay/cc-devenv-doctor/archive/refs/heads/main.zip && unzip -oq cc.zip && rm cc.zip && cd cc-devenv-doctor-main && bash setup.sh
```

วิธีวางใน Terminal: กด **⌘ Command + V** แล้วกด **Enter**

### ขั้นที่ 3 — ตอบคำถาม

- **"Which coding agent…"** — กด **Enter** เฉย ๆ (= ลงทั้ง Claude Code และ Codex)
- **"Where should the Claude Code plugins be enabled?"** — กด **Enter** เฉย ๆ
- **"Password:"** — พิมพ์รหัสผ่านที่ใช้เข้าเครื่อง แล้วกด **Enter**
  **ตอนพิมพ์รหัสผ่านจะไม่มีตัวอักษรหรือจุดขึ้นบนจอเลย เป็นเรื่องปกติ** พิมพ์ให้ครบแล้วกด Enter
- **"Press RETURN…"** — กด **Enter**

จากนั้นรอจนขึ้นคำว่า **`=== Summary ===`** แล้วไปที่[ขั้นที่ 4](#ขั้นที่-4--ดูผล)

---

## วิธีติดตั้งบน Windows

### ขั้นที่ 1 — เปิดโปรแกรม PowerShell

กดปุ่ม **Windows** บนคีย์บอร์ด พิมพ์ว่า `PowerShell` แล้วกด **Enter**
(ไม่ต้องเลือก "Run as administrator")

### ขั้นที่ 2 — คัดลอกคำสั่งนี้ไปวาง แล้วกด Enter

```powershell
cd ~; Invoke-WebRequest https://github.com/killernay/cc-devenv-doctor/archive/refs/heads/main.zip -OutFile cc.zip; Expand-Archive cc.zip -DestinationPath . -Force; Remove-Item cc.zip; cd cc-devenv-doctor-main; powershell -ExecutionPolicy Bypass -File setup.ps1
```

วิธีวางใน PowerShell: **คลิกขวา** ในหน้าต่าง (หรือกด **Ctrl + V**) แล้วกด **Enter**

### ขั้นที่ 3 — ตอบคำถาม

- **"Which coding agent…"** — กด **Enter** เฉย ๆ (= ลงทั้ง Claude Code และ Codex)
- **"Where should the Claude Code plugins be enabled?"** — กด **Enter** เฉย ๆ
- ถ้ามีหน้าต่างเด้งถาม **"Do you want to allow this app to make changes to your device?"** — กด **Yes**
- ถ้าสคริปต์บอกว่า **ต้องรีสตาร์ทเครื่อง** (เพราะติดตั้ง WSL2 ให้ Docker) — รีสตาร์ท แล้วกลับมาทำขั้นที่ 1–2 อีกรอบ สคริปต์จะข้ามของที่ลงไปแล้ว

จากนั้นรอจนขึ้นคำว่า **`=== Summary ===`**

---

## ขั้นที่ 4 — ดูผล

ตอนจบสคริปต์จะสรุปเป็นรายการ:

- **`[v]`** = ติดตั้งสำเร็จ
- **`[!]`** = ยังไม่สำเร็จ ข้างหลังจะมีบอกว่าต้องทำอะไรต่อ

เจอ `[!]` ไม่ต้องตกใจ ส่วนใหญ่แก้ได้ด้วยการ **ปิดหน้าต่างนี้ เปิดใหม่ แล้ววางคำสั่งเดิมจากขั้นที่ 2 ซ้ำ** — สคริปต์รันซ้ำกี่รอบก็ได้ มันจะข้ามของที่ลงสำเร็จไปแล้ว

ครั้งแรก Docker มักขึ้น `[!]` เสมอ — ให้เปิดแอป **Docker Desktop** หนึ่งครั้ง รอ 1–2 นาทีจนมันพร้อม ก็ใช้ได้แล้ว

## ขั้นที่ 5 — ล็อกอิน

**ปิดหน้าต่าง Terminal / PowerShell แล้วเปิดใหม่ก่อน** (สำคัญ — หน้าต่างเก่ายังมองไม่เห็นโปรแกรมที่เพิ่งลง)

แล้วพิมพ์อย่างใดอย่างหนึ่ง กด Enter:

| ใช้ตัวไหน | พิมพ์ | จะเกิดอะไรขึ้น |
|---|---|---|
| Claude Code | `claude` | เบราว์เซอร์เปิดหน้าล็อกอินของ Claude ล็อกอินให้เสร็จแล้วกลับมาที่หน้าต่างเดิม |
| Codex | `codex` | เลือก **Sign in with ChatGPT** แล้วล็อกอินในเบราว์เซอร์ |

ถ้ามีคำถามอื่นขึ้นมา (เช่น เลือกธีมสี หรือถามว่าไว้ใจโฟลเดอร์นี้ไหม) กด **Enter** ตามที่เลือกไว้ให้ได้เลย

ออกจากโปรแกรม: กด **Ctrl + C** สองครั้ง

## ขั้นที่ 6 — ให้มันตรวจเครื่องให้

หลังล็อกอินแล้ว อยู่ในโปรแกรม `claude` หรือ `codex` ให้พิมพ์:

| ใช้ตัวไหน | พิมพ์ |
|---|---|
| Claude Code | `/devenv-doctor:environment-doctor` |
| Codex | `$environment-doctor` |

หรือพิมพ์ว่า `check my setup` ก็ได้ มันจะไล่ตรวจทุกอย่างแล้วสรุปเป็นตาราง ✅ / ❌ ถ้าขาดอะไรจะบอกคำสั่งที่ต้องวางให้ตรงกับเครื่องคุณ

บน Codex บางครั้งมันจะขออนุญาตรันคำสั่งตรวจ — อนุญาตได้ คำสั่งตรวจทั้งหมดแค่อ่านข้อมูล ไม่ได้แก้อะไรในเครื่อง

ถ้าขึ้น ✅ ครบ — **พร้อมใช้งานแล้ว** 🎉

---

## ติดปัญหา

| อาการ | ทำอย่างไร |
|---|---|
| `command not found: claude` หรือ `'claude' is not recognized` (หรือ `codex`) | ปิดหน้าต่างแล้วเปิดใหม่ ถ้ายังไม่ได้ วางคำสั่งจากขั้นที่ 2 ซ้ำ |
| พิมพ์รหัสผ่านแล้วไม่มีอะไรขึ้นบนจอ | ปกติ พิมพ์ให้ครบแล้วกด Enter |
| Docker ขึ้น `[!]` | เปิดแอป Docker Desktop หนึ่งครั้ง รอ 1–2 นาที |
| Windows บอกให้รีสตาร์ท | รีสตาร์ท แล้ววางคำสั่งจากขั้นที่ 2 ซ้ำ |
| Windows ขึ้น `winget not found` | อัปเดต Windows หรือลงแอป **App Installer** จาก Microsoft Store แล้ววางคำสั่งซ้ำ |
| ล็อกอิน Claude แล้วบอกว่าไม่มีสิทธิ์ใช้ | บัญชี Claude ฟรีใช้ Claude Code ไม่ได้ ต้องเป็น Pro ขึ้นไป — หรือใช้ Codex แทน |
| พิมพ์ `/devenv-doctor:environment-doctor` แล้วไม่มีอะไรเกิดขึ้น | ออกจากโปรแกรม (Ctrl + C สองครั้ง) แล้วเปิดใหม่ |
| Mac: `VS Code` ขึ้น `[!]` | เปิดแอป VS Code หนึ่งครั้ง กด ⌘ Command + Shift + P พิมพ์ `Shell Command: Install 'code' command in PATH` กด Enter แล้ววางคำสั่งซ้ำ |

ยังไม่หาย? [เปิด issue](https://github.com/killernay/cc-devenv-doctor/issues) แล้วแปะข้อความในส่วน `=== Summary ===` มาด้วย

### อย่าลบโฟลเดอร์ `cc-devenv-doctor-main`

สคริปต์วางไว้ในโฟลเดอร์ผู้ใช้ของคุณ (Mac: `/Users/ชื่อคุณ/cc-devenv-doctor-main`, Windows: `C:\Users\ชื่อคุณ\cc-devenv-doctor-main`) — Claude Code อ่านตัวตรวจเครื่องจากโฟลเดอร์นี้ตรง ๆ ถ้าลบไป ตัวตรวจเครื่องจะหายไปจาก Claude Code

### อยากได้เวอร์ชันใหม่

วางคำสั่งจากขั้นที่ 2 ซ้ำ มันจะโหลดเวอร์ชันล่าสุดทับของเดิม

---

## สำหรับคนที่คุ้นกับคอมพิวเตอร์แล้ว

### ลงอะไรให้บ้าง

- **Homebrew** (Mac), **Git**, **Node.js** (LTS บน Windows, `node` ของ Homebrew บน macOS)
- **Claude Code CLI** และ/หรือ **Codex CLI** — ผ่าน native installer ตัวทางการ
- **[devenv-doctor](./devenv-doctor)** — ปลั๊กอินตรวจเครื่องที่มากับ repo นี้ ลงให้ในเอเจนต์ที่เลือก
- **Docker Desktop** รวมถึง WSL2 บน Windows ถ้ายังไม่มี
- **VS Code** + extensions: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) / [Codex](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt) และ [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers)
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — grilling, TDD, code review ฯลฯ
- บน macOS: เพิ่ม `~/.local/bin` เข้า `~/.zprofile` (หรือ `~/.bash_profile`) ครั้งเดียว เพราะตัวติดตั้ง Claude Code ไม่ทำให้

VS Code extensions กับ mattpocock-skills เป็น **ตัวอย่าง** ว่าเครื่องที่พร้อมใช้งานหน้าตาเป็นยังไง ไม่ใช่คำแนะนำว่าต้องใช้ เปลี่ยนเป็นของที่คุณใช้จริงได้เลย นั่นคือวิธี fork ที่ตั้งใจไว้ (เรื่อง VS Code: ผมเองไม่ได้เปิด VS Code เลยตั้งแต่ตุลาคม 2025 แต่สำหรับมือใหม่ editor ที่มี extension ของเอเจนต์ติดมาแล้วเป็นจุดเริ่มที่เป็นมิตรกว่า terminal เปล่า ๆ — ถ้ามี editor ที่ชอบอยู่แล้ว ลบบล็อกนั้นออกจากสคริปต์ได้ ไม่มีอะไรอื่นพึ่งพามัน)

### ข้ามคำถามด้วยตัวแปร

| ตัวแปร | ค่า | ผล |
|---|---|---|
| `AGENTS` | `claude` / `codex` / `both` | ลงเอเจนต์ตัวไหน (ค่าเริ่มต้น `both`) |
| `PLUGIN_SCOPE` | `user` / `project` / `local` | ปลั๊กอิน Claude Code ใช้ได้ที่ไหน (ค่าเริ่มต้น `user`) |

```bash
AGENTS=both PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:AGENTS="both"; $env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

`user` เขียนลง `~/.claude/settings.json` ใช้ได้ทุกโปรเจกต์ `project` เขียน `.claude/settings.json` ลงโฟลเดอร์ที่รันสคริปต์ ปลั๊กอินจะโหลดเฉพาะในโฟลเดอร์นั้น — ถ้ารันจากโฟลเดอร์ดาวน์โหลดก็แปลว่าใช้ได้แค่ในโฟลเดอร์ดาวน์โหลด ซึ่งแทบไม่มีใครต้องการ Codex ไม่มีตัวเลือกนี้ ปลั๊กอินเปิดระดับ user เสมอ

### ใช้ git clone แทน ZIP

```bash
git clone https://github.com/killernay/cc-devenv-doctor.git
cd cc-devenv-doctor
bash setup.sh                                          # macOS
powershell -ExecutionPolicy Bypass -File setup.ps1     # Windows
```

### เอาแค่ปลั๊กอิน devenv-doctor

มีเอเจนต์ **กับ git** อยู่แล้ว ไม่ต้อง clone เอง — คำสั่ง marketplace clone ให้

```
# Claude Code (2.1.275 ขึ้นไป)
claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor

# Codex
codex plugin marketplace add killernay/cc-devenv-doctor
codex plugin add devenv-doctor@ngernthongdee
```

ถ้ามีเซสชันเปิดค้างอยู่ตอนติดตั้ง: Claude Code ใช้ `/reload-plugins` ส่วน Codex ให้เปิดเซสชันใหม่ ไม่มี git จะขึ้น *"Failed to clone marketplace repository"* — ใช้สคริปต์แทน มันลง git ให้

### ลงเองทีละขั้น (ไม่ใช้สคริปต์)

ลำดับมีผล: git ต้องมาก่อนปลั๊กอินทุกตัว (marketplace ถูก clone ด้วย git) Node ต้องมาก่อน claude-mem

| # | ของ | macOS | Windows (PowerShell) |
|---|---|---|---|
| 1 | Homebrew (เฉพาะ Mac) | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` | — |
| 2 | Git | `brew install git` | `winget install --id Git.Git -e` |
| 3 | Node.js ≥ 20 | `brew install node` | `winget install --id OpenJS.NodeJS.LTS -e` |
| 4a | Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` | `irm https://claude.ai/install.ps1 \| iex` |
| 4b | Codex | `curl -fsSL https://chatgpt.com/codex/install.sh \| sh` | `irm https://chatgpt.com/codex/install.ps1 \| iex` |
| 5 | Docker Desktop (macOS 14 ขึ้นไป) | `brew install --cask docker-desktop` | `wsl --install --no-distribution` รีสตาร์ท แล้ว `winget install --id Docker.DockerDesktop -e` |
| 6 | VS Code (ไม่บังคับ) | `brew install --cask visual-studio-code` | `winget install --id Microsoft.VisualStudioCode -e` |

- **macOS:** ตัวติดตั้ง Claude Code ไม่เพิ่ม `~/.local/bin` เข้า PATH ให้: `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile`
- **Windows:** ลง Git ก่อน Claude Code — Claude Code ใช้ Git Bash เป็น shell ถ้าไม่มีจะใช้ PowerShell แทน
- ลงอะไรเสร็จให้เปิด terminal ใหม่ และต้องเปิดแอป Docker หนึ่งครั้งให้ engine เริ่มทำงาน

จากนั้น: ล็อกอิน (`claude` / `codex`) → [ลงปลั๊กอิน devenv-doctor](#เอาแค่ปลั๊กอิน-devenv-doctor) → ของเสริม:

- VS Code extensions: `code --install-extension anthropic.claude-code` / `openai.chatgpt` / `ms-azuretools.vscode-containers`
- mattpocock-skills: Claude Code `claude plugin marketplace add anthropics/claude-plugins-official` แล้ว `claude plugin install mattpocock-skills@claude-plugins-official`; Codex `codex plugin marketplace add mattpocock/skills` แล้ว `codex plugin add mattpocock-skills@mattpocock`
- เช็ค: `claude doctor` / `codex doctor --summary` แล้วเรียก devenv-doctor ในเอเจนต์

### ความจำข้ามเซสชัน (claude-mem, ไม่บังคับ)

```
npx claude-mem install
```

ทำหลังล็อกอินแล้ว มันตรวจเจอทั้ง Claude Code และ Codex ลง Bun กับ uv ให้เอง ต้องมี Node ≥ 20 และถ้าใช้กับ Claude Code ต้องเป็น 2.1.139 ขึ้นไป ตัว memory provider ที่มันเลือกไว้ให้ (CMEM Pro) **จะเสียเงินหลังทดลองใช้ 30 วัน** — ถ้าไม่ต้องการให้เลือกตัวอื่นตอนมันถาม

### ถอนออก

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```
```
codex plugin remove devenv-doctor@ngernthongdee
codex plugin marketplace remove ngernthongdee
```

ต้องใส่ id เต็ม `name@marketplace` ตามที่ `claude plugin list` / `codex plugin list` แสดง และต้องลบ marketplace แยกอีกขั้น

### devenv-doctor ตรวจอะไรบ้าง

git, Node, Claude Code และ Codex CLI รวมถึงล็อกอินแล้วหรือยัง (`claude doctor`, `codex doctor`), VS Code extensions, Docker (ทั้งตัวโปรแกรมและ engine), claude-mem, ปลั๊กอินที่ลงไว้ — แล้วให้คำสั่งแก้ตาม OS

- **Claude Code:** ทุกคำสั่งตรวจเป็น read-only และ pre-approved ไว้แล้ว จึงไม่มีเด้งถามสิทธิ์
- **Codex:** sandbox ของ Codex อาจบล็อกการตรวจบางตัว (เช่น socket ของ Docker) skill รู้ว่านั่นคือ sandbox ไม่ใช่เครื่องพัง และจะขอสิทธิ์รันซ้ำแทนการรายงานผิด ๆ

ตัวอย่างผลบนเครื่องที่รันสคริปต์แล้ว:

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

มันยังรู้จักความพังที่หน้าตาเหมือนสำเร็จ: เซสชันที่เปิดไว้ก่อนลงปลั๊กอิน, ปลั๊กอิน Claude Code ที่ลงผิด scope, ปลั๊กอินที่ไม่เคย add marketplace และ `codex plugin install` (คำสั่งของ Codex คือ `add`)

---

## ที่มาของโปรเจกต์

เรื่องเริ่มที่ห้องสอบวิชา **AI Agentic Engineering for IT**

เนื้อหาไม่ใช่ส่วนที่ยาก ส่วนที่ยากคือการทำให้เครื่องของทุกคนพร้อมใช้งาน ลง git ต่อด้วย Node ต่อด้วย VS Code ต่อด้วย Docker ต่อด้วย Claude Code CLI — ทีละคำสั่ง บน Windows กับ Mac พร้อมกัน เจอ PATH ไม่รีเฟรช เจอ installer หยุดถามคำถามที่ไม่มีใครในห้องตอบได้ เวลาหลายชั่วโมงหมดไปกับตรงนั้น ทั้งที่ควรได้ใช้กับเนื้อหาจริง

ที่น่าหงุดหงิดคือมันไม่มีอะไรน่าสนใจเลย คำสั่งชุดเดิม ลำดับเดิม พังแบบเดิมทุกครั้ง — ซึ่งเป็นปัญหาประเภทที่ควรแก้ครั้งเดียวแล้วแจกออกไป จะได้ไม่มีใครต้องเสียเวลาทั้งเช้ากับมันอีก

สรุป: สคริปต์หนึ่งตัวต่อหนึ่ง OS กับปลั๊กอินที่บอกได้ว่าอะไรยังพังอยู่

ทำไมไม่ `npm install -g @anthropic-ai/claude-code` (หรือ `@openai/codex`) เฉย ๆ? เพราะคำสั่งนั้นลงแค่ตัวเอเจนต์ แล้วปล่อยให้คุณไปลง git, Node, VS Code, Docker เองทีละอย่าง แล้วไปงมไวยากรณ์ปลั๊กอินเอง ซึ่งนั่นแหละคือจุดที่เวลาทั้งเช้าหายไป

## สำหรับคนที่จะแก้โค้ดต่อ

macOS มาพร้อม **bash 3.2** และเครื่องเปล่าไม่มีเวอร์ชันใหม่กว่านั้นใน `PATH` — ซึ่งคือเครื่องที่ `setup.sh` เล็งไว้พอดี ต้องเขียนให้ compatible กับ bash 3.2: ห้ามใช้ negative array index (`${arr[-1]}`), ห้าม associative array และห้าม expand `"${arr[@]}"` โดยไม่เช็คความยาวก่อนตอนเปิด `set -u` ไว้ — `bash -n` จับไม่ได้สักข้อ มันพังตอน runtime เท่านั้น

ฝั่ง PowerShell คำสั่ง native (`winget`, `claude`, `codex`, `code`) ไม่โยน terminating error เพราะฉะนั้น `try`/`catch` ครอบไว้ก็ไม่เคยทำงาน ให้เช็ค `$LASTEXITCODE` แทน

manifest ของปลั๊กอินมีชุดเดียว เป็นรูปแบบของ Claude Code (`.claude-plugin/`) Codex อ่านได้ตรง ๆ อย่าเพิ่มสำเนา `.codex-plugin/` ถ้าไม่ได้ต้องการ metadata เฉพาะ Codex ส่วนคำที่ใช้เรียก skill ให้ใส่ไว้ใน `description` ของ frontmatter เพราะ Codex อ่านแค่ `name` กับ `description`

ตรวจ manifest ก่อน push:

```bash
claude plugin validate . --strict
claude plugin validate ./devenv-doctor --strict
```

แล้วเช็คว่า Codex ยังเห็นปลั๊กอิน โดยไม่ไปแตะ config Codex ของตัวเอง:

```bash
CODEX_HOME=$(mktemp -d) sh -c 'codex plugin marketplace add "$PWD" && codex plugin list -m ngernthongdee'
```

เปิดรับ issue และ PR — โดยเฉพาะอะไรก็ตามที่ตัดขั้นตอนที่มือใหม่ต้องทำเองด้วยมือออกไปได้

## License

MIT — ดู [LICENSE](./LICENSE) เอาไปใช้ fork ต่อ เปลี่ยนลิสต์ extension เป็นของตัวเองได้เลย
