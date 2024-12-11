#!/bin/bash

#This script sets the default audio output device to HDMI

if [[ "$(cat /proc/device-tree/model)" != "Raspberry Pi 5"* ]]
then
    if [[ "$(pw-cli list-objects | grep -c "Built-in Audio Digital Stereo")" == "1" ]]
    then
        node_name="$(pw-cli list-objects | grep -A 1 "Built-in Audio Digital Stereo" | awk 'NR==2')"
        node_name=${node_name#*\"}
        node_name="${node_name::-1}"
        id="$(pw-cli info "$node_name" | awk 'NR==1')"
        id="${id##* }"
        wpctl set-default "$id"
    fi
fi
