#!/bin/bash

# This script hides unwanted apps from the applications menu

session_files=(
'/usr/share/xsessions/gnome-classic.desktop'
'/usr/share/xsessions/gnome-classic-xorg.desktop'
'/usr/share/wayland-sessions/gnome-classic.desktop'
'/usr/share/wayland-sessions/gnome-classic-wayland.desktop'
)

for session in "${session_files[@]}"
do
    if ! grep -Fxq "Hidden=true" "$session"
    then
        if grep -q '^Hidden=' "$session"
        then
            sed -i '/^Hidden=/c\Hidden=true' "$session"
        else
            echo 'Hidden=true' | tee -a "$session"
        fi
    fi
done
# The above commands hide the GNOME Classic sessions

apps_to_hide=('/usr/share/applications/org.gnome.font-viewer.desktop' '/usr/share/applications/zutty.desktop')

/usr/libexec/shockos/batch-hide-apps.sh "${apps_to_hide[@]}"
