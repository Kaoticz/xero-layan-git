#!/bin/

# localectl set-keymap --no-convert br-abnt
# Run this script with
# curl -OL https://raw.githubusercontent.com/Kaoticz/xero-layan-git/arch/CleanInstall/install2.sh
# bash install2.sh

# Setup the user
Input=
echo "Type the name of the user: "
read Input
useradd -mg wheel "$Input"

# Set the password of the user
echo "Set the password for $Input: "
passwd "$Input"

# Define the permissions for sudo
echo "" | sudo tee -a /etc/sudoers
echo "#Give admin to all wheel users" | sudo tee -a /etc/sudoers
echo "%wheel ALL=(ALL) ALL" | sudo tee -a /etc/sudoers
echo "" | sudo tee -a /etc/sudoers
echo "#Don't ask for root password on the same console session" | sudo tee -a /etc/sudoers
echo "#Defaults !tty_tickets" | sudo tee -a /etc/sudoers

# Change /etc/pacman.conf to allow concurrent downloads
echo ""
echo "Please, enable ParallelDownloads in the following file (don't set the value too high). Proceeding in 10 seconds."
sleep 10
nano /etc/pacman.conf

## Install KDE and repository backend
pacman -S --disable-download-timeout xorg sddm plasma plasma-wayland-session kde-applications packagekit-qt5 flatpak fwupd reflector

# Run login manager on startup
systemctl enable sddm.service

# Run reflector on startup
systemctl enable reflector.service

# Get the next script
curl -OL https://raw.githubusercontent.com/Kaoticz/xero-layan-git/arch/CleanInstall/install3.sh
mv install3.sh /home/"$Input"/install3.sh
rm install2.sh

# Reboot the system
echo ""
echo "Installation is now complete and the system will reboot in 10 seconds. Execute 'bash /home/$Input/install3.sh' when it comes back up."
sleep 10
reboot