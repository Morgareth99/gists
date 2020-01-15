#!/bin/bash

# sprunge as a bash function:
# sprunge() { curl -F 'sprunge=<-' http://sprunge.us < "${1:-/dev/stdin}"; } # usage: sprunge FILE # or some_command | sprunge

cat $1 | curl -F 'sprunge=<-' http://sprunge.us
