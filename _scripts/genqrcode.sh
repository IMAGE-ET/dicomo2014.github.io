#!/bin/bash

BASEURL="http://zxing.org/w/chart?cht=qr&chs=350x350&chld=L&choe=UTF-8&chl="
DICOMO_PEOPLEURL="http://dicomo2014.github.io/people/"

for (( i=4000; i < 4400; i++))
do
    URL=${BASEURL}${DICOMO_PEOPLEURL}${i}
    wget -O ${i}.png $URL
done
