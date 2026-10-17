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

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt5Compat.GraphicalEffects
import Cutefish.Settings 1.0
import Cutefish.Appearance 1.0 as FrameworkAppearance
import FishUI 1.0 as FishUI

import "../"

ItemPage {
    headerTitle: qsTr("Wallpaper")

    FrameworkAppearance.Wallpaper {
        id: background
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight + FishUI.Units.largeSpacing * 2

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: FishUI.Units.largeSpacing

            // SECTION: WALLPAPERS & COLORS
            Label {
                text: qsTr("WALLPAPERS & COLORS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                Layout.fillWidth: true
                implicitHeight: _wallCol.implicitHeight + FishUI.Units.largeSpacing * 2

                ColumnLayout {
                    id: _wallCol
                    anchors.fill: parent
                    anchors.margins: FishUI.Units.largeSpacing
                    spacing: FishUI.Units.largeSpacing

                    // Header: Background type & Segmented Control
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: FishUI.Units.largeSpacing * 2

                        Label {
                            text: qsTr("Background type")
                            font.bold: true
                            leftPadding: FishUI.Units.smallSpacing
                        }

                        Item { Layout.fillWidth: true }

                        FishUI.SegmentedControl {
                            Layout.preferredWidth: 200
                            currentIndex: background.type
                            onCurrentIndexChanged: {
                                background.type = currentIndex
                            }

                            TabButton {
                                text: qsTr("Picture")
                            }

                            TabButton {
                                text: qsTr("Color")
                            }
                        }
                    }

                    HorizontalDivider {
                        Layout.fillWidth: true
                    }

                    // Wallpaper GridView
                    GridView {
                        id: _view
                        Layout.fillWidth: true
                        visible: background.type === 0
                        clip: true
                        model: background.backgrounds
                        interactive: false

                        readonly property int itemTargetWidth: 180
                        readonly property int columns: Math.max(1, Math.floor(_view.width / itemTargetWidth))
                        readonly property int numRows: Math.ceil(Math.max(1, _view.count) / columns)

                        cellWidth: Math.floor(_view.width / columns)
                        cellHeight: Math.round(cellWidth * 9 / 16)
                        implicitHeight: numRows * cellHeight + FishUI.Units.largeSpacing

                        delegate: Item {
                            id: itemDelegate
                            property bool isSelected: modelData === background.path
                            width: _view.cellWidth
                            height: _view.cellHeight

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 6
                                radius: 12
                                color: "transparent"
                                border.width: isSelected ? 3 : 0
                                border.color: FishUI.Theme.highlightColor

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: isSelected ? 3 : 0
                                    radius: isSelected ? 9 : 12
                                    clip: true
                                    color: FishUI.Theme.darkMode ? "#2C2C2E" : "#E5E5EA"

                                    Image {
                                        id: _image
                                        anchors.fill: parent
                                        source: "file://" + modelData
                                        sourceSize: Qt.size(_view.cellWidth * Screen.devicePixelRatio, _view.cellHeight * Screen.devicePixelRatio)
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        smooth: true
                                        mipmap: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            background.path = modelData
                                        }
                                        onEntered: _image.opacity = 0.8
                                        onExited: _image.opacity = 1.0
                                    }
                                }
                            }
                        }
                    }

                    // Color Picker
                    Loader {
                        Layout.fillWidth: true
                        visible: background.type === 1
                        sourceComponent: colorView
                    }
                }
            }

            Item {
                height: FishUI.Units.largeSpacing
            }
        }
    }

    Component {
        id: colorView

        GridView {
            id: _colorView
            Layout.fillWidth: true

            readonly property int cellDim: 50
            readonly property int columns: Math.max(1, Math.floor(_colorView.width / cellDim))
            implicitHeight: Math.ceil(_colorView.count / columns) * cellDim + FishUI.Units.largeSpacing

            cellWidth: cellDim
            cellHeight: cellDim

            interactive: false
            model: ListModel {}

            property var itemSize: 32

            Component.onCompleted: {
                model.append({"bgColor": "#2B8ADA"})
                model.append({"bgColor": "#4DA4ED"})
                model.append({"bgColor": "#B7E786"})
                model.append({"bgColor": "#F2BB73"})
                model.append({"bgColor": "#EE72EB"})
                model.append({"bgColor": "#F0905A"})
                model.append({"bgColor": "#595959"})
                model.append({"bgColor": "#000000"})
            }

            delegate: Rectangle {
                property bool checked: Qt.colorEqual(background.color, bgColor)
                property color currentColor: bgColor

                width: _colorView.itemSize + FishUI.Units.largeSpacing
                height: width
                color: "transparent"
                radius: width / 2
                border.color: _mouseArea.pressed ? Qt.rgba(currentColor.r,
                                                           currentColor.g,
                                                           currentColor.b, 0.6)
                                                 : Qt.rgba(currentColor.r,
                                                           currentColor.g,
                                                           currentColor.b, 0.4)
                border.width: checked ? 3 : _mouseArea.containsMouse ? 2 : 0

                MouseArea {
                    id: _mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: background.color = bgColor
                }

                Rectangle {
                    width: 32
                    height: width
                    anchors.centerIn: parent
                    color: currentColor
                    radius: width / 2
                }
            }
        }
    }
}
