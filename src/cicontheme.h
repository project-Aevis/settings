/*
 * Copyright (C) 2021-2026 CutefishOS Team.
 * Copyright (C) 2026 Project Aevis Contributors.
 */

#ifndef CICONTHEME_H
#define CICONTHEME_H

#include <QObject>
#include <QStringList>

class CIconTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList installedThemes READ installedThemes CONSTANT)

public:
    explicit CIconTheme(QObject *parent = nullptr);

    QStringList installedThemes() const;
    static QStringList list();
};

#endif // CICONTHEME_H
