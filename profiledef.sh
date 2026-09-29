#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="aegis"
iso_label="AEGIS_v1"
iso_publisher="Edwey <https://github.com/Edwey/AEGIS-OS>"
iso_application="AEGIS OS Live/Installer"
iso_version="v1.0"
install_dir="aegis"
buildmodes=('iso')
bootmodes=('uefi-x64.systemd.esp' 'bios.syslinux.mbr' 'bios.syslinux.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')