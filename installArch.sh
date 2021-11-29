#!/bin/bash
#set -e

CurrentDir=$(pwd)

echo "##########################################"
echo "Be Careful this will override your Rice!! Proceeding in 5 seconds"
echo "##########################################"
sleep 5

echo "Creating Backups of ~/.config folder"
echo "#####################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)

echo "Installing required Tools"
echo "#################################"
sudo pacman -S --needed --noconfirm kvantum-qt5 latte-dock lolcat neofetch yakuake git exa awk

# Install paru
Input=
echo "Install 'paru' as an AUR helper? (y/n): "
read Input

if [ "$Input" == "y" ] || [ "$Input" == "yes" ]
then
    git clone https://aur.archlinux.org/paru.git /tmp/paru
	cd /tmp/paru
	makepkg -si
	cd $CurrentDir
fi

echo "Installing Layan Theme"
echo "#################################"
sudo pacman -S --needed --noconfirm layan-gtk-theme-git layan-kde-git tela-circle-icon-theme-git

# Install the Layan cursors globally
git clone https://github.com/vinceliuice/Layan-cursors /tmp/Layan-cursors
cp -r /tmp/Layan-cursors/dist/ /usr/share/icons/Layan-cursors
cp -r /tmp/Layan-cursors/dist-border/ /usr/share/icons/Layan-border-cursors
cp -r /tmp/Layan-cursors/dist-white/ /usr/share/icons/Layan-white-cursors

echo "Installing Fonts"
echo "#################################"
sudo pacman -S --needed --noconfirm nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-meslo nerd-fonts-terminus noto-fonts-emoji

echo "Applying new Rice, hold on..."
echo "#################################"
cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. /

#echo "Applying Grub Theme...."
#echo "#################################"
#chmod +x CyberRe.sh
#sudo ./CyberRe.sh
#sudo sed -i "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
#sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Rebooting system in 5 seconds..."
echo "#################################"
sleep 5
sudo reboot
