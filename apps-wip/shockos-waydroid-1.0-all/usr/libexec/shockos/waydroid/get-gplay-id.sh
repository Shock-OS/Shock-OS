#!/bin/bash

if [[ ! -f ~/.local/share/waydroid/data/media/0/.shockos ]]
then
    sudo mkdir -p ~/.local/share/waydroid/data/media/0/.shockos
    sudo mount --bind /usr/share/shockos/waydroid/waydroid-shell-scripts ~/.local/share/waydroid/data/media/0/.shockos
fi
/usr/libexec/shockos/waydroid/start-session.sh
id="$(sudo waydroid shell /data/media/0/.shockos/get-gplay-id.sh)"
id="${id#*|}"
echo "$id"

