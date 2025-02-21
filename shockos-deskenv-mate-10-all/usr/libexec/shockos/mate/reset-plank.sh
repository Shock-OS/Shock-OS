#!/bin/bash

dconf reset -f /net/launchpad/plank/docks/shockos-dock/
mkdir -p ~/.config/plank/shockos-dock/launchers/
rm -rf ~/.config/plank/shockos-dock/launchers/*
cp /usr/share/shockos/mate/plank-launchers/* ~/.config/plank/shockos-dock/launchers/

