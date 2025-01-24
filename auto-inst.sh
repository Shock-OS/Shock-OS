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

# Initial Setup stuff
source /usr/lib/shockos/shockos-dist-info.sh
if [[ "$SHOCKOS_DESKENV" == "GNOME" ]]
then
    echo "dbus-run-session -- bash -c 'export XDG_VTNR=\$(fgconsole) && XDG_SESSION_TYPE=wayland gnome-session'" | tee /home/shockos/.bash_profile
elif [[ "$SHOCKOS_DESKENV" == "MATE" ]]
then
    echo 'startx' | tee /home/shockos/.bash_profile #should probably be replaced with dbus cmd like GNOME edition
    echo 'mate-session' | tee /home/shockos/.xinitrc #should probably be replaced with dbus cmd like GNOME edition
else
    echo 'ERROR: Could not get deskenv information from /usr/lib/shockos/shockos-dist-info.sh. Exiting...'
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

