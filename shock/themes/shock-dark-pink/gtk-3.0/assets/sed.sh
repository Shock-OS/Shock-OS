#!/bin/sh
sed -i \
         -e 's/#2c2c2c/rgb(0%,0%,0%)/g' \
         -e 's/#ececec/rgb(100%,100%,100%)/g' \
    -e 's/#3c3c3c/rgb(50%,0%,0%)/g' \
     -e 's/#cf72b7/rgb(0%,50%,0%)/g' \
     -e 's/#373737/rgb(50%,0%,50%)/g' \
     -e 's/#ececec/rgb(0%,0%,50%)/g' \
	"$@"
