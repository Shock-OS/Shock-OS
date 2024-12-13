#!/bin/bash

# This script finalizes the setup process after the initial setup process has completed.

if (($(cat /usr/share/shockos/initsetup/setupvalue)==1))
then
    echo "Finalizing setup... DO NOT POWER OFF DEVICE"
    sudo rm -r /etc/systemd/system/getty@tty1.service.d # removes the 'shock' user from autologin as the setup is complete
    sudo deluser --remove-home shockos
    sudo systemctl set-default graphical
    #the default .bashrc file restoration patch begins
    sudo rm ~/.bashrc
    sudo cp /etc/skel/.bashrc ~/
    sudo chown "$(whoami)" ~/.bashrc
    #the default .bashrc file restoration patch ends
    sudo rm /usr/share/shockos/initsetup/setupvalue
    sudo rm /etc/sudoers.d/initsetup-rootpriv #this command removes elevated privilages as they are no longer required.
    sudo rm /etc/dconf/db/local.d/01-shockos-initsetup-deskenv
    sudo rm /etc/dconf/db/local.d/locks/00-shockos-initsetup-deskenv
    if (($(ls /etc/dconf/db/local.d/locks/)==0))
    then
        sudo rm -r /etc/dconf/db/local.d/locks/
    fi
    sudo dconf update
    echo "Setup complete, rebooting..."
    reboot
else
    echo "ERROR: This process has either already been completed or is not meant to be run yet. Exiting..."
fi
