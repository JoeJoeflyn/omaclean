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
        if (cleanOverlayLoader.item) {
          cleanOverlayLoader.item.grabFocus()
        }
      })
    }
  }

  // Exact NightLight / StayAwake behavior:
  // 1. When locked (active): 100% visible & highlighted
  // 2. When idle (inactive): ONLY revealed when user hovers over the center bar area (dimmed), otherwise completely hidden!
  readonly property bool centerHovered: (bar && bar.centerSectionHovered === true) || (bar && bar.centerSectionRevealHeld === true) || hoverDetector.hovered
  readonly property bool shouldShow: root.isLocked || root.centerHovered

  visible: shouldShow
  implicitWidth: shouldShow ? button.implicitWidth : 0
  implicitHeight: shouldShow ? button.implicitHeight : 0

  Behavior on implicitWidth { NumberAnimation { duration: 120 } }

  HoverHandler {
    id: hoverDetector
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰃢"
    slotSize: Style.bar.statusSlot
    active: root.isLocked
    useActiveColor: true
    dimmed: !root.isLocked
    opacity: root.isLocked ? 1.0 : (root.centerHovered ? 0.5 : 0.0)
    tooltipText: root.isLocked ? "Clean Screen Active (Press ESC to unlock)" : "Clean Screen"

    onPressed: function(b) {
      root.toggle()
    }
  }

  // Multi-screen black wipe overlay
  Loader {
    id: cleanOverlayLoader
    active: root.isLocked
    sourceComponent: Component {
      Item {
        id: overlayContainer

        function grabFocus() {
          for (var i = 0; i < screenWindows.count; i++) {
            var item = screenWindows.itemAt(i)
            if (item && item.focusTrap) item.focusTrap.forceActiveFocus()
          }
        }

        Repeater {
          id: screenWindows
          model: Quickshell.screens

          PanelWindow {
            id: win
            required property var modelData
            screen: modelData
            visible: root.isLocked
            color: "#000000"

            anchors {
              top: true
              bottom: true
              left: true
              right: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            exclusionMode: ExclusionMode.Ignore

            property alias focusTrap: keyTrap

            Rectangle {
              anchors.fill: parent
              color: "#000000"
            }

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

              Column {
                anchors.centerIn: parent
                spacing: 16

                Text {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: "󰃢"
                  font.pixelSize: 48
                  color: "#E23636"
                }

                Text {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: "Clean Screen Active"
                  font.pixelSize: 26
                  font.bold: true
                  color: "#FFFFFF"
                }

                Text {
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: "Keys & touchpad are locked. Wipe safely.\nPress ESC to unlock."
                  font.pixelSize: 15
                  color: "#8A94A6"
                  horizontalAlignment: Text.AlignHCenter
                  lineHeight: 1.4
                }
              }
            }
          }
        }
      }
    }
  }
}
