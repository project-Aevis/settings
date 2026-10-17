/*
 * Copyright (C) 2021 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
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
import Cutefish.Network 1.0 as NM

import "../"

ItemPage {
    id: control
    headerTitle: qsTr("Wi-Fi")

    property var itemHeight: 45
    property var settingsMap: ({})

    NM.Handler {
        id: handler
    }

    NM.WifiSettings {
        id: wifiSettings
    }

    NM.NetworkModel {
        id: networkModel
    }

    NM.EnabledConnections {
        id: enabledConnections
    }

    NM.IdentityModel {
        id: connectionModel
    }

    NM.Configuration {
        id: configuration
    }

    NewNetworkDialog {
        id: newNetworkDialog

        onConnect: {
            wifiSettings.addOtherConnection(ssid, username, pwd, type)
        }
    }

    Component.onCompleted: {
        handler.requestScan()
    }

    Timer {
        id: scanTimer
        interval: 10200
        repeat: true
        running: control.visible
        onTriggered: handler.requestScan()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: mainLayout.implicitHeight
        visible: enabledConnections.wirelessHwEnabled

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.bottomMargin: FishUI.Units.largeSpacing
            spacing: FishUI.Units.largeSpacing * 2

            RoundedItem {
                WifiView {
                    Layout.fillWidth: true
                    visible: enabledConnections.wirelessHwEnabled
                }
            }

            StandardButton {
                Layout.fillWidth: true
                text: qsTr("Add other...")
                onClicked: newNetworkDialog.show()
            }

            // Personal Hotspot
            RoundedItem {
                id: hotspotItem

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: FishUI.Units.smallSpacing

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("Personal Hotspot")
                            font.bold: true
                            color: FishUI.Theme.textColor
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Switch {
                            id: hotspotSwitch
                            Layout.alignment: Qt.AlignRight
                            onToggled: {
                                if (checked) {
                                    configuration.hotspotName = ssidName.text
                                    configuration.hotspotPassword = hotspotPassword.text
                                    handler.createHotspot()
                                } else {
                                    handler.stopHotspot()
                                }
                            }
                        }
                    }

                    Item { height: 4 }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: FishUI.Units.largeSpacing
                        rowSpacing: FishUI.Units.smallSpacing

                        Label {
                            text: qsTr("SSID")
                            color: FishUI.Theme.disabledTextColor
                        }

                        TextField {
                            id: ssidName
                            text: configuration.hotspotName.length > 0 ? configuration.hotspotName : "Aevis-Hotspot"
                            placeholderText: qsTr("SSID Name")
                            Layout.fillWidth: true
                        }

                        Label {
                            text: qsTr("Password")
                            color: FishUI.Theme.disabledTextColor
                        }

                        TextField {
                            id: hotspotPassword
                            echoMode: TextInput.Password
                            text: configuration.hotspotPassword.length > 0 ? configuration.hotspotPassword : "12345678"
                            placeholderText: qsTr("Password")
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Item {
                height: FishUI.Units.largeSpacing
            }
        }
    }
}
