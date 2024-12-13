#!/bin/bash

if [[ -f ~/.config/shockos/first-run-indicator ]]
then
    /usr/libexec/shockos/startup-deskenv.sh
    /usr/libexec/shockos/set-audio-out-to-hdmi.sh
    rm ~/.config/shockos/first-run-indicator
fi

mkdir -p ~/.cache/shockos-tmp
rm -r ~/.cache/shockos-tmp/* &
