#!/bin/sh
# kde-wallpapers-workaround.sh
#
# GitHub: @netzverweigerer
# 
# Adds all files in the current directory to the KDE wallpaper selection dialog
#
# This is a workaround script, basically because KDE doesn't allow adding
# multiple files from the wallpaper selection dialog, at all.
#

exec > ~/.config/plasmarc.tmp
a="$(echo -n "usersWallpapers="; for file in *; do readlink -f "$file"; done | while read line; do echo -n "$line"; echo -n ","; done | sed 's/,$//'; echo)"; cat ~/.config/plasmarc | grep -v '^usersWallpapers='; echo "$a"
mv ~/.config/plasmarc.tmp ~/.config/plasmarc




