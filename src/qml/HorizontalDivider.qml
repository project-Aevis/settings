/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS Inset Card Divider
 */

import QtQuick 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI

Item {
    id: control
    height: 1
    Layout.fillWidth: true

    property real leftInset: 0
    property real rightInset: 0
    property color color: FishUI.Theme.glassBorderColor

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: control.leftInset
        anchors.rightMargin: control.rightInset
        color: control.color

        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.Linear
            }
        }
    }
}

