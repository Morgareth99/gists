#!/usr/bin/env bash
# randomizes elements of an array (outputs to demonstrate, too)

dir="$HOME/examplefiles/"
array=($dir/*)

shuffle() {
local i tmp size max rand
size=${#array[*]}
max=$(( 32768 / size * size ))
for ((i=size-1; i>0; i--)); do
while (( (rand=$RANDOM) >= max )); do :; done
rand=$(( rand % (i+1) ))
tmp=${array[i]} array[i]=${array[rand]} array[rand]=$tmp
for file in "${tmp[@]}"; do echo "----- $file"; done
done
}

shuffle
exit 0



