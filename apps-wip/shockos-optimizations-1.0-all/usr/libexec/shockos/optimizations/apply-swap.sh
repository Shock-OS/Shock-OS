#!/bin/bash

swap_gb="$1"
if [[ -e /swapfile ]]
then
    swapoff /swapfile
    rm -r /swapfile
fi
fallocate -l "${swap_gb}G" /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

