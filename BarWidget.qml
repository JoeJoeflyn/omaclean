import QtQuick
import qs.Ui

BarIndicator {
  id: root

  property bool activeState: false

  active: root.activeState
  activeText: "󰃢"
  inactiveText: "󰃢"
  activeTooltipText: "Clean Screen: Active"
  inactiveTooltipText: "Clean Screen"

  function toggle() {
    root.activeState = !root.activeState
  }

  onPressed: function() { root.toggle() }
}
