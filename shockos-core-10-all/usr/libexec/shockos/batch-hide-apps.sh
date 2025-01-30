#!/bin/bash

# This script takes .desktop file arguments and appends 'Hidden=True' and 'NoDisplay=true' if those lines don't already exist in the file, effectively hiding the app shortcuts from the application menu

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

apps_to_hide=("$@")

for app in "${apps_to_hide[@]}"
do
    if [[ "$app" == *'.desktop' ]]
    then
        if ! grep -Fxq "NoDisplay=true" "$app"
        then
            if grep -q '^NoDisplay=' "$app"
            then
                sed -i '/^NoDisplay=/c\NoDisplay=true' "$app"
            else
                echo 'NoDisplay=true' | tee -a "$app"
            fi
        fi
    else
        echo "ERROR: File '${app}' is not a .desktop file. Skipping it..."
    fi
done

