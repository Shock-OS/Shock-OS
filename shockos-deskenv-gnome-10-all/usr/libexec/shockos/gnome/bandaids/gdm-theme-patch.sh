#!/bin/bash

# This bandaid patch installs gdm-tools by realmazharhussain, an external script used to set the GDM theme to Yaru-purple-dark. After installation, it sets the GDM theme to Yaru-purple-dark and removes the temporary installation files for gdm-tools.

unzip /usr/share/shockos/gnome/bandaids/gdm/gdm-tools-1.2.zip -d /usr/share/shockos/gnome/bandaids/gdm/
/usr/share/shockos/gnome/bandaids/gdm/gdm-tools-1.2/install.sh --no-ask
set-gdm-theme -s Yaru-purple-dark
rm -rf /usr/share/shockos/gnome/bandaids/gdm
if (( $(ls /usr/share/shockos/gnome/bandaids/ | wc -l) < 1 ))
then
    rm /usr/share/shockos/gnome/bandaids
fi
