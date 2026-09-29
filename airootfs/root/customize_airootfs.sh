#!/bin/bash
# Configure the AEGIS OS Live Environment

# Enable core services
systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl enable bluetooth.service
systemctl enable vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service

# Add Fish to valid shells
echo "/usr/bin/fish" >> /etc/shells

# Create the live user 'aegis'
useradd -m -G wheel -s /usr/bin/fish aegis
echo "aegis:aegis" | chpasswd

# Allow passwordless sudo for the wheel group
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# Set root password just in case
echo 'root:root' | chpasswd

echo "AEGIS OS Live Environment configured!"