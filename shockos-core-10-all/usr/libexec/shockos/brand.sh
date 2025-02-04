#!/bin/bash

# This script installs Shock OS logos

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

sed -i '1s/.*/PRETTY_NAME="Shock OS X Jasmine"/' /usr/lib/os-release
cp -rf /usr/share/shockos/branding/debian-logos/* /usr/share/desktop-base/debian-logos/
for size in /usr/share/shockos/branding/emblems/*
do
    for image in "$size"/*
    do
        cp -f "$image" /usr/share/icons/desktop-base/"$(basename "$size")"/emblems/"$(basename "$image")"
    done
done
cp -rf /usr/share/shockos/branding/plymouth/* /usr/share/plymouth/
cp -f /usr/share/shockos/branding/start-here.svg /usr/share/icons/Yaru/scalable/places/
cp -f /usr/share/shockos/branding/start-here-symbolic.svg /usr/share/icons/Yaru/scalable/places/
