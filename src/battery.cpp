/*
 * Copyright (C) 2021 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
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

#include "battery.h"
#include <QDateTime>
#include <QSettings>
#include <QDir>
#include <QFile>
#include <QDBusArgument>
#include <QDBusReply>
#include <QDBusServiceWatcher>
#include <QDebug>

static const QString s_sServer = "com.cutefish.Services";
static const QString s_sPath = "/com/cutefish/Services/Battery";
static const QString s_sInterface = "com.cutefish.Services.Battery";

//DBus Battery Info Structure
struct BatteryInfo {
    uint time, state;
    double value;
};
Q_DECLARE_METATYPE(BatteryInfo)

const QDBusArgument &operator<<(QDBusArgument &argument, const BatteryInfo &info) {
    argument.beginStructure();
    argument << info.time << info.value << info.state;
    argument.endStructure();
    return argument;
}

const QDBusArgument &operator>>(const QDBusArgument &argument, BatteryInfo &info) {
    argument.beginStructure();
    argument >> info.time >> info.value >> info.state;
    argument.endStructure();
    return argument;
}

Battery::Battery(QObject *parent)
    : QObject(parent)
    , m_upowerInterface(new QDBusInterface("org.freedesktop.UPower",
                                           "/org/freedesktop/UPower",
                                           "org.freedesktop.UPower",
                                           QDBusConnection::systemBus(), this))
    , m_interface(nullptr)
    , m_available(false)
    , m_onBattery(false)
{
    QDBusConnection::systemBus().connect("org.freedesktop.UPower", "/org/freedesktop/UPower",
                                         "org.freedesktop.DBus.Properties",
                                         "PropertiesChanged", this,
                                         SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));

    if (m_upowerInterface && m_upowerInterface->isValid()) {
        m_onBattery = m_upowerInterface->property("OnBattery").toBool();
    }

    QDBusServiceWatcher *watcher = new QDBusServiceWatcher(s_sServer,
                                                           QDBusConnection::sessionBus(),
                                                           QDBusServiceWatcher::WatchForRegistration | QDBusServiceWatcher::WatchForUnregistration,
                                                           this);
    connect(watcher, &QDBusServiceWatcher::serviceRegistered, this, &Battery::initServices);
    connect(watcher, &QDBusServiceWatcher::serviceUnregistered, this, [this](const QString &) {
        if (m_available) {
            m_available = false;
            emit validChanged();
        }
    });

    initServices();
}

void Battery::initServices()
{
    delete m_interface;
    m_interface = new QDBusInterface(s_sServer, s_sPath, s_sInterface, QDBusConnection::sessionBus(), this);

    bool newAvailable = m_interface->isValid() && !m_interface->lastError().isValid();

    if (newAvailable) {
        QDBusConnection::sessionBus().connect(s_sServer, s_sPath, s_sInterface, "chargeStateChanged", this, SLOT(chargeStateChanged(int)));
        QDBusConnection::sessionBus().connect(s_sServer, s_sPath, s_sInterface, "chargePercentChanged", this, SLOT(chargePercentChanged(int)));
        QDBusConnection::sessionBus().connect(s_sServer, s_sPath, s_sInterface, "lastChargedPercentChanged", this, SLOT(lastChargedPercentChanged()));
        QDBusConnection::sessionBus().connect(s_sServer, s_sPath, s_sInterface, "capacityChanged", this, SLOT(capacityChanged(int)));
        QDBusConnection::sessionBus().connect(s_sServer, s_sPath, s_sInterface, "remainingTimeChanged", this, SLOT(remainingTimeChanged(qlonglong)));

        m_udi = m_interface->property("udi").toString();
        emit udiChanged();
    }

    if (m_available != newAvailable) {
        m_available = newAvailable;
        emit validChanged();
    }

    if (m_available) {
        emit chargeStateChanged(chargeState());
        emit chargePercentChanged(chargePercent());
        emit capacityChanged(capacity());
        emit lastChargedPercentChanged();
    }
}

bool Battery::available() const
{
    return m_available;
}

bool Battery::onBattery() const
{
    return m_onBattery;
}

void Battery::refresh()
{
    if (m_interface && m_interface->isValid()) {
        m_interface->call("refresh");
    }
}

QVariantList Battery::getHistory(const int timespan, const int resolution)
{
    QVariantList listValues;
    QVariantMap listItem;

    if (m_udi.isEmpty()) {
        return listValues;
    }

    QDBusMessage historyMessage = QDBusMessage::createMethodCall("org.freedesktop.UPower", m_udi,
                                                                 "org.freedesktop.UPower.Device", "GetHistory");
    QVariantList historyMessageArguments;
    historyMessageArguments.append("charge");
    historyMessageArguments.append((uint) timespan);
    historyMessageArguments.append((uint) resolution);
    historyMessage.setArguments(historyMessageArguments);

    quint64 offset = QDateTime::currentDateTime().toSecsSinceEpoch();

    QDBusReply<QDBusArgument> historyArgument = QDBusConnection::systemBus().call(historyMessage);
    if (historyArgument.isValid()) {
        QDBusArgument arrayArgument = historyArgument.value();
        arrayArgument.beginArray();
        while (!arrayArgument.atEnd()) {
            BatteryInfo info;
            arrayArgument >> info;
            listItem.insert("time", offset - info.time);
            listItem.insert("value", info.value);

            if (info.value > 0)
                listValues += listItem;
        }
    }

    return listValues;
}

int Battery::chargeState() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("chargeState").toInt() : 0;
}

int Battery::chargePercent() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("chargePercent").toInt() : 0;
}

int Battery::lastChargedPercent() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("lastChargedPercent").toInt() : 0;
}

int Battery::capacity() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("capacity").toInt() : 0;
}

QString Battery::statusString() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("statusString").toString() : QString();
}

QString Battery::lastChargedTime() const
{
    return (m_interface && m_interface->isValid()) ? m_interface->property("lastChargedTime").toString() : QString();
}

bool Battery::showPercent()
{
    const QString aevisPath = QDir::home().filePath(QStringLiteral(".config/aevis/statusbar.conf"));
    const QString cutefishPath = QDir::home().filePath(QStringLiteral(".config/cutefishos/statusbar.conf"));
    QSettings settings(QFile::exists(aevisPath) ? aevisPath : cutefishPath, QSettings::IniFormat);
    return settings.value("BatteryPercentage", false).toBool();
}

void Battery::setPercentEnabled(bool value)
{
    QDBusInterface aevisStatusbar("org.aevis.Statusbar", "/Statusbar", "org.aevis.Statusbar", QDBusConnection::sessionBus());
    if (aevisStatusbar.isValid()) {
        aevisStatusbar.call("setBatteryPercentage", value);
    }
    QDBusInterface("com.cutefish.Statusbar", "/Statusbar").call("setBatteryPercentage", value);
}

QString Battery::udi() const
{
    return m_udi;
}

void Battery::onPropertiesChanged(const QString &ifaceName, const QVariantMap &changedProps, const QStringList &invalidatedProps)
{
    Q_UNUSED(ifaceName);
    Q_UNUSED(invalidatedProps);

    bool onBattery = m_onBattery;
    if (changedProps.contains("OnBattery")) {
        onBattery = changedProps.value("OnBattery").toBool();
    } else if (m_upowerInterface && m_upowerInterface->isValid()) {
        onBattery = m_upowerInterface->property("OnBattery").toBool();
    }

    if (onBattery != m_onBattery) {
        m_onBattery = onBattery;
        if (m_interface && m_interface->isValid()) {
            m_interface->call("refresh");
        }
        emit onBatteryChanged();
    }
}
