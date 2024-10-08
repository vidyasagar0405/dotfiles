#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/onedark
. /home/vs/.config/chadwm/scripts/battery

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$yellow^  "
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  # updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ "$updates" -eq 0 ]; then
    printf "  ^c$green^    F"
  else
    printf "  ^c$green^    $updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^c$yellow^   "
  printf "^c$yellow^%.0f\n" $(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')
}

mem() {
  printf "^c$purple^^b$black^  "
  printf "^c$purple^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	  up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^$(iwgetid -r)" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date +"%b %d %a,%l:%M%P"| sed 's/  / /g')  "
}

disk() {
  hdd=$(df -h | awk 'NR==2{print $5}')
  printf "^c$red^ 󰆓 $hdd%"
}

while true; do
  
  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(cpu) $(mem) $(disk) $(brightness) $(get_battery) $(clock)"
done
