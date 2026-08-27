import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// BarWidget for omaClean — native keyboard lock toggle button on Omarchy top bar.
BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var cleankbdService: bar?.shell?.pluginServiceFor("omaclean") || bar?.shell?.firstPartyServiceFor("omaclean")
  readonly property bool isLocked: cleankbdService ? cleankbdService.locked : false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    slotSize: Style.bar.iconSlot
    active: root.isLocked
    tooltipText: root.isLocked ? "Keyboard locked — click to unlock" : "Lock keyboard for cleaning"

    iconComponent: Component {
      Text {
        anchors.centerIn: parent
        text: "󰌌"
        font.pixelSize: Style.font.bodyLarge
        color: root.isLocked ? Color.accent : (button.hovered ? Color.foreground : Color.muted)
      }
    }

    onPressed: function() {
      if (root.cleankbdService) {
        root.cleankbdService.toggle()
      } else {
        ipcProc.command = ["omarchy-shell", "omaclean", "toggle"]
        ipcProc.running = true
      }
    }
  }

  Process { id: ipcProc }
}
