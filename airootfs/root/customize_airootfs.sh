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
