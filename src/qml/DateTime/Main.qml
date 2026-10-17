/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Date & Time Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Date & Time")

    TimeZoneDialog {
        id: timeZoneDialog
    }

    TimeZoneMap {
        id: timeZoneMap
    }

    Time {
        id: time
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: DATE & TIME
            Label {
                text: qsTr("DATE & TIME")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Set time and date automatically")
                    subtitle: !time.canNTP ? qsTr("NTP service required for auto-sync") : qsTr("Synchronize with network time servers")
                    showSwitch: true
                    checked: time.useNtp
                    enabled: time.canNTP
                    onClicked: time.useNtp = checked
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("24-Hour Time")
                    subtitle: qsTr("Display time in 24-hour format instead of 12-hour AM/PM")
                    showSwitch: true
                    checked: time.twentyFour
                    onClicked: time.twentyFour = checked
                }
            }

            // SECTION: TIME ZONE
            Label {
                text: qsTr("TIME ZONE")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Closest City / Time Zone")
                    value: timeZoneMap.currentTimeZone ? timeZoneMap.currentTimeZone : qsTr("Set Time Zone...")
                    showChevron: true
                    onClicked: timeZoneDialog.show()
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Set time zone automatically using current location")
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
