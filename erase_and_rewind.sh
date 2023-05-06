#!/usr/bin/bash

if [ -f ".env" ]; then
    export $(echo $(cat ".env" | sed 's/#.*//g'| xargs) | envsubst)
fi

export DEV="/dev/${DISK}"

echo "WARNING! Formatting drive ${DEV}... Press ENTER to continue."
read

