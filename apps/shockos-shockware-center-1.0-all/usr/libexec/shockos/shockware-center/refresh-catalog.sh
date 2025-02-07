#!/bin/bash

#This script is used to refresh the package catalog and convert the yaml appstream files to xml for use with the Shockware Center. This script also includes a patch that enables the Shockware Center to run on 32-bit systems.

if (($(id -u)!=0))
then
    echo "Script must be run as root. Exiting..."
    exit
fi

source /usr/share/shockos/shockware-center/appstream-dirs
apt update
mkdir -p "$apt_appstream_dir"/xml
if (($(getconf LONG_BIT)==32)) # Patch for 32-bit systems
then
    codename="$(lsb_release -cs)"
    mkdir -p "$apt_appstream_dir"/yaml
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-contrib/48x48
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-main/48x48
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-non-free/48x48
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-contrib/64x64
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-main/64x64
    mkdir -p "$apt_appstream_dir"/icons/debian-"$codename"-non-free/64x64
    if [[ "$(wget https://appstream.debian.org/data/"$codename"/contrib/icons-48x48.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-contrib/48x48 2>&1)" != *"fail"* ]]
    then
        wget https://appstream.debian.org/data/"$codename"/main/icons-48x48.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-main/48x48
        wget https://appstream.debian.org/data/"$codename"/non-free/icons-48x48.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-non-free/48x48
        wget https://appstream.debian.org/data/"$codename"/contrib/icons-64x64.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-contrib/64x64
        wget https://appstream.debian.org/data/"$codename"/main/icons-64x64.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-main/64x64
        wget https://appstream.debian.org/data/"$codename"/non-free/icons-64x64.tar.gz -P "$apt_appstream_dir"/icons/debian-"$codename"-non-free/64x64
        cd "$apt_appstream_dir"/icons/debian-"$codename"-contrib/48x48
        unp -f *.gz
        rm *.gz
        cd "$apt_appstream_dir"/icons/debian-"$codename"-main/48x48
        unp -f *.gz
        rm *.gz
        cd "$apt_appstream_dir"/icons/debian-"$codename"-non-free/48x48
        unp -f *.gz
        rm *.gz
        cd "$apt_appstream_dir"/icons/debian-"$codename"-contrib/64x64
        unp -f *.gz
        rm *.gz
        cd "$apt_appstream_dir"/icons/debian-"$codename"-main/64x64
        unp -f *.gz
        rm *.gz
        cd "$apt_appstream_dir"/icons/debian-"$codename"-non-free/64x64
        unp -f *.gz
        rm *.gz
        wget https://appstream.debian.org/data/"$codename"/contrib/Components-armhf.yml.gz -O "$apt_appstream_dir"/yaml/debian-"$codename"-contrib-Components-armhf.yml.gz
        wget https://appstream.debian.org/data/"$codename"/main/Components-armhf.yml.gz -O "$apt_appstream_dir"/yaml/debian-"$codename"-main-Components-armhf.yml.gz
        wget https://appstream.debian.org/data/"$codename"/non-free/Components-armhf.yml.gz -O "$apt_appstream_dir"/yaml/debian-"$codename"-non-free-Components-armhf.yml.gz
    fi
fi

for i in "$apt_appstream_dir"/yaml/*
do
    appstreamcli convert "$i" "$apt_appstream_dir"/xml/"$(basename "$i")".xml
done
