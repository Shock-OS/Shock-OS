#!/bin/bash

# This script applies the Shock OS modifications to the MATE Desktop (panel layouts, etc.)

# Ensure script is running as root, exit otherwise
if [[ $(id -u) -ne 0 ]]
then
    echo "ERROR: Script must be run as root. Exiting..."
    exit 1
fi

# Install default Shock OS panel layout
cp -rf /usr/share/shockos/mate/panel-layouts/default.layout /usr/share/mate-panel/layouts/
cp -rf /usr/share/shockos/mate/panel-layouts/default.panel /usr/share/mate-panel/layouts/

# Have applications use generic names
cp -rf /usr/share/shockos/mate/applications-generic-names/* /usr/share/applications/

# [LEGACY?] Install Yaru icons for Shock OS
cp -rf /usr/share/shockos/mate/yaru-icons/* /usr/share/icons/Yaru/
gtk-update-icon-cache -f /usr/share/icons/Yaru/

# Customize LightDM to use Slick Greeter and Shock OS branding
mkdir -p /etc/lightdm/
echo '[Greeter]
background=/usr/share/shockos/mate/branding/lightdm-bg.svg
cursor-theme-name=Yaru
icon-theme-name=Yaru-purple-dark
show-hostname=true
show-power=false
show-keyboard=true
show-clock=false
theme-name=Yaru-purple-dark' | tee /etc/lightdm/slick-greeter.conf
sed -i '/^#greeter-hide-users=/c\greeter-hide-users=false' /etc/lightdm/lightdm.conf

# Redirect mate-appearance-properties to shockos-mate-backgrounds (for desktop context menu)
mv /usr/bin/mate-appearance-properties /usr/bin/mate-appearance-properties-vanilla
ln -s /usr/bin/shockos-mate-backgrounds /usr/bin/mate-appearance-properties

