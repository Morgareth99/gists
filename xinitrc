#!/bin/sh
#
# custom ~/.xinitrc file
# Written 2015 by Netzverweigerer @ Github.
# ---------------------------------------------------------------------------- 
# This stuff is released under:
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Armin <spampostfach1@yahoo.de> wrote this file. As long as you retain this
# notice you can do whatever you want with this stuff. If we meet some day,
# and you thinkthis stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------



#
# Executed by startx (run your window manager from here)

# Initially set gray/black grid pattern:
xsetroot -mod 4 4 -fg gray15 -bg black

# Load global xinitrc.d files
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# enable ctrl-alt-backspace to kill X
setxkbmap -option terminate:ctrl_alt_bksp

# autocutsel - synchronize copy/paste buffer with X selection buffer
# autocutsel -fork &
autocutsel &
autocutsel -selection PRIMARY &

# load .Xresources file
xrdb -load ~/.Xresources

# we should eventually take care of this:
keychain ~/.ssh/id_rsa
[ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
[ -f ~/.keychain/$HOSTNAME-sh-gpg ] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
eval "$(ssh-agent)"

# xset +fp /usr/share/fonts/misc/
# xset +fp /usr/share/fonts/artwiz-fonts/
xset +fp /usr/share/fonts/local/
for fontdir in /usr/share/fonts/*; do xset +fp "$fontdir"; done
# add artwiz fonts to font path
xset +fp /usr/share/fonts/X11/artwiz

# empty chromiums cache
rm -rfv $HOME/.cache/chromium/

# start xscreensaver-daemon
xautolock -time 3 -locker $HOME/bin/lock & 
# xscreensaver -nosplash &

# start xbindkeys
xbindkeys &

# redshift
# redshift -l "50:8" -t "6500:5500" -b 1.0 &

# set up screen configuration:
# $HOME/.screenlayout/layout-multihead.sh

# wallpaper
# Esetroot -f "$HOME/Pictures/3840x1080/0wiUA4O.jpg"

# set keyboard repeat rate
# xset r rate 400 30
xset r rate 200 30

# set mouse speed
xset m 4 4


### compton
# compton: 
# compton --vsync opengl &
# compton with fast fades:
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c &
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --paint-on-overlay --config $HOME/.compton.conf &
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --paint-on-overlay --shadow-exclude="name = 'XOSD'" &
### shadow prevention on multihead overlaps, opengl, non-distracting work-mode:

compton_top_offset="-15"
compton_left_offset="-15"
compton_opacity_borders="1.0"
compton_opacity_shadows="0.5"
compton_radius="15"
compton -t "$compton_top_offset" -l "$compton_left_offset" --xinerama-shadow-crop --vsync opengl -e "$compton_opacity_borders" -o "$compton_opacity_shadows" -r "$compton_radius" -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --shadow-exclude="name = 'XOSD'" &

# enable synergy (keyboard/mouse remote control of windows machine)
# synergy &

# cinnamon-session

### Awesome:
# exec ck-launch-session dbus-launch awesome

### Xfce:
# exec ck-launch-session dbus-launch startxfce4
# exec startxfce4

### Openbox:
# Esetroot -f $HOME/Pictures/2.jpg
# xfce4-panel &
# exec openbox

### Fluxbox
# dunst -config ~/.dunstrc &
# startfluxbox

# WindowMaker:
# wmaker

### KDE:
# startkde

### Mate:
# mate-volume-control-applet &
# mate-session

xset +fp $HOME/.fonts
xset +fp $HOME/.fonts/artwiz-aleczapka-en-1.3

### i3
dunst -config ~/.dunstrc &
# exec ck-launch-session dbus-launch i3
xset -bg black -fg gray20 -mod 4 4
i3 -c $HOME/.i3/config


