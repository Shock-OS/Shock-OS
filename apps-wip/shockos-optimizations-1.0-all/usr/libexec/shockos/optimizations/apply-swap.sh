#!/bin/bash

if [[ "$(id -u)" != "0" ]]
then
    echo "Script must be run as root, exiting..."
    exit 1
fi

swap_gb="$1"
swappiness="$2"
ram_overcommit_mode="$3"
ram_overcommit_ratio="$4"
ram_dirty_ratio="$5"
ram_dirty_background_ratio="$6"
ram_vfs_cache_pressure="$7"

current_swappiness=$(cat /proc/sys/vm/swappiness)
current_ram_overcommit_mode=$(cat /proc/sys/vm/overcommit_memory)
current_ram_overcommit_ratio=$(cat /proc/sys/vm/overcommit_ratio)
current_ram_dirty_ratio=$(cat /proc/sys/vm/dirty_ratio)
current_ram_dirty_background_ratio=$(cat /proc/sys/vm/dirty_background_ratio)
current_ram_vfs_cache_pressure=$(cat /proc/sys/vm/vfs_cache_pressure)

swap_bytes=$((swap_gb * $((1000**3))))
current_swap_bytes=$(stat -c %s /swapfile)
if [[ ! -f /swapfile ]] || ((swap_bytes != current_swap_bytes))
then
    if [[ -f /swapfile ]]
    then
        swapoff /swapfile
        rm /swapfile
    fi
    if [[ -f /var/swap ]]
    then
        dphys-swapfile swapoff
        systemctl disable dphys-swapfile
        rm /var/swap
    fi
    swap_bytes=$((swap_gb * (1000**3)))
    fallocate -l $swap_bytes /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
fi

function changeval {
local var=$1
local val=$2
if [[ "$(cat /etc/sysctl.conf)" =~ "${var}" ]]
then
    sed -i "s/^${var}.*/${var}=${val}/" /etc/sysctl.conf
else
    echo "${var}=${val}" | tee -a /etc/sysctl.conf
fi
}
vars=('swappiness'
    'ram_overcommit_mode'
    'ram_overcommit_ratio'
    'ram_dirty_ratio'
    'ram_dirty_background_ratio'
    'ram_vfs_cache_pressure')
sysctl_vars=('vm.swappiness'
    'vm.overcommit_memory'
    'vm.overcommit_ratio'
    'vm.dirty_ratio'
    'vm.dirty_background_ratio'
    'vm.vfs_cache_pressure')
current_vars=()
sysctl_reload=false
for i in "${!vars[@]}"
do
    var=${vars[i]}
    current_var="current_${var}"
    if ((${!var} != ${!current_var}))
    then
        changeval ${sysctl_vars[i]} ${!var}
        sysctl_reload=true
    fi
done
if $sysctl_reload
then
    sysctl -p
fi

