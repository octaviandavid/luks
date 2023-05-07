#!/usr/bin/bash

# run as root check
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root."
    exit
fi

# .env check
if [ -f ".env" ]; then
    export $(echo $(cat ".env" | sed 's/#.*//g'| xargs) | envsubst)
else
    cp .env.sample .env
    echo "Please check .env file values before attempting a rerun."
    exit
fi

# config
export DEV="/dev/${DISK}"
export DM="${DEV##*/}"
export DEVP="${DEV}$( if [[ "$DEV" =~ "nvme" ]]; then echo "p"; fi )"
export DM="${DM}$( if [[ "$DM" =~ "nvme" ]]; then echo "p"; fi )"

# present state dump
lsblk

sgdisk --print $DEV

echo "WARNING! Formatting drive ${DEV}... Press ENTER to continue."
read

# execution
sgdisk --zap-all $DEV


sgdisk --new=1:0:+512M $DEV
sgdisk --typecode=1:8301 $DEV 
sgdisk --change-name=1:GRUB $DEV


#sgdisk --hybrid 1 $DEV

sgdisk --print $DEV

ls /dev/mapper/

mkfs.fat -F32 ${DEVP}1  

mkdir -p /mnt/boot

mount ${DEVP}1 /mnt/boot

pacman -Q grub || pacman -S --noconfirm grub   

sudo grub-install --root-directory=/mnt/boot /dev/sda













