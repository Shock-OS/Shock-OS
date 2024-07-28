#!/bin/bash

drives=($(lsblk | grep /media | grep -oP "(sd[a-z]|mmcblk[0-9])" | awk '{print "/dev/"$1}' | sort -u))

drives_and_labels=""

for drive in "${drives[@]}"
do

    drive_label=""

    for num in {1..1000}
    do

        part_label=""

        if [[ "$drive" == "/dev/mmcblk"* ]]
        then

            part_label="$(lsblk --output LABEL "${drive}p${num}")"

        else

            part_label="$(lsblk --output LABEL "${drive}${num}")"

        fi

        part_label="${part_label:6}" #Removes leading 'LABEL ' from part_label

        if [[ -z "$part_label" ]]
        then

            break

        elif [[ -z "$drive_label" ]]
        then

            drive_label="$part_label"

        else

            drive_label+=", $part_label"

        fi

    done

    if [[ -z "$drive_label" ]]
    then

        drive_label="NO LABEL"

    fi
    
    if [[ -z "$drives_and_labels"  ]]
    then

        drives_and_labels="['$drive ($drive_label)'"

    else

        drives_and_labels+=", '$drive ($drive_label)'"

    fi

done

if [[ -n "$drives_and_labels" ]]
then

    drives_and_labels+="]"

else

    drives_and_labels="[]"

fi

echo "$drives_and_labels"
