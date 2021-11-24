# Scripts for building a custom Artix live ISO configured with [my dotfiles](https://github.com/alansartorio/dotfiles)

First you have to run `buildiso -p base -x` to generate the chroot directory.

Then run `./build.sh` to configure the chroot and build the `.iso`.

Try the image with qemu:
`qemu-system-x86_64 -drive format=raw,file=~/artools-workspace/iso/base/artix-base-openrc-20211123-x86_64.iso -m 2G -display gtk,zoom-to-fit=on -enable-kvm`

Or burn it into a USB to try it in a real PC:
`dd bs=64M if=~/artools-workspace/iso/base/artix-base-openrc-20211123-x86_64.iso of=/dev/sde conv=fsync oflag=direct status=progress`

Troubleshooting:

overlayfs error: caused by kernel update without reboot. `sudo reboot`

==> ERROR: A failure occurred in make_bootfs().
    Aborting...
Solved with:
	`sudo rm -rf /var/lib/artools/buildiso/base/iso/boot`


