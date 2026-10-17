/*
 * Copyright (C) 2021 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * Author:     Kate Leet <kateleet@cutefishos.com>
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

#include "notifications.h"

Notifications::Notifications(QObject *parent)
    : QObject(parent)
    , m_iface(QDBusInterface("org.aevis.Notification", "/Notification", "org.aevis.Notification", QDBusConnection::sessionBus()).isValid()
              ? QDBusInterface("org.aevis.Notification", "/Notification", "org.aevis.Notification", QDBusConnection::sessionBus())
              : QDBusInterface("com.cutefish.Notification", "/Notification", "com.cutefish.Notification", QDBusConnection::sessionBus()))
{
    m_doNotDisturb = m_iface.property("doNotDisturb").toBool();

    QDBusConnection::sessionBus().connect("org.aevis.Notification",
                                          "/Notification",
                                          "org.aevis.Notification",
                                          "doNotDisturbChanged", this, SLOT(onDBusDoNotDisturbChanged()));
    QDBusConnection::sessionBus().connect("com.cutefish.Notification",
                                          "/Notification",
                                          "com.cutefish.Notification",
                                          "doNotDisturbChanged", this, SLOT(onDBusDoNotDisturbChanged()));
}

bool Notifications::doNotDisturb() const
{
    return m_doNotDisturb;
}

void Notifications::setDoNotDisturb(bool enabled)
{
    m_doNotDisturb = enabled;

    QDBusInterface aevisIface("org.aevis.Notification",
                              "/Notification",
                              "org.aevis.Notification", QDBusConnection::sessionBus());
    if (aevisIface.isValid()) {
        aevisIface.asyncCall("setDoNotDisturb", enabled);
    }

    QDBusInterface legacyIface("com.cutefish.Notification",
                               "/Notification",
                               "com.cutefish.Notification", QDBusConnection::sessionBus());
    if (legacyIface.isValid()) {
        legacyIface.asyncCall("setDoNotDisturb", enabled);
    }

    emit doNotDisturbChanged();
}

void Notifications::onDBusDoNotDisturbChanged()
{
    m_doNotDisturb = m_iface.property("doNotDisturb").toBool();
    emit doNotDisturbChanged();
}
