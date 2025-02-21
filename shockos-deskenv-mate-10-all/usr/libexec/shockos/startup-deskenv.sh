#!/bin/bash

if [[ -f ~/.config/shockos/first-run-indicator ]]
then
    /usr/libexec/shockos/mate/reset-plank.sh
fi

#NON-FIRST-RUN-SETUP COMMANDS GO HERE
gsettings reset org.mate.lockdown disable-log-out #ensures that the user can logout and shutdown (fixes the shutdown menu being locked if the system crashed during automatic updates)

