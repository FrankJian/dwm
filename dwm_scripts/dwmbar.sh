#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0
file_path=$(readlink -f "$0")

# load colors
. ${file_path%/*}/bar_themes/nord

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$blue^ 閭 $cpu_val"
}

pkg_updates() {
  updates=$(doas xbps-install -un | wc -l) # void
  # updates=$(checkupdates | wc -l)   # arch
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$green^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  bat_text=$(expr $(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+"))
  [ ! "$(acpi -b | grep 'Battery 0' | grep Discharging)" ] && charge_icon=""
  if  [ "$bat_text" -ge 95 ];  then bat_icon="";
  elif [ "$bat_text" -ge 90 ]; then bat_icon="";
  elif [ "$bat_text" -ge 80 ]; then bat_icon="";
  elif [ "$bat_text" -ge 70 ]; then bat_icon="";
  elif [ "$bat_text" -ge 60 ]; then bat_icon="";
  elif [ "$bat_text" -ge 50 ]; then bat_icon="";
  elif [ "$bat_text" -ge 40 ]; then bat_icon="";
  elif [ "$bat_text" -ge 30 ]; then bat_icon="";
  elif [ "$bat_text" -ge 20 ]; then bat_icon="";
  elif [ "$bat_text" -ge 10 ]; then bat_icon="";
  else bat_icon=""; fi

  bat_text="$bat_text"
  bat_icon="$charge_icon$bat_icon"
  text="$bat_icon$bat_text"
  printf "^c$blue^ ${bat_icon} "
  printf "$bat_text"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$red^  "
  printf "$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up)
    nm_name=$(nmcli -a | grep "connected to" | awk -F ' ' '{print($NF)}')
	  printf "^c$blue^   ${nm_name}" ;;
	down) printf "^c$red^  Disconnected" ;;
	esac
}

clock() {
	printf "^c$red^   $(date '+%H:%M')  "
}

while true; do
  sleep 1 && xsetroot -name "$updates $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
