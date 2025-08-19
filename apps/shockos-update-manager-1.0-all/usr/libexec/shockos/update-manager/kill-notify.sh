#!/bin/bash

pidfile=~/.cache/shockos-tmp/update-manager/notify-pid
if [[ -f "$pidfile" ]]
then
    killpid="$(cat "$pidfile")"
    kill "$killpid"
fi

