#!/bin/bash

# This script is only meant to be run once after a fresh install of Shock OS (not an upgrade)

sed -i 's/AutoEnable=[^ ]*/#AutoEnable=true/g' /etc/bluetooth/main.conf
sed -i "s/# in later on. Defaults to 'true'.[^ ]*/# in later on. While most distros set this to 'true' by default, Shock OS leaves it unset by default so the system will respect the user's previous setting instead of always enabling Bluetooth./g" /etc/bluetooth/main.conf

