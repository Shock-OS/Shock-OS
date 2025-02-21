#!/bin/bash

function get_bg {
gsettings get org.mate.background picture-filename | sed -E 's/^["\x27]+|["\x27]+$//g'
}

function set_bg_alpha {
local current_bg="$(get_bg)"
local total_files=$(ls "$imgdir"/* | wc -l)
local current_file=$(ls "$imgdir"/* | grep -n "$current_bg" | cut -d: -f1)
until [[ "$next_bg" != "$current_bg" ]] && [[ "$type" == 'image/'* ]]
do
    current_file=$((current_file+1))
    if ((current_file>total_files))
    then
        current_file=1
    fi
    local next_bg="$(ls "$imgdir"/* | sed -n "${current_file}p")"
    local type="$(file -b --mime-type "$next_bg")"
done
gsettings set org.mate.background picture-filename "$next_bg"
}

function set_bg_random {
local current_bg="$(get_bg)"
until [[ "$random_bg" != "$current_bg" ]] && [[ "$type" == 'image/'* ]]
do
    local random_bg="$(ls "$imgdir"/* | shuf -n 1)"
    local type="$(file -b --mime-type "$random_bg")"
done
gsettings set org.mate.background picture-filename "$random_bg"
}

function set_bg {
local order="$(gsettings get net.shockos.mate.backgrounds.slideshow order | sed -E 's/^["\x27]+|["\x27]+$//g')"
if [[ "$order" == 'alpha' ]]
then
    set_bg_alpha
elif [[ "$order" == 'random' ]]
then
    set_bg_random
fi
}

if "$(gsettings get net.shockos.mate.backgrounds.slideshow enabled)"
then
    imgdir="$(gsettings get net.shockos.mate.backgrounds.slideshow folder | sed -E 's/^["\x27]+|["\x27]+$//g')"
    delay="$(gsettings get net.shockos.mate.backgrounds.slideshow delay)"
    delay="${delay#* }"
    delay=$((delay*60))
    if [[ -f ~/.cache/shockos-tmp/shockos-mate-backgrounds/slideshow-changenow-indicator ]]
    then
        set_bg
        rm ~/.cache/shockos-tmp/shockos-mate-backgrounds/slideshow-changenow-indicator
    fi
    while true
    do
        sleep $delay
        set_bg
    done
fi

