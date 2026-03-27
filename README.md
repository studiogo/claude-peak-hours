# Claude Peak Hours

A lightweight macOS menu bar app that shows whether Claude is currently in **peak** or **off-peak** hours.

During peak hours (weekdays 5 AM – 11 AM PT), Anthropic applies stricter session limits. This app gives you a clear, always-visible indicator so you know when to conserve tokens and when to go all out.

![Menu Bar](docs/screenshot.png)

## Features

- **Menu bar indicator** — green circle + "Full power" or red circle + "Restricted"
- **Warning mode** — orange indicator 15 minutes before a status change
- **Popover details** — click the icon for countdown timer, restriction hours in your local timezone, and schedule info
- **Notifications** — optional macOS notifications when peak hours start/end and 15 min before changes
- **Launch at login** — optional auto-start
- **Localized** — Polish and English, auto-detected from system language
- **Lightweight** — native Swift + SwiftUI, ~5 MB RAM, no dependencies

## Requirements

- macOS 13 (Ventura) or later
- Xcode Command Line Tools (`xcode-select --install`)

## Install

### One-liner (recommended)

```bash
curl -sL https://raw.githubusercontent.com/studiogo/claude-peak-hours/main/install.sh | bash
```

Downloads the latest release, installs to `/Applications`, and starts the app.

### Download manually

1. Go to [Releases](https://github.com/studiogo/claude-peak-hours/releases)
2. Download `Claude-Peak-Hours-v*.zip`
3. Unzip and move `Claude Peak Hours.app` to `/Applications`

### Build from source

```bash
git clone https://github.com/studiogo/claude-peak-hours.git
cd claude-peak-hours
./build.sh
cp -r "build/Claude Peak Hours.app" /Applications/
```

## Peak Hours Schedule

Based on [Anthropic's announcement](https://www.anthropic.com):

| | Peak | Off-Peak |
|---|---|---|
| **When** | Weekdays 5:00–11:00 AM PT | Evenings, nights, weekends |
| **PT** | 5:00–11:00 | All other times |
| **CET** | 14:00–20:00 | All other times |
| **Effect** | Faster session limit usage | Normal session limits |

The app auto-converts to your local timezone.

## How It Works

No API calls, no network requests. The app simply checks the current time against the known peak hours schedule (weekdays 5–11 AM Pacific Time) and updates every 30 seconds.

---

## PL

Lekka aplikacja macOS na menu bar, ktora pokazuje czy Claude jest w godzinach peak (ograniczenia) czy off-peak (pelna moc). Automatycznie wykrywa jezyk systemu i wyswietla komunikaty po polsku lub angielsku.

## License

MIT
