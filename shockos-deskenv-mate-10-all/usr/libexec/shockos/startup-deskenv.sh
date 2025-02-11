#!/bin/bash

if [[ -f ~/.config/shockos/first-run-indicator ]]
then
    rm -rf ~/.config/plank/shockos-dock/launchers/*
    cp /usr/share/shockos/mate/plank-launchers/* ~/.config/plank/shockos-dock/launchers/
fi

#NON-FIRST-RUN-SETUP COMMANDS GO HERE
gsettings reset org.mate.lockdown disable-log-out #ensures that the user can logout and shutdown (fixes the shutdown menu being locked if the system crashed during automatic updates)

