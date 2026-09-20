import QtQuick
import qs.Commons
import qs.Ui

// The bar-side half of the drawer: a single icon button. The drawer itself
// opens from here (see Drawer.qml).
BarWidget {
  id: root
  moduleName: "io.github.mario4810.drawer"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: setting("icon", "󰇘")
    tooltipText: "Drawer"
  }
}
