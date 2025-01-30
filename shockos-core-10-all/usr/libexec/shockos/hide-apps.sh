#!/bin/bash

# This script hides unwanted apps from the applications menu

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

apps_to_hide=('/usr/share/applications/htop.desktop' '/usr/share/applications/yad-icon-browser.desktop')

/usr/libexec/shockos/batch-hide-apps.sh "${apps_to_hide[@]}"

if [[ -f /usr/libexec/shockos/hide-apps-deskenv.sh ]]
then
    /usr/libexec/shockos/hide-apps-deskenv.sh
fi
