#!/bin/bash

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
