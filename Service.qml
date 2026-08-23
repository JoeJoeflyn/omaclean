import QtQuick
import Quickshell.Io
import Quickshell

Item {
  id: root
  property var shell: null

  readonly property string home: Quickshell.env("HOME")
  readonly property string statePath: home + "/.local/state/omarchy/indicators/clean-kbd"
  readonly property var keyboardDevices: ["at-translated-set-2-keyboard"]

  property bool stateLoaded: false
  property bool locked: false

  function applyDevice(lockedVal) {
    const enable = lockedVal ? "false" : "true"
    const names = keyboardDevices.map(d => "'" + d + "'").join(",")
    applyProcess.command = ["hyprctl", "eval", "for _, n in ipairs({" + names + "}) do hl.device({ name = n, enabled = " + enable + " }) end"]
    applyProcess.running = true
  }

  function setLocked(value) {
    const v = !!value
    root.locked = v
    root.stateLoaded = true
    applyDevice(v)
    persistProcess.command = v
      ? ["bash", "-lc", "mkdir -p \"$HOME/.local/state/omarchy/indicators\" && touch \"$HOME/.local/state/omarchy/indicators/clean-kbd\""]
      : ["bash", "-lc", "rm -f \"$HOME/.local/state/omarchy/indicators/clean-kbd\""]
    persistProcess.running = true
  }

  function toggle() {
    setLocked(!locked)
  }

  Process {
    id: statusProbe
    command: ["bash", "-c", "if [[ -f $HOME/.local/state/omarchy/indicators/clean-kbd ]]; then echo yes; else echo no; fi"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        root.locked = String(text).trim() === "yes"
        root.stateLoaded = true
        applyDevice(root.locked)
      }
    }
  }

  Process { id: applyProcess }
  Process { id: persistProcess }

  Component.onCompleted: statusProbe.running = true

  IpcHandler {
    target: "omaclean"
    function status(): string { return JSON.stringify({ locked: root.locked, stateLoaded: root.stateLoaded }) }
    function toggle(): string { root.toggle(); return root.locked ? "locked" : "unlocked" }
    function enable(): string { root.setLocked(true); return "locked" }
    function disable(): string { root.setLocked(false); return "unlocked" }
  }
}
