#!/bin/bash
set -e

echo "=== [1/5] Fixing Mirrors & Signatures ==="
# 1. Force a reliable mirror (MIT) inside the build environment
mkdir -p airootfs/etc/pacman.d
echo "Server = https://mirrors.mit.edu/archlinux/\$repo/os/\$arch" > airootfs/etc/pacman.d/mirrorlist

# 2. Disable signature checks to prevent 'missing required signature' errors
# This adds 'SigLevel = Never' under the [options] section
if ! grep -q "SigLevel = Never" pacman.conf; then
    sed -i '/\[options\]/a SigLevel = Never' pacman.conf
fi
echo "Mirrors and Signatures fixed."

echo "=== [2/5] Ensuring Boot Folders Exist ==="
# archiso requires these folders, but they aren't in git.
# We copy them from the system default if they are missing.
if [ ! -d "efiboot" ]; then
    echo "Copying efiboot..."
    sudo cp -r /usr/share/archiso/configs/releng/efiboot .
fi

if [ ! -d "syslinux" ]; then
    echo "Copying syslinux..."
    sudo cp -r /usr/share/archiso/configs/releng/syslinux .
fi

echo "=== [3/5] Fixing Permissions ==="
chmod +x profiledef.sh airootfs/root/customize_airootfs.sh

echo "=== [4/5] Cleaning Old Builds ==="
sudo rm -rf ~/aegis-work ~/aegis-output

echo "=== [5/5] Starting Build ==="
sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .

echo "=== BUILD COMPLETE ==="
ls -lh ~/aegis-output/