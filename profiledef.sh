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
