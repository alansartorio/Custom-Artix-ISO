#!/bin/bash

ROOT=/var/lib/artools/buildiso/base/artix/rootfs

sudo cp installLive.sh "$ROOT/"
sudo ln /etc/ca-certificates/trust-source/anchors/bump.der "$ROOT/etc/ca-certificates/trust-source/anchors/bump.der"

# export http_proxy='localhost:3128'
# export https_proxy='localhost:3128'
# sudo tee -a "$ROOT/etc/environment" <<EOF
# EOF
sudo -E artix-chroot "$ROOT" /installLive.sh
sudo rm "$ROOT/installLive.sh"

buildiso -p base -sc
buildiso -p base -bc
buildiso -p base -zc
