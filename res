#!/bin/bash
# res - gets the current screen resolution <armin@mutt.email>, GPLv3+
xrandr --prop | grep current | grep max | xargs | cut -d"," -f 2- | cut -d" " -f 3-5 | sed 's/ //g;s/,//g'

