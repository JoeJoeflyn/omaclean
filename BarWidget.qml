import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  property bool isLocked: false

  function toggle() {
    root.isLocked = !root.isLocked
    if (root.isLocked) {
      Qt.callLater(function() {
        if (cleanOverlayWindow) keyTrap.forceActiveFocus()
      })
    }
  }

  visible: true
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰃢"
    slotSize: Style.bar.statusSlot
    active: root.isLocked
    useActiveColor: true
    tooltipText: root.isLocked ? "Clean Screen Active (Press ESC to unlock)" : "Clean Screen / Keyboard Wipe Protection"

    onPressed: function(b) {
      root.toggle()
    }
  }

  PanelWindow {
    id: cleanOverlayWindow
    visible: root.isLocked
    color: "#000000"
    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Item {
      id: keyTrap
      anchors.fill: parent
      focus: true

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.AllButtons
        onClicked: (mouse) => { mouse.accepted = true }
        onPressed: (mouse) => { mouse.accepted = true }
        onReleased: (mouse) => { mouse.accepted = true }
      }

      Keys.onPressed: (event) => {
        event.accepted = true
        if (event.key === Qt.Key_Escape) {
          root.isLocked = false
        }
      }

      Text {
        anchors.centerIn: parent
        text: "󰃢  Clean Screen Active\n\nKeys & touchpad are locked. Wipe safely.\nPress ESC to unlock."
        color: "#E8E6E3"
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 1.4
      }
    }
  }
}
