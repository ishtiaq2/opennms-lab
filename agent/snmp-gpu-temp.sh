#!/bin/bash


# temp=$(cat /sys/class/thermal/thermal_zone0/temp)
# Convert to °C
# temp=$((temp / 1000))
# echo "GPU/CPU Temp: ${temp}°C"
# awk -v t="$temp" 'BEGIN {print t/1000}'


#!/bin/bash

# 1. Capture arguments
# snmpd passes "-g" as $1 and the OID as $2
FLAG=$1
OID=$2

# 2. Output the OID (Required by snmpd protocol)
# If $2 is empty (manual run), use $1, otherwise use $2
if [ -z "$OID" ]; then
    echo $1
else
    echo $OID
fi

# 3. Output the type
echo string

# 4. Output the value
# Read raw millidegree value (e.g., 45123)
raw_temp=$(cat /sys/class/thermal/thermal_zone0/temp)

# Convert to Float (Degrees Celsius) using awk
awk -v t="$raw_temp" 'BEGIN {printf "%.4f", t/1000}'

# sudo cp /home/ishtiaq3/snmp_agent/snmp-gpu-temp.sh /usr/local/bin/
# sudo chmod 755 /usr/local/bin/snmp-gpu-temp.sh
# sudo systemctl restart snmpd
