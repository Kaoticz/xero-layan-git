#!/bin/bash

# Install the network manager and GRUB
pacman -S --noconfirm networkmanager grub os-prober

# Enable the network manager on startup
systemctl enable NetworkManager

# Setup GRUB
grub-install /dev/sda

# Add GRUB_DISABLE_OS_PROBER=false to the end of the file
echo "" | tee -a /etc/default/grub
echo "# Allow GRUB to detect other OSes" | tee -a /etc/default/grub
echo "GRUB_DISABLE_OS_PROBER=false" | tee -a /etc/default/grub

echo "" | tee -a /etc/default/grub
echo "# Disable the GRUB submenu (shows the OS/Kernel on the main screen)" | tee -a /etc/default/grub
echo "GRUB_DISABLE_SUBMENU=n" | tee -a /etc/default/grub

echo "" | tee -a /etc/default/grub
echo "# Save and use the last used kernel" | tee -a /etc/default/grub
echo "GRUB_DEFAULT=saved" | tee -a /etc/default/grub
echo "GRUB_SAVEDEFAULT=true" | tee -a /etc/default/grub

# Set swapiness
echo "vm.swappiness=10" | tee -a /etc/sysctl.d/99-swappiness.conf

# Generate the grub configuration
grub-mkconfig -o /boot/grub/grub.cfg

# Set password for root
echo ""
echo "Type the password for root: "
passwd

# Generate the locale
echo "LC_ALL=en_US.UTF-8" | tee -a /etc/environment
echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen
echo "LANG=en_US.UTF-8" | tee -a /etc/locale.conf
locale-gen

# Name the computer (ex: archbox)
Input=
echo ""
echo "Define the name of the computer: "
read Input
echo "$Input" | tee -a /etc/hostname

# Set the local time # (press TAB for autocompletion) ln -sf /usr/share/zoneinfo/[TAB]/[TAB]
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Clean-up
rm install1.sh