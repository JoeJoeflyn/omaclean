import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var cleankbdService: bar?.shell?.firstPartyServiceFor("omaclean")

  implicitWidth: Style.bar.statusSlot
  implicitHeight: Style.bar.statusSlot

  BarIndicator {
    id: indicator
    anchors.fill: parent
    bar: root.bar
    indicatorHost: root
    active: root.cleankbdService ? root.cleankbdService.locked : false
    activeText: "󰌌"
    inactiveText: "󰌌"
    activeTooltipText: "Keyboard locked — click to unlock"
    inactiveTooltipText: "Lock keyboard for cleaning"

    onPressed: function() {
      if (root.cleankbdService) root.cleankbdService.toggle()
    }
  }
}
