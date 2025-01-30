#!/bin/bash

# This script hides unwanted apps from the applications menu

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

apps_to_hide=(
'/usr/share/applications/display-im6.q16.desktop'
'/usr/share/applications/ca.desrt.dconf-editor.desktop'
'/usr/share/applications/caja-file-management-properties.desktop'
'/usr/share/applications/mate-volume-control.desktop'
'/usr/share/applications/mate-tweak.desktop'
'/usr/share/applications/mate-font-viewer.desktop'
'/usr/share/applications/mate-appearance-properties.desktop'
'/usr/share/applications/picom.desktop'
'/usr/share/applications/mpv.desktop'
'/usr/share/applications/zutty.desktop'
)

/usr/libexec/shockos/batch-hide-apps.sh "${apps_to_hide[@]}"

