#!/usr/bin/python3
import sys

# === CONFIGURATION ===
LOG_FILE = "/tmp/snmp_debug.log"
BASE = ".1.3.6.1.3.99"
OID_TEMP = ".1.3.6.1.3.99.1.1"
OID_LOAD = ".1.3.6.1.3.99.1.2"

def log(msg):
    """Writes debug info to a file"""
    with open(LOG_FILE, "a") as f:
        f.write(msg + "\n")

def get_temp():
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            return "{:.2f}".format(int(f.read().strip()) / 1000.0)
    except:
        return "0.00"

def get_load():
    try:
        with open("/proc/loadavg", "r") as f:
            return str(int(float(f.read().split()[0]) * 100))
    except:
        return "0"

def output(oid, type_name, value):
    log(f"RESPONDING: {oid} = {value}")
    print(oid)
    print(type_name)
    print(value)
    sys.exit(0)

def main():
    if len(sys.argv) < 3:
        sys.exit(0)

    mode = sys.argv[1]
    req = sys.argv[2]
    
    log(f"REQUEST: {mode} {req}")

    # === GET REQUEST (-g) ===
    if mode == "-g":
        if req == OID_TEMP:
            output(OID_TEMP, "string", get_temp())
        elif req == OID_LOAD:
            output(OID_LOAD, "integer", get_load())

    # === GETNEXT REQUEST (-n) ===
    elif mode == "-n":
        # 1. If asking for BASE (or anything before .1.1), return TEMP
        # We check if request is 'shorter' or strictly 'less' than TEMP
        if req == BASE or req < OID_TEMP:
            output(OID_TEMP, "string", get_temp())

        # 2. If asking for TEMP (or anything between TEMP and LOAD), return LOAD
        if req == OID_TEMP:
            output(OID_LOAD, "integer", get_load())

        # 3. If asking for LOAD, return NOTHING (Exit)
        if req == OID_LOAD:
            log("End of MIB")
            sys.exit(0)

if __name__ == "__main__":
    main()