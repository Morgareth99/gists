#!/bin/bash
# simple tput setaf example
j=(1 3 4 7 9 10 11 12 13 14 15 33 209 198 137 242 103 245 228); for i in "${j[@]}"; do echo "-- $i"; tput setaf "$i"; echo "Hello World. $i"; done
