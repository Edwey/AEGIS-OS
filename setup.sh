#!/bin/bash
set -e

echo "=== [1/6] Fetching Fresh Mirrors ==="
# Download the official mirrorlist, uncomment the servers, and take the top 20
curl -s "https://archlinux.org/mirrorlist/all/" | sed -n 's/^#Server = /Server = /p' | head -n 20 | sudo tee /etc/pacman.d/mirrorlist > /dev/null
echo "Mirrors updated."

echo "=== [2/6] Installing Build Tools ==="
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git archiso syslinux dos2unix curl
echo "Tools installed."

echo "=== [3/6] Copying Missing Boot Folders ==="
# These are required by archiso but not in the git repo.
if [ ! -d "efiboot" ]; then
    echo "Copying efiboot..."
    sudo cp -r /usr/share/archiso/configs/releng/efiboot .
fi

if [ ! -d "syslinux" ]; then
    echo "Copying syslinux..."
    sudo cp -r /usr/share/archiso/configs/releng/syslinux .
fi
echo "Boot folders ready."

echo "=== [4/6] Fixing Permissions ==="
chmod +x profiledef.sh airootfs/root/customize_airootfs.sh
echo "Permissions fixed."

echo "=== [5/6] Cleaning Old Builds ==="
sudo rm -rf ~/aegis-work ~/aegis-output
echo "Cleaned."

echo "=== [6/6] Starting Build ==="
sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .

echo "=== BUILD COMPLETE ==="
ls -lh ~/aegis-output/