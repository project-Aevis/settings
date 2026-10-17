/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Mouse Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0
import Cutefish.Accounts 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Mouse")

    CursorThemeModel {
        id: cursorModel
    }

    Mouse {
        id: mouse
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: MOUSE
            Label {
                text: qsTr("MOUSE")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Primary mouse button")
                    subtitle: qsTr("Choose left or right button for main click actions")
                    value: mouse.leftHanded ? qsTr("Right") : qsTr("Left")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Left-handed mouse")
                    subtitle: qsTr("Swap primary and secondary buttons")
                    showSwitch: true
                    checked: mouse.leftHanded
                    onClicked: mouse.leftHanded = checked
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Natural scrolling")
                    subtitle: qsTr("Content tracks finger movement on scroll wheel")
                    showSwitch: true
                    checked: mouse.naturalScroll
                    onClicked: mouse.naturalScroll = checked
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
                            id: accelerationSlider
                            Layout.fillWidth: true
                            from: 1
                            to: 11
                            stepSize: 1

                            Component.onCompleted: {
                                value = 6 + mouse.pointerAcceleration / 0.2
                            }

                            onValueChanged: {
                                mouse.pointerAcceleration = Math.round(((value - 6) * 0.2) * 10) / 10
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

            // SECTION: POINTER THEMES
            Label {
                text: qsTr("POINTER THEME")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
                visible: _view.count > 0
            }

            RoundedItem {
                visible: _view.count > 0
                spacing: 8

                GridView {
                    id: _view
                    Layout.fillWidth: true
                    implicitHeight: Math.ceil(_view.count / Math.max(1, Math.floor(_view.width / itemWidth))) * cellHeight + 10
                    model: cursorModel
                    interactive: false
                    leftMargin: 0
                    rightMargin: 0

                    property int itemWidth: 120
                    property int itemHeight: 96
                    cellHeight: itemHeight
                    cellWidth: itemWidth

                    currentIndex: cursorModel.themeIndex(cursorModel.currentTheme)

                    delegate: Item {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight

                        property bool isCurrent: _view.currentIndex === index

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            color: isCurrent ? (FishUI.Theme.darkMode ? Qt.rgba(0, 0.48, 1, 0.2) : "#E8F0FE") : (mouseArea.containsMouse ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(0, 0, 0, 0.04)) : "transparent")
                            radius: 8
                            border.width: isCurrent ? 2 : 1
                            border.color: isCurrent ? "#007AFF" : (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.08))

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 6

                                FishUI.IconItem {
                                    width: 28
                                    height: 28
                                    source: model.image
                                    smooth: true
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Label {
                                    text: model.name
                                    font.pixelSize: 11
                                    font.weight: isCurrent ? Font.Medium : Font.Normal
                                    color: isCurrent ? "#007AFF" : FishUI.Theme.textColor
                                    Layout.alignment: Qt.AlignHCenter
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 100
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                _view.currentIndex = index
                                cursorModel.currentTheme = model.id
                            }
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
