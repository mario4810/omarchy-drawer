import QtQuick
import qs.Commons

// The two lists behind the drawer's edit button: what is in the drawer (click
// to send it back to the bar) and what is on the bar (click to move it in).
Item {
  id: root

  required property QtObject bar
  property var stashed: []
  property var movable: []
  property string busyId: ""
  property string errorText: ""

  signal stash(string id, bool keepEnabled)
  signal restore(string id)

  readonly property color foreground: bar ? bar.barForeground : Color.foreground
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property int maxHeight: Style.space(420)

  implicitWidth: Style.space(300)
  implicitHeight: Math.min(maxHeight, flick.contentHeight)

  Flickable {
    id: flick
    anchors.fill: parent
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    Column {
      id: column
      width: flick.width
      spacing: Style.space(2)

      SectionLabel { text: "In the drawer" }
      Text {
        visible: root.stashed.length === 0
        width: parent.width
        leftPadding: Style.space(8)
        text: "Nothing yet. Pick a widget below."
        color: root.foreground
        opacity: 0.6
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
      Repeater {
        model: root.stashed
        delegate: ItemRow {
          required property var modelData
          label: modelData.missing ? modelData.name + " (not installed)" : modelData.name
          glyph: "󰁍"
          hint: "Back to the bar"
          busy: root.busyId === modelData.id
          onActivated: root.restore(modelData.id)
        }
      }

      SectionLabel { text: "On the bar"; topGap: Style.space(6) }
      Repeater {
        model: root.movable
        delegate: ItemRow {
          required property var modelData
          label: modelData.name
          detail: modelData.section
          glyph: "󰁔"
          hint: "Move into the drawer"
          busy: root.busyId === modelData.id
          onActivated: root.stash(modelData.id, modelData.keepEnabled)
        }
      }

      Text {
        visible: root.errorText !== ""
        width: parent.width
        topPadding: Style.space(4)
        leftPadding: Style.space(8)
        rightPadding: Style.space(8)
        text: root.errorText
        wrapMode: Text.Wrap
        color: root.bar ? root.bar.urgent : Color.urgent
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
    }
  }

  component SectionLabel: Text {
    property real topGap: 0
    width: parent.width
    topPadding: topGap
    leftPadding: Style.space(8)
    color: root.foreground
    opacity: 0.6
    font.family: root.fontFamily
    font.pixelSize: Style.font.caption
    font.bold: true
  }

  component ItemRow: Rectangle {
    id: row

    property string label: ""
    property string detail: ""
    property string glyph: ""
    property string hint: ""
    property bool busy: false
    signal activated()

    width: parent ? parent.width : 0
    height: Style.space(28)
    radius: Style.cornerRadius
    color: mouse.containsMouse ? Util.alpha(root.foreground, 0.12) : "transparent"
    opacity: busy ? 0.5 : 1

    Text {
      anchors.left: parent.left
      anchors.leftMargin: Style.space(8)
      anchors.verticalCenter: parent.verticalCenter
      text: row.label
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
    }
    Text {
      anchors.right: glyphText.left
      anchors.rightMargin: Style.space(8)
      anchors.verticalCenter: parent.verticalCenter
      text: row.detail
      color: root.foreground
      opacity: 0.55
      font.family: root.fontFamily
      font.pixelSize: Style.font.caption
    }
    Text {
      id: glyphText
      anchors.right: parent.right
      anchors.rightMargin: Style.space(8)
      anchors.verticalCenter: parent.verticalCenter
      text: row.glyph
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      enabled: !row.busy
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: row.activated()
    }
  }
}
