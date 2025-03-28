#!/bin/bash

# Get RAM usage percentage
ram_usage=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100 - $5}')

# store the highest percentage
if [[ -f "/tmp/highest_ram_usage.txt" ]]; then
    highest_ram_usage=$(cat /tmp/highest_ram_usage.txt)
else
    highest_ram_usage=0
fi

if (( $(echo "$ram_usage > $highest_ram_usage" | bc -l) )); then
    highest_ram_usage=$ram_usage
    echo "$highest_ram_usage" > /tmp/highest_ram_usage.txt
fi

# Color coding
if (( $(echo "$ram_usage < 50" | bc -l) )); then
    color="#FFFFFF"  # white as long as it's below 50
elif (( $(echo "$ram_usage < 70" | bc -l) )); then
    color="#FFD700"  # yellow if below 70 but above 50
else
    color="#D32F2F"  # red if above 70
fi

echo "▥ $ram_usage% | color=$color"
echo "---"
echo "Highest RAM Usage: | color=#fffffe"
echo "Peak: $highest_ram_usage%"
