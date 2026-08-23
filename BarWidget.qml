import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var cleankbdService: bar?.shell?.firstPartyServiceFor("omaclean")

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰌌"
    active: root.cleankbdService ? root.cleankbdService.locked : false
    useActiveColor: true
    tooltipText: root.cleankbdService && root.cleankbdService.locked
      ? "Keyboard locked — click to unlock"
      : "Lock keyboard for cleaning"

    onPressed: function(buttonCode) {
      if (root.cleankbdService) root.cleankbdService.toggle()
    }
  }
}
