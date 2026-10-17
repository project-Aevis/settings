/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * macOS System Settings Scrollable Area
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import FishUI 1.0 as FishUI

Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    clip: true

    topMargin: 16
    bottomMargin: 24
    leftMargin: 28
    rightMargin: 28

    contentWidth: width - (leftMargin + rightMargin)

    FishUI.WheelHandler {
        id: wheelHandler
        target: root
    }

    ScrollBar.vertical: ScrollBar {
        bottomPadding: 6
    }
}
