sudo pacman-key --init
sudo pacman-key --populate artix
sudo pacman -Sy

# Autologin to user on boot
if ! sudo cat /etc/init.d/agetty.tty1 | grep -Fq "agetty_options"
then
	sudo sed -i "/^description=.*/a agetty_options=\"--autologin $USER --noclear\"" /etc/init.d/agetty.tty1
fi

# Add arch mirrors

if ! sudo cat /etc/pacman.conf | grep -Fq "ARCHLINUX"
then
	sudo pacman -S --noconfirm artix-archlinux-support
	sudo pacman-key --populate archlinux
	sudo tee -a /etc/pacman.conf <<"EOF"
# ARCHLINUX
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

#[multilib]
#Include = /etc/pacman.d/mirrorlist-arch
EOF
	sudo pacman -Sy
fi


echo "User is $USER"
echo "Home is $HOME"

# Font Key workaround
keyFile="$HOME/.gnupg/gpg.conf"
if ! { [ -f "$keyFile" ] && grep -Fq "FONT_WORKAROUND" "$keyFile"; }
then
	cat >> "$keyFile" <<"EOF"
# FONT_WORKAROUND
keyserver hkps://keyserver.ubuntu.com
EOF
fi

# Install paru
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si --noconfirm --needed )
rm -rf paru

git clone https://github.com/alansartorio/Artix-Config.git || (cd Artix-Config; git pull)
ln -s "$(pwd)/Artix-Config/install.sh" /bin/install

# Install some packages
sudo pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa ntfs-3g openssh xorg xorg-xinit wget zsh openrc-zsh-completions bspwm sxhkd feh rofi alacritty # kdeconnect connman-gtk
paru -S --noconfirm --needed polybar siji-git ttf-unifont xorg-fonts-misc neovim

paru -S --noconfirm --needed neofetch firefox dolphin cmst


# Install my dotfiles
git clone https://github.com/alansartorio/dotfiles.git .dotfiles || (cd .dotfiles; git pull)
cd .dotfiles
script/install
script/bootstrap

