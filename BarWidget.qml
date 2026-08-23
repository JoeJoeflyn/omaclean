import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omaclean"

  readonly property var panelItem: bar?.shell?.firstPartyPanelFor ? bar.shell.firstPartyPanelFor("omaclean") : (bar?.shell?.thirdPartyPanelFor ? bar.shell.thirdPartyPanelFor("omaclean") : null)
  readonly property bool isCleanActive: panelItem ? panelItem.active === true : false

  function toggle() {
    if (panelItem && panelItem.toggle) {
      panelItem.toggle()
    }
  }

  BarPill {
    id: pill
    parent: root
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    
    label: "󰃢"
    accent: root.isCleanActive
    tooltipText: root.isCleanActive ? "Clean Screen Active (Click to Exit)" : "Clean Screen / Keyboard Wipe Protection"

    onClicked: root.toggle()
  }
}
