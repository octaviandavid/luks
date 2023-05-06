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
    echo "Please check .env file values before attemting a rerun."
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


sgdisk --new=1:0:+768M $DEV
sgdisk --typecode=1:8301 $DEV 
sgdisk --change-name=1:/boot $DEV

sgdisk --new=2:0:+2M $DEV
sgdisk --typecode=2:ef02 $DEV 
sgdisk --change-name=2:GRUB $DEV

sgdisk --new=3:0:+128M $DEV
sgdisk --typecode=3:ef00 $DEV 
sgdisk --change-name=3:EFI-SP $DEV 

sgdisk --new=5:0:0 $DEV
sgdisk --typecode=5:8301 $DEV
sgdisk --change-name=5:rootfs $DEV

sgdisk --hybrid 1:2:3 $DEV

sgdisk --print $DEV


