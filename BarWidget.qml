import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  property bool isLocked: false

  // EXACT same rule as NightLight / StayAwake:
  // - ACTIVE: Always visible, full opacity (1.0), theme accent color.
  // - INACTIVE: Completely hidden (0 width, 0 opacity). ONLY reveals when mouse hovers over the center bar section (dimmed 0.45 opacity).
  readonly property bool centerHovered: !!bar && (bar.centerSectionHovered === true || bar.centerSectionRevealHeld === true)
  readonly property bool shouldShow: root.isLocked || root.centerHovered

  visible: shouldShow
  implicitWidth: shouldShow ? button.implicitWidth : 0
  implicitHeight: shouldShow ? button.implicitHeight : 0

  Behavior on implicitWidth {
    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
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
    opacity: root.isLocked ? 1.0 : (root.centerHovered ? 0.45 : 0.0)
    tooltipText: root.isLocked ? "Clean Screen: Active" : "Clean Screen"

    onPressed: function(b) {
      root.isLocked = !root.isLocked
    }
  }
}
