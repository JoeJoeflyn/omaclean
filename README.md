# omaClean — Keyboard Lock for Cleaning

A plugin for [Omarchy](https://omarchy.org/) that locks keyboard input so you can wipe down your screen and keyboard safely without triggering keystrokes.

[![Omarchy Plugin](https://img.shields.io/badge/omarchy-plugin-blue.svg)](https://omarchyplugins.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

![omaClean Preview](preview.png)

---

## Features

- **One-Click Keyboard Lock**: Click the bar icon to disable keyboard input via `hyprctl` — no keystrokes get through while cleaning.
- **Click to Unlock**: Click the icon again to re-enable the keyboard. Mouse remains active while locked.
- **Persistent State**: Survives reboots — if you locked your keyboard before restarting, it stays locked on next boot.
- **Native Bar Widget & Background Service**: Works automatically out-of-the-box with zero helper scripts.

---

## Installation

Install in **one command**:

```bash
omarchy plugin add https://github.com/JoeJoeflyn/omaclean --yes
```

After install, the keyboard icon (`󰌌`) appears in your top bar. Click it to lock the keyboard, click again to unlock.

---

## Removal

```bash
omarchy plugin remove omaclean
omarchy restart shell
```

---

## License

MIT License © 2026 JoeJoeflyn
