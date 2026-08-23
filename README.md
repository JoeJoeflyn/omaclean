# omaClean 🧼 — Keyboard Lock for Cleaning

Native status bar indicator and keyboard input protection for [Omarchy](https://omarchy.org/). One click disables your keyboard so you can wipe down your screen and keyboard safely without triggering unwanted keystrokes.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🌟 Features

- **🛡️ One-Click Keyboard Lock**: Disables keyboard input via `hyprctl` so no keystrokes get through while cleaning.
- **🎛️ Top Bar Indicator**: Clean native `BarIndicator` that glows in your active theme accent when locked, hidden when inactive (reveals on hover).
- **💾 Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **⌨️ CLI & IPC**: Toggle from terminal, scripts, or window manager hotkeys.

---

## 📥 Installation

Install omaClean using the Omarchy CLI:

```bash
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --enable
omarchy restart shell
```

### Manual Bar Configuration

Add `"omaclean"` to your desired status bar section in `~/.config/omarchy/shell.json`:

```jsonc
{
  "bar": {
    "sections": {
      "right": [
        "omaclean",
        "omarchy.audio",
        "omarchy.network",
        "omarchy.battery"
      ]
    }
  }
}
```

---

## 🗑️ Removal & Uninstallation

```bash
omarchy plugin remove omaclean
omarchy restart shell
```

---

## ⌨️ Shell / IPC Commands

Control omaClean from your terminal, scripts, or window manager hotkeys:

```bash
# Toggle keyboard lock
omarchy-shell cleankbd toggle

# Lock keyboard
omarchy-shell cleankbd enable

# Unlock keyboard
omarchy-shell cleankbd disable

# Check status
omarchy-shell cleankbd status
```

---

## 📄 License

MIT License © 2026 JoeJoeflyn
