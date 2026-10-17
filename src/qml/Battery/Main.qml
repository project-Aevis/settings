/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Battery Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import "../"

ItemPage {
    id: batteryPage
    headerTitle: qsTr("Battery")

    property int historyType: BatteryHistoryModel.ChargeType
    readonly property var timespanComboDurations: [3600, 7200, 43200, 86400, 172800, 604800]
    readonly property int chargePercent: battery.chargePercent

    Battery {
        id: battery
    }

    BatteryHistoryModel {
        id: history
        duration: timespanComboDurations[3]
        device: battery.udi
        type: BatteryHistoryModel.ChargeType
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight
        visible: battery.available

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // macOS Battery Hero Card
            RoundedItem {
                Layout.fillWidth: true
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 90

                    RowLayout {
                        anchors.fill: parent
                        spacing: 16

                        // Battery Icon Container
                        Rectangle {
                            width: 54
                            height: 54
                            radius: 12
                            color: battery.chargePercent <= 20 ? "#FF3B30" : (battery.onBattery ? "#34C759" : "#30D158")
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.centerIn: parent
                                width: 28
                                height: 28
                                sourceSize: Qt.size(width, height)
                                source: "qrc:/images/sensors-voltage-symbolic.svg"
                                visible: !battery.onBattery
                            }

                            Label {
                                anchors.centerIn: parent
                                visible: battery.onBattery
                                text: battery.chargePercent + "%"
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: "white"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 4

                            RowLayout {
                                spacing: 8
                                Label {
                                    text: battery.chargePercent + "%"
                                    font.pixelSize: 24
                                    font.weight: Font.Bold
                                    color: FishUI.Theme.textColor
                                }

                                Rectangle {
                                    radius: 10
                                    color: FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.05)
                                    implicitWidth: statusText.implicitWidth + 14
                                    implicitHeight: 20
                                    Layout.alignment: Qt.AlignVCenter

                                    Label {
                                        id: statusText
                                        anchors.centerIn: parent
                                        text: battery.onBattery ? qsTr("On Battery") : qsTr("Power Adapter Connected")
                                        font.pixelSize: 10
                                        font.weight: Font.Medium
                                        color: FishUI.Theme.textColor
                                    }
                                }
                            }

                            Label {
                                text: battery.statusString.length > 0 ? battery.statusString : (battery.onBattery ? qsTr("Using battery power") : qsTr("Fully charged / charging"))
                                font.pixelSize: 11
                                color: FishUI.Theme.disabledTextColor
                            }
                        }
                    }
                }
            }

            // SECTION: BATTERY HEALTH
            Label {
                text: qsTr("BATTERY HEALTH")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
                visible: battery.capacity > 0
            }

            RoundedItem {
                visible: battery.capacity > 0
                spacing: 0

                StandardItem {
                    title: qsTr("Battery Health")
                    value: battery.capacity >= 80 ? qsTr("Normal") : qsTr("Service Recommended")
                    subtitle: qsTr("Maximum capacity: ") + battery.capacity + "%"
                    showChevron: false
                }

                HorizontalDivider {
                    visible: battery.lastChargedPercent !== 0
                }

                StandardItem {
                    title: qsTr("Last Charged to")
                    value: battery.lastChargedPercent + "%"
                    subtitle: battery.lastChargedTime
                    visible: battery.lastChargedPercent !== 0
                }
            }

            // SECTION: OPTIONS
            Label {
                text: qsTr("OPTIONS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Show percentage in menu bar")
                    showSwitch: true
                    checked: battery.showPercent
                    onClicked: battery.setPercentEnabled(checked)
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Optimized Battery Charging")
                    subtitle: qsTr("Reduces battery aging by learning your daily charging routine")
                    showSwitch: true
                    checked: true
                }
            }

            // SECTION: USAGE HISTORY
            Label {
                text: qsTr("LAST 24 HOURS USAGE")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
                visible: history.count > 2
            }

            RoundedItem {
                visible: history.count > 2
                spacing: 0

                HistoryGraph {
                    Layout.fillWidth: true
                    height: 220
                    data: history.points
                    xTicksAt: 4
                    xDivisionWidth: 1000 * 60 * 60 * 2
                    xMin: history.firstDataPointTime
                    xMax: history.lastDataPointTime
                    xDuration: history.duration
                    yUnits: "%"
                    yMax: 100
                    yStep: 20
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Label {
        anchors.centerIn: parent
        text: qsTr("No battery found")
        font.pixelSize: 14
        color: FishUI.Theme.disabledTextColor
        visible: !battery.available
    }
}
