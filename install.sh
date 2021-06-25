HOME=/home/artix

mkdir "$HOME"
chown artix:artix "$HOME"
cp /userInstall.sh "$HOME/install.sh"
chsh -s /bin/bash artix
su artix -c "cd $HOME; source install.sh"
rm "$HOME/install.sh"
chsh -s /bin/zsh artix
