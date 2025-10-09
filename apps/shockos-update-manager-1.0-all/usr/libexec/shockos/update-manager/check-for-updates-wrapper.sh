#!/bin/bash

sleep 20

while true
do
    /usr/libexec/shockos/update-manager/check-for-updates.py
    sleep 43200
done

