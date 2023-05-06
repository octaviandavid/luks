#!/usr/bin/bash

# run as root check
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root."
    exit
fi

if [ -f ".env" ]; then
    export $(echo $(cat ".env" | sed 's/#.*//g'| xargs) | envsubst)
else
    cp .env.sample .env
    echo "Please check .env file values before attemting a rerun."
    exit
fi

export DEV="/dev/${DISK}"

lsblk

sgdisk --print $DEV

echo "WARNING! Formatting drive ${DEV}... Press ENTER to continue."
read

sgdisk --zap-all $DEV

