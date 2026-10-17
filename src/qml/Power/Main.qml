/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Energy Saver Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Cutefish.Settings 1.0
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    id: control
    headerTitle: qsTr("Energy Saver")

    PowerManager {
        id: power
    }

    Battery {
        id: battery
    }

    property var timeoutValues: [60, 120, 300, 600, 900, 1200, 1800, -1]

    function timeoutToIndex(timeout) {
        var index = timeoutValues.indexOf(timeout)
        return index >= 0 ? index : timeoutValues.indexOf(300)
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: ENERGY MODE
            Label {
                text: qsTr("ENERGY MODE")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Power Mode")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        FishUI.SegmentedControl {
                            Layout.preferredWidth: 240
                            currentIndex: power.mode === 1 ? 1 : 0

                            TabButton {
                                text: qsTr("Power Save")
                                onClicked: power.mode = 0
                            }

                            TabButton {
                                text: qsTr("Performance")
                                onClicked: power.mode = 1
                            }
                        }
                    }
                }
            }

            Label {
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.rightMargin: 4
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: 10
                text: qsTr("Performance mode maximizes CPU and GPU frequencies for intensive workloads, while Power Save mode conserves energy.")
            }

            // SECTION: DISPLAY SLEEP
            Label {
                text: qsTr("DISPLAY SLEEP")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
            }

            RoundedItem {
                spacing: 0

                // Battery sleep row
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46
                    visible: battery.available

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Turn off display when inactive on battery")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.preferredWidth: 160
                            model: [qsTr("1 Minute"), qsTr("2 Minutes"), qsTr("5 Minutes"),
                                    qsTr("10 Minutes"), qsTr("15 Minutes"), qsTr("20 Minutes"),
                                    qsTr("30 Minutes"), qsTr("Never")]
                            currentIndex: timeoutToIndex(power.batteryScreenOff)
                            onActivated: power.batteryScreenOff = timeoutValues[currentIndex]
                        }
                    }
                }

                HorizontalDivider {
                    visible: battery.available
                }

                // AC sleep row
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Turn off display when inactive on power adapter")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        ComboBox {
                            Layout.preferredWidth: 160
                            model: [qsTr("1 Minute"), qsTr("2 Minutes"), qsTr("5 Minutes"),
                                    qsTr("10 Minutes"), qsTr("15 Minutes"), qsTr("20 Minutes"),
                                    qsTr("30 Minutes"), qsTr("Never")]
                            currentIndex: timeoutToIndex(power.acScreenOff)
                            onActivated: power.acScreenOff = timeoutValues[currentIndex]
                        }
                    }
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Prevent automatic sleeping when display is off")
                    showSwitch: true
                    checked: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Wake for network access")
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
