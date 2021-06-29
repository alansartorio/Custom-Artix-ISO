ROOT=/var/lib/artools/buildiso/base/artix/rootfs

sudo cp installLive.sh "$ROOT/"
artix-chroot "$ROOT" /installLive.sh
sudo rm "$ROOT/installLive.sh"

buildiso -p base -sc
buildiso -p base -bc
buildiso -p base -zc
