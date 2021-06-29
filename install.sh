HOME=/home/artix



mkdir "$HOME"
chown artix:artix "$HOME"

chsh -s /bin/bash artix
userScript=%READCONTENT userInstall.sh
sudo -u artix sh -c "$userScript"

chsh -s /bin/zsh artix
