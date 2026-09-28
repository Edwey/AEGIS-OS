# 🛡️ AEGIS OS - Build Documentation

> **Version:** 1.1.0-alpha
> **Status:** In Development (boots to SDDM + Plasma, theming/W tiling still aspirational)
> **Base:** Arch Linux (`arch` / `x86_64`)
> **Desktop:** KDE Plasma 6 (Wayland) via SDDM + `qylock` theme
> **ISO boot:** systemd-boot (UEFI) + Syslinux (BIOS), SquashFS/XZ

## 📖 Project Vision

AEGIS OS is a portable, secure, cyberpunk-minimalist Arch-based live ISO.
Goal: **dynamic theming** (accents follow wallpaper), **animated/video wallpapers**,
and a glassmorphic Qt look via Kvantum. Most of that vision is **planned, not yet
configured** — see Implemented vs. Roadmap below.

## ✅ Implemented vs. 🗺️ Roadmap

**Implemented today (matches code):**

* Archiso profile builds a bootable live ISO (`profiledef.sh`).
* KDE Plasma 6 Wayland session + SDDM autologin target (`sddm` enabled).
* SDDM theme `qylock` cloned from `https://github.com/Darkkal44/qylock` at build
  time and set as `Current=qylock` (`airootfs/root/customize_airootfs.sh`,
  `airootfs/etc/sddm.conf.d/theme.conf`). Video dependencies
  (`qt6-multimedia`, `qt6-multimedia-ffmpeg`, `gst-plugins-*`) are pre-baked in
  `packages.x86_64`.
* Fish as default shell for `root`/`arch`, NetworkManager + Bluetooth + CUPS enabled.
* Terminal stack: `kitty` + `fish` + `btop` + `fastfetch` + `neovim`.
* Audio: PipeWire (`pipewire`, `pipewire-pulse`, `pipewire-alsa`, `pavucontrol`).
* Build helper `setup.sh`: pins MIT mirror, disables sig checks (`SigLevel = Never`),
  copies missing `efiboot/` + `syslinux/` from releng, fixes perms, cleans
  `~/aegis-work` / `~/aegis-output`, runs `mkarchiso`.

**Planned / aspirational (in old README, no config in repo yet):**

* `niri` / `Hyprland` alternate sessions, Polonium auto-tiling, Catppuccin Mocha +
  Cyber Arch theme, `Tela-circle-dark` icons, KDE-native dynamic accent theming,
  MP4/WebGL animated walls, GRUB cyber menu, ext4 prescription. None of these have
  package entries or dotfiles checked in (see Known Drift).

## 🏗️ Tech Stack (actual)

| Component | Choice | Source |
| :--- | :--- | :--- |
| **Base** | Arch Linux, `install_dir=arch` | `profiledef.sh` |
| **Kernel** | `linux` (+ `linux-lts` in package list; bootstrap only `linux`) | `profiledef.sh`, `packages.x86_64` |
| **ISO bootloader** | `systemd-boot` ESP + El Torito (UEFI), `syslinux` MBR + El Torito (BIOS) | `profiledef.sh` `bootmodes` |
| **Target-system boot pkgs** | `grub`, `efibootmgr`, `os-prober`, `syslinux` (for installed system, not ISO menu theme) | `packages.x86_64` |
| **Image** | SquashFS, `xz -Xbcj x86 -b 1M -Xdict-size 1M` | `profiledef.sh` |
| **Desktop** | `plasma-desktop`, `plasma-workspace`, `plasma-systemmonitor`, `plasma-wayland-session`, `dolphin`, `kate`, `kwrite`, `kcalc`, `spectacle`, `krunner`, `kwalletmanager`, `kdeconnect`, `bluedevil`, `plasma-nm`, `powerdevil`, `kde-cli-tools`, `xorg-xwayland` | `packages.x86_64` |
| **Login** | SDDM + `qylock` theme | `customize_airootfs.sh`, `airootfs/etc/sddm.conf.d/theme.conf` |
| **Shell/prompt** | Fish; checked-in skel uses **Starship** (`starship.toml`, Catppuccin Mocha), but `customize_airootfs.sh` overwrites skel at build time with a **Tide/fisher** variant — see Known Drift | `airootfs/etc/skel/.config/...`, `customize_airootfs.sh` |
| **Qt decor** | `kvantum` installed, no theme config checked in | `packages.x86_64` |
| **Fonts** | `ttf-jetbrains-mono`, `inter-font`, `noto-fonts` | `packages.x86_64` |
| **Media/SDDM deps** | `qt6-multimedia`, `qt6-multimedia-ffmpeg`, `gst-plugins-base/good/bad/ugly` | `packages.x86_64` |
| **Net/disk/utils** | `networkmanager`, `nm-connection-editor`, `git`, `curl`, `wget`, `openssh`, `unzip`, `p7zip`, `unrar`, `gparted`, `flameshot`, `cups`, `system-config-printer`, `ntfs-3g`, `btrfs-progs`, `rsync`, `mesa` | `packages.x86_64` |
| **Repos** | `core`, `extra`, `multilib`; `ParallelDownloads = 5` | `pacman.conf` |

No AUR helper and no AUR packages in the official list. `Prompt.md` lists
`brave-bin`, `polonium`, `tela-circle-icon-theme-dark`, etc. — those are **not**
in `packages.x86_64` and will not install via `mkarchiso`.

## 📂 Repository Structure (actual)

```text
aegis-os/
├── README.md
├── Prompt.md                        # original Windows generator script (stale vs. current files)
├── profiledef.sh                    # archiso profile (systemd-boot + syslinux, squashfs/xz)
├── packages.x86_64                  # 80 pkgs: Plasma, SDDM, PipeWire, Fish/Kitty, Kvantum, Qt6/GST
├── pacman.conf                      # core/extra/multilib, ParallelDownloads=5
├── setup.sh                         # 5-stage build helper (mirrors, sigs, efiboot/syslinux, mkarchiso)
└── airootfs/
    ├── root/customize_airootfs.sh   # enables services, sets fish, installs qylock, writes Tide skel
    └── etc/
        ├── pacman.d/mirrorlist      # checked-in: leaseweb (setup.sh overwrites with MIT at build)
        ├── sddm.conf.d/theme.conf   # [Theme] Current=qylock
        └── skel/.config/
            ├── fish/config.fish     # checked-in: Starship variant (overwritten by customize script)
            └── starship.toml        # Catppuccin Mocha cyberpunk prompt (orphaned if Tide wins)
```

`efiboot/` and `syslinux/` are intentionally git-ignored and restored by `setup.sh`
from `/usr/share/archiso/configs/releng/` when missing.

## 🚀 Build

Prerequisites: clean Arch Linux host/VM with `archiso`, `git`, `sudo`.

```bash
# Recommended (does mirror/sig fix, restores boot dirs, cleans work dirs):
chmod +x setup.sh
./setup.sh
# Output: ~/aegis-output/*.iso
```

Manual equivalent:

```bash
chmod +x profiledef.sh airootfs/root/customize_airootfs.sh
sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .
```

What `setup.sh` does (5 stages):

1. Writes `airootfs/etc/pacman.d/mirrorlist` → MIT mirror; injects
   `SigLevel = Never` under `[options]` in `pacman.conf` if absent.
2. Copies `efiboot/` + `syslinux/` from releng if missing.
3. `chmod +x profiledef.sh airootfs/root/customize_airootfs.sh`.
4. `sudo rm -rf ~/aegis-work ~/aegis-output`.
5. `sudo mkarchiso -v -w ~/aegis-work -o ~/aegis-output .`.

## ⚠️ Known Drift / TODO

1. **Shell prompt split:** checked-in skel = Starship, build-time skel = Tide via
   `fisher` — but `fisher`/`tide`/`starship` are not in `packages.x86_64`, so
   first-launch install depends on network + AUR/git. Decide on one (Starship is
   fully checked in) and align `customize_airootfs.sh` + package list.
2. **README vision vs. code:** niri/Hyprland, Polonium, Tela icons, Catppuccin
   configs, dynamic-theming rules, animated-wall assets, GRUB theme, ext4 setup
   have no packages or dotfiles. Either add them or keep them in Roadmap only.
3. **Redundant media install:** `customize_airootfs.sh` runs
   `pacman -S qt6-multimedia ...` even though those are already in
   `packages.x86_64` — harmless but slows the build; consider dropping.
4. **Mirrorlist churn:** checked-in mirror (leaseweb) is always overwritten by
   `setup.sh` (MIT). Either check in the MIT version or make `setup.sh`
   non-destructive.
5. **`Prompt.md` stale:** its embedded `packages.x86_64` / Fish+Tide template
   disagrees with the current files. Regenerate or archive it to avoid confusion.
```

