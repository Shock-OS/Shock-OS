#!/bin/sh
sed -i \
         -e 's/#3e3e3e/rgb(0%,0%,0%)/g' \
         -e 's/#ffffff/rgb(100%,100%,100%)/g' \
    -e 's/#3c3c3c/rgb(50%,0%,0%)/g' \
     -e 's/#ff5d00/rgb(0%,50%,0%)/g' \
     -e 's/#636363/rgb(50%,0%,50%)/g' \
     -e 's/#ffffff/rgb(0%,0%,50%)/g' \
	"$@"
