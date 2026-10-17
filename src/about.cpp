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

#include "about.h"

#include <QFile>
#include <QStorageInfo>
#include <QSettings>
#include <QProcess>

#ifdef Q_OS_LINUX
#include <sys/sysinfo.h>
#elif defined(Q_OS_FREEBSD)
#include <sys/types.h>
#include <sys/sysctl.h>
#endif

static QString formatByteSize(double size, int precision)
{
    static const char * const units[] = { "B", "KB", "MB", "GB", "TB", "PB", "EB" };
    int unit = 0;

    while (qAbs(size) >= 1024.0 && unit < 6) {
        size /= 1024.0;
        ++unit;
    }

    return QString("%1 %2")
        .arg(QString::number(size, 'f', unit == 0 ? 0 : precision),
             QLatin1String(units[unit]));
}

About::About(QObject *parent)
    : QObject(parent)
{
}

bool About::isAevisOS()
{
    return QFile::exists(QStringLiteral("/etc/aevis")) ||
           QFile::exists(QStringLiteral("/etc/aevisos")) ||
           QFile::exists(QStringLiteral("/etc/cutefishos")) ||
           QFile::exists(QStringLiteral("/etc/cutefish"));
}

bool About::isCutefishOS()
{
    return isAevisOS();
}

QString About::version()
{
    for (const char *path : { "/etc/aevis", "/etc/cutefish" }) {
        if (QFile::exists(QLatin1String(path))) {
            QSettings settings(QLatin1String(path), QSettings::IniFormat);
            const QString v = settings.value(QStringLiteral("Version")).toString();
            if (!v.isEmpty())
                return v;
        }
    }
    return QStringLiteral("1.0.0 (Aevis Edition)");
}

QString About::osName()
{
    QString name = QSysInfo::prettyProductName();
    if (name.isEmpty() || name == QStringLiteral("Unknown")) {
        name = QStringLiteral("Project Aevis GNU/Linux");
    }
    return name;
}

QString About::architecture()
{
    return QSysInfo::currentCpuArchitecture();
}

QString About::kernelType()
{
    return QSysInfo::kernelType();
}

QString About::kernelVersion()
{
    return QSysInfo::kernelVersion();
}

QString About::hostname()
{
    return QSysInfo::machineHostName();
}

QString About::userName()
{
    const QByteArray userName = qgetenv("USER");
    return QString::fromUtf8(userName.isEmpty() ? qgetenv("USERNAME") : userName);
}

QString About::memorySize()
{
    QString ram;
    const qlonglong totalRam = calculateTotalRam();

    if (totalRam > 0) {
        ram = formatByteSize(totalRam, 1);
    } else {
        ram = QStringLiteral("16.0 GB");
    }
    return ram;
}

QString About::prettyProductName()
{
    return osName();
}

QString About::internalStorage()
{
    QStorageInfo storage = QStorageInfo::root();
    if (!storage.isValid()) return QStringLiteral("Root Volume");
    qint64 total = storage.bytesTotal();
    qint64 free = storage.bytesAvailable();
    qint64 used = total - free;
    return QString("%1 / %2")
            .arg(formatByteSize(used, 1))
            .arg(formatByteSize(total, 1));
}

QString About::cpuInfo()
{
    static QString cachedCpuInfo;
    if (!cachedCpuInfo.isEmpty())
        return cachedCpuInfo;

    QFile file(QStringLiteral("/proc/cpuinfo"));
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString modelName;
        int coreCount = 0;
        QTextStream in(&file);
        while (!in.atEnd()) {
            const QString line = in.readLine();
            if (line.startsWith(QLatin1String("processor"))) {
                ++coreCount;
            } else if (modelName.isEmpty() &&
                       (line.startsWith(QLatin1String("model name")) ||
                        line.startsWith(QLatin1String("Hardware")) ||
                        line.startsWith(QLatin1String("Processor")))) {
                int colonIdx = line.indexOf(QLatin1Char(':'));
                if (colonIdx != -1) {
                    modelName = line.mid(colonIdx + 1).trimmed();
                }
            }
        }
        if (!modelName.isEmpty()) {
            if (coreCount > 0)
                modelName.append(QStringLiteral(" (%1 Cores)").arg(coreCount));
            cachedCpuInfo = modelName;
            return cachedCpuInfo;
        }
    }

    cachedCpuInfo = QSysInfo::buildCpuArchitecture();
    return cachedCpuInfo;
}

void About::openUpdator()
{
    if (!QProcess::startDetached(QStringLiteral("aevis-updator"), {})) {
        QProcess::startDetached(QStringLiteral("cutefish-updator"), {});
    }
}

qlonglong About::calculateTotalRam() const
{
    qlonglong ret = -1;
#ifdef Q_OS_LINUX
    struct sysinfo info;
    if (sysinfo(&info) == 0)
        ret = qlonglong(info.totalram) * info.mem_unit;
#elif defined(Q_OS_FREEBSD)
    size_t len;
    unsigned long memory;
    len = sizeof(memory);
    sysctlbyname("hw.physmem", &memory, &len, NULL, 0);
    ret = memory;
#endif
    return ret;
}
