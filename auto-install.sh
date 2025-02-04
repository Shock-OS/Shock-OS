#!/bin/bash

#this script installs the Shock OS .deb packages in the current directory and prepares the system for initial setup

sudo apt install -y pipewire-audio || { echo "ERROR: Failed to install package pipewire-audio. Exiting..."; exit 1; }

sudo apt install -y ./"shockos-core_"* || { echo "ERROR: Failed to install shockos-core package. Exiting..."; exit 1; }
sudo apt install -y ./"shockos-deskenv-"* || { echo "ERROR: Failed to install shockos-deskenv package. Exiting..."; exit 1; }

for app in *
do
    if [[ "$app" == *'.deb' ]]
    then
        sudo apt install -y ./"$app" || { echo "ERROR: Failed to install ${app}. Exiting..."; exit 1; }
    fi
done
    
sudo apt update
sudo apt autopurge -y
sudo apt update

source /usr/lib/shockos/dist-info

# [BANDAID PATCH]: GDM THEME PATCH BEGINS
if [[ "$SHOCKOS_DESKENV" == "GNOME" ]]
then
    sudo /usr/libexec/shockos/gnome/bandaids/gdm-theme-patch.sh
fi
# [BANDAID PATCH]: GDM THEME PATCH ENDS

# Initial Setup stuff
if [[ "$SHOCKOS_DESKENV" == "GNOME" ]]
then
    echo "if [[ ! -f /tmp/shockos-initsetup/started.indicator ]]
then
    mkdir -p /tmp/shockos-initsetup
    touch /tmp/shockos-initsetup/started.indicator
    dbus-run-session -- bash -c 'export XDG_VTNR=\$(fgconsole) && XDG_SESSION_TYPE=wayland gnome-session'
fi" | tee /home/shockos/.bashrc
elif [[ "$SHOCKOS_DESKENV" == "MATE" ]]
then
    echo "if [[ ! -f /tmp/shockos-initsetup/started.indicator ]]
then
    mkdir -p /tmp/shockos-initsetup
    touch /tmp/shockos-initsetup/started.indicator
    dbus-run-session -- bash -c 'export XDG_VTNR=\$(fgconsole) && XDG_SESSION_TYPE=x11 startx'
fi" | tee /home/shockos/.bashrc
else
    echo 'ERROR: Could not get deskenv information from /usr/lib/shockos/dist-info. Exiting...'
    exit 1
fi
mkdir -p /home/shockos/.config/autostart/
echo '[Desktop Entry]
Type=Application
Exec=/usr/libexec/shockos/initsetup.sh
Hidden=false
Name=Shock OS Initial Setup Program
Comment=This program runs on a fresh installation of Shock OS to allow system configuration and user creation.
X-GNOME-Autostart-Delay=0
X-MATE-Autostart-Delay=0' | tee /home/shockos/.config/autostart/shockos-initsetup.desktop

