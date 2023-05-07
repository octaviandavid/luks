

sudo arch-chroot /mnt /bin/bash

# in chroot

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

grub-mkconfig -o /boot/grub/grub.cfg

tree /boot -L 2

cd /root
curl -s -L https://github.com/vinceliuice/grub2-themes/archive/refs/tags/2022-10-30.tar.gz | tar -xzvf -
cd grub2-themes-2022-10-30
./install.sh -b -t tela











