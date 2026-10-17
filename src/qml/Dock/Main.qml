/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Desktop & Dock Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Cutefish.Settings 1.0
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    headerTitle: qsTr("Desktop & Dock")

    DockSettings {
        id: dockSettings
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: DOCK
            Label {
                text: qsTr("DOCK")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                // Dock Size Row
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Size")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.preferredWidth: 100
                        }

                        Label {
                            text: qsTr("Small")
                            font.pointSize: 7.5
                            color: FishUI.Theme.disabledTextColor
                        }

                        Slider {
                            id: sizeSlider
                            Layout.fillWidth: true
                            from: 36
                            to: 84
                            stepSize: 2
                            value: dockSettings.dockIconSize
                            onMoved: dockSettings.setDockIconSize(Math.round(value))
                        }

                        Label {
                            text: qsTr("Large")
                            font.pointSize: 7.5
                            color: FishUI.Theme.disabledTextColor
                        }
                    }
                }

                HorizontalDivider {}

                // Position on screen
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Position on screen")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        FishUI.SegmentedControl {
                            id: posControl
                            Layout.preferredWidth: 220
                            currentIndex: dockSettings.dockDirection

                            TabButton {
                                text: qsTr("Left")
                                onClicked: dockSettings.setDockDirection(0)
                            }
                            TabButton {
                                text: qsTr("Bottom")
                                onClicked: dockSettings.setDockDirection(1)
                            }
                            TabButton {
                                text: qsTr("Right")
                                onClicked: dockSettings.setDockDirection(2)
                            }
                        }
                    }
                }

                HorizontalDivider {}

                // Automatically hide and show Dock
                StandardItem {
                    title: qsTr("Automatically hide and show the Dock")
                    showSwitch: true
                    checked: dockSettings.dockVisibility !== 0
                    onClicked: dockSettings.setDockVisibility(checked ? 2 : 0)
                }

                HorizontalDivider {}

                // Dock Visibility Mode
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Display mode")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        FishUI.SegmentedControl {
                            Layout.preferredWidth: 260
                            currentIndex: dockSettings.dockVisibility

                            TabButton {
                                text: qsTr("Always Show")
                                onClicked: dockSettings.setDockVisibility(0)
                            }
                            TabButton {
                                text: qsTr("Always Hide")
                                onClicked: dockSettings.setDockVisibility(1)
                            }
                            TabButton {
                                text: qsTr("Smart Hide")
                                onClicked: dockSettings.setDockVisibility(2)
                            }
                        }
                    }
                }

                HorizontalDivider {}

                // Floating Rounded Window
                StandardItem {
                    title: qsTr("Floating rounded dock style")
                    subtitle: qsTr("Show dock with macOS curved floating margin")
                    showSwitch: true
                    checked: dockSettings.dockRoundedWindow
                    onClicked: dockSettings.setDockRoundedWindow(checked)
                }
            }

            // SECTION: WINDOWS & BEHAVIOR
            Label {
                text: qsTr("WINDOWS & BEHAVIOR")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 12
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Minimize windows into application icon")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Animate opening applications")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Show indicators for open applications")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Show recent applications in Dock")
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
