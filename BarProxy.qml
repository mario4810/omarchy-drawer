import QtQuick
import qs.Commons

// The bar as the hosted widgets see it: the real bar facade with the colours
// swapped for the popup palette. The widgets are drawn in the bar's ink, which
// on a transparent bar is picked to suit the wallpaper (dark on a light one),
// and would be unreadable on a themed popup card.
QtObject {
  id: root

  required property QtObject source

  readonly property color foreground: Color.popups.text
  readonly property color barForeground: Color.popups.text
  readonly property color background: Color.popups.background
  readonly property bool transparent: false

  readonly property color urgent: source.urgent
  readonly property string fontFamily: source.fontFamily
  readonly property string position: source.position
  readonly property bool vertical: source.vertical
  readonly property int barSize: source.barSize
  readonly property bool foregroundAnimationEnabled: source.foregroundAnimationEnabled
  readonly property bool centerSectionRevealHeld: source.centerSectionRevealHeld
  readonly property bool centerHoverRevealSuppressed: source.centerHoverRevealSuppressed
  readonly property var activePopout: source.activePopout
  readonly property var clickTargets: source.clickTargets
  readonly property var layoutConfig: source.layoutConfig
  readonly property var foreignPopoutMarker: source.foreignPopoutMarker
  readonly property var shell: source.shell
  readonly property string pluginId: source.pluginId
  readonly property string moduleName: source.moduleName

  function setCenterHoverRevealSuppressed(value) { source.setCenterHoverRevealSuppressed(value) }
  function showTooltip(target, text) { source.showTooltip(target, text) }
  function hideTooltip(target) { source.hideTooltip(target) }
  function registerClickTarget(target) { source.registerClickTarget(target) }
  function unregisterClickTarget(target) { source.unregisterClickTarget(target) }
  function requestPopout(owner) { source.requestPopout(owner) }
  function releasePopout(owner) { source.releasePopout(owner) }
  function switchPanelFrom(owner, direction) { return source.switchPanelFrom(owner, direction) }
  function targetBelongsToWindow(target, window) { return source.targetBelongsToWindow(target, window) }
  function moduleWidgets(id) { return source.moduleWidgets(id) }
  function run(command) { source.run(command) }
}
