#!/bin/bash

if [[ -f ~/.config/shockos/first-run-indicator ]]
then
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/shockos-terminal-shortcut/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/shockos-terminal-shortcut/ name 'Shock OS Terminal Shortcut'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/shockos-terminal-shortcut/ command 'gnome-terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/shockos-terminal-shortcut/ binding '<Primary><Alt>t'
else #NON-FIRST-RUN-SETUP-COMMANDS GO HERE
    gsettings reset org.gnome.desktop.lockdown disable-log-out #ensures that the user can logout and shutdown (fixes the shutdown menu being locked if the system crashed during automatic updates)
fi

