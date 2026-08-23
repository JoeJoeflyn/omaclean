import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  property bool isLocked: false

  function toggle() {
    if (root.isLocked) root.deactivate()
    else root.activate()
  }

  function activate() {
    root.isLocked = true
    Qt.callLater(function() {
      if (cleanOverlayWindow) keyTrap.forceActiveFocus()
    })
  }

  function deactivate() {
    root.isLocked = false
  }

  IpcHandler {
    target: "omaclean"
    function toggle() { root.toggle() }
    function open() { root.activate() }
    function close() { root.deactivate() }
  }

  // Exactly like Idle/StayAwake: Hidden when inactive, appears on top center when active!
  visible: root.isLocked
  implicitWidth: root.isLocked ? button.implicitWidth : 0
  implicitHeight: root.isLocked ? button.implicitHeight : 0

  BarIconButton {
    id: button
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    text: "󰃢"
    accent: true
    tooltipText: "Clean Screen Active (Press ESC to unlock)"
    onClicked: root.toggle()
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
          root.deactivate()
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
