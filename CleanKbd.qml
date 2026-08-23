import QtQuick
import qs.Ui

BarIndicator {
  id: root

  readonly property var cleankbdService: bar?.shell?.firstPartyServiceFor("omaclean")

  active: cleankbdService ? cleankbdService.locked : false
  activeText: "󰌌"
  inactiveText: "󰌌"
  activeTooltipText: "Keyboard locked — click to unlock"
  inactiveTooltipText: "Lock keyboard for cleaning"

  function toggle() {
    if (root.cleankbdService) root.cleankbdService.toggle()
  }

  onPressed: function() { root.toggle() }
}
