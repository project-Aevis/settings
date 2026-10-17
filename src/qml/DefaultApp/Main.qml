/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Default Applications Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Default Applications")

    DefaultApplications {
        id: defaultApps
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: DEFAULT APPLICATIONS
            Label {
                text: qsTr("DEFAULT APPLICATIONS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                // Web Browser
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Default web browser")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                            enabled: browserComboBox.count !== 0
                        }

                        FishUI.ComboBox {
                            id: browserComboBox
                            Layout.preferredWidth: 220
                            textRole: "name"
                            model: defaultApps.browserList
                            currentIndex: defaultApps.browserIndex >= 0 ? defaultApps.browserIndex : (defaultApps.browserList.length > 0 ? 0 : -1)
                            enabled: count !== 0
                            onActivated: defaultApps.setDefaultBrowser(currentIndex)
                        }
                    }
                }

                HorizontalDivider {}

                // File Manager
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("File manager")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                            enabled: fileManagerComboBox.count !== 0
                        }

                        FishUI.ComboBox {
                            id: fileManagerComboBox
                            Layout.preferredWidth: 220
                            textRole: "name"
                            model: defaultApps.fileManagerList
                            currentIndex: defaultApps.fileManagerIndex >= 0 ? defaultApps.fileManagerIndex : (defaultApps.fileManagerList.length > 0 ? 0 : -1)
                            enabled: count !== 0
                            onActivated: defaultApps.setDefaultFileManager(currentIndex)
                        }
                    }
                }

                HorizontalDivider {}

                // Email Client
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Email reader")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                            enabled: emailComboBox.count !== 0
                        }

                        FishUI.ComboBox {
                            id: emailComboBox
                            Layout.preferredWidth: 220
                            textRole: "name"
                            model: defaultApps.emailList
                            currentIndex: defaultApps.emailIndex >= 0 ? defaultApps.emailIndex : (defaultApps.emailList.length > 0 ? 0 : -1)
                            enabled: count !== 0
                            onActivated: defaultApps.setDefaultEMail(currentIndex)
                        }
                    }
                }

                HorizontalDivider {}

                // Terminal
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Terminal emulator")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                            enabled: terminalComboBox.count !== 0
                        }

                        FishUI.ComboBox {
                            id: terminalComboBox
                            Layout.preferredWidth: 220
                            textRole: "name"
                            model: defaultApps.terminalList
                            currentIndex: defaultApps.terminalIndex >= 0 ? defaultApps.terminalIndex : (defaultApps.terminalList.length > 0 ? 0 : -1)
                            enabled: count !== 0
                            onActivated: defaultApps.setDefaultTerminal(currentIndex)
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
