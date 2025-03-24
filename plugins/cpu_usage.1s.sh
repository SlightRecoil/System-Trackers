#!/bin/bash

cpu_usage=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')

# store the highest percentage
if [[ -f "/tmp/highest_cpu_usage.txt" ]]; then
    highest_cpu_usage=$(cat /tmp/highest_cpu_usage.txt)
else
    highest_cpu_usage=0
fi

if (( $(echo "$cpu_usage > $highest_cpu_usage" | bc -l) )); then
    highest_cpu_usage=$cpu_usage
    echo "$highest_cpu_usage" > /tmp/highest_cpu_usage.txt
fi


if (( $(echo "$cpu_usage < 50" | bc -l) )); then
    color="#FFFFFF"  # white as long as it's below 50
elif (( $(echo "$cpu_usage < 70" | bc -l) )); then
    color="#FFD700"  # yellow if below 70 but above 50
else
    color="#D32F2F"  # red if above 70
fi


echo "⚙ $cpu_usage% | color=$color"
echo "---"
echo "Highest CPU Usage: $highest_cpu_usage%"
