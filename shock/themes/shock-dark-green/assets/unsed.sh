#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#2c2c2c/g' \
         -e 's/rgb(100%,100%,100%)/#ececec/g' \
    -e 's/rgb(50%,0%,0%)/#3c3c3c/g' \
     -e 's/rgb(0%,50%,0%)/#25b526/g' \
 -e 's/rgb(0%,50.196078%,0%)/#25b526/g' \
     -e 's/rgb(50%,0%,50%)/#373737/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#373737/g' \
     -e 's/rgb(0%,0%,50%)/#ececec/g' \
	"$@"
