import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  property bool active: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight
  visible: true

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰃢"
    slotSize: Style.bar.statusSlot
    active: root.active
    useActiveColor: true
    tooltipText: root.active ? "Clean Screen: Active" : "Clean Screen"

    onPressed: function(b) {
      root.active = !root.active
    }
  }
}
