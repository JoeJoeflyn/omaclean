import QtQuick
import Quickshell.Io
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  // Keyboards to lock while cleaning (names from `hyprctl devices`)
  readonly property var keyboardDevices: ["at-translated-set-2-keyboard"]
  property bool locked: false
  property bool hovered: false

  readonly property string home: Quickshell.env("HOME")
  readonly property string stateDir: home + "/.local/state/omarchy/indicators"
  readonly property string statePath: stateDir + "/clean-kbd"

  // Same reveal rule as omarchy.indicators: own hover or held center reveal.
  readonly property bool revealInactiveIndicators: root.hovered || (!!bar && bar.centerSectionRevealHeld === true)

  implicitWidth: Style.bar.statusSlot
  implicitHeight: Style.bar.statusSlot

  BarIndicator {
    id: indicator
    anchors.fill: parent
    bar: root.bar
    indicatorHost: root
    active: root.locked
    activeText: "󰌌"
    inactiveText: "󰌌"
    activeTooltipText: "Keyboard locked — click to unlock"
    inactiveTooltipText: "Lock keyboard for cleaning"
    onPressed: function() { root.toggle() }
  }

  HoverHandler {
    onHoveredChanged: root.hovered = hovered
  }

  function applyDevice(lockedVal) {
    const enable = lockedVal ? "false" : "true"
    const names = root.keyboardDevices.map(d => "'" + d + "'").join(",")
    applyProcess.command = ["hyprctl", "eval", "for _, n in ipairs({" + names + "}) do hl.device({ name = n, enabled = " + enable + " }) end"]
    applyProcess.running = true
  }

  function persist(lockedVal) {
    const cmd = lockedVal
      ? "mkdir -p \"$HOME/.local/state/omarchy/indicators\" && touch \"$HOME/.local/state/omarchy/indicators/clean-kbd\""
      : "rm -f \"$HOME/.local/state/omarchy/indicators/clean-kbd\""
    persistProcess.command = ["bash", "-lc", cmd]
    persistProcess.running = true
  }

  function setLocked(value, persistFile) {
    const v = !!value
    if (persistFile) persist(v)
    root.locked = v
    applyDevice(v)
  }

  function toggle() {
    setLocked(!locked, true)
  }

  Process { id: applyProcess }
  Process {
    id: persistProcess
    onExited: probeProcess.running = true
  }
  Process {
    id: probeProcess
    command: ["bash", "-c", "if [[ -f $HOME/.local/state/omarchy/indicators/clean-kbd ]]; then echo yes; else echo no; fi"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        const isLocked = String(text).trim() === "yes"
        if (root.locked !== isLocked) {
          root.locked = isLocked
          applyDevice(isLocked)
        }
      }
    }
  }
  FileView {
    id: watcher
    path: root.stateDir
    watchChanges: true
    printErrors: false
    onFileChanged: probeProcess.running = true
  }
  Component.onCompleted: probeProcess.running = true

  IpcHandler {
    target: "omaclean"
    function status(): string { return JSON.stringify({ locked: root.locked }) }
    function toggle(): string { root.toggle(); return root.locked ? "locked" : "unlocked" }
    function enable(): string { root.setLocked(true, true); return "locked" }
    function disable(): string { root.setLocked(false, true); return "unlocked" }
  }
}
