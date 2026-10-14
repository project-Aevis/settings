/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 *
 * macOS Inset Grouped Software Update Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    headerTitle: qsTr("Software Update")

    property bool isChecking: false
    property string lastChecked: qsTr("Today, 3:30 AM")

    Timer {
        id: checkTimer
        interval: 1800
        repeat: false
        onTriggered: {
            isChecking = false
            var now = new Date()
            lastChecked = qsTr("Today, ") + now.toLocaleTimeString(Qt.locale(), "h:mm AP")
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // Status Card Hero
            RoundedItem {
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 110

                    RowLayout {
                        anchors.fill: parent
                        spacing: 20

                        // Update Badge Icon
                        Rectangle {
                            width: 60
                            height: 60
                            radius: 14
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#007AFF" }
                                GradientStop { position: 1.0; color: "#0051B3" }
                            }
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.centerIn: parent
                                width: 32
                                height: 32
                                sourceSize: Qt.size(width, height)
                                source: "qrc:/images/view-refresh.svg"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 4

                            Label {
                                text: isChecking ? qsTr("Checking for updates...") : qsTr("Cutefish Edition 26.04")
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: FishUI.Theme.textColor
                            }

                            Label {
                                text: isChecking ? qsTr("Connecting to software repository...") : qsTr("Your system is up to date.")
                                font.pixelSize: 11
                                color: FishUI.Theme.disabledTextColor
                            }

                            Label {
                                text: qsTr("Last checked: ") + lastChecked
                                font.pixelSize: 10
                                color: FishUI.Theme.disabledTextColor
                            }
                        }

                        // Check Now Button
                        Button {
                            text: isChecking ? qsTr("Checking...") : qsTr("Check for Updates")
                            enabled: !isChecking
                            Layout.alignment: Qt.AlignVCenter
                            onClicked: {
                                isChecking = true
                                checkTimer.start()
                            }
                        }
                    }
                }
            }

            // SECTION: AUTOMATIC UPDATES
            Label {
                text: qsTr("AUTOMATIC UPDATES")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Automatic Updates")
                    subtitle: qsTr("Download new updates when available and install system security responses")
                    value: qsTr("On")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Check for updates automatically")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Download new updates when available")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Install Cutefish security responses and system files")
                    showSwitch: true
                    checked: true
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
