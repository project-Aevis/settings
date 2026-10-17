/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 */

#include "cicontheme.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QSettings>
#include <QDebug>

CIconTheme::CIconTheme(QObject *parent)
    : QObject(parent)
{
}

QStringList CIconTheme::installedThemes() const
{
    return list();
}

QStringList CIconTheme::list()
{
    QStringList themes;
    QStringList searchPaths;
    searchPaths << QDir::homePath() + QStringLiteral("/.icons")
                << QDir::homePath() + QStringLiteral("/.local/share/icons")
                << QStringLiteral("/usr/share/icons")
                << QStringLiteral("/usr/local/share/icons");

    for (const QString &basePath : searchPaths) {
        QDir dir(basePath);
        if (!dir.exists())
            continue;

        const QStringList subDirs = dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
        for (const QString &subDir : subDirs) {
            QString themePath = basePath + QLatin1Char('/') + subDir;
            QString indexPath = themePath + QStringLiteral("/index.theme");
            if (QFile::exists(indexPath)) {
                // Must have Directories entry in [Icon Theme] per XDG spec (otherwise it is a cursor theme)
                QSettings themeFile(indexPath, QSettings::IniFormat);
                themeFile.beginGroup(QStringLiteral("Icon Theme"));
                const QString directories = themeFile.value(QStringLiteral("Directories")).toString();
                themeFile.endGroup();
                if (directories.trimmed().isEmpty()) {
                    continue;
                }

                if (!themes.contains(subDir) && subDir != QStringLiteral("hicolor") && !subDir.startsWith(QStringLiteral("default"))) {
                    themes.append(subDir);
                }
            }
        }
    }

    themes.sort(Qt::CaseInsensitive);

    if (themes.isEmpty()) {
        themes << QStringLiteral("Cutefish") << QStringLiteral("Cutefish-Dark") << QStringLiteral("Cutefish-Light");
    }

    return themes;
}
