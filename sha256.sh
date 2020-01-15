#!/bin/bash

IFS= read -d '' -n 1 keyvariable   
while IFS= read -d '' -n 1 -t 2 c
do
keyvariable+=$c
done
echo $keyvariable | openssl dgst -sha256 | sed s/\(stdin\)=//i | cut -d " " -f 2


