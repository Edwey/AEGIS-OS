#!/bin/bash
set -e

echo "=== [1/5] Fixing Mirrors ==="
echo "Server = https://mirror.leaseweb.com/archlinux/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

echo "=== [2/5] Installing Build Tools ==="
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git archiso syslinux dos2unix reflector

# echo "=== [3/5] Cloning AEGIS OS Repo ==="
# cd ~
# git clone https://github.com/Edwey/AEGIS-OS.git
# cd AEGIS-OS

echo "=== [4/5] Fixing Permissions ==="
chmod +x profiledef.sh airootfs/root/customize_airootfs.sh

echo "=== [5/5] Starting Build ==="
# Using home directory to avoid /tmp space limits
sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .

echo "=== BUILD COMPLETE ==="
ls -lh ~/aegis-output/