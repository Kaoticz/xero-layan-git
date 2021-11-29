#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! Proceeding in 5 seconds"
echo "##########################################"
sleep 5

echo "Updating the system in case required"
echo "#####################################"
sudo apt update && sudo apt upgrade -y

echo "Creating Backups of ~/.config folder"
echo "#####################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)

echo "Installing required Tools"
echo "#################################"
sudo apt install qt5-style-kvantum latte-dock lolcat neofetch yakuake -y

echo "Installing Layan Theme"
echo "#################################"
git clone https://github.com/vinceliuice/Layan-kde && cd Layan-kde && ./install.sh
cd ..
git clone https://github.com/vinceliuice/Tela-circle-icon-theme && cd Tela-circle-icon-theme && ./install.sh -c purple
cd ..
git clone https://github.com/vinceliuice/Layan-gtk-theme && cd Layan-gtk-theme && ./install.sh
cd ..

echo "Installing Fonts"
echo "#################################"
sudo apt install fonts-firacode fonts-font-awesome libfontawesomefx-java fonts-noto-color-emoji fonts-hack-ttf -y
mkdir -p ~/.local/share/fonts/FiraCodeNerd
cp -Rf FiraCodeNerd/. ~/.local/share/fonts/FiraCodeNerd/
sudo fc-cache -f -v

echo "Applying new Rice, hold on..."
echo "#################################"
cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. /

#echo "Applying Grub Theme...."
#echo "#################################"
#chmod +x CyberRe.sh
#sudo ./CyberRe.sh
#sleep 2
#echo "Activating Hidden Grub...."
#echo "#################################"
#sudo sed -i "s/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g" /etc/default/grub
#sudo sed -i "s/GRUB_TIMEOUT_STYLE/#GRUB_TIMEOUT_STYLE/g" /etc/default/grub
#sudo sed -i "s/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g" /etc/default/grub
#sudo sed -i "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
#sudo sed -i "s/GRUB_THEME/#GRUB_THEME/g" /etc/default/grub.d/99_breeze-grub.cfg
#sudo update-grub

echo "Rebooting system in 5 seconds..."
echo "#################################"
sleep 5
sudo reboot
