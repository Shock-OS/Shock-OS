#!/bin/bash

# This script takes .desktop file arguments and appends 'Hidden=True' and 'NoDisplay=true' if those lines don't already exist in the file, effectively hiding the app shortcuts from the application menu

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

