#!/bin/bash

# This bandaid patch installs gdm-tools by realmazharhussain, an external script used to set the GDM theme to Yaru-purple-dark. After installation, it sets the GDM theme to Yaru-purple-dark and removes the temporary installation files for gdm-tools.

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

unzip /usr/share/shockos/gnome/bandaids/gdm/gdm-tools-1.2.zip -d /usr/share/shockos/gnome/bandaids/gdm/
/usr/share/shockos/gnome/bandaids/gdm/gdm-tools-1.2/install.sh --no-ask
set-gdm-theme -s Yaru-purple-dark
rm -rf /usr/share/shockos/gnome/bandaids/gdm
if (( $(ls /usr/share/shockos/gnome/bandaids/ | wc -l) < 1 ))
then
    rm -rf /usr/share/shockos/gnome/bandaids
fi
