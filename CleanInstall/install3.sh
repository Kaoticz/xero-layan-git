#!/bin/bash

# Add the theme repository to /etc/pacman.conf
echo "" | sudo tee -a /etc/pacman.conf
echo "# Add the XeroLinux repository for the themes" | sudo tee -a /etc/pacman.conf
echo "[xerolinux_repo]" | sudo tee -a /etc/pacman.conf
echo "SigLevel = Optional TrustAll" | sudo tee -a /etc/pacman.conf
echo "Server = https://xerolinux.github.io/\$repo/\$arch" | sudo tee -a /etc/pacman.conf

# Update the repository list and system
sudo pacman -Syyu --noconfirm

# Install common tools
sudo pacman -S --needed --noconfirm --disable-download-timeout git exa awk

# Install paru
Input=
echo ""
echo "Install 'paru' as an AUR helper? (y/n): "
read Input

if [ "$Input" == "y" ] || [ "$Input" == "yes" ]
then
    git clone https://aur.archlinux.org/paru.git /tmp/paru
	cd /tmp/paru
	makepkg -si
fi

# Install the Xero Layan theme
git clone https://github.com/Kaoticz/xero-layan-git -b arch /tmp/xero-layan-git
bash /tmp/xero-layan-git/installArch.sh

# Setup swap file
echo "Creating the swap file"

## Create the swap file (2GB)
sudo dd if=/dev/zero of=/var/swapfile bs=1024 count=1953125‬

# Don't do this, causes problems on Btrfs drives
#sudo fallocate -l 2G /var/swapfile

sudo chmod 600 /var/swapfile

sudo mkswap /var/swapfile

sudo swapon /var/swapfile

echo "" | sudo tee -a /etc/fstab
echo "# Swap file" | sudo tee -a /etc/fstab
echo "/var/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# Clean-up
sudo rm $HOME/install3.sh

# Reboot
sudo reboot