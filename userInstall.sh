cd ~

alias paru='paru --sudoflags "-E"'
alias sudo='sudo -E'

# Autologin to user on boot
if ! sudo cat "/etc/init.d/agetty.tty1" | grep -Fq "agetty_options"
then
    sudo sed -i "/^description=.*/a agetty_options=\"--autologin $USER --noclear\"" "/etc/init.d/agetty.tty1"
fi

# Set TYPEOFDEVICE environment variable
if ! sudo cat "/etc/environment" | grep -Fq "TYPEOFDEVICE"
then
    echo "TYPEOFDEVICE=LIVEUSB" | sudo tee -a "/etc/environment"
fi

sudo pacman-key --init
sudo pacman-key --populate artix
sudo pacman -Sy --needed --noconfirm artix-keyring archlinux-keyring artix-archlinux-support
sudo pacman-key --populate archlinux
sudo pacman -Sy
# 

# Font Key workaround
keyFile="$HOME/.gnupg/gpg.conf"
if ! { [ -f "$keyFile" ] && grep -Fq "FONT_WORKAROUND" "$keyFile"; }
then
	cat >> "$keyFile" <<"EOF"
# FONT_WORKAROUND
keyserver hkps://keyserver.ubuntu.com
EOF
fi

cloneOrPull () {
    repo="$1"
    dir=${repo%.git}
    dir=${dir##*/}
    dir=${2:-$dir}
    git clone "$repo" "$dir" || (cd "$dir"; git pull)
}


# Install paru
sudo pacman -S --noconfirm --needed base-devel git
cloneOrPull https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si --noconfirm --needed )
rm -rf paru

# Add arch mirrors

if ! sudo cat "/etc/pacman.conf" | grep -Fq "ARCHLINUX"
then
	sudo tee -a "/etc/pacman.conf" <<"EOF"
# ARCHLINUX
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

#[multilib]
#Include = /etc/pacman.d/mirrorlist-arch

[options]
ParallelDownloads=6
EOF
	paru -S --noconfirm --needed rate-mirrors-bin
	rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist-arch
    sudo pacman -Sy
fi

# Download my Artix installer
cloneOrPull https://github.com/alansartorio/Artix-Config.git
ln -s "$(pwd)/Artix-Config/install.sh" /bin/install


# Install some packages
paru -S --noconfirm --needed pulseaudio pulseaudio-alsa ntfs-3g \
openssh xorg xorg-xinit wget zsh openrc-zsh-completions \
rofi alacritty neovim neofetch firefox dolphin networkmanager-openrc


sudo rc-update add NetworkManager

# Install my dotfiles
cloneOrPull https://github.com/alansartorio/dotfiles.git .dotfiles
cd .dotfiles
script/install
script/bootstrap
script/postinstall

zsh -c ""
