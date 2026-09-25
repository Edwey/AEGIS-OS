# AEGIS OS - Automated Windows Setup Script
# This creates all folders and writes all files with the updated Dynamic/Animated Wallpaper + Tide plan.

Write-Host "Creating AEGIS OS directory structure..." -ForegroundColor Cyan
$dirs = @("airootfs/root", "airootfs/etc/skel/.config/fish", "airootfs/etc/sddm.conf.d")
foreach ($dir in $dirs) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

Write-Host "Writing profiledef.sh..." -ForegroundColor Green
@'
#!/usr/bin/env bash
# shellcheck disable=SC2034
iso_name="aegis-os"
iso_label="AEGIS_OS_$(date +%Y%m)"
iso_publisher="AEGIS OS Project"
iso_application="AEGIS OS Live/Rescue"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito' 'bios.syslinux.mbr' 'bios.syslinux.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_packages=('base' 'base-devel' 'linux' 'linux-firmware' 'mkinitcpio' 'nano')
'@ | Out-File -FilePath "profiledef.sh" -Encoding utf8

Write-Host "Writing packages.x86_64..." -ForegroundColor Green
@'
base
linux
linux-lts
linux-firmware
mkinitcpio
sudo
grub
efibootmgr
os-prober
ntfs-3g
btrfs-progs
rsync
plasma-desktop
plasma-workspace
plasma-systemmonitor
dolphin
kate
kwrite
kcalc
filelight
partitionmanager
ark
spectacle
krunner
kwalletmanager
kdeconnect
gwenview
okular
kamoso
ktorrent
bluedevil
plasma-nm
powerdevil
kde-cli-tools
niri
hyprland
xorg-xwayland
fish
fisher
kitty
alacritty
btop
fastfetch
neovim
networkmanager
nm-connection-editor
pavucontrol
git
curl
wget
openssh
unzip
p7zip
unrar
timeshift
gparted
flameshot
brave-bin
firefox
vlc
bitwarden
wine
bottles
steam
lutris
kvantum
catppuccin-cursors-mocha
ttf-inter
ttf-jetbrains-mono
tela-circle-icon-theme-dark
polonium
'@ | Out-File -FilePath "packages.x86_64" -Encoding utf8

Write-Host "Writing pacman.conf..." -ForegroundColor Green
@'
[options]
HoldPkg     = pacman glibc
Architecture = auto
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 5

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
'@ | Out-File -FilePath "pacman.conf" -Encoding utf8

Write-Host "Writing customize_airootfs.sh..." -ForegroundColor Green
@'
#!/bin/bash
set -e

echo "[AEGIS] Enabling essential systemd services..."
systemctl enable NetworkManager
systemctl enable sddm
systemctl enable bluetooth
systemctl enable cups

echo "[AEGIS] Setting default shell to Fish..."
chsh -s /usr/bin/fish root
if id -u arch &>/dev/null; then
    chsh -s /usr/bin/fish arch
fi

echo "[AEGIS] Installing qylock SDDM theme dependencies..."
pacman -S --noconfirm qt6-multimedia qt6-multimedia-ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly

echo "[AEGIS] Cloning and installing qylock SDDM theme..."
cd /usr/share/sddm/themes
git clone https://github.com/Darkkal44/qylock.git
cd qylock
chmod +x sddm.sh
./sddm.sh

echo "[AEGIS] Configuring SDDM to use qylock..."
mkdir -p /etc/sddm.conf.d
cat <<EOF > /etc/sddm.conf.d/theme.conf
[Theme]
Current=qylock
EOF

echo "[AEGIS] Setting up Fish shell with auto-installing Tide prompt..."
mkdir -p /etc/skel/.config/fish
cat <<'EOF' > /etc/skel/.config/fish/config.fish
# AEGIS OS - Fish Shell Configuration

# Disable default greeting
set -g fish_greeting

# Auto-install Tide if not present (runs only on first launch)
if not functions -q tide
    echo (set_color yellow)"[AEGIS] Installing Tide prompt for the first time..."(set_color normal)
    fisher install IlanCosman/tide
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time='No' --prompt_spacing=Compact --icons='Many icons' --transient='No'
end

# Custom Aliases
alias ll='ls -la --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias neofetch='fastfetch'

# Welcome Message
echo ""
echo (set_color cyan)"  Welcome to AEGIS OS."(set_color normal)
echo (set_color mauve)"  Stay secure. Stay sharp."(set_color normal)
echo ""
EOF

echo "[AEGIS] Build customization complete."
'@ | Out-File -FilePath "airootfs/root/customize_airootfs.sh" -Encoding utf8

Write-Host "Writing SDDM theme config..." -ForegroundColor Green
@'
[Theme]
Current=qylock
'@ | Out-File -FilePath "airootfs/etc/sddm.conf.d/theme.conf" -Encoding utf8

Write-Host "Updating README.md..." -ForegroundColor Green
@'
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
'@ | Out-File -FilePath "README.md" -Encoding utf8

Write-Host "✅ AEGIS OS setup complete! All files created." -ForegroundColor Cyan