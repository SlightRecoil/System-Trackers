#!/bin/bash

# get total CPU usage percentage every second
while true
do              # -l 1 to run once; -n 0 to hide detailed processes; awk $3: pull               from third field in line
    cpu_usage=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')

    if (( $(echo "$cpu_usage < 50" | bc -l) )); then
        color="\033[0;37m"  # white as long as its below 50
    elif (( $(echo "$cpu_usage < 70" | bc -l) )); then
        color="\033[0;33m"  # yellow if below 70 but above 50
    else
        color="\033[0;31m"  # red if above 70
    fi

    echo -e "${color}CPU Usage: $cpu_usage%\033[0m"
    sleep 0.5
done
