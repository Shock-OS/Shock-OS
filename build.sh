#!/bin/bash

DESKENV="${1^^}"
if [[ "$DESKENV" == "MATE" ]] || [[ "$DESKENV" == "GNOME" ]]
then
    day=$(date '+%e')
    if [[ "$day" == "11" ]] || [[ "$day" == "12" ]] || [[ "$day" == "13" ]]
    then
      suffix="th"
    else
      case $((day % 10)) in
        1) suffix="st";;
        2) suffix="nd";;
        3) suffix="rd";;
        *) suffix="th";;
      esac
    fi
    echo "SHOCKOS_BUILD_DATE=\"$(date "+%A, %B %e$suffix, %Y")\"" | tee ./shockos-core-10-all/usr/lib/shockos/dist-info
    if [[ -e ./BUILD_OUT ]]
    then
        rm -r ./BUILD-OUT
    fi
    mkdir ./BUILD-OUT
    cp ./auto-install.sh ./BUILD-OUT/
    dpkg-deb --build ./shockos-core-10-all ./BUILD-OUT
    dpkg-deb --build ./shockos-deskenv-"$1"-10-all ./BUILD-OUT
    for app in ./apps/*
    do
        if [[ -f "$app"/DEBIAN/control ]]
        then
            dpkg-deb --build "$app" ./BUILD-OUT
        fi
    done
    if [[ -d ./apps/"$DESKENV" ]]
    then
        for app in ./apps/"$DESKENV"/*
        do
            dpkg-deb --build "$app" ./BUILD-OUT
        done
    fi
else
    echo "ERROR: Must use either 'gnome' or 'mate' as an argument."
fi

