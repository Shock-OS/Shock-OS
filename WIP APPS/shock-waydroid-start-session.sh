#!/bin/bash

while IFS= read -r line
do
    if [[ "$line" == *"Android with user"*"is ready"* ]]
    then
        exit
    fi
done < <(waydroid --details-to-stdout session start &)
