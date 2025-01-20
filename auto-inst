#!/bin/bash

#this script installs the Shock OS .deb in the current directory

sudo apt install -y pipewire-audio || { echo "ERROR: Failed to install package pipewire-audio. Exiting..."; exit 1; }

sudo apt install -y ./"shockos-core_"* || { echo "ERROR: Failed to install shockos-core package. Exiting..."; exit 1; }
sudo apt install -y ./"shockos-deskenv-"* || { echo "ERROR: Failed to install shockos-deskenv package. Exiting..."; exit 1; }

for app in *
do
    if [[ "$app" != "auto-inst" ]]
    then
        sudo apt install -y ./"$app" || { echo "ERROR: Failed to install ${app}. Exiting..."; exit 1; }
    fi
done
    
sudo apt update
sudo apt autopurge -y
sudo apt update
