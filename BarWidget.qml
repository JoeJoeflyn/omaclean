import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  // Keyboards to lock while cleaning (names from `hyprctl devices`)
  readonly property var keyboardDevices: ["at-translated-set-2-keyboard"]
  property bool locked: false
  property bool hovered: false

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

  function toggle() {
    const enable = root.locked ? "true" : "false"
    const names = root.keyboardDevices.map(d => "'" + d + "'").join(",")
    applyProcess.command = ["hyprctl", "eval", `for _, n in ipairs({${names}}) do hl.device({ name = n, enabled = ${enable} }) end`]
    applyProcess.running = true
    root.locked = !root.locked
  }

  Process {
    id: applyProcess
  }
}
