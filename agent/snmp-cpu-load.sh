#!/bin/bash

# 1-minute load average (e.g. 0.42)
LOAD=$(awk '{print $1}' /proc/loadavg)

# Convert to integer percentage without bc
PERCENT=$(awk -v l="$LOAD" 'BEGIN { printf "%d", l * 100 }')

echo ".1.3.6.1.3.99.1.2"
echo "integer"
echo "$PERCENT"
