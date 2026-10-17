/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Language & Region Settings
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI
import Cutefish.Settings 1.0 as Settings
import "./"

ItemPage {
    headerTitle: qsTr("Language & Region")

    Settings.Language {
        id: language
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            // SECTION: PREFERRED LANGUAGES
            Label {
                text: qsTr("PREFERRED LANGUAGES")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 0

                ListView {
                    id: listView
                    Layout.fillWidth: true
                    interactive: false
                    spacing: 0

                    Layout.preferredHeight: {
                        var totalHeight = 0
                        for (var i = 0; i < listView.visibleChildren.length; ++i) {
                            totalHeight += listView.visibleChildren[i].height
                        }
                        return totalHeight
                    }

                    model: language.languages
                    currentIndex: language.currentLanguage

                    delegate: ColumnLayout {
                        width: listView.width
                        spacing: 0

                        property bool isSelected: index === language.currentLanguage

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 46

                            Rectangle {
                                anchors.fill: parent
                                color: itemMouse.containsMouse ? (FishUI.Theme.darkMode ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.03)) : "transparent"
                                radius: 6
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: language.setCurrentLanguage(index)
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 10

                                Label {
                                    text: modelData
                                    font.pixelSize: 13
                                    font.weight: isSelected ? Font.Medium : Font.Normal
                                    color: FishUI.Theme.textColor
                                    Layout.fillWidth: true
                                }

                                Image {
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(16, 16)
                                    source: "qrc:/images/dark/checked.svg"
                                    visible: isSelected
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        HorizontalDivider {
                            visible: index < listView.count - 1
                        }
                    }
                }
            }

            // SECTION: REGION & FORMATS
            Label {
                text: qsTr("REGION & FORMATS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 8
            }

            RoundedItem {
                spacing: 0

                StandardItem {
                    title: qsTr("Region")
                    value: qsTr("System Default")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Calendar")
                    value: qsTr("Gregorian")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Temperature")
                    value: qsTr("Celsius (°C)")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Measurement system")
                    value: qsTr("Metric")
                    showChevron: false
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("First day of week")
                    value: qsTr("Monday")
                    showChevron: false
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
