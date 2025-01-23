#!/bin/bash

# This script finalizes the setup process after the initial setup process has completed.

if [[ -f /usr/lib/shockos/initsetup/step ]]
then
    if [[ "$(cat /usr/lib/shockos/initsetup/step)" == "fin" ]]
    then
        echo "Finalizing setup... DO NOT POWER OFF DEVICE"
        sudo rm -r /etc/systemd/system/getty@tty1.service.d # removes the 'shock' user from autologin as the setup is complete
        sudo deluser --remove-home shockos
        sudo systemctl set-default graphical
        sudo rm -f ~/.bash_profile
        sudo rm /etc/dconf/db/local.d/01-shockos-initsetup-deskenv
        sudo rm /etc/dconf/db/local.d/locks/00-shockos-initsetup-deskenv
        if (($(ls /etc/dconf/db/local.d/locks/ | wc -l)==0))
        then
            sudo rm -r /etc/dconf/db/local.d/locks/
        fi
        sudo dconf update
        # [BANDAID PATCH]: GDM THEME PATCH BEGINS
        source /usr/lib/shockos/shockos-dist-info.sh
        if [[ "$SHOCKOS_DESKENV" == "GNOME" ]]
        then
            sudo /usr/libexec/shockos/gnome/bandaids/gdm-theme-patch.sh
        fi
        # [BANDAID PATCH]: GDM THEME PATCH ENDS
        sudo rm /usr/lib/shockos/initsetup/step
        sudo rm /etc/sudoers.d/initsetup-rootpriv #this command removes elevated privilages as they are no longer required.
        echo "Setup complete, rebooting..."
        reboot
    else
        echo "ERROR: This script is not meant to be run yet. Exiting..."
        exit 1
    fi
else
    echo "You system has already been set up. No need to run this script."
fi


