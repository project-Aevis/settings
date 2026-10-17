/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Grouped Card Container
 */

import QtQuick 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI

Rectangle {
    id: cardRoot
    Layout.fillWidth: true

    default property alias content: _mainLayout.data
    property alias spacing: _mainLayout.spacing
    property alias layout: _mainLayout

    property real horizontalPadding: 16
    property real verticalPadding: 10

    color: FishUI.Theme.secondBackgroundColor
    radius: FishUI.Theme.mediumRadius
    antialiasing: true

    border.width: 1 / FishUI.Dpi.ratio
    border.color: FishUI.Theme.glassBorderColor

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.Linear
        }
    }

    implicitHeight: _mainLayout.implicitHeight +
                    _mainLayout.anchors.topMargin +
                    _mainLayout.anchors.bottomMargin

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.leftMargin: cardRoot.horizontalPadding
        anchors.rightMargin: cardRoot.horizontalPadding
        anchors.topMargin: cardRoot.verticalPadding
        anchors.bottomMargin: cardRoot.verticalPadding
        spacing: 8
    }
}
