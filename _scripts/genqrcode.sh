#!/bin/bash

BASEURL="http://zxing.org/w/chart?cht=qr&chs=350x350&chld=L&choe=UTF-8&chl="
FILE=$1
TARGETURL=$2

URL=${BASEURL}${TARGETURL}
wget -O $FILE $URL
