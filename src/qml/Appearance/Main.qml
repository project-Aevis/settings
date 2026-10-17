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

import Cutefish.Settings 1.0
import Cutefish.Appearance 1.0 as FrameworkAppearance
import FishUI 1.0 as FishUI
import "../"

ItemPage {
    headerTitle: qsTr("Appearance")

    FrameworkAppearance.Appearance {
        id: appearance
    }

    IconThemeModel {
        id: iconThemeModel
    }

    FontsModel {
        id: fontsModel
    }

    Fonts {
        id: fonts
    }

    function updateFontSelection() {
        var currentGen = appearance.fontFamily || fontsModel.systemGeneralFont;
        for (var i in fontsModel.generalFonts) {
            if (currentGen === fontsModel.generalFonts[i]) {
                generalFontComboBox.currentIndex = i;
                break;
            }
        }

        var currentFixed = appearance.fixedFontFamily || fontsModel.systemFixedFont;
        for (i in fontsModel.fixedFonts) {
            if (currentFixed === fontsModel.fixedFonts[i]) {
                fixedFontComboBox.currentIndex = i;
                break;
            }
        }
    }

    Connections {
        target: fontsModel
        function onLoadFinished() {
            updateFontSelection();
        }
    }

    Connections {
        target: appearance
        function onFontFamilyChanged() {
            updateFontSelection();
        }
        function onFixedFontFamilyChanged() {
            updateFontSelection();
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: FishUI.Units.largeSpacing * 2

            Label {
                text: qsTr("APPEARANCE")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                spacing: 12

                // Light Mode and Dark Mode
                RowLayout {
                    spacing: FishUI.Units.largeSpacing * 2

                    IconCheckBox {
                        source: "qrc:/images/light_mode.svg"
                        text: qsTr("Light")
                        iconWidth: 120
                        iconHeight: iconWidth * 68 / 100
                        checked: !FishUI.Theme.darkMode
                        onClicked: appearance.switchDarkMode(false)
                    }

                    IconCheckBox {
                        source: "qrc:/images/dark_mode.svg"
                        text: qsTr("Dark")
                        iconWidth: 120
                        iconHeight: iconWidth * 68 / 100
                        checked: FishUI.Theme.darkMode
                        onClicked: appearance.switchDarkMode(true)
                    }
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Dim the wallpaper in Dark Mode")
                    checked: appearance.dimsWallpaper
                    showSwitch: true
                    onClicked: appearance.setDimsWallpaper(!appearance.dimsWallpaper)
                }

                HorizontalDivider {}

                StandardItem {
                    title: qsTr("Allow wallpaper tinting and blur in windows")
                    checked: appearance.blurEnabled
                    showSwitch: true
                    onClicked: appearance.setBlurEnabled(!appearance.blurEnabled)
                }
            }

            Label {
                text: qsTr("ACCENT COLOR")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                GridView {
                    id: accentColorView
                    height: itemSize
                    Layout.fillWidth: true
                    cellWidth: height
                    cellHeight: height
                    interactive: false
                    model: ListModel {}

                    property var itemSize: 30 + FishUI.Units.largeSpacing * 2

                    Component.onCompleted: {
                        model.append({"accentColor": String(FishUI.Theme.blueColor)})
                        model.append({"accentColor": String(FishUI.Theme.redColor)})
                        model.append({"accentColor": String(FishUI.Theme.greenColor)})
                        model.append({"accentColor": String(FishUI.Theme.purpleColor)})
                        model.append({"accentColor": String(FishUI.Theme.pinkColor)})
                        model.append({"accentColor": String(FishUI.Theme.orangeColor)})
                        model.append({"accentColor": String(FishUI.Theme.greyColor)})
                    }

                    delegate: Item {
                        id: _accentColorItem

                        property bool checked: Qt.colorEqual(FishUI.Theme.highlightColor, accentColor)
                        property color currentColor: accentColor

                        width: GridView.view.itemSize
                        height: width

                        MouseArea {
                            id: _mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: appearance.setAccentColor(index)
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: FishUI.Units.smallSpacing
                            color: "transparent"
                            radius: width / 2

                            border.color: _mouseArea.pressed ? Qt.rgba(currentColor.r,
                                                                       currentColor.g,
                                                                       currentColor.b, 0.6)
                                                             : Qt.rgba(currentColor.r,
                                                                       currentColor.g,
                                                                       currentColor.b, 0.4)
                            border.width: checked || _mouseArea.containsMouse ? 3 : 0

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: FishUI.Units.smallSpacing
                                color: currentColor
                                radius: width / 2

                                Image {
                                    anchors.centerIn: parent
                                    width: parent.height * 0.6
                                    height: width
                                    sourceSize: Qt.size(width, height)
                                    source: "qrc:/images/dark/checked.svg"
                                    visible: checked
                                }
                            }
                        }
                    }
                }
            }

            Label {
                text: qsTr("ICON PACKS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                GridLayout {
                    columns: 2
                    Layout.fillWidth: true
                    columnSpacing: FishUI.Units.largeSpacing * 1.5
                    rowSpacing: FishUI.Units.largeSpacing * 1.5

                    Label {
                        text: qsTr("Icon Theme")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    ComboBox {
                        id: iconThemeComboBox
                        model: iconThemeModel.installedThemes
                        Layout.fillWidth: true
                        topInset: 0
                        bottomInset: 0
                        leftPadding: FishUI.Units.largeSpacing
                        rightPadding: FishUI.Units.largeSpacing
                        currentIndex: {
                            if (!model || model.length === 0) return -1
                            var currentTheme = appearance.iconTheme
                            if (!currentTheme) currentTheme = "Cutefish"
                            var idx = model.indexOf(currentTheme)
                            return idx >= 0 ? idx : 0
                        }
                        onActivated: function(index) {
                            if (index >= 0 && index < model.length) {
                                appearance.setIconTheme(model[index])
                            }
                        }
                    }
                }
            }

            Label {
                text: qsTr("TYPOGRAPHY & FONTS")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: FishUI.Theme.disabledTextColor
                Layout.leftMargin: 4
                Layout.topMargin: 4
            }

            RoundedItem {
                Layout.bottomMargin: FishUI.Units.largeSpacing * 2

                GridLayout {
                    columns: 2
                    Layout.fillWidth: true

                    columnSpacing: FishUI.Units.largeSpacing * 1.5
                    rowSpacing: FishUI.Units.largeSpacing * 1.5

                    Label {
                        text: qsTr("General Font")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    ComboBox {
                        id: generalFontComboBox
                        model: fontsModel.generalFonts
                        Layout.fillWidth: true
                        topInset: 0
                        bottomInset: 0
                        leftPadding: FishUI.Units.largeSpacing
                        rightPadding: FishUI.Units.largeSpacing
                        onActivated: appearance.setFontFamily(currentText)
                    }

                    Label {
                        text: qsTr("Fixed Font")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    ComboBox {
                        id: fixedFontComboBox
                        model: fontsModel.fixedFonts
                        Layout.fillWidth: true
                        topInset: 0
                        bottomInset: 0
                        leftPadding: FishUI.Units.largeSpacing
                        rightPadding: FishUI.Units.largeSpacing
                        onActivated: appearance.setFixedFontFamily(currentText)
                    }

                    Label {
                        text: qsTr("Font Size")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    FishUI.SegmentedControl {
                        Layout.fillWidth: true

                        TabButton {
                            text: qsTr("Small")
                        }

                        TabButton {
                            text: qsTr("Medium")
                        }

                        TabButton {
                            text: qsTr("Large")
                        }

                        TabButton {
                            text: qsTr("Huge")
                        }

                        currentIndex: {
                            var index = 0

                            if (appearance.fontPointSize <= 9)
                                index = 0
                            else if (appearance.fontPointSize <= 10)
                                index = 1
                            else if (appearance.fontPointSize <= 12)
                                index = 2
                            else if (appearance.fontPointSize <= 15)
                                index = 3

                            return index
                        }

                        onCurrentIndexChanged: {
                            var fontSize = 0

                            switch (currentIndex) {
                            case 0:
                                fontSize = 9
                                break;
                            case 1:
                                fontSize = 10
                                break;
                            case 2:
                                fontSize = 12
                                break;
                            case 3:
                                fontSize = 15
                                break;
                            }

                            appearance.setFontPointSize(fontSize)
                        }
                    }

                    Label {
                        text: qsTr("Hinting")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    ComboBox {
                        model: fonts.hintingModel
                        textRole: "display"
                        Layout.fillWidth: true
                        currentIndex: fonts.hintingCurrentIndex
                        onCurrentIndexChanged: fonts.hintingCurrentIndex = currentIndex
                    }

                    Label {
                        text: qsTr("Anti-Aliasing")
                        bottomPadding: FishUI.Units.smallSpacing
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: fonts.antiAliasing
                        onCheckedChanged: fonts.antiAliasing = checked
                    }
                }
            }
        }
    }
}
