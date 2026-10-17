/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Trackpad Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Trackpad")

    Touchpad {
        id: touchpad

        Component.onCompleted: {
            accelSpeedSlider.load()
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: TRACKPAD
            Label {
                text: qsTr("TRACKPAD")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Enable Trackpad")
                    showSwitch: true
                    checked: touchpad.enabled
                    onClicked: touchpad.enabled = checked
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Tap to click")
                    subtitle: qsTr("Tap with one finger to click")
                    showSwitch: true
                    checked: touchpad.tapToClick
                    onClicked: touchpad.tapToClick = checked
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Natural scrolling")
                    subtitle: qsTr("Content tracks finger movement")
                    showSwitch: true
                    checked: touchpad.naturalScroll
                    onClicked: touchpad.naturalScroll = checked
                }

                HorizontalDivider {}

                // Tracking speed slider
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("Tracking speed")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.preferredWidth: 120
                        }

                        Label {
                            text: qsTr("Slow")
                            font.pointSize: 7.5
                            color: FishUI.Theme.disabledTextColor
                        }

                        Slider {
                            id: accelSpeedSlider
                            Layout.fillWidth: true
                            from: 1
                            to: 11
                            stepSize: 1
                            property int accelSpeedValue: 0

                            function load() {
                                accelSpeedValue = Math.round(touchpad.pointerAcceleration * 100)
                                value = Math.round(6 + touchpad.pointerAcceleration / 0.2)
                            }

                            function onAccelSpeedChanged(val) {
                                if (val !== accelSpeedSlider.accelSpeedValue) {
                                    accelSpeedSlider.accelSpeedValue = val
                                    accelSpeedSlider.value = Math.round(6 + (val / 100) / 0.2)
                                }
                                if ((val / 100) !== touchpad.pointerAcceleration) {
                                    touchpad.pointerAcceleration = val / 100
                                }
                            }

                            onMoved: {
                                if (touchpad !== undefined) {
                                    accelSpeedValue = Math.round(((value - 6) * 0.2) * 100)
                                    onAccelSpeedChanged(accelSpeedValue)
                                }
                            }
                        }

                        Label {
                            text: qsTr("Fast")
                            font.pointSize: 7.5
                            color: FishUI.Theme.disabledTextColor
                        }
                    }
                }
            }

            // SECTION: GESTURES
            Label {
                text: qsTr("SCROLL & ZOOM GESTURES")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Zoom in or out")
                    subtitle: qsTr("Pinch with two fingers")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Smart zoom")
                    subtitle: qsTr("Double-tap with two fingers")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Swipe between pages")
                    subtitle: qsTr("Scroll left or right with two fingers")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Mission Control / Overview")
                    subtitle: qsTr("Swipe up with three fingers")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Swipe between full-screen apps")
                    subtitle: qsTr("Swipe left or right with three fingers")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("App Grid / Launchpad")
                    subtitle: qsTr("Pinch with thumb and three fingers")
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
