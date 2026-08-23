# omaClean — Keyboard Lock for Cleaning

A service plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

![omaClean Preview](preview.png)

---

## Features

- **One-Click Keyboard Lock**: Click the indicator to disable keyboard input via `hyprctl` — no keystrokes get through while cleaning.
- **Click to Unlock**: Click the indicator again to re-enable the keyboard. Mouse still works while locked.
- **Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **Native Indicator**: Shows beside NightLight, StayAwake, and DnD in the indicators widget. Hides when inactive, reveals on hover — same behavior as the other indicators.

---

## Installation

```bash
# 1. Install the service plugin
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --yes

# 2. Add the indicator to your indicators widget
~/.config/omarchy/plugins/omaclean/setup.sh
```

That's it. The setup script clones `omarchy.indicators`, copies `CleanKbd.qml` into it, and restarts the shell.

Hover the center bar section to reveal the keyboard icon beside the other indicators. Click to lock, click again to unlock.

---

## Removal

```bash
omarchy plugin remove omaclean
omarchy plugin remove giogio.indicators
omarchy restart shell
```

---

## License

MIT License © 2026 JoeJoeflyn
