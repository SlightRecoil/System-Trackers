#!/bin/bash

cpu_usage=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')

if (( $(echo "$cpu_usage < 50" | bc -l) )); then
    color="#FFFFFF"  # white as long as its below 50
elif (( $(echo "$cpu_usage < 70" | bc -l) )); then
    color="#FFFF00"  # yellow if below 70 but above 50
else
    color="#FF0000"  # red if above 70
fi

echo "⚙ $cpu_usage% | color=$color"
