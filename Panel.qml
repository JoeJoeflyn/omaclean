import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "omaclean"
  ipcTarget: "omaclean"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  property bool active: false
  property int bgModeIndex: 0 // 0: Dark Black, 1: Bright White, 2: Dim Glass
  readonly property var bgColors: ["#000000", "#FFFFFF", "#0A0C16F0"]
  readonly property var bgNames: ["Dark Mode (Spots Dust)", "Bright Mode (Spots Smudges)", "Dim Glass Tint"]
  
  property real holdProgress: 0.0
  property bool isHoldingEsc: false
  readonly property real holdDurationMs: 2000.0

  function toggle() {
    if (root.active) {
      root.deactivate()
    } else {
      root.activate()
    }
  }

  function activate() {
    root.holdProgress = 0.0
    root.isHoldingEsc = false
    root.bgModeIndex = 0
    root.active = true
    Qt.callLater(function() {
      if (cleanOverlayWindow) {
        keyTrap.forceActiveFocus()
      }
    })
  }

  function deactivate() {
    holdTimer.stop()
    root.isHoldingEsc = false
    root.holdProgress = 0.0
    root.active = false
  }

  function cycleBgMode() {
    root.bgModeIndex = (root.bgModeIndex + 1) % root.bgColors.length
  }

  IpcHandler {
    target: "omaclean"
    function toggle() { root.toggle() }
    function open() { root.activate() }
    function close() { root.deactivate() }
  }

  // --- Fullscreen Exclusive Lock Overlay ---
  PanelWindow {
    id: cleanOverlayWindow
    visible: root.active
    
    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    color: root.bgColors[root.bgModeIndex]
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Behavior on color {
      ColorAnimation { duration: 250 }
    }

    Item {
      id: keyTrap
      anchors.fill: parent
      focus: true

      // Intercept 100% of all mouse clicks & gestures
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.AllButtons
        onClicked: (mouse) => {
          mouse.accepted = true
          root.cycleBgMode()
        }
        onPressed: (mouse) => { mouse.accepted = true }
        onReleased: (mouse) => { mouse.accepted = true }
        onWheel: (wheel) => { wheel.accepted = true }
      }

      // Intercept 100% of all keys
      Keys.onPressed: (event) => {
        event.accepted = true
        if (event.key === Qt.Key_Escape) {
          if (!root.isHoldingEsc) {
            root.isHoldingEsc = true
            holdTimer.restart()
          }
        } else if (event.key === Qt.Key_Space) {
          root.cycleBgMode()
        }
      }

      Keys.onReleased: (event) => {
        event.accepted = true
        if (event.key === Qt.Key_Escape) {
          root.isHoldingEsc = false
          holdTimer.stop()
          root.holdProgress = 0.0
        }
      }

      // --- Hold ESC Timer ---
      Timer {
        id: holdTimer
        interval: 16 // 60 fps
        repeat: true
        running: false
        onTriggered: {
          if (root.isHoldingEsc) {
            root.holdProgress = Math.min(1.0, root.holdProgress + (16.0 / root.holdDurationMs))
            if (root.holdProgress >= 1.0) {
              root.deactivate()
            }
          }
        }
      }

      // --- Center Cleaning HUD Card ---
      Rectangle {
        id: hudCard
        anchors.centerIn: parent
        width: 480
        height: 380
        radius: 20

        readonly property bool isLightBg: root.bgModeIndex === 1
        color: isLightBg ? "#F0F2F5" : "#111622E6"
        border.color: isLightBg ? "#CCCCCC" : (Color.accent || "#E23636")
        border.width: 2

        ColumnLayout {
          anchors.centerIn: parent
          width: parent.width - 48
          spacing: 14

          // Icon & Title
          RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            Text {
              text: "󰃢"
              font.pixelSize: 36
              color: Color.accent || "#E23636"
            }

            Text {
              text: "Clean Screen Active"
              font.pixelSize: 22
              font.bold: true
              font.family: Style.font.headingFamily || "sans-serif"
              color: hudCard.isLightBg ? "#111111" : "#FFFFFF"
            }
          }

          // Subtitle description
          Text {
            Layout.alignment: Qt.AlignHCenter
            text: "All keyboard keys & trackpad clicks are locked.\nWipe your screen and keyboard safely."
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            color: hudCard.isLightBg ? "#555555" : "#8A94A6"
            lineHeight: 1.3
          }

          Item { Layout.preferredHeight: 6 }

          // --- Circular Hold-to-Unlock Progress Ring ---
          Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90

            Canvas {
              id: progressCanvas
              anchors.fill: parent
              property real progress: root.holdProgress
              onProgressChanged: requestPaint()

              onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var cx = width / 2
                var cy = height / 2
                var r = width / 2 - 6

                // Track Background
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.strokeStyle = hudCard.isLightBg ? "#DDDDDD" : "#242C3D"
                ctx.lineWidth = 6
                ctx.stroke()

                // Progress Arc
                if (progress > 0) {
                  ctx.beginPath()
                  ctx.arc(cx, cy, r, -Math.PI / 2, (-Math.PI / 2) + (Math.PI * 2 * progress))
                  ctx.strokeStyle = Color.accent || "#E23636"
                  ctx.lineWidth = 6
                  ctx.lineCap = "round"
                  ctx.stroke()
                }
              }
            }

            ColumnLayout {
              anchors.centerIn: parent
              spacing: 2

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.isHoldingEsc ? Math.round(root.holdProgress * 100) + "%" : "ESC"
                font.pixelSize: 14
                font.bold: true
                color: root.isHoldingEsc ? (Color.accent || "#E23636") : (hudCard.isLightBg ? "#222222" : "#FFFFFF")
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: "HOLD"
                font.pixelSize: 9
                font.bold: true
                color: hudCard.isLightBg ? "#777777" : "#8A94A6"
              }
            }
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.isHoldingEsc ? "Keep holding to unlock..." : "Hold ESC to Exit"
            font.pixelSize: 12
            font.bold: true
            color: root.isHoldingEsc ? (Color.accent || "#E23636") : (hudCard.isLightBg ? "#444444" : "#A6B0C3")
          }

          Item { Layout.preferredHeight: 4 }

          // Mode & Shortcuts Hint Bar
          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            radius: 8
            color: hudCard.isLightBg ? "#E2E5EB" : "#1A2130"

            RowLayout {
              anchors.centerIn: parent
              spacing: 16

              Text {
                text: "Mode: " + root.bgNames[root.bgModeIndex]
                font.pixelSize: 11
                color: Color.accent || "#E23636"
              }

              Text {
                text: "•   [Space] Switch BG"
                font.pixelSize: 11
                color: hudCard.isLightBg ? "#666666" : "#8A94A6"
              }
            }
          }
        }
      }
    }
  }
}
