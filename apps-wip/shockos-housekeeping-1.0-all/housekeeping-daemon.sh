#!/bin/bash

if [[ " $@ " =~ ' --verbose ' ]]
then
    verbose=true
else
    verbose=false
fi

while true
do
    days=$(gsettings get net.shockos.housekeeping deltrash-days)
    if (( days > 365 ))
    then
        gsettings set net.shockos.housekeeping deltrash-days 365
        days=365
    fi
    current_date=$(date +"%s")
    if $verbose
    then
        echo "DAYS: $days"
        echo "CURRENT_DATE (in seconds): $current_date"
    fi
    for infofile in ~/.local/share/Trash/info/*
    do
        trashfile=''
        date=''
        file_days_old=''
        if [[ "$infofile" == *'.trashinfo' ]]
        then
            date="$(grep -m 1 '^DeletionDate=' "$infofile")"
            date="${date:13}"
            date=$(date -d "$date" +"%s")
            file_days_old=$(( (current_date - date) / 86400 ))
            if (( file_days_old > days ))
            then
                trashfile="$(basename "$infofile")"
                trashfile="${trashfile::-10}"
                rm -rf ~/.local/share/Trash/files/"$trashfile"
                rm "$infofile"
                if $verbose
                then
                    echo "Deleted file '${trashfile}' because it is older than $days days."
                fi
            fi
            if $verbose
            then
                echo "INFOFILE: $infofile"
                echo "TRASHFILE: $trashfile"
                echo "DATE (in seconds): $date"
                echo "FILE_DAYS_OLD: $file_days_old"
            fi
        fi
    done
    sleep 86400 #sleep one day
done

