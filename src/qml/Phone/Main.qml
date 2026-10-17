/*
 * Copyright (C) 2024 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * KDE Connect Integration Page.
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs
import Cutefish.Settings 1.0
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    id: root
    headerTitle: qsTr("KDE Connect")

    ContinuityManager {
        id: continuity
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Select File to Send via KDE Connect")
        onAccepted: {
            var path = selectedFile.toString()
            if (path.indexOf("file://") === 0)
                path = path.substring(7)
            continuity.shareFile(path)
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: contentCol.implicitHeight + FishUI.Units.largeSpacing * 2

        ColumnLayout {
            id: contentCol
            anchors.fill: parent
            spacing: FishUI.Units.largeSpacing * 2

            // Top Hero Card: Connected Phone
            RoundedItem {
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    spacing: FishUI.Units.largeSpacing * 2

                    // Vector Phone Graphic
                    Rectangle {
                        width: 72
                        height: 120
                        radius: FishUI.Theme.mediumRadius
                        color: FishUI.Theme.darkMode ? "#1C1C1E" : "#E5E5EA"
                        border.color: continuity.isConnected
                                      ? FishUI.Theme.greenColor
                                      : (FishUI.Theme.darkMode ? "#48484A" : "#C7C7CC")
                        border.width: 2

                        // Screen glass
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: FishUI.Theme.smallRadius
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: FishUI.Theme.darkMode ? "#2C2C2E" : "#F2F2F7" }
                                GradientStop { position: 1.0; color: FishUI.Theme.darkMode ? "#1C1C1E" : "#E5E5EA" }
                            }

                            // Dynamic Island pill
                            Rectangle {
                                anchors.top: parent.top
                                anchors.topMargin: 4
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 22
                                height: 6
                                radius: 3
                                color: FishUI.Theme.darkMode ? "#000000" : "#8E8E93"
                            }

                            // Center Phone Glyph
                            Image {
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                source: "qrc:/images/sidebar/" + (FishUI.Theme.darkMode ? "dark/" : "light/") + "phone.svg"
                                opacity: continuity.isConnected ? 0.9 : 0.4
                            }

                            // Home indicator line
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 4
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 20
                                height: 2
                                radius: 1
                                color: FishUI.Theme.disabledTextColor
                            }
                        }
                    }

                    // Device Details & Status
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: FishUI.Units.smallSpacing

                        RowLayout {
                            spacing: FishUI.Units.smallSpacing

                            Label {
                                text: continuity.isConnected ? (continuity.deviceName.length > 0 ? continuity.deviceName : qsTr("Connected Device")) : qsTr("No Device Connected")
                                font.family: FishUI.Theme.fontFamily
                                font.bold: true
                                font.pixelSize: 20
                                color: FishUI.Theme.textColor
                            }

                            // Online dot badge
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: continuity.isConnected ? FishUI.Theme.greenColor : FishUI.Theme.disabledTextColor
                            }
                        }

                        Label {
                            text: continuity.isConnected ? (qsTr("Connected") +
                                  (continuity.networkType.length > 0 ? (" • " + continuity.networkType) : "") +
                                  (continuity.batteryCharge >= 0 ? (" • " + continuity.batteryCharge + "% " + qsTr("Battery")) : "") +
                                  (continuity.isCharging ? " ⚡" : ""))
                                : qsTr("Pair an Android, iOS, or Linux device using KDE Connect")
                            font.family: FishUI.Theme.fontFamily
                            color: FishUI.Theme.disabledTextColor
                            font.pixelSize: 13
                        }

                        // Battery Bar (only when connected and battery known)
                        Rectangle {
                            visible: continuity.isConnected && continuity.batteryCharge >= 0
                            Layout.preferredWidth: 200
                            height: 10
                            radius: 5
                            color: Qt.rgba(0.5, 0.5, 0.5, 0.2)

                            Rectangle {
                                width: Math.max(8, parent.width * (Math.max(0, continuity.batteryCharge) / 100))
                                height: parent.height
                                radius: 5
                                color: continuity.batteryCharge > 20 ? FishUI.Theme.greenColor : FishUI.Theme.redColor
                            }
                        }

                        Item { height: FishUI.Units.smallSpacing }

                        // Quick Action Buttons
                        RowLayout {
                            spacing: FishUI.Units.largeSpacing

                            Button {
                                visible: !continuity.isConnected
                                text: qsTr("Pair Device / Open KDE Connect")
                                onClicked: continuity.openKdeConnect()
                            }

                            Button {
                                visible: !continuity.isConnected
                                text: qsTr("Check Again")
                                onClicked: continuity.refresh()
                            }

                            Button {
                                visible: continuity.isConnected
                                text: qsTr("Ring Device")
                                onClicked: continuity.ringPhone()
                            }

                            Button {
                                visible: continuity.isConnected
                                text: qsTr("Send File")
                                onClicked: fileDialog.open()
                            }

                            Button {
                                visible: continuity.isConnected
                                text: qsTr("Send Ping")
                                onClicked: continuity.sendPing()
                            }
                        }
                    }
                }
            }

            // Continuity Features Group
            ColumnLayout {
                Layout.fillWidth: true
                spacing: FishUI.Units.smallSpacing

                Label {
                    text: qsTr("Integration Features")
                    font.family: FishUI.Theme.fontFamily
                    font.bold: true
                    color: FishUI.Theme.disabledTextColor
                    leftPadding: FishUI.Units.smallSpacing
                }

                RoundedItem {
                    Layout.fillWidth: true

                    StandardItem {
                        title: qsTr("Universal Clipboard")
                        subtitle: qsTr("Seamlessly copy and paste text and images between your phone and computer")
                        checked: continuity.clipboardSync
                        showSwitch: true
                        onClicked: continuity.setClipboardSync(!continuity.clipboardSync)
                    }

                    HorizontalDivider {}

                    StandardItem {
                        title: qsTr("Notification Mirroring")
                        subtitle: qsTr("Show incoming phone notifications in Notification Center")
                        checked: continuity.notificationSync
                        showSwitch: true
                        onClicked: continuity.setNotificationSync(!continuity.notificationSync)
                    }

                    HorizontalDivider {}

                    StandardItem {
                        title: qsTr("Show Status in Menu Bar")
                        subtitle: qsTr("Display phone status and quick actions in the top status bar")
                        checked: continuity.showInMenuBar
                        showSwitch: true
                        onClicked: continuity.setShowInMenuBar(!continuity.showInMenuBar)
                    }
                }
            }

            // Device & KDE Connect Integration Group
            ColumnLayout {
                Layout.fillWidth: true
                spacing: FishUI.Units.smallSpacing

                Label {
                    text: qsTr("Integration & Connection")
                    font.family: FishUI.Theme.fontFamily
                    font.bold: true
                    color: FishUI.Theme.disabledTextColor
                    leftPadding: FishUI.Units.smallSpacing
                }

                RoundedItem {
                    Layout.fillWidth: true

                    StandardItem {
                        title: qsTr("Protocol Provider")
                        value: continuity.kdeConnectActive ? qsTr("KDE Connect D-Bus (Active)") : qsTr("KDE Connect (Inactive)")
                    }

                    HorizontalDivider {}

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Device Name")
                            font.family: FishUI.Theme.fontFamily
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                        }

                        Item { Layout.fillWidth: true }

                        TextField {
                            text: continuity.deviceName
                            onEditingFinished: continuity.setDeviceName(text)
                        }
                    }

                    HorizontalDivider {}

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Connection State")
                            font.family: FishUI.Theme.fontFamily
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: continuity.isConnected ? qsTr("Disconnect") : qsTr("Connect")
                            onClicked: continuity.toggleConnect()
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: FishUI.Units.largeSpacing
            }
        }
    }
}
