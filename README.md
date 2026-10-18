# Aevis System Settings

System Settings control center for the Aevis Desktop Environment.

Part of the **[Project Aevis](https://github.com/project-Aevis)** suite.

![screenshot](screenshots/Screenshot_20211025_150819.png)

## Modules

- **Display & Screen**: Resolution, scaling, refresh rate, orientation
- **Appearance**: Light/Dark theme switch, accent colors, wallpaper picker, cursor & icon themes
- **Network & Wi-Fi**: NetworkManager integration, Wi-Fi connections, cellular data
- **Bluetooth**: Device discovery, pairing, and audio profile configuration
- **Sound**: Volume, output/input device selection, application volume mixer
- **Power & Battery**: Sleep timers, battery health, power profiles
- **Users & Accounts**: User account management, password change, avatar picture
- **System Information**: Hardware overview, OS version, kernel information

## Dependencies

### Debian / Ubuntu

```shell
sudo apt install cmake extra-cmake-modules build-essential \
    qt6-base-dev qt6-declarative-dev libkf6networkmanagerqt-dev \
    libkf6bluezqt-dev libkf6config-dev libicu-dev libfreetype6-dev
```

### Arch Linux

```shell
sudo pacman -S extra-cmake-modules qt6-base qt6-declarative \
    networkmanager-qt modemmanager-qt fontconfig freetype2
```

## Build and Install

```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
```

## License

This project is licensed under the GNU General Public License v3.0 (GPLv3).
