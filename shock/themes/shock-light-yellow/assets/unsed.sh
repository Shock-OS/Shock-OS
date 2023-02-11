#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#d8d8d8/g' \
         -e 's/rgb(100%,100%,100%)/#101010/g' \
    -e 's/rgb(50%,0%,0%)/#ececec/g' \
     -e 's/rgb(0%,50%,0%)/#cdba00/g' \
 -e 's/rgb(0%,50.196078%,0%)/#cdba00/g' \
     -e 's/rgb(50%,0%,50%)/#ffffff/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#ffffff/g' \
     -e 's/rgb(0%,0%,50%)/#1a1a1a/g' \
	"$@"
