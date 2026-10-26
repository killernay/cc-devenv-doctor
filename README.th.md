# cc-devenv-doctor

คำสั่งเดียว พาเครื่อง Windows หรือ Mac เปล่า ๆ ไปถึง [Claude Code](https://claude.com/claude-code) หรือ [Codex](https://developers.openai.com/codex/cli) ที่ใช้งานได้จริง — พ่วงปลั๊กอินที่คอยตรวจสุขภาพเครื่องให้ต่อหลังจากนั้น เรียกได้จากในเอเจนต์ทั้งสองตัว

> English version: [README.md](./README.md)

## ทำไมถึงมีของชิ้นนี้

เรื่องเริ่มที่ห้องสอบวิชา **AI Agentic Engineering for IT**

เนื้อหาไม่ใช่ส่วนที่ยาก ส่วนที่ยากคือการทำให้เครื่องของทุกคนพร้อมใช้งาน ลง git ต่อด้วย Node ต่อด้วย VS Code ต่อด้วย Docker ต่อด้วย Claude Code CLI — ทีละคำสั่ง บน Windows กับ Mac พร้อมกัน เจอ PATH ไม่รีเฟรช เจอ installer หยุดถามคำถามที่ไม่มีใครในห้องตอบได้ เวลาหลายชั่วโมงหมดไปกับตรงนั้น ทั้งที่ควรได้ใช้กับเนื้อหาจริง

ที่น่าหงุดหงิดคือมันไม่มีอะไรน่าสนใจเลย คำสั่งชุดเดิม ลำดับเดิม พังแบบเดิมทุกครั้ง — ซึ่งเป็นปัญหาประเภทที่ควรแก้ครั้งเดียวแล้วแจกออกไป จะได้ไม่มีใครต้องเสียเวลาทั้งเช้ากับมันอีก

สรุป: สคริปต์หนึ่งตัวต่อหนึ่ง OS กับปลั๊กอินที่บอกได้ว่าอะไรยังพังอยู่

## ลงอะไรให้บ้าง

- **Git**
- **Node.js** (LTS บน Windows, `node` ของ Homebrew บน macOS)
- **Claude Code CLI** และ/หรือ **Codex CLI** — เลือกเองได้ ลงผ่าน native installer ตัวทางการทั้งคู่
- **[devenv-doctor](./devenv-doctor)** — ปลั๊กอินที่มาพร้อม repo นี้ ลงให้ในเอเจนต์ที่เลือก มันจะไล่เช็คของจริง แล้วบอกว่าต้องแก้อะไรบ้าง
- **Docker Desktop** รวมถึงติดตั้ง WSL2 ให้บน Windows ถ้ายังไม่มี
- **VS Code** + extensions: [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) และ/หรือ [Codex](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt) กับ [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers) สำหรับ Docker
- **[mattpocock-skills](https://github.com/mattpocock/skills)** — grilling, TDD, code review และอื่น ๆ ฝั่ง Claude Code มาจาก marketplace ทางการของ Anthropic ฝั่ง Codex มาจาก marketplace ของ Matt เอง

## สองอย่างสุดท้ายเป็นแค่ตัวอย่าง ไม่ใช่สาระ

VS Code extensions กับ mattpocock-skills ใส่มาเพื่อเป็น **ตัวอย่างว่าเครื่องที่พร้อมใช้งานหน้าตาเป็นยังไง** ไม่ได้แปลว่านี่คือของที่เหมาะกับทุกคน สาระจริง ๆ ของสคริปต์คือ พอฐานทำงานได้แล้ว การเพิ่ม skill หรือ extension ตัวถัดไปเหลือแค่บรรทัดเดียว แทนที่จะเป็นทั้งบ่าย ที่ใส่ไว้ก็เพื่อให้เห็นรูปร่างของเรื่องนี้ และเพื่อให้คนที่เพิ่งเริ่มมีของที่ใช้ได้ตั้งแต่วันแรก

เปลี่ยนเป็นของที่คุณใช้จริงได้เลย นั่นคือวิธี fork ที่ตั้งใจไว้

### เรื่อง VS Code โดยเฉพาะ

พูดตรง ๆ: **ผมไม่ได้เปิด VS Code เลยตั้งแต่ตุลาคม 2025** ไม่เปิดเลยสักครั้ง

แต่ก็ยังใส่ไว้ในสคริปต์ และคิดว่าถูกแล้ว — ถ้าคุณเพิ่งเริ่ม editor ที่มี extension ของเอเจนต์ติดมาแล้วคือทางที่สั้นที่สุดที่จะได้ของที่ใช้งานได้ และเป็นจุดลงจอดที่เป็นมิตรกว่า terminal เปล่า ๆ เยอะ

แต่อย่าอ่านว่านี่คือคำแนะนำจากคนที่ใช้มันทุกวัน ถ้ามี editor ที่ชอบอยู่แล้ว ลบบล็อกนั้นออกจากสคริปต์ได้เลย ไม่มีอะไรอื่นพึ่งพามัน

## เริ่มใช้งาน

### ถ้ามี git อยู่แล้ว

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

### ถ้ายังไม่มี git

1. ไปที่ [github.com/killernay/cc-devenv-doctor](https://github.com/killernay/cc-devenv-doctor) กด **Code → Download ZIP** แล้วแตกไฟล์
2. เปิด terminal / PowerShell ในโฟลเดอร์ที่แตกออกมา — GitHub ตั้งชื่อให้ว่า **`cc-devenv-doctor-main`** ไม่ใช่ `cc-devenv-doctor`
3. รันสคริปต์เดิมตามด้านบน — `bash setup.sh` (macOS) หรือ `powershell -ExecutionPolicy Bypass -File setup.ps1` (Windows) สคริปต์จะลง git ให้ระหว่างทางเอง

สคริปต์เป็น idempotent รันซ้ำได้ ปลอดภัย มันจะข้ามของที่ลงไว้แล้ว และสรุปผลผ่าน/ไม่ผ่านให้ตอนจบ ขั้นไหนพังจะพิมพ์คำสั่งสำหรับลองใหม่มาให้ด้วย

### สองคำถามที่สคริปต์จะถาม

1. **จะใช้เอเจนต์ตัวไหน** — Claude Code, Codex หรือทั้งคู่ (กด Enter = ทั้งคู่) ของที่ผูกกับเอเจนต์ทั้งหมด — CLI, VS Code extension, ปลั๊กอิน — ลงตามคำตอบนี้
2. **จะเปิดใช้ปลั๊กอิน Claude Code ที่ระดับไหน** (ถามเฉพาะตอนเลือก Claude Code ด้วย):
   - **user** (แนะนำ) — เขียนลง `~/.claude/settings.json` ปลั๊กอินใช้ได้ทุกโปรเจกต์บนเครื่องนี้
   - **project** — เขียน `.claude/settings.json` ลงในโฟลเดอร์ที่รันสคริปต์ ปลั๊กอินจะโหลดเฉพาะตอนอยู่ใน*โฟลเดอร์นั้น*

   กด Enter ผ่านไปเลยจะได้ `user` เลือก `project` เฉพาะตอนที่ตั้งใจจะผูกปลั๊กอินกับโปรเจกต์เดียวจริง ๆ — และถ้ารันสคริปต์จากโฟลเดอร์ดาวน์โหลด `project` จะแปลว่า "ใช้ได้แค่ในโฟลเดอร์ดาวน์โหลด" ซึ่งแทบจะแน่นอนว่าไม่ใช่สิ่งที่ต้องการ ฝั่ง Codex ไม่มีให้เลือก ปลั๊กอินเปิดใช้ระดับ user เสมอ

ถ้าไม่อยากให้ถาม กำหนดไปตั้งแต่แรก (`AGENTS` เป็น `claude`, `codex` หรือ `both`):

```bash
AGENTS=both PLUGIN_SCOPE=user bash setup.sh
```
```powershell
$env:AGENTS="both"; $env:PLUGIN_SCOPE="user"; powershell -ExecutionPolicy Bypass -File setup.ps1
```

### เอาแค่ปลั๊กอิน devenv-doctor ไม่เอา bootstrap ทั้งชุด

มีเอเจนต์ **กับ git** อยู่แล้ว อยากได้แค่ปลั๊กอิน ไม่ต้อง clone เอง ไม่ต้องโหลด ZIP ไม่ต้อง `cd` ไปไหน — คำสั่ง marketplace clone ให้เอง

**Claude Code** (2.1.275 ขึ้นไป — คำสั่งเดียว):

```
claude plugin install devenv-doctor --marketplace killernay/cc-devenv-doctor
```

แล้วเปิด `claude` พิมพ์ `/devenv-doctor:environment-doctor` จบ — ติดตั้งเป็น scope **user** คือใช้ได้ทุกโปรเจกต์บนเครื่องนี้ ถ้าอยากจำกัดแค่โฟลเดอร์เดียว ดู[คำถามเรื่อง scope](#สองคำถามที่สคริปต์จะถาม) ถ้าตอนติดตั้งมีเซสชัน Claude Code เปิดค้างอยู่ ให้ `/reload-plugins` ก่อน

**Codex:**

```
codex plugin marketplace add killernay/cc-devenv-doctor
codex plugin add devenv-doctor@ngernthongdee
```

แล้วเปิดเซสชัน `codex` ใหม่ พิมพ์ `$environment-doctor` หรือพิมพ์ว่า "check my setup" เฉย ๆ ก็ได้ Codex อ่าน marketplace รูปแบบของ Claude ใน repo นี้ได้ตรง ๆ ไม่มี manifest แยกของ Codex ให้ต้องคอยซิงก์

ทั้งสองฝั่งเรียก `git clone` ข้างใน เครื่องต้องมี git ไม่งั้นขึ้น *"Failed to clone marketplace repository"* — ถ้ายังไม่มี git ให้รันสคริปต์ setup ด้านบนแทน มันลง git ให้ด้วย

### ถอนออกยังไง

```
claude plugin uninstall devenv-doctor@ngernthongdee
claude plugin marketplace remove ngernthongdee
```
```
codex plugin remove devenv-doctor@ngernthongdee
codex plugin marketplace remove ngernthongdee
```

ต้องใส่ id เต็ม `name@marketplace` ตามที่ `claude plugin list` / `codex plugin list` แสดง และการลบ marketplace เป็นอีกขั้นแยกต่างหาก ไม่งั้น marketplace จะยังค้างอยู่ทั้งที่ไม่มีปลั๊กอินเหลือแล้ว

## อะไรที่ยังต้องใช้คนทำ

สามอย่างที่เขียนสคริปต์แทนไม่ได้จริง ๆ เพราะต้องให้คุณยืนยันตัวตนเองหรือตอบคำถามเอง:

1. **Login** — รัน `claude` และ/หรือ `codex` หลังสคริปต์จบ แต่ละตัวจะเปิดเบราว์เซอร์ให้ล็อกอิน
2. **`npx claude-mem install`** (ไม่บังคับ) — ให้เอเจนต์มีความจำข้ามเซสชัน มันตรวจเจอทั้ง Claude Code และ Codex ลง runtime ของตัวเอง (Bun, uv) ให้เอง แล้วถามว่าจะใช้ memory provider ไหน ตัวที่เลือกไว้ให้ (CMEM Pro) จะเสียเงินหลังทดลองใช้ 30 วัน — ถ้าไม่ต้องการก็เลือกตัวอื่นตอนมันถาม จัดอยู่กลุ่มเดียวกับ extension ด้านบน คือตัวอย่างของสิ่งที่ต่อเพิ่มได้เมื่อฐานพร้อมแล้ว
3. **รีสตาร์ทเครื่อง** ถ้าสคริปต์ต้องลง WSL2 ให้บน Windows (Docker Desktop ต้องใช้) — สคริปต์จะบอกชัดเจนถ้าเข้าเคสนี้

บน macOS ตัวติดตั้ง Claude Code วาง `claude` ไว้ที่ `~/.local/bin` แต่ไม่เพิ่มโฟลเดอร์นั้นเข้า shell profile ให้ เปิด terminal ใหม่ก็ยังขึ้น *command not found* สคริปต์เลยเพิ่มให้ใน `~/.zprofile` (หรือ `~/.bash_profile` ถ้าใช้ bash) ครั้งเดียว

## devenv-doctor

ติดตั้งแล้วเรียกจากในเอเจนต์ — หรือจะเล่าปัญหาไปตรง ๆ ("setup พัง", "ทำไม docker ไม่ทำงาน") ก็เรียก skill ตัวเดียวกัน:

- **Claude Code:** `/devenv-doctor:environment-doctor` ทุกการเช็คเป็น read-only และ pre-approved ไว้แล้ว เลยไม่มีเด้งถามสิทธิ์ระหว่างทาง ถ้าเรียกแล้วไม่ตอบ แปลว่าเซสชันเปิดอยู่ก่อนปลั๊กอินถูกติดตั้ง — รัน `/reload-plugins` หรือเปิดเซสชันใหม่
- **Codex:** `$environment-doctor` sandbox ของ Codex อาจบล็อกการเช็คบางตัว (เช่น socket ของ Docker) skill รู้ว่านั่นคือ sandbox ไม่ใช่เครื่องพัง และจะขอสิทธิ์รันเช็คนั้นซ้ำ แทนที่จะรายงานว่าพังทั้งที่ไม่พัง

มันจะไล่เช็คของจริง — git, Node, Claude Code และ Codex CLI รวมถึงล็อกอินแล้วหรือยัง (`claude doctor`, `codex doctor`), VS Code extensions, Docker, claude-mem, ปลั๊กอินที่ลงไว้ — แล้วให้คำสั่งแก้ที่ตรงกับ OS ของคุณ

### หน้าตาผลลัพธ์

บนเครื่องที่รันสคริปต์ไปแล้ว รายงานจะออกมาประมาณนี้:

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

อันไหนไม่ขึ้น ✅ มันจะบอกคำสั่งแก้มาให้ตรงกับ OS ของคุณ

นอกจากนี้มันยังรู้จักความพังที่หน้าตาเหมือนสำเร็จ: เซสชันที่เปิดไว้ก่อนลงปลั๊กอิน, ปลั๊กอิน Claude Code ที่ลงผิด scope, ปลั๊กอินที่ไม่เคย add marketplace เลย และ `codex plugin install` (คำสั่งของ Codex คือ `add`)

## ทำไมไม่ใช้ `npm install -g @anthropic-ai/claude-code` (หรือ `@openai/codex`) เฉย ๆ

คำสั่งนั้นลงแค่ตัวเอเจนต์ แล้วปล่อยให้คุณไปลง git, Node, VS Code, Docker เองทีละอย่าง แล้วไปงมไวยากรณ์ของปลั๊กอินเอง ซึ่งนั่นแหละคือจุดที่เวลาทั้งเช้าหายไป

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

## ร่วมพัฒนา

เปิดรับ issue และ PR — โดยเฉพาะอะไรก็ตามที่ตัดขั้นตอนที่มือใหม่ต้องทำเองด้วยมือออกไปได้

## License

MIT — ดู [LICENSE](./LICENSE) เอาไปใช้ fork ต่อ เปลี่ยนลิสต์ extension เป็นของตัวเองได้เลย
