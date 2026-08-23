# omaClean 🧼 — Keyboard Lock for Cleaning

A service + bar widget plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

![omaClean Preview](preview.png)

---

## 🌟 Features

- **🛡️ One-Click Keyboard Lock**: Click the indicator to disable keyboard input via `hyprctl` — no keystrokes get through while cleaning.
- **🖱️ Click to Unlock**: Click the indicator again to re-enable the keyboard. Mouse still works while locked.
- **💾 Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **🎛️ Native Bar Indicator**: Shows in the center bar section beside the clock and other indicators.

---

## 📥 Installation

One command:

```bash
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --yes --enable
omarchy restart shell
```

The indicator appears in the center bar section. Hover to reveal it when inactive, click to lock, click again to unlock.

---

## 🗑️ Removal

```bash
omarchy plugin remove omaclean
omarchy restart shell
```

---

## 📄 License

MIT License © 2026 JoeJoeflyn
