#!/usr/bin/env python3

# This script is a library for Shock OS apps

with open('/usr/lib/shockos/dist-info', 'r') as dist_info:
    for line in dist_info:
        if '=' in line:
            parts = line.split("=")
            item = parts[0].strip().strip('"')
            value = parts[1].strip().strip('"')
            if value:
                if item == 'SHOCKOS_FULL_NAME':
                    full_name = value
                elif item == 'SHOCKOS_VERSION_NUMBER':
                    version_number = value
                elif item == 'SHOCKOS_DESKENV':
                    deskenv = value
                    if deskenv == 'GNOME':
                        deskenv_is_gnome = True
                        deskenv_is_mate = False
                    elif deskenv == 'MATE':
                        deskenv_is_gnome = False
                        deskenv_is_mate = True
                elif item == 'SHOCKOS_BUILD_DATE':
                    build_date = value
                else:
                    print(f"ERROR: Unknown item {item}")
            else:
                print(f"WARNING: No value associated with item {item}. If Shock OS is currently being built, this warning can be safely ignored.")
                
