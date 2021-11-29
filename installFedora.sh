#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! Proceeding in 5 seconds"
echo "##########################################"
sleep 5

echo "Creating Backup of ~/.config folder"
echo "#####################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.
%d-%H.%M.%S)
echo "Installing required Tools"
echo "#################################"
sudo dnf install git-core gtk-murrine-engine gtk2-engines kvantum latte-dock lolcat neofetch yakuake -y

echo "Installing Layan Theme & Icons"
echo "#################################"
git clone https://github.com/vinceliuice/Layan-kde && cd Layan-kde && ./install.sh
cd ..
git clone https://github.com/vinceliuice/Tela-circle-icon-theme && cd Tela-circle-icon-theme && ./install.sh -c purple
cd ..
git clone https://github.com/vinceliuice/Layan-gtk-theme && cd Layan-gtk-theme && ./install.sh
cd ..

echo "Installing Fonts (Long Process)..."
echo "#################################"
sudo dnf install fira-code-fonts google-noto-emoji-fonts texlive-collection-basic dejavu-fonts-all texlive-fira -y
mkdir -p ~/.local/share/fonts/FiraCodeNerd
cp -Rf FiraCodeNerd/. ~/.local/share/fonts/FiraCodeNerd/
fc-cache -fv

echo "Applying new Rice, hold on..."
cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. /

#echo "Applying Grub Theme...."
#echo "#################################"
#chmod +x CyberRe.sh
#sudo ./CyberRe.sh
#sudo sed -i "s/GRUB_TERMINAL_OUTPUT/#GRUB_TERMINAL_OUTPUT/g" /etc/default/grub
#sudo sed -i "s/GRUB_ENABLE_BLSCFG=true/GRUB_ENABLE_BLSCFG=false/g" /etc/default/grub
#sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

echo "Rebooting system in 5 seconds..."
echo "#################################"
sleep 5
sudo reboot




