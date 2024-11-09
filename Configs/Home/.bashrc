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

## Lists the reverse dependencies of the specified package in the system.
## Usage: paru-deps <package_name>
paru-deps()
{
    paru -Qii "$*" | rg -e '(^Name|^Required By|^Optional For)'
}

## Prints the git branch of the current directory to stdout or a whitespace
## if the current directory is not in a git repository.
## Usage: git_branch
git_branch()
{
    local -r branch=$(git branch 2> /dev/null | sed -nr "s/^\* (\S.+)$/\1/p")
    [[ -n $branch ]] && echo " ($branch) " || echo ' '
}

## Prints learning material about a programming language or a tool to stdout.
## Usage: cheat <language>
cheat()
{
    [[ -n $1 ]] && curl cheat.sh/"$1"/:learn || curl cheat.sh
}

## Sources a bash file if it exists.
## Usage: source_if_exists <path_to_sh_file>
source_if_exists()
{
    if [[ -f $* ]]; then
        source "$*"
    fi
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
## Usage: ls
## Usage: ls <args>
## Usage: ls <file_path>
## Usage: ls <args> <file_path>
## Example args: -l, -a, -Ta, -lah
ls()
{
    local -r exa_args='--color=always --group-directories-first --icons'

    if [[ ${*} =~ -.+$ ]]; then
        exa $exa_args "$@"
    else
        exa $exa_args -la "$@"
    fi
}

## Watch network packets on Flatpak Wireshark.
## Usage: packets
packets()
{
    pkexec tcpdump -i enp0s31f6 -U -w - | flatpak run --branch=stable --arch=x86_64 --device=all --filesystem=host --file-forwarding=host --share=network org.wireshark.Wireshark -k -i - > /dev/null 2>&1 | xargs -0 -n1 sh -c 'wireshark "$@" < /dev/null' sh > /dev/null 2>&1 & disown
}

## Creates or resets a network bridge and connects it with a host network.
## Usage: bridgenetwork
## Usage: bridgenetwork <bridge_name>
## Usage: bridgenetwork <bridge_name> <network_name>
bridgenetwork()
{
    local -r blue_color='\033[0;34m'  # ANSI blue color.
    local -r reset_color='\e[0m'      # ANSI default color.
    local -r bridge=$([[ -z $1 ]] && echo 'virbr0' || echo "$1")
    local -r host_network=$([[ -z $2 ]] && echo 'enp0s31f6' || echo "$2")
    local -r host_ip_regex="${host_network}[ a-zA-Z]+(([0-9]{1,3}\.?\/?){5})"
    local -r host_address=$([[ $(ip -br addr show) =~ $host_ip_regex ]] && echo "${BASH_REMATCH[1]}" || echo '192.168.15.10/24')

    # If host network does not exist, exit.
    if ! [[ $(ip -br addr show) =~ $host_network ]]; then
        echo -e "The provided host network ${blue_color}${host_network}${reset_color} does not exist." >&2
        return 1
    fi

    # If bridge already exists, remove it.
    if [[ $(bridge link) =~ $bridge ]]; then
        sudo ip link set "$bridge" nomaster
        sudo ip link set "$bridge" down
        sudo ip link delete "$bridge" type bridge
    fi

    # Create the bridge.
    sudo ip link add name "$bridge" type bridge
    sudo ip link set "$host_network" master "$bridge"
    sudo ip link set dev "$bridge" up
    sudo ip addr add dev "$bridge" "$host_address"

    echo -e "Successfully connected bridge ${blue_color}${bridge}${reset_color} to the network ${blue_color}${host_network}${reset_color} at address ${blue_color}${host_address}${reset_color}."
}

## Spins down an HDD device.
## Usage: sleepdrive /dev/sdX
sleepdrive()
{
    if ! [[ $(file "$1") =~ block ]]; then
        echo "Drive $1 not found." >&2
        return 1
    fi

    udisksctl power-off -b "$1" > /dev/null 2>&1
}

## Quick initialization of frequently used programs.
## Usage: startup
startup()
{
    udisksctl power-off -b /dev/sdb > /dev/null 2>&1
    element-desktop > /dev/null 2>&1 & disown
    tutanota-desktop > /dev/null 2>&1 & disown
    vesktop > /dev/null 2>&1 & disown
    betterbird > /dev/null 2>&1 & disown
    com.rtosta.zapzap > /dev/null 2>&1 & disown
}

# ble.sh attach START
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach

# The terminal's prompt
# The pattern \[ASCII_COLOR\] defines a color
# For example: \[\033[0;36m\]
PS1='\[\033[0;36m\][\u@\h \W]\$\[\033[0;32m\]$(git_branch)\[\033[0m\]'

# Exported environment variables
export HISTCONTROL=ignoreboth:erasedups
#export GPG_TTY=$(tty)   # Enable commit signing in the shell
#export EDITOR=nano      # Set nano as the default text editor for sudoedit

# LF icons and behavior
source_if_exists "${XDG_CONFIG_HOME}/lf/lfcd.sh"
source_if_exists "${XDG_CONFIG_HOME}/lf/icons.sh"
alias lf='lfcd'

# Add local applications to the shell
if [[ -d "$HOME/.bin" ]]; then
    PATH="$HOME/.bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.dotnet/tools" ]]; then
    PATH="$HOME/.dotnet/tools:$PATH"
fi

# Ignore upper and lowercase during TAB completion
bind "set completion-ignore-case on"

# Music
alias lofi="mpv --no-terminal --no-video --force-window https://www.youtube.com/watch?v=jfKfPfyJRdk & disown"
alias synthwave="mpv --no-terminal --no-video --force-window https://www.youtube.com/watch?v=UedTcufyrHc & disown"
alias asot="mpv --no-terminal --no-video --force-window https://www.youtube.com/watch?v=NGsjwNsXE0w & disown"
alias asot-video="mpv --no-terminal --force-window https://www.youtube.com/watch?v=NGsjwNsXE0w & disown"

# Youtube
alias youtube='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" --merge-output-format mp4 '

# Check disk usage
alias disk='sudo btrfs filesystem usage /'

# Userlist
alias userlist="cut -d: -f1 /etc/passwd"

# Get the fastest mirrors for your location
alias update-mirrors='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist'

# Bash aliases
alias reload='cd ~ && source ~/.bashrc'
alias cls='clear'

# Replace cat with bat
alias cat='bat --paging=never '

# Configuration files
alias bashrc='kate ~/.bashrc'
alias pacmanconf='sudo -e /etc/pacman.conf'
alias mkinitcpioconf='sudo -e /etc/mkinitcpio.conf'
alias makepkgconf='sudo -e /etc/makepkg.conf'
alias refindconf='sudo -e /efi/EFI/refind/refind.conf'
alias refindlinuxconf='sudo -e /boot/refind_linux.conf'
alias sambaconf='sudo -e /etc/samba/smb.conf'
alias repolist='sudo -e /etc/pacman.d/mirrorlist'

# 'cd' aliases
alias repo='cd ~/Documents/Programming/Repositories'
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

# Recent Installed Packages
alias latest-packages="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias oldest-packages="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# Get kernel logs
alias journal='journalctl -x -b 0'
alias journal-errors='journalctl -x -p 3 -b 0'
alias journal-lasterrors='journalctl -x -p 3 -b 1'

# Shutdown and reboot
alias reboot="sudo reboot"
alias shutdown="sudo shutdown now"

# Package management
alias update='time flatpak update && time paru --disable-download-timeout -Syu '
alias update-aur='paru --disable-download-timeout -Sua '
alias pacman-unlock="sudo rm /var/lib/pacman/db.lck"
alias paru-local='paru -Qs '
alias paru-info='paru -Sii '
alias paru-search='paru -Ss '
alias paru-remove='paru -Rn '
alias paru-install='paru --disable-download-timeout -S '
alias paru-installdeps='paru --asdeps --disable-download-timeout -S '
alias paru-localinstall='paru -U '
alias paru-clear='paru -Scc'
alias paru-autoremove='paru -Rn $(paru -Qtdq)'

# Development
alias valgrind='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose -s '
alias cloc='cloc --vcs=git .'

# Networking
alias myip='curl -s http://tnx.nl/ip | tr -d "<>"'

# C#
alias csharp='csharprepl'
alias ef-add='dotnet ef migrations add '
alias ef-remove='dotnet ef migrations remove '
alias ef-update='dotnet ef database update'

# Sleep backup drive
alias sleephdd='sleepdrive /dev/sdb'

# Sudo
alias mount-degraded='sudo mount -o ro,degraded '
alias mount-storage='sudo mount --mkdir -o rw,noatime,commit=120,compress=zstd:5,discard=async,space_cache=v2 /dev/sda1 /run/media/$USER/storage_ssdsata'

clear

# ble.sh attach FINISH
[[ ${BLE_VERSION-} ]] && ble-attach
