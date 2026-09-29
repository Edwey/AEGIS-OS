#!/bin/bash

# Automatically merge missing Archiso skeleton files (bootloaders, etc.)
if [ ! -d "syslinux" ]; then
    echo "Merging Archiso skeleton files..."
    cp -rn /usr/share/archiso/configs/releng/* .
fi

echo "Cleaning up previous builds..."
sudo rm -rf work/ out/

echo "Starting AEGIS OS build..."
sudo mkarchiso -v -w work/ -o out/ .

echo "============================================="
echo "Build complete! Your ISO is in the 'out/' folder."
echo "============================================="