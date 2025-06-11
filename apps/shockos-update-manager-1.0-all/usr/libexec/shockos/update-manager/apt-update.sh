#!/bin/bash

if [[ "$EUID" != '0' ]]
then
    echo 'Script must be run as root.'
    exit
fi

apt update
