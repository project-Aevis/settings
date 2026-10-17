/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Sound Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import Cutefish.Audio 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Sound")

    function audioIcon(value) {
        if (value <= 0)
            return "audio-volume-muted-symbolic"
        else if (value <= 25)
            return "audio-volume-low-symbolic"
        else if (value <= 75)
            return "audio-volume-medium-symbolic"
        else
            return "audio-volume-high-symbolic"
    }

    function microphoneIcon(value) {
        if (value <= 25)
            return "audio-input-microphone-low-symbolic"
        else if (value <= 70)
            return "audio-input-microphone-medium-symbolic"
        else
            return "audio-input-microphone-high-symbolic"
    }

    SinkModel {
        id: paSinkModel
    }

    SourceModel {
        id: paSourceModel
    }

    PulseObjectFilterModel {
        id: paSinkFilterModel
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        sourceModel: paSinkModel
    }

    PulseObjectFilterModel {
        id: paSourceFilterModel
        sortRole: "SortByDefault"
        sortOrder: Qt.DescendingOrder
        filterOutInactiveDevices: true
        sourceModel: paSourceModel
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: SOUND EFFECTS
            Label {
                text: qsTr("SOUND EFFECTS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Alert sound")
                    value: qsTr("Default (Boop)")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Play sound on startup")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Play user interface sound effects")
                    showSwitch: true
                    checked: true
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Play feedback when volume is changed")
                    showSwitch: true
                    checked: true
                }
            }

            // SECTION: OUTPUT
            Label {
                text: qsTr("OUTPUT")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 12
                visible: sinks.count >= 1
            }

            RoundedItem {
                visible: sinks.count >= 1
                spacing: 0

                ListView {
                    id: sinks
                    Layout.fillWidth: true
                    interactive: false
                    spacing: 0

                    Layout.preferredHeight: {
                        var totalHeight = 0
                        for (var i = 0; i < sinks.visibleChildren.length; ++i) {
                            totalHeight += sinks.visibleChildren[i].height
                        }
                        return totalHeight
                    }

                    model: paSinkFilterModel

                    delegate: ColumnLayout {
                        width: sinks.width
                        spacing: 0

                        readonly property var currentPort: Ports[ActivePortIndex]

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 64

                            RowLayout {
                                anchors.fill: parent
                                spacing: 14

                                ColumnLayout {
                                    Layout.preferredWidth: 160
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 2

                                    Label {
                                        text: !currentPort ? Description : currentPort.description
                                        font.pointSize: 9
                                        color: FishUI.Theme.textColor
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Label {
                                        text: qsTr("Built-in Output")
                                        font.pointSize: 7.5
                                        color: FishUI.Theme.disabledTextColor
                                    }
                                }

                                Image {
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(width, height)
                                    source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/" + audioIcon(slider.value / slider.to * 100) + ".svg"
                                    smooth: false
                                    antialiasing: true
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Slider {
                                    id: slider
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    value: Volume
                                    from: PulseAudio.MinimalVolume
                                    to: PulseAudio.NormalVolume
                                    enabled: VolumeWritable
                                    visible: HasVolume

                                    ToolTip {
                                        parent: slider.handle
                                        visible: slider.pressed
                                        text: (slider.value / slider.to * 100).toFixed(0) + "%"
                                    }

                                    onMoved: {
                                        Volume = value
                                        Muted = (value === 0)
                                    }
                                }

                                Label {
                                    text: (slider.value / slider.to * 100).toFixed(0) + "%"
                                    font.pointSize: 8
                                    color: FishUI.Theme.disabledTextColor
                                    Layout.preferredWidth: 36
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        HorizontalDivider {
                            visible: index < sinks.count - 1
                        }
                    }
                }
            }

            // SECTION: INPUT
            Label {
                text: qsTr("INPUT")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 12
                visible: sinkInputView.count >= 1
            }

            RoundedItem {
                visible: sinkInputView.count >= 1
                spacing: 0

                ListView {
                    id: sinkInputView
                    Layout.fillWidth: true
                    interactive: false
                    spacing: 0

                    Layout.preferredHeight: {
                        var totalHeight = 0
                        for (var i = 0; i < sinkInputView.visibleChildren.length; ++i) {
                            totalHeight += sinkInputView.visibleChildren[i].height
                        }
                        return totalHeight
                    }

                    model: paSourceFilterModel

                    delegate: ColumnLayout {
                        width: sinkInputView.width
                        spacing: 0

                        readonly property var currentPort: Ports[ActivePortIndex]

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 64

                            RowLayout {
                                anchors.fill: parent
                                spacing: 14

                                ColumnLayout {
                                    Layout.preferredWidth: 160
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 2

                                    Label {
                                        text: !currentPort ? Description : currentPort.description
                                        font.pointSize: 9
                                        color: FishUI.Theme.textColor
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Label {
                                        text: qsTr("Built-in Microphone")
                                        font.pointSize: 7.5
                                        color: FishUI.Theme.disabledTextColor
                                    }
                                }

                                Image {
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(width, height)
                                    source: "qrc:/images/" + (FishUI.Theme.darkMode ? "dark" : "light") + "/" + microphoneIcon(_slider.value / _slider.to * 100) + ".svg"
                                    smooth: false
                                    antialiasing: true
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Slider {
                                    id: _slider
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    value: Volume
                                    from: PulseAudio.MinimalVolume
                                    to: PulseAudio.NormalVolume
                                    enabled: VolumeWritable
                                    visible: HasVolume

                                    onMoved: {
                                        Volume = value
                                        Muted = (value === 0)
                                    }

                                    ToolTip {
                                        parent: _slider.handle
                                        visible: _slider.pressed
                                        text: (_slider.value / _slider.to * 100).toFixed(0) + "%"
                                    }
                                }

                                Label {
                                    text: (_slider.value / _slider.to * 100).toFixed(0) + "%"
                                    font.pointSize: 8
                                    color: FishUI.Theme.disabledTextColor
                                    Layout.preferredWidth: 36
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        HorizontalDivider {
                            visible: index < sinkInputView.count - 1
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
