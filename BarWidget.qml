import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var cleankbdService: bar?.shell?.firstPartyServiceFor("omaclean")
  property bool indicatorAreaHovered: false
  property bool indicatorItemHovered: false
  readonly property bool revealInactiveIndicators: indicatorAreaHovered || indicatorItemHovered || (bar && bar.centerSectionRevealHeld === true && bar.centerHoverRevealSuppressed !== true)

  implicitWidth: indicator.implicitWidth
  implicitHeight: indicator.implicitHeight

  HoverHandler {
    onHoveredChanged: root.indicatorAreaHovered = hovered
  }

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
