#!/usr/bin/bash

# run as root check
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -f ".env" ]; then
    export $(echo $(cat ".env" | sed 's/#.*//g'| xargs) | envsubst)
fi

export DEV="/dev/${DISK}"

lsblk

sgdisk --print $DEV

echo "WARNING! Formatting drive ${DEV}... Press ENTER to continue."
read

