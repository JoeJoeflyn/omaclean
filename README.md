# omaClean 🧼 — Keyboard Lock for Cleaning

A service plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🌟 Features

- **🛡️ One-Click Keyboard Lock**: Disables keyboard input via `hyprctl` so no keystrokes get through while cleaning.
- **💾 Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **🎛️ Bar Indicator**: Shows as an indicator inside the Omarchy indicators widget, next to NightLight, StayAwake, DnD, etc.
- **⌨️ CLI & IPC**: Toggle from terminal, scripts, or window manager hotkeys.

---

## 📥 Installation

Install omaClean using the Omarchy CLI:

```bash
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --enable
omarchy restart shell
```

Then add the **Clean keyboard** indicator to your Indicators widget via the Omarchy bar settings, or add `giogio.indicators` (cloned from `omarchy.indicators`) which includes the CleanKbd indicator.

---

## ⌨️ Shell / IPC Commands

Control omaClean from your terminal, scripts, or window manager hotkeys:

```bash
# Toggle keyboard lock
omarchy-shell omaclean toggle

# Lock keyboard
omarchy-shell omaclean enable

# Unlock keyboard
omarchy-shell omaclean disable

# Check status
omarchy-shell omaclean status
```

---

## 🗑️ Removal & Uninstallation

```bash
omarchy plugin remove omaclean
omarchy restart shell
```

---

## 📄 License

MIT License © 2026 JoeJoeflyn
