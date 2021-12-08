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
sudo pacman -S --needed --noconfirm --disable-download-timeout git exa awk thunar expac

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
	sudo pacman -S --needed --noconfirm --disable-download-timeout asp bat
fi

# Install the Xero Layan theme
git clone https://github.com/Kaoticz/xero-layan-git -b arch /tmp/xero-layan-git
bash /tmp/xero-layan-git/installArch.sh

# Clean-up
sudo rm $HOME/install3.sh

# Download instructions
curl -OL https://raw.githubusercontent.com/Kaoticz/xero-layan-git/arch/CleanInstall/instructions.txt

# Reboot
echo "Done. Rebooting in 5 seconds."
sleep 5
sudo reboot