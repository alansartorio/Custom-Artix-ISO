export HOME=/home/artix
trust extract-compat

mkdir "$HOME"
chown artix:artix "$HOME"

chsh -s /bin/bash artix
userScript=%READCONTENT userInstall.sh
sudo -E -u artix sh -c "$userScript"

chsh -s /bin/zsh artix
