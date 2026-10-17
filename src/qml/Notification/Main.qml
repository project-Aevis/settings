/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Notification Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Notifications")

    Notifications {
        id: notifications
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: FOCUS & DO NOT DISTURB
            Label {
                text: qsTr("FOCUS & DO NOT DISTURB")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Do Not Disturb")
                    subtitle: qsTr("Silence calls and notifications when activated")
                    showSwitch: true
                    checked: notifications.doNotDisturb
                    onClicked: notifications.doNotDisturb = checked
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Silence notifications when display is sleeping")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Silence notifications when screen is locked")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Silence notifications when mirroring display")
                    showSwitch: true
                    checked: true
                }
            }

            // SECTION: NOTIFICATION PREVIEWS & SOUNDS
            Label {
                text: qsTr("NOTIFICATION STYLE & PREVIEWS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Show Previews")
                    value: qsTr("When Unlocked")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Play sound for notifications")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Show notification badges on Dock icons")
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
