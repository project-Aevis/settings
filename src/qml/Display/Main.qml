/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Displays Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Cutefish.Settings 1.0
import Cutefish.Screen 1.0 as CS
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    headerTitle: qsTr("Displays")

    Brightness {
        id: brightness
    }

    CS.Screen {
        id: screen
    }

    Timer {
        id: brightnessTimer
        interval: 100
        repeat: false
        onTriggered: {
            brightness.setValue(brightnessSlider.value)
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // macOS Display Hero Preview
            Item {
                Layout.fillWidth: true
                implicitHeight: 120
                Layout.topMargin: 4
                Layout.bottomMargin: 8

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    // Monitor graphic
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 100
                        height: 64
                        radius: 6
                        color: FishUI.Theme.darkMode ? "#1E1E1E" : "#E2E2E7"
                        border.width: 3
                        border.color: FishUI.Theme.darkMode ? "#3A3A3C" : "#D1D1D6"

                        // Inner display screen
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: 3
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#007AFF" }
                                GradientStop { position: 1.0; color: "#5856D6" }
                            }
                        }
                    }

                    // Display stand
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 24
                        height: 8
                        color: FishUI.Theme.darkMode ? "#3A3A3C" : "#D1D1D6"
                        radius: 2
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: _screenView.currentItem && _screenView.currentItem.element ? _screenView.currentItem.element.display : qsTr("Built-in Display")
                        font.pointSize: 9
                        font.weight: Font.DemiBold
                        color: FishUI.Theme.textColor
                    }
                }
            }

            // SECTION: BRIGHTNESS
            Label {
                text: qsTr("BRIGHTNESS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                visible: brightness.enabled
            }

            RoundedItem {
                visible: brightness.enabled
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Image {
                            width: 16
                            height: 16
                            sourceSize: Qt.size(width, height)
                            source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-low-symbolic.svg"
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Slider {
                            id: brightnessSlider
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            value: brightness.value
                            from: 1
                            to: 100
                            stepSize: 1
                            onMoved: brightnessTimer.start()

                            ToolTip {
                                parent: brightnessSlider.handle
                                visible: brightnessSlider.pressed
                                text: brightnessSlider.value.toFixed(0) + "%"
                            }
                        }

                        Image {
                            width: 16
                            height: 16
                            sourceSize: Qt.size(width, height)
                            source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-symbolic.svg"
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Label {
                            text: brightnessSlider.value.toFixed(0) + "%"
                            font.pointSize: 8
                            color: FishUI.Theme.disabledTextColor
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Automatically adjust brightness")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Night Shift")
                    subtitle: qsTr("Automatically shift display colors toward the warmer end of the spectrum")
                    showSwitch: true
                    checked: false
                }
            }

            // SECTION: RESOLUTION & SCALING
            Label {
                text: qsTr("RESOLUTION & SCALING")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 12
                visible: _screenView.count > 0
            }

            RoundedItem {
                visible: _screenView.count > 0
                spacing: 0

                // Scale Row
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 46

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        Label {
                            text: qsTr("UI Scaling")
                            font.pointSize: 9
                            color: FishUI.Theme.textColor
                            Layout.fillWidth: true
                        }

                        FishUI.SegmentedControl {
                            id: scaleControl
                            Layout.preferredWidth: 280

                            TabButton { text: "100%" }
                            TabButton { text: "125%" }
                            TabButton { text: "150%" }
                            TabButton { text: "175%" }
                            TabButton { text: "200%" }

                            currentIndex: {
                                var output = _screenView.currentItem ? _screenView.currentItem.element : null
                                var scale = output ? output.scale : 1.0
                                if (scale <= 1.0) return 0;
                                if (scale <= 1.25) return 1;
                                if (scale <= 1.50) return 2;
                                if (scale <= 1.75) return 3;
                                return 4;
                            }

                            onActivated: function(index) {
                                var scales = [1.0, 1.25, 1.50, 1.75, 2.0];
                                var value = scales[index];
                                var output = _screenView.currentItem ? _screenView.currentItem.element : null
                                if (output && output.scale !== value) {
                                    output.scale = value
                                    screen.save()
                                }
                            }
                        }
                    }
                }

                HorizontalDivider {}

                // Screen view with Resolution & Refresh rate
                ListView {
                    id: _screenView
                    Layout.fillWidth: true
                    model: screen.outputModel
                    orientation: ListView.Horizontal
                    interactive: false
                    currentIndex: 0
                    clip: true

                    Layout.preferredHeight: currentItem ? currentItem.implicitHeight : 0

                    delegate: ColumnLayout {
                        id: screenDelegate
                        width: _screenView.width
                        spacing: 0

                        property var element: model

                        // Resolution row
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 46

                            RowLayout {
                                anchors.fill: parent
                                spacing: 12

                                Label {
                                    text: qsTr("Resolution")
                                    font.pointSize: 9
                                    color: FishUI.Theme.textColor
                                    Layout.fillWidth: true
                                }

                                ComboBox {
                                    id: resCombo
                                    Layout.preferredWidth: 200
                                    model: element.resolutions
                                    currentIndex: element.resolutionIndex !== undefined ? element.resolutionIndex : -1
                                    onActivated: {
                                        element.resolutionIndex = currentIndex
                                        screen.save()
                                    }
                                }
                            }
                        }

                        HorizontalDivider {}

                        // Refresh rate row
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 46

                            RowLayout {
                                anchors.fill: parent
                                spacing: 12

                                Label {
                                    text: qsTr("Refresh rate")
                                    font.pointSize: 9
                                    color: FishUI.Theme.textColor
                                    Layout.fillWidth: true
                                }

                                ComboBox {
                                    id: refreshRateCombo
                                    Layout.preferredWidth: 200
                                    model: element.refreshRates
                                    currentIndex: element.refreshRateIndex ? element.refreshRateIndex : 0
                                    onActivated: {
                                        element.refreshRateIndex = currentIndex
                                        screen.save()
                                    }
                                }
                            }
                        }

                        HorizontalDivider {}

                        // Rotation row
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 52

                            RowLayout {
                                anchors.fill: parent
                                spacing: 12

                                Label {
                                    text: qsTr("Rotation")
                                    font.pointSize: 9
                                    color: FishUI.Theme.textColor
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    spacing: 8
                                    RotationButton { value: 0 }
                                    RotationButton { value: 90 }
                                    RotationButton { value: 180 }
                                    RotationButton { value: 270 }
                                }
                            }
                        }
                    }
                }
            }

            PageIndicator {
                id: screenPageIndicator
                Layout.alignment: Qt.AlignHCenter
                count: _screenView.count
                currentIndex: _screenView.currentIndex
                onCurrentIndexChanged: _screenView.currentIndex = currentIndex
                interactive: true
                visible: count > 1
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
