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

# Exported environment variables
export HISTCONTROL=ignoreboth:erasedups
export GPG_TTY=$(tty) # Enable commit signing in the shell
export EDITOR=nano    # Set nano as the default text editor for sudoedit

# The terminal's prompt
PS1='[\u@\h \W]\$ '

# Add local applications to the shell
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# Ignore upper and lowercase during TAB completion
bind "set completion-ignore-case on"

# Replace cat with bat
alias cat='bat --paging=never '

# Check disk usage
alias disk='sudo btrfs filesystem usage /'

# Userlist
alias userlist="cut -d: -f1 /etc/passwd"

# Get the fastest mirrors for your location
alias update-mirrors='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist'

#Bash aliases
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
alias etc='cd /etc'
alias music='cd ~/Music'
alias videos='cd ~/Videos'
alias conf='cd ~/.config'
alias desktop='cd ~/Desktop'
alias pictures='cd ~/Pictures'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias global-apps='cd /usr/share/applications'
alias local-apps='cd ~/.local/share/applications'

#Recent Installed Packages
alias newest-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias oldest-installed="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# Get kernel logs
alias journal='journalctl -x -b 0'
alias journal-errors='journalctl -x -p 3 -b 0'
alias journal-lasterrors='journalctl -x -p 3 -b 1'

# Shutdown and reboot
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"

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

## Lists the reverse dependencies of the specified package in the system.
## Usage: paru-deps <package_name>
paru-deps()
{
    paru -Qii "$*" | rg -e '(^Name|^Required By|^Optional For)'
}

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

    local -r lname="$(basename "$1")"
    local -r rname="$(basename "$2")"
    local -r owner1="$(stat -c '%U' $1)"
    local -r owner2="$(stat -c '%U' $2)"
    local -r priv=$([[ $owner1 == "root" || $owner2 == "root" ]] && echo "sudo" || echo "")

    ( cd "$(dirname "$1")" && $priv mv -T "$lname" ".${rname}" ) && \
    ( cd "$(dirname "$2")" && $priv mv -T "$rname" "$lname" ) && \
    ( cd "$(dirname "$1")" && $priv mv -T ".${rname}" "$rname" )
}

## Replace ls with exa.
## Usage: ls <args> <file_path>
ls()
{
    local -r exa_args='--color=always --group-directories-first --icons'

    if [[ ${*} =~ -.+$ ]]; then
        exa $exa_args "$@"
    else
        exa $exa_args -la "$@"
    fi
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
