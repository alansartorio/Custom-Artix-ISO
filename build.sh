ROOT=/var/lib/artools/buildiso/base/artix/rootfs

sudo cp install.sh userInstall.sh "$ROOT/"
artix-chroot "$ROOT" /install.sh
sudo rm "$ROOT/"{install.sh,userInstall.sh}

buildiso -p base -sc
buildiso -p base -bc
buildiso -p base -zc
