#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#3e3e3e/g' \
         -e 's/rgb(100%,100%,100%)/#ffffff/g' \
    -e 's/rgb(50%,0%,0%)/#3c3c3c/g' \
     -e 's/rgb(0%,50%,0%)/#ff5d00/g' \
 -e 's/rgb(0%,50.196078%,0%)/#ff5d00/g' \
     -e 's/rgb(50%,0%,50%)/#636363/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#636363/g' \
     -e 's/rgb(0%,0%,50%)/#ffffff/g' \
	"$@"