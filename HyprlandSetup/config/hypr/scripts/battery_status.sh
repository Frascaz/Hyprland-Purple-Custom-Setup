#!/bin/bash

capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    icon=""
else
    if [ "$capacity" -le 15 ]; then
        icon=""
    elif [ "$capacity" -le 30 ]; then
        icon=""
    elif [ "$capacity" -le 60 ]; then
        icon=""
    elif [ "$capacity" -le 80 ]; then
        icon=""
    else
        icon=""
    fi
fi

echo "$icon $capacity%"
