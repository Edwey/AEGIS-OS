Perfect. Here is the updated, copy-pasteable content for your `README.md`. Just select all the text in your current `README.md` in VS Code, delete it, and paste this in. It accurately reflects the v1 build we just created.

```markdown
# 🛡️ AEGIS OS

**Version:** 1.0.0 (Initial Release)  
**Base:** Arch Linux (x86_64)  
**Desktop:** KDE Plasma 6 (Wayland)  

## 📖 Project Vision
AEGIS OS is a custom, minimal Arch-based Linux distribution designed for performance, security, and deep customization. Built from the ground up using `archiso`, it serves as a daily-driver foundation featuring a modern KDE Plasma environment and the Fish shell.

## ✨ Core Features (v1)
- **Graphical Installer:** Ships with Calamares for an easy, "click-next" installation experience.
- **Desktop Environment:** KDE Plasma 6 (Wayland) with SDDM.
- **Shell:** Fish shell configured as the default for the live environment.
- **Live Environment:** Boots directly into a usable desktop to test hardware compatibility before installing.
- **Minimal Bloat:** Only essential packages included to keep the ISO lightweight and fast.

## 🏗️ How to Build

### Prerequisites
You need a working Arch Linux environment (or an Arch-based VM) with `archiso` and `git` installed.
```bash
sudo pacman -S archiso git base-devel
```

### Build Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/Edwey/AEGIS-OS.git
   cd AEGIS-OS
   ```
2. Make the build script executable:
   ```bash
   chmod +x build.sh airootfs/root/customize_airootfs.sh
   ```
3. Run the build script (this will automatically fetch missing Archiso skeleton files and compile the ISO):
   ```bash
   ./build.sh
   ```
4. Your bootable ISO will be generated in the `out/` directory.

## 🗺️ Roadmap (Future Versions)
- [ ] Custom Plymouth boot splash with AEGIS logo.
- [ ] Custom SDDM login theme.
- [ ] Dynamic accent coloring based on wallpaper.
- [ ] Pre-installed live wallpaper engine (Komorebi / Wallpaper Engine plugin).
- [ ] Advanced terminal widgets and tiling extensions.
```

---

### Phase 4: The Build Script (`build.sh`)

This is the final file. This script is smart: when you run it in the VM, it will automatically check if you are missing any underlying Arch Linux skeleton files (like the bootloader configs) and pull them from your VM's system before starting the build.

Run this in your Windows PowerShell:

```powershell
# 1. Define the build script
$buildScript = @"
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
"@

# 2. Write the file without BOM
[System.IO.File]::WriteAllText("$PWD\build.sh", $buildScript, (New-Object System.Text.UTF8Encoding $false))

Write-Host "Phase 4 complete! build.sh created." -ForegroundColor Green
```

---

### The Final Steps: Commit, Push, and Build!

Now that all the files are made in VS Code:

**1. On Windows (Commit and Push):**
Go to the terminal in VS Code (or PowerShell in your folder) and run:
```powershell
git add .
git commit -m "feat: AEGIS OS v1 base profile with KDE, Fish, and Calamares"
git push
```

**2. In the VM (The Factory):**
Switch over to your VMware Arch Linux VM (where you were previously SSH'd in, or sitting at the TTY). 
Type these commands exactly:

```bash
# Install the official Archiso builder tool
sudo pacman -Sy --needed archiso git base-devel

# Clone your updated repo
git clone https://github.com/Edwey/AEGIS-OS.git
cd AEGIS-OS

# Give the scripts permission to run
chmod +x build.sh airootfs/root/customize_airootfs.sh

# START THE BUILD!
./build.sh
```
