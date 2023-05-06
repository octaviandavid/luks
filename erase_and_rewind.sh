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


sgdisk --new=1:0:+8M $DEV
sgdisk --typecode=1:ef02 $DEV 
sgdisk --change-name=1:GRUB $DEV

sgdisk --new=2:0:+512M $DEV
sgdisk --typecode=2:ef00 $DEV 
sgdisk --change-name=2:EFI-SP $DEV 

sgdisk --new=3:0:+100G $DEV
sgdisk --typecode=3:8301 $DEV 
sgdisk --change-name=3:WINDOWS $DEV 

sgdisk --new=4:0:+768M $DEV
sgdisk --typecode=4:8301 $DEV 
sgdisk --change-name=4:/boot $DEV

sgdisk --new=5:0:0 $DEV
sgdisk --typecode=5:8301 $DEV
sgdisk --change-name=5:rootfs $DEV

sgdisk --hybrid 1:2:4 $DEV

sgdisk --print $DEV

echo $LUKS_PASSWORD | cryptsetup luksFormat --type=luks1 ${DEVP}4
echo $LUKS_PASSWORD | cryptsetup luksFormat ${DEVP}5

echo $LUKS_PASSWORD | cryptsetup open ${DEVP}4 LUKS_BOOT
echo $LUKS_PASSWORD | cryptsetup open ${DEVP}5 ${DM}5_crypt

ls /dev/mapper/

mkfs.vfat -F 16 -n EFI-SP ${DEVP}2

mkfs.ext4 -L boot /dev/mapper/LUKS_BOOT






