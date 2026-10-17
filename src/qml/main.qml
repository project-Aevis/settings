/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Ventura / Sonoma System Settings Clone
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import Qt5Compat.GraphicalEffects
import FishUI 1.0 as FishUI

FishUI.Window {
    id: rootWindow
    title: qsTr("System Settings")
    visible: true
    width: 980
    height: 660

    minimumWidth: 860
    minimumHeight: 560

    property alias stackView: _stackView
    property alias sideBar: sideBar

    // Navigation History Stack
    property var navHistory: [0]
    property int navIndex: 0
    property bool inNavAction: false

    function canGoBack() {
        return navIndex > 0
    }

    function canGoForward() {
        return navIndex < navHistory.length - 1
    }

    function goBack() {
        if (canGoBack()) {
            inNavAction = true
            navIndex--
            var targetIdx = navHistory[navIndex]
            sideBar.currentIndex = targetIdx
            _stackView.replace(Qt.resolvedUrl(sideBar.model.get(targetIdx).page))
            inNavAction = false
        }
    }

    function goForward() {
        if (canGoForward()) {
            inNavAction = true
            navIndex++
            var targetIdx = navHistory[navIndex]
            sideBar.currentIndex = targetIdx
            _stackView.replace(Qt.resolvedUrl(sideBar.model.get(targetIdx).page))
            inNavAction = false
        }
    }

    background.color: "transparent"
    background.opacity: 1
    header.height: 40
    contentTopMargin: 0

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // macOS Left Sidebar
        SideBar {
            id: sideBar
            Layout.preferredWidth: 242
            Layout.fillHeight: true

            onCurrentIndexChanged: {
                if (!inNavAction) {
                    navHistory = navHistory.slice(0, navIndex + 1)
                    navHistory.push(currentIndex)
                    navIndex = navHistory.length - 1
                }
                switchPageFromIndex(currentIndex)
            }
        }

        // macOS 1px Sidebar / Content Inset Divider
        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.08)
            z: 5
        }

        // macOS Content Detail Pane
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: FishUI.Theme.darkMode ? "#1C1C1E" : "#F5F5F7"
            }

            StackView {
                id: _stackView
                anchors.fill: parent
                initialItem: Qt.resolvedUrl(sideBar.model.get(0).page)
                clip: true

                pushEnter: Transition {
                    NumberAnimation { property: "opacity"; from: 0.6; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                }
                pushExit: Transition {
                    NumberAnimation { property: "opacity"; from: 1.0; to: 0.6; duration: 150; easing.type: Easing.OutQuad }
                }
                replaceEnter: Transition {
                    NumberAnimation { property: "opacity"; from: 0.6; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                }
                replaceExit: Transition {
                    NumberAnimation { property: "opacity"; from: 1.0; to: 0.6; duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    function switchPageFromIndex(index) {
        if (index >= 0 && index < sideBar.model.count) {
            _stackView.replace(Qt.resolvedUrl(sideBar.model.get(index).page))
        }
    }

    function switchPageFromName(pageName) {
        for (var i = 0; i < sideBar.model.count; ++i) {
            if (pageName === sideBar.model.get(i).name) {
                sideBar.currentIndex = i
                break
            }
        }

        rootWindow.show()
        rootWindow.raise()
    }
}
