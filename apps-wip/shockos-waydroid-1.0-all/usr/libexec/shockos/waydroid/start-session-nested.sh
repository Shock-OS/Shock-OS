#!/bin/bash

source /usr/lib/shockos/dist-info

if [[ "$SHOCKOS_DESKENV" != 'MATE' ]]
then
    echo 'This script is only meant to be run on the MATE Edition of Shock OS. If you are using GNOME Edition, there is no need start Waydroid in a nested Weston compositor as GNOME already supports Wayland by default.'
    exit
fi
if [[ ! -f /run/user/"$(id -u)"/shockos-waydroid.lock ]]
then
    mkdir -p ~/.cache/shockos-tmp/waydroid
    weston --socket=shockos-waydroid --shell=kiosk-shell.so & pid=$!
    echo "$pid" | tee ~/.cache/shockos-tmp/waydroid/weston-pid
    while [[ ! -e /run/user/"$(id -u)"/shockos-waydroid ]]
    do
        sleep 0.2
    done
fi
while IFS= read -r line
do
    if [[ "$line" == *'Android with user'*'is ready'* ]]
    then
        exit
    fi
done < <(WAYLAND_DISPLAY=shockos-waydroid waydroid --details-to-stdout show-full-ui &)

