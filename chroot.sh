

sudo arch-chroot /mnt /bin/bash

# in chroot

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

grub-mkconfig -o /boot/grub/grub.cfg

tree /boot -L 2















