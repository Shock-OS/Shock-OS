#!/bin/bash

if [[ " $* " =~ ' --count ' ]]
then
    sudo /usr/libexec/shockos/update-manager/apt-update.sh > /dev/null 2>&1
    flatpak update -y --appstream > /dev/null 2>&1
    apt_updates="$(apt list --upgradable | tail -n +2 | wc -l)"
    flatpak_updates="$(flatpak remote-ls --updates | wc -l)"
    echo $((apt_updates + flatpak_updates))
else
    sudo /usr/libexec/shockos/update-manager/apt-update.sh
    flatpak update -y --appstream
fi

