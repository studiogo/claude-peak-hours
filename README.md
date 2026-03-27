# Claude Peak Hours

Know when to go all out and when to conserve tokens.

During peak hours (weekdays 5 AM – 11 AM PT), Anthropic applies stricter session limits. These tools give you a clear indicator so you never get surprised by throttling.

Two tools — pick what fits your workflow:

---

## 1. macOS Menu Bar App

Always-visible indicator next to your clock.

### Features
- **Menu bar indicator** — 🟢 Full power / 🔴 Restricted / 🟡 Warning
- **Popover details** — click for countdown timer, restriction hours in your local timezone
- **Notifications** — optional macOS alerts when peak hours start/end and 15 min before
- **Launch at login** — optional auto-start
- **Localized** — Polish and English, auto-detected from system language
- **Lightweight** — native Swift + SwiftUI, no dependencies

### Requirements
- macOS 13 (Ventura) or later
- Xcode Command Line Tools (`xcode-select --install`)

### Install

```bash
curl -sL https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/install.sh | bash
```

### Uninstall

```bash
rm -rf "/Applications/Claude Peak Hours.app"
```

### Alternative install methods

**Download manually:**
1. Go to [Releases](https://github.com/studiogo/claude-peak-hours/releases)
2. Download `Claude-Peak-Hours-v*.zip`
3. Unzip and move `Claude Peak Hours.app` to `/Applications`

**Build from source:**
```bash
git clone https://github.com/studiogo/claude-peak-hours.git
cd claude-peak-hours
./build.sh
cp -r "build/Claude Peak Hours.app" /Applications/
```

---

## 2. Claude Code Status Line

Peak/off-peak status with countdown right in your Claude Code terminal. Works on **macOS, Linux, and Windows** (WSL/Git Bash).

```
Claude │ ████████░░░░░░░░░░░░ 40% │ 🟢 OK 6h 34m
Claude │ ██████████████░░░░░░ 72% │ 🔴 PEAK 2h 15m
```

### Features
- **🟢 OK 6h 34m** — off-peak, countdown to next peak
- **🔴 PEAK 2h 15m** — peak hours, countdown to end
- **Context bar** — shows context window usage with color coding (green/yellow/red)
- **Compact warning** — ⚠ COMPACT when context > 80%

### Requirements
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- `jq` — JSON parser
  - macOS: `brew install jq`
  - Linux: `sudo apt install jq`
  - Windows: `choco install jq`

### Install

```bash
curl -sL https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/statusline-install.sh | bash
```

This will:
1. Download the status line script to `~/.claude/statusline.sh`
2. Back up your existing statusline (if any) to `~/.claude/statusline.sh.backup`
3. Add `statusLine` config to `~/.claude/settings.json`
4. Restart Claude Code to see it

### Uninstall

```bash
curl -sL https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/statusline-uninstall.sh | bash
```

This will:
1. Remove the statusline script
2. Restore your previous statusline from backup (if any)
3. Remove `statusLine` from `settings.json`

---

## Peak Hours Schedule

Based on [Anthropic's announcement](https://support.anthropic.com/en/articles/9646069-usage-limits-for-claude-ai):

| | Peak | Off-Peak |
|---|---|---|
| **When** | Weekdays 5:00–11:00 AM PT | Evenings, nights, weekends |
| **PT** | 5:00–11:00 | All other times |
| **CET** | 14:00–20:00 | All other times |
| **Effect** | Faster session limit usage | Normal session limits |

Both tools auto-convert to your local timezone.

## How It Works

No API calls, no network requests. Both tools simply check the current time against the known peak hours schedule (weekdays 5–11 AM Pacific Time).

- **Menu bar app** — updates every 30 seconds
- **Status line** — updates after each Claude Code response

## License

MIT
