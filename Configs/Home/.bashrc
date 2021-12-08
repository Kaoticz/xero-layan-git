#
# ~/.bashrc
#

#Ibus settings if you need them
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups

PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"

# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l='exa -lah --color=always --group-directories-first --icons' # tree listing

#available free memory
alias free="free -h"

#continue download
alias wget="wget -c"

# Check disk usage
alias disk='sudo btrfs filesystem usage /'

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#Pacman for software managment
alias pacman-local='sudo pacman -Qs'
alias pacman-search='sudo pacman -Ss'
alias pacman-remove='sudo pacman -R'
alias pacman-install='sudo pacman -S --disable-download-timeout '
alias pacman-localinstall='sudo pacman -U '
alias pacman-upgrade='pacman -Sy archlinux-keyring --needed --noconfirm && sudo pacman -Syyu'
alias pacman-clrcache='sudo pacman -Scc'
alias pacman-update='sudo pacman -Sy'
alias pacman-autoremove='sudo pacman -Rns $(pacman -Qtdq)'
alias pacman-unlock="sudo rm /var/lib/pacman/db.lck"
alias update='paru -Syyu && flatpak update && pacman-upgrade'

#Paru as AUR helper
alias paru-local='paru -Qs '
alias paru-install='paru -S '
alias paru-remove='paru -Rs '
alias paru-search='paru -Ss '
alias paru-update='paru -Syyu'

#Snap Update
#alias sup='sudo snap refresh'

#grub update
alias grub-refresh='sudo grub-mkconfig -o /boot/grub/grub.cfg'

#get fastest mirrors in your neighborhood
alias mirrortest='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist'

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Public /home/$USER/Public"

#Bash aliases
alias journal='journalctl -p 3 -xb'
alias screensaver='xscreensaver-demo'
alias reload='cd ~ && source ~/.bashrc'
alias cls='clear'

#hardware info --short
alias hw="hwinfo --short"

#youtube-dl
alias ytv-best='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" --merge-output-format mp4 '

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#Copy/Remove files/dirs
alias rmd='rm -r'
alias srm='sudo rm'
alias srmd='sudo rm -r'
alias cpd='cp -R'
alias scp='sudo cp'
alias scpd='sudo cp -R'

#nano
alias bashrc='sudo nano ~/.bashrc'
alias sddmconf='sudo nano /etc/sddm.conf'
alias pacmanconf='sudo nano /etc/pacman.conf'
alias makepkgconf='sudo nano /etc/makepkg.conf'
alias grubconf='sudo nano /etc/default/grub'
alias sambaconf='sudo nano /etc/samba/smb.conf'
alias repolist='sudo nano /etc/pacman.d/mirrorlist'

#cd/ aliases
alias home='cd ~'
alias etc='cd /etc/'
alias music='cd ~/Music'
alias videos='cd ~/Videos'
alias conf='cd ~/.config'
alias desktop='cd ~/Desktop'
alias pictures='cd ~/Pictures'
alias donwloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias sapps='cd /usr/share/applications'
alias lapps='cd ~/.local/share/applications'

#switch between lightdm and sddm
#alias tolightdm="sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed ; sudo systemctl enable lightdm.service -f ; echo 'Lightm is active - reboot now'"
#alias tosddm="sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo 'Sddm is active - reboot now'"

#Recent Installed Packages
alias last-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias oldest-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# Shutdown and reboot
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"

# # ex = EXtractor for all kinds of archives
# # usage: extract <file>
extract ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

clear