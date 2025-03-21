#!/bin/bash

# get total CPU usage percentage every second
while true
do
    cpu_usage=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}')
    echo "CPU Usage: $cpu_usage"
    sleep 1
done

