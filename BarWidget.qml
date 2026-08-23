import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var panelItem: {
    if (!bar || !bar.shell) return null
    if (typeof bar.shell.thirdPartyPanelFor === "function") {
      var p = bar.shell.thirdPartyPanelFor("omaclean")
      if (p) return p
    }
    if (typeof bar.shell.firstPartyPanelFor === "function") {
      return bar.shell.firstPartyPanelFor("omaclean")
    }
    return null
  }
  readonly property bool isCleanActive: panelItem ? panelItem.active === true : false

  function toggle() {
    if (panelItem && typeof panelItem.toggle === "function") {
      panelItem.toggle()
    }
  }

  implicitWidth: pill.implicitWidth
  implicitHeight: pill.implicitHeight
  visible: true

  BarPill {
    id: pill
    anchors.verticalCenter: parent.verticalCenter
    
    label: "󰃢"
    accent: root.isCleanActive
    tooltipText: root.isCleanActive ? "Clean Screen Active (Click to Exit)" : "Clean Screen / Keyboard Wipe Protection"

    onClicked: root.toggle()
  }
}
