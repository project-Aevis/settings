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

#include "application.h"
#include <QDebug>
#include <QIcon>
#include <QFile>

#ifdef __GLIBC__
#include <malloc.h>
#endif

int main(int argc, char *argv[])
{
#ifdef __GLIBC__
    mallopt(M_ARENA_MAX, 1);
    mallopt(M_TRIM_THRESHOLD, 64 * 1024);
    mallopt(M_MMAP_THRESHOLD, 32 * 1024);
#endif

    // Dynamic EGL vendor selection to prevent NVIDIA driver bloat on Intel/AMD GPUs
    if (!QFile::exists(QStringLiteral("/dev/nvidia0")) &&
        QFile::exists(QStringLiteral("/usr/share/glvnd/egl_vendor.d/50_mesa.json"))) {
        qputenv("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json");
    }

    qputenv("QSG_RENDER_LOOP", "basic");

    Application app(argc, argv);

    app.setApplicationName(QStringLiteral("aevis-settings"));
    app.setApplicationDisplayName(QStringLiteral("Settings"));
    app.setOrganizationDomain(QStringLiteral("aevis.org"));
    app.setWindowIcon(QIcon::fromTheme(QStringLiteral("aevis-settings"),
                      QIcon::fromTheme(QStringLiteral("cutefish-settings"),
                      QIcon::fromTheme(QStringLiteral("preferences-system")))));

    return 0;
}
