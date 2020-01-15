#!/bin/sh
for i in {0..256};do o=00$i;echo -e -n "${o:${#o}-3:3} "; tput setaf $i; done


