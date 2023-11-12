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
export GPG_TTY=$(tty) # Enable commit signing in the shell
export EDITOR=nano    # Set nano as the default text editor for sudoedit

PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# Ignore upper and lowercase during TAB completion
bind "set completion-ignore-case on"

# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l='exa -lah --color=always --group-directories-first --icons' # tree listing

# Check disk usage
alias disk='sudo btrfs filesystem usage /'

# Userlist
alias userlist="cut -d: -f1 /etc/passwd"

# Package managment
alias pacman-unlock="sudo rm /var/lib/pacman/db.lck"
alias update='flatpak update && paru -Syu '
alias paru-local='paru -Qs '
alias paru-search='paru -Ss '
alias paru-remove='paru -Rs '
alias paru-install='paru --disable-download-timeout -S '
alias paru-upgrade='paru --disable-download-timeout -Syu '
alias paru-localinstall='paru -U '
alias paru-clear='paru -Scc'
alias paru-autoremove='sudo paru -Rns $(paru -Qtdq)'

# Get the fastest mirrors for your location
alias update-mirrors='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist'

#Bash aliases
alias journal='journalctl -p 3 -xb'
alias screensaver='xscreensaver-demo'
alias reload='cd ~ && source ~/.bashrc'
alias cls='clear'

# Youtube
alias youtube='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" --merge-output-format mp4 '

# Configuration files
alias bashrc='kate ~/.bashrc & disown'
alias pacmanconf='sudo -e /etc/pacman.conf'
alias makepkgconf='sudo -e /etc/makepkg.conf'
alias refindconf='sudo -e /efi/EFI/refind/refind.conf'
alias refindlinuxconf='sudo -e /boot/refind_linux.conf'
alias sambaconf='sudo -e /etc/samba/smb.conf'
alias repolist='sudo -e /etc/pacman.d/mirrorlist'

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
alias global-apps='cd /usr/share/applications'
alias local-apps='cd ~/.local/share/applications'

#Recent Installed Packages
alias newest-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias oldest-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# Shutdown and reboot
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"

## Extracts a compressed file.
## Usage: extract <file>
extract ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   unzstd "$1"    ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## Swaps the name of one file with another (also works for directories, drives and pipes).
## Usage: swap <test1.txt> <test2.txt>
swap ()
{
    test $# -eq 2 || return 2

    test -e "$1" || return 3
    test -e "$2" || return 3

    local lname="$(basename "$1")"
    local rname="$(basename "$2")"
    local owner1="$(stat -c '%U' $1)"
    local owner2="$(stat -c '%U' $2)"
    local priv=$([[ $owner1 == "root" || $owner2 == "root" ]] && echo "sudo" || echo "")

    ( cd "$(dirname "$1")" && $priv mv -T "$lname" ".${rname}" ) && \
    ( cd "$(dirname "$2")" && $priv mv -T "$rname" "$lname" ) && \
    ( cd "$(dirname "$1")" && $priv mv -T ".${rname}" "$rname" )
}

# Quick initialization of frequently used programs.
# Usage: startup
startup()
{
    discord > /dev/null & disown
    element-desktop > /dev/null & disown
    betterbird > /dev/null & disown
    tutanota-desktop > /dev/null & disown
    io.github.mimbrero.WhatsAppDesktop > /dev/null & disown
}

clear
