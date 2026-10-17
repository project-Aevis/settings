/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS System Settings Content Item Page
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI

Page {
    id: page

    property string headerTitle

    background: Rectangle {
        color: FishUI.Theme.darkMode ? "#1C1C1E" : "#F5F5F7"
    }

    header: Item {
        height: 54

        TapHandler {
            enabled: !rootWindow.isFullScreen
            onTapped: if (tapCount === 2) rootWindow.toggleMaximized()
            gesturePolicy: TapHandler.DragThreshold
        }

        DragHandler {
            target: null
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            grabPermissions: PointerHandler.CanTakeOverFromItems | PointerHandler.ApprovesTakeOverByAnything
            onActiveChanged: if (active) rootWindow.helper.startSystemMove(rootWindow)
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 28
            anchors.rightMargin: 28
            spacing: 14

            // macOS Navigation Buttons (Back & Forward)
            Row {
                spacing: 4
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                    width: 24
                    height: 24
                    radius: 5
                    color: backMouse.pressed ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.12))
                                             : (backMouse.containsMouse ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.05)) : "transparent")
                    opacity: rootWindow.canGoBack() ? 1.0 : 0.35

                    Text {
                        anchors.centerIn: parent
                        text: "‹"
                        font.pixelSize: 18
                        font.bold: true
                        color: FishUI.Theme.textColor
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        hoverEnabled: rootWindow.canGoBack()
                        enabled: rootWindow.canGoBack()
                        onClicked: rootWindow.goBack()
                    }
                }

                Rectangle {
                    width: 24
                    height: 24
                    radius: 5
                    color: fwdMouse.pressed ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.12))
                                            : (fwdMouse.containsMouse ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.05)) : "transparent")
                    opacity: rootWindow.canGoForward() ? 1.0 : 0.35

                    Text {
                        anchors.centerIn: parent
                        text: "›"
                        font.pixelSize: 18
                        font.bold: true
                        color: FishUI.Theme.textColor
                    }

                    MouseArea {
                        id: fwdMouse
                        anchors.fill: parent
                        hoverEnabled: rootWindow.canGoForward()
                        enabled: rootWindow.canGoForward()
                        onClicked: rootWindow.goForward()
                    }
                }
            }

            Label {
                text: page.headerTitle
                font.bold: true
                font.pixelSize: 22
                color: FishUI.Theme.textColor
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }
        }
    }
}
