#!/bin/bash
# monitor.sh
# PROGRAM MONITOR FOR SSH CONSOLE

GOV=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
MIN=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
MAX=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`
# get the load averages
read one five fifteen rest < /proc/loadavg
echo "$(tput setaf 2)
HOST NAME.........: `hostname`
TODAY.............: `date +"%A, %e %B %Y, %R"`
UPTIME............: ${UPTIME}
MEMORY............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total)
RUNNING PROCESSES.: `ps ax | wc -l | tr -d " "`
$(tput sgr0)"
echo "PROCESSOR NAME....: "`uname -m`
echo "$GOV $MIN $MAX" | awk  '{ printf "GOVERNOR..........: %s\nMIN FREQENCY......: %4dMhz\nMAX FREQENCY......: %4dMhz\n\n", $1, $2/1000, $3/1000 }'
C=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
T=`cat /sys/class/thermal/thermal_zone0/temp`
echo "------------ CURRENT VALUES CPU ------------"
echo ""
echo " $C $T" | awk  '{ printf "ACTUAL FREQENCY IS :%4dMhz and CPU TEMPERATURE IS : %-.2f°C\n",$1/1000,$2/1000 }'
echo ""
