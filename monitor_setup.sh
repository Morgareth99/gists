#!/bin/bash

# define connector for external display here:
# external_connector="HDMI3"
external_connector="DP3"

# singlehead script
singlehead_script="/home/armin/.screenlayout/single-pad.sh"

# multihead script
multihead_script="/home/armin/.screenlayout/multi-pad.sh"

# detect if external display is connected
ext_num="$(xrandr | grep -E "^${external_connector}\ con.*$" | wc -l)"

if [[ "$ext_num" == 1 ]]; then
  echo "Running multihead script: $multihead_script"
  "$multihead_script"
else
  echo "Running singlehead script: $singlehead_script"
  "$singlehead_script"
fi


