#!/bin/bash

if [[ -f ~/.config/shockos/first-run-indicator ]]
then
    if [[ "$(cat /proc/device-tree/model)" == "Raspberry Pi 4"* ]]
    then
        gsettings set org.mate.session.required-components windowmanager "marco-glx"
    fi
else #NON-FIRST-RUN-SETUP COMMANDS GO HERE
    gsettings reset org.mate.lockdown disable-log-out #ensures that the user can logout and shutdown (fixes the shutdown menu being locked if the system crashed during automatic updates)
fi

