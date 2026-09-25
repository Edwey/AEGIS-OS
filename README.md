# 🛡️ AEGIS OS - Master Build Documentation

> **Version:** 1.1.0-alpha  
> **Status:** In Development  
> **Base:** Arch Linux  
> **Desktop:** KDE Plasma 6 (Wayland) with niri/Hyprland fallbacks

## 📖 Project Vision
AEGIS OS is a portable, secure, cyberpunk-minimalist Linux distribution. It features **dynamic theming** (accent colors adapt to your wallpaper), **animated/video wallpapers** (native KDE support), and a fluid, glassmorphic aesthetic powered by Kvantum blur.

## 🏗️ Architecture & Tech Stack
| Component | Choice | Details |
| :--- | :--- | :--- |
| **Base** | Arch Linux | Bleeding-edge, lightweight, ultimate control. |
| **Kernel** | `linux` + `linux-lts` | Latest for new hardware, LTS fallback for old PCs. |
| **Desktop** | KDE Plasma 6 (Wayland) | Default session. |
| **Alternative WM** | `niri` + `Hyprland` | Pre-installed, selectable from SDDM. |
| **Theme** | **Catppuccin Mocha** + Cyber Arch | Dark, minimal, neon cyan/purple accents. |
| **Window Decor** | **Kvantum** | Real transparency and blur on all Qt apps. |
| **Icons** | `Tela-circle-dark` | Clean, cyber-minimalist iconography. |
| **Terminal** | **Kitty** + **Fish** + **Tide** | Auto-configuring, beautiful Catppuccin prompt. |
| **Dynamic Theming**| **KDE Native** | System accents automatically match the active wallpaper. |
| **Animated Walls** | **KDE Native Video/Web** | Built-in support for MP4/WebGL live wallpapers. |
| **Tiling** | **Polonium** | i3-like dynamic auto-tiling for KDE. Toggleable. |
| **Filesystem** | **ext4** | Rock-solid, maximum compatibility. |
| **Bootloader** | **GRUB** | Custom cyber-themed menu. |

## 📂 Repository Structure

aegis-os/
├── README.md
├── profiledef.sh
├── packages.x86_64
├── pacman.conf
└── airootfs/
    ├── root/customize_airootfs.sh
    └── etc/
        ├── skel/.config/fish/config.fish
        └── sddm.conf.d/theme.conf

## 🚀 Next Steps
1. Commit these files to Git.
2. Spin up an Arch Linux VM.
3. Clone this repo and run `sudo mkarchiso -v -w /tmp/work -o /tmp/out .`
