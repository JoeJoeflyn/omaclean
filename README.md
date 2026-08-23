# omaClean 🧼 — Keyboard Lock for Cleaning

A service plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes. Shows as a native indicator beside NightLight, StayAwake, DnD, and friends.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🌟 Features

- **🛡️ One-Click Keyboard Lock**: Click the indicator to disable keyboard input via `hyprctl` — no keystrokes get through while cleaning.
- **🖱️ Click to Unlock**: Click the indicator again to re-enable the keyboard. Mouse still works while locked.
- **💾 Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **🎛️ Native Indicator**: Shows inside the Omarchy indicators widget, beside NightLight, StayAwake, DnD, etc. Reveals on hover when inactive.

---

## 📥 Installation

omaClean is a **service plugin** — it provides the keyboard lock logic. The indicator (`CleanKbd.qml`) lives inside the Omarchy indicators widget, just like NightLight and StayAwake.

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

The Clean Keyboard indicator now appears beside NightLight, StayAwake, and the other indicators in your bar. Hover the center section to reveal it, click to lock, click again to unlock.

---

## 🗑️ Removal & Uninstallation

```bash
omarchy plugin remove omaclean
omarchy restart shell
```

---

## 📄 License

MIT License © 2026 JoeJoeflyn
