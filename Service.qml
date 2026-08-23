import QtQuick
import Quickshell.Io
import Quickshell

Item {
  id: root
  property var shell: null

  readonly property string home: Quickshell.env("HOME")
  readonly property string stateDir: home + "/.local/state/omarchy/indicators"
  readonly property string statePath: stateDir + "/clean-kbd"
  readonly property var keyboardDevices: ["at-translated-set-2-keyboard"]

  property bool locked: false
  property bool stateLoaded: false

  function applyDevice(lockedVal) {
    const enable = lockedVal ? "false" : "true"
    const names = keyboardDevices.map(d => "'" + d + "'").join(",")
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
    root.stateLoaded = true
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
        if (!root.stateLoaded || root.locked !== isLocked) {
          root.locked = isLocked
          root.stateLoaded = true
          applyDevice(isLocked)
        } else {
          root.stateLoaded = true
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
    function status(): string { return JSON.stringify({ locked: root.locked, stateLoaded: root.stateLoaded }) }
    function toggle(): string { root.toggle(); return root.locked ? "locked" : "unlocked" }
    function enable(): string { root.setLocked(true, true); return "locked" }
    function disable(): string { root.setLocked(false, true); return "unlocked" }
  }
}
