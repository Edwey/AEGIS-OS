#!/bin/bash
set -e

echo "=== [1/4] Fixing Mirrors with Reflector ==="
# This finds the fastest, working mirrors automatically
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo "=== [2/4] Ensuring Build Tools are Installed ==="
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git archiso syslinux dos2unix reflector

echo "=== [3/4] Copying Missing Boot Folders ==="
# These are required by archiso but not in the git repo. 
# We check if they exist first to avoid errors.
if [ ! -d "efiboot" ]; then
    echo "Copying efiboot..."
    sudo cp -r /usr/share/archiso/configs/releng/efiboot .
fi

if [ ! -d "syslinux" ]; then
    echo "Copying syslinux..."
    sudo cp -r /usr/share/archiso/configs/releng/syslinux .
fi

echo "=== [4/4] Starting Build ==="
# Clean previous failed builds to ensure a fresh start
sudo rm -rf ~/aegis-work ~/aegis-output

# Run the build
sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .

echo "=== BUILD COMPLETE ==="
ls -lh ~/aegis-output/