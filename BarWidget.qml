import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Ui

BarIndicator {
  id: root

  property bool isLocked: false

  active: root.isLocked
  activeText: "󰃢"
  inactiveText: "󰃢"
  activeTooltipText: "Clean Screen Active (Press ESC to unlock)"
  inactiveTooltipText: "Clean Screen / Keyboard Lock"

  function toggle() {
    root.isLocked = !root.isLocked
    if (root.isLocked) {
      Qt.callLater(function() {
        if (cleanOverlayWindow) keyTrap.forceActiveFocus()
      })
    }
  }

  onPressed: function() { root.toggle() }

  // Simple input-blocking overlay
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
