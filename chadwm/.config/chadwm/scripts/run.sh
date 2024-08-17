#!/bin/sh
input-remapper-control --command autoload --config-dir /home/vs/.config/input-remapper-2/ &
xrdb merge ~/.Xresources 
xbacklight -set 10 &
/usr/bin/nitrogen --set-zoom-fill --random /home/vs/Pictures/wallpapers/
xset r rate 200 50 &
picom --animations -b &
dash ~/.config/chadwm/scripts/bar.sh &
nm-applet &
blueman-applet &
/usr/local/bin/dwm
# betterlockscreen -u /home/vs/Pictures/wallpapers/
#while type dwm >/dev/null; do dwm && continue || break; done
