#!/bin/bash

# increase/decrease window gap in bspwm

current="$(bspc config -d focused window_gap)"

if [[ "$1" == "increase" ]]; then
  new=$((current+2))
	echo "$new"
	bspc config -d focused window_gap "$new"
fi

if [[ "$1" == "decrease" ]]; then
  new=$((current-2))
	bspc config -d focused window_gap "$new"
fi


