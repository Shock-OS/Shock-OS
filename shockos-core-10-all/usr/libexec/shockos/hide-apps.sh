#!/bin/bash

# This script hides unwanted apps from the applications menu

apps_to_hide=('/usr/share/applications/htop.desktop' '/usr/share/applications/yad-icon-browser.desktop')

/usr/libexec/shockos/batch-hide-apps.sh "${apps_to_hide[@]}"

if [[ -f /usr/libexec/shockos/hide-apps-deskenv.sh ]]
then
    /usr/libexec/shockos/hide-apps-deskenv.sh
fi
