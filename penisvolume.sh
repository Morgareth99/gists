#!/bin/bash
# vim:ft=sh ts=2 sw=2 sts=2 et

# Written by Armin (netzverweigerer) - http://github.com/netzverweigerer

# penisvolume.sh - simple script to change the audio volume from the command line.
# shows an on-screen-dick (OSD) representing the volume.

# Synopsis:
# penisvolume [increase|decrease]

# This script is released as public domain software - feel free to use it as
# you wish

# Use how many percent step sizes?
stepsize="3"
osd_font="-*-terminus-*-*-*-*-*-320-*-*-*-*-*-*"

display=""

function osd () {
  v="$@"
  echo "$v"
  oldpid="$(pidof osd_cat)"
  display+="8"
  for i in $(seq 1 $v); do display+="="; done
  display+="D"
  if [[ "$v" -ge 100 ]]; then display+=" < o.O WOOT "; fi
  echo "$display" | osd_cat -f "$osd_font" -O 2 -u "#000" -T "Volume" -c "#ddd" -o 20 & 
  sleep 0.02
  kill -9 "$oldpid"
}

# get current volume:
function getvolume () {
  current_left="$(amixer -- sget Master | cut -b 3- | grep ^Front\ Left | cut -d"[" -f 2 | cut -d"%" -f 1)"
  current_right="$(amixer -- sget Master | cut -b 3- | grep ^Front\ Right | cut -d"[" -f 2 | cut -d"%" -f 1)"
  if [[ "$current_left" -ne "$current_right" ]]; then
    echo "Left and right channel have unequal levels."
  fi
  # get arithmetic average value of left/right:
  average="$(echo "scale=2; (${current_left}+${current_right}) / 2" | bc | cut -d"." -f 1)"
  echo "$average"
}
current="$(getvolume)"

# set levels:
function setvolume () {
  vol="$@"
  amixer -- sset Master "${@}%" >/dev/null
}

# increase volume:
function increase () {
  newlevel="$(echo "scale=2; ${current}+${stepsize}" | bc | cut -d"." -f 1)"
  setvolume "$newlevel"
  osd "$newlevel"
}

# decrease volume:
function decrease () {
  newlevel="$(echo "scale=2; ${current}-${stepsize}" | bc | cut -d"." -f 1)"
  setvolume "$newlevel"
  osd "$newlevel"
}

# parse argument
if [[ "$1" == "increase" ]]; then
  increase
fi
if [[ "$1" == "decrease" ]]; then
  decrease
fi



