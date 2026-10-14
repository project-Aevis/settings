/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt5Compat.GraphicalEffects
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import Cutefish.Network 1.0 as NM
import Cutefish.Accounts 1.0 as Accounts

Item {
    implicitWidth: 250

    property int itemRadiusV: 8

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Accounts.UserAccount {
        id: currentUser
    }

    Rectangle {
        anchors.fill: parent
        color: FishUI.Theme.darkMode ? "#1A1B26" : "#E1E2E7"
        opacity: FishUI.Theme.blurEnabled ? 0.85 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.Linear
            }
        }
    }

    ListModel {
        id: listModel

        ListElement {
            title: qsTr("Wi-Fi")
            name: "wlan"
            page: "qrc:/qml/WLAN/Main.qml"
            iconSource: "wlan.svg"
            iconColor: "#007AFF"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("Personal Hotspot")
            name: "hotspot"
            page: "qrc:/qml/Hotspot/Main.qml"
            iconSource: "wlan.svg"
            iconColor: "#34C759"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("Network")
            name: "ethernet"
            page: "qrc:/qml/Wired/Main.qml"
            iconSource: "network.svg"
            iconColor: "#007AFF"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("Bluetooth")
            name: "bluetooth"
            page: "qrc:/qml/Bluetooth/Main.qml"
            iconSource: "bluetooth.svg"
            iconColor: "#007AFF"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("KDE Connect")
            name: "phonelink"
            page: "qrc:/qml/Phone/Main.qml"
            iconSource: "phone.svg"
            iconColor: "#34C759"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("VPN & Proxy")
            name: "proxy"
            page: "qrc:/qml/Proxy/Main.qml"
            iconSource: "proxy.svg"
            iconColor: "#007AFF"
            category: qsTr("Network")
        }

        ListElement {
            title: qsTr("Notifications")
            name: "notifications"
            page: "qrc:/qml/Notification/Main.qml"
            iconSource: "notifications.svg"
            iconColor: "#FF3B30"
            category: qsTr("Notifications & Sound")
        }

        ListElement {
            title: qsTr("Sound")
            name: "sound"
            page: "qrc:/qml/Sound/Main.qml"
            iconSource: "sound.svg"
            iconColor: "#FF2D55"
            category: qsTr("Notifications & Sound")
        }

        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/Appearance/Main.qml"
            iconSource: "appearance.svg"
            iconColor: "#5E5CE6"
            category: qsTr("Appearance & Display")
        }

        ListElement {
            title: qsTr("Wallpaper")
            name: "background"
            page: "qrc:/qml/Wallpaper/Main.qml"
            iconSource: "wallpaper.svg"
            iconColor: "#30B0C7"
            category: qsTr("Appearance & Display")
        }

        ListElement {
            title: qsTr("Desktop & Dock")
            name: "dock"
            page: "qrc:/qml/Dock/Main.qml"
            iconSource: "dock.svg"
            iconColor: "#AF52DE"
            category: qsTr("Appearance & Display")
        }

        ListElement {
            title: qsTr("Displays")
            name: "display"
            page: "qrc:/qml/Display/Main.qml"
            iconSource: "display.svg"
            iconColor: "#0A84FF"
            category: qsTr("Appearance & Display")
        }

        ListElement {
            title: qsTr("General")
            name: "about"
            page: "qrc:/qml/About/Main.qml"
            iconSource: "about.svg"
            iconColor: "#8E8E93"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Software Update")
            name: "update"
            page: "qrc:/qml/Update/Main.qml"
            iconSource: "about.svg"
            iconColor: "#0A84FF"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Date & Time")
            name: "datetime"
            page: "qrc:/qml/DateTime/Main.qml"
            iconSource: "datetime.svg"
            iconColor: "#FF9500"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Language & Region")
            name: "language"
            page: "qrc:/qml/LanguagePage.qml"
            iconSource: "language.svg"
            iconColor: "#007AFF"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Battery")
            name: "battery"
            page: "qrc:/qml/Battery/Main.qml"
            iconSource: "battery.svg"
            iconColor: "#34C759"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Energy Saver")
            name: "power"
            page: "qrc:/qml/Power/Main.qml"
            iconColor: "#FF9500"
            iconSource: "power.svg"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Mouse")
            name: "mouse"
            page: "qrc:/qml/Cursor/Main.qml"
            iconSource: "cursor.svg"
            iconColor: "#64D2FF"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Trackpad")
            name: "touchpad"
            page: "qrc:/qml/Touchpad/Main.qml"
            iconSource: "touchpad.svg"
            iconColor: "#8E8E93"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Users & Groups")
            name: "accounts"
            page: "qrc:/qml/User/Main.qml"
            iconSource: "accounts.svg"
            iconColor: "#FF9500"
            category: qsTr("General & Hardware")
        }

        ListElement {
            title: qsTr("Default Apps")
            name: "defaultapps"
            page: "qrc:/qml/DefaultApp/Main.qml"
            iconSource: "defaultapps.svg"
            iconColor: "#5856D6"
            category: qsTr("General & Hardware")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // macOS Window Controls Spacer
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: rootWindow.header.height
        }

        // macOS User Profile Card
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.bottomMargin: 8

            Rectangle {
                id: profileBg
                anchors.fill: parent
                radius: 10
                color: profileMouse.pressed ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.08))
                                           : (profileMouse.containsMouse ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)) : "transparent")
                antialiasing: true
            }

            MouseArea {
                id: profileMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    rootWindow.switchPageFromName("accounts")
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 10

                Image {
                    id: userAvatar
                    Layout.preferredWidth: 38
                    Layout.preferredHeight: 38
                    source: currentUser.iconFileName ? "file:///" + currentUser.iconFileName : "image://icontheme/default-user"
                    sourceSize: Qt.size(38, 38)
                    antialiasing: true
                    smooth: true

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: 38
                            height: 38
                            Rectangle {
                                anchors.fill: parent
                                radius: 19
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1

                    Label {
                        text: currentUser.displayName ? currentUser.displayName : (currentUser.realName ? currentUser.realName : currentUser.userName)
                        font.bold: true
                        font.pointSize: 10
                        color: FishUI.Theme.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Label {
                        text: qsTr("User Account")
                        font.pointSize: 8
                        color: FishUI.Theme.disabledTextColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Text {
                    text: "›"
                    font.pointSize: 14
                    color: FishUI.Theme.disabledTextColor
                }
            }
        }

        // macOS Search Bar
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.bottomMargin: 8

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.06)
                border.width: searchInput.activeFocus ? 2 : 0
                border.color: "#007AFF"
                antialiasing: true

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        text: "🔍"
                        font.pixelSize: 10
                        opacity: 0.5
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        font.pointSize: 9
                        color: FishUI.Theme.textColor
                        selectByMouse: true
                        clip: true

                        Text {
                            anchors.fill: parent
                            text: qsTr("Search")
                            color: FishUI.Theme.disabledTextColor
                            font.pointSize: searchInput.font.pointSize
                            visible: !searchInput.text && !searchInput.activeFocus
                        }
                    }

                    Text {
                        text: "×"
                        font.pixelSize: 12
                        font.bold: true
                        color: FishUI.Theme.disabledTextColor
                        visible: searchInput.text.length > 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: searchInput.text = ""
                        }
                    }
                }
            }
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel

            spacing: 2
            leftMargin: 10
            rightMargin: 10
            topMargin: 0
            bottomMargin: 10

            ScrollBar.vertical: ScrollBar {}

            section.property: "category"
            section.delegate: Item {
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: searchInput.text.length > 0 ? 0 : 24
                visible: searchInput.text.length === 0

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    color: FishUI.Theme.disabledTextColor
                    font.bold: true
                    font.pointSize: 7.5
                    text: section.toUpperCase()
                }
            }

            FishUI.WheelHandler {
                target: listView
            }

            delegate: Item {
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                visible: searchInput.text.length === 0 ||
                         model.title.toLowerCase().indexOf(searchInput.text.toLowerCase()) !== -1 ||
                         model.category.toLowerCase().indexOf(searchInput.text.toLowerCase()) !== -1
                height: visible ? 34 : 0

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    antialiasing: true

                    color: {
                        if (item.isCurrent)
                            return "#007AFF"
                        else if (mouseArea.pressed)
                            return FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.08)
                        else if (mouseArea.containsMouse)
                            return FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(0, 0, 0, 0.04)
                        else
                            return "transparent"
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: listView.currentIndex = index
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 10

                    Rectangle {
                        id: iconRect
                        width: 22
                        height: 22
                        Layout.alignment: Qt.AlignVCenter
                        radius: 6
                        color: model.iconColor

                        Image {
                            id: icon
                            anchors.centerIn: parent
                            width: 14
                            height: width
                            source: "qrc:/images/sidebar/dark/" + model.iconSource
                            sourceSize: Qt.size(14, 14)
                            Layout.alignment: Qt.AlignVCenter
                            antialiasing: true
                            smooth: true
                        }
                    }

                    Label {
                        id: itemTitle
                        text: model.title
                        color: item.isCurrent ? "#FFFFFF" : (FishUI.Theme.darkMode ? FishUI.Theme.textColor : "#1D1D1F")
                        font.pointSize: 9
                        font.weight: item.isCurrent ? Font.DemiBold : Font.Normal
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    function removeItem(name) {
        for (var i = 0; i < listModel.count; ++i) {
            if (name === listModel.get(i).name) {
                listModel.remove(i)
                break
            }
        }
    }

    Battery {
        id: _battery

        Component.onCompleted: {
            if (!_battery.available)
                removeItem("battery")
        }
    }

    NM.EnabledConnections {
        id: nmEnabledConnections

        Component.onCompleted: {
            if (!nmEnabledConnections.wirelessHwEnabled)
                removeItem("wlan")
        }
    }

    Touchpad {
        id: _touchPad

        Component.onCompleted: {
            if (!_touchPad.available)
                removeItem("touchpad")
        }
    }
}
