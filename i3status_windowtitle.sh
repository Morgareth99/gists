#!/bin/bash

# i3status_windowtitle

# This script is a dirty hack to simulate an i3status command that simply
# outputs JSON containing the current window title every 100msec.

# Written by Armin J. <netzverweigerer@github>

# settings
greeting="Welcome to i3..."
delay="0.1"


# function to get current window title
function t () {
  id="$(xprop -root _NET_ACTIVE_WINDOW)"
  if [[ "$id" =~ .*0x0$ ]]; then echo "Empty Workspace"; exit 0; fi
  # window title name
  title="$(xprop -id $(echo "$id" | cut -d ' ' -f 5) WM_NAME | cut -d"=" -f 2- | cut -b 3- | rev | cut -b 2- | rev)"
  # window class name
  class="$(xprop -id $(echo "$id" | cut -d ' ' -f 5) | grep -i ^wm_class | rev | cut -b 2- | cut -d"," -f 1 | rev | cut -b 3-)"
  echo "  $title  <$class> " | sed 's/\\/\\\\/g' | sed 's/\"/\\\"/g'
}

# initialize and show greeting
echo '{"version":1}'
echo '['
echo "[{\"color\": \"#cccccc\", \"name\": \"wt\", \"full_text\": \"$greeting \n\"}]"
sleep 5

# main loop
while true; do
out="$(t)"
echo -n ',[{"color": "#cccccc", "name": "wt", "full_text": "'
echo -n "$out"
echo '\n"}]'
sleep $delay
done


