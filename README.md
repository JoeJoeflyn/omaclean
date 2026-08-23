# omaClean 🧼 — Keyboard Lock for Cleaning

A service plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes. Shows as a native indicator beside NightLight, StayAwake, DnD, and friends.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🌟 Features

- **🛡️ One-Click Keyboard Lock**: Disables keyboard input via `hyprctl` so no keystrokes get through while cleaning.
- **💾 Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **🎛️ Native Indicator**: Shows inside the Omarchy indicators widget, beside NightLight, StayAwake, DnD, etc.
- **⌨️ CLI & IPC**: Toggle from terminal, scripts, or window manager hotkeys.

---

## 📥 Installation

omaClean is a **service plugin** — it provides the keyboard lock logic and IPC. The indicator (`CleanKbd.qml`) lives inside the Omarchy indicators widget, just like NightLight and StayAwake.

### Step 1: Install the service

```bash
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --yes --enable
```

### Step 2: Add the indicator to your bar

Clone the built-in indicators plugin and add the CleanKbd indicator:

```bash
omarchy plugin clone omarchy.indicators
cp ~/.config/omarchy/plugins/omaclean/CleanKbd.qml \
   ~/.config/omarchy/plugins/<yourname>.indicators/indicators/
```

Then edit `<yourname>.indicators/manifest.json` and add the CleanKbd option to the `items` schema:

```json
{
  "value": "CleanKbd",
  "label": "Clean keyboard",
  "description": "Lock keyboard for cleaning"
}
```

### Step 3: Restart the shell

```bash
omarchy restart shell
```

The Clean Keyboard indicator now appears beside NightLight, StayAwake, and the other indicators in your bar.

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
