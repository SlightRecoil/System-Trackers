#!/bin/bash

# track ram usage in percent, output every 0.5 seconds
while true
do
    # Use 'memory_pressure' command to get memory usage
    ram_usage=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100 - $5}')

    if (( $(echo "$ram_usage < 50" | bc -l) )); then
        color="\033[0;37m"  # white as long as it's below 50% used
    elif (( $(echo "$ram_usage < 70" | bc -l) )); then
        color="\033[0;33m"  # yellow if below 70% but above 50% used
    else
        color="\033[0;31m"  # red if above 70% used
    fi

    echo -e "${color}RAM Usage: $ram_usage%\033[0m"
    sleep 0.5
done
