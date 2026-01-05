import subprocess
import time
import os

# --- CONFIGURATION ---
AGENT_IP = "192.168.0.38"
COMMUNITY = "public"

# 1. Custom OID (From your RPI-MONITOR-MIB)
# Raw OID: .1.3.6.1.3.99.1.1.0
OID_TEMP = "RPI-MONITOR-MIB::rpiCpuTemp"
OID_CPU_LOAD = "RPI-MONITOR-MIB::rpiCpuLoad"

# 2. Standard OIDs (Built-in to Linux/SNMP)
# These fetch the values you set in snmpd.conf (sysLocation, sysContact)
# Raw OID: .1.3.6.1.2.1.1.6.0
OID_LOCATION = "SNMPv2-MIB::sysLocation.0" 

# Raw OID: .1.3.6.1.2.1.1.4.0
OID_CONTACT  = "SNMPv2-MIB::sysContact.0"

def get_snmp_data(oid_or_name):
    """
    Runs snmpget to fetch a single value.
    Returns the string value or "Error".
    """
    try:
        command = [
            "snmpget", "-v", "2c", "-c", COMMUNITY, 
            "-O", "qv", # Output value only, no "STRING:" prefix
            AGENT_IP, oid_or_name
        ]
        
        # Capture standard error (stderr) to debug if needed
        result = subprocess.run(
            command, capture_output=True, text=True, timeout=2)
        
        if result.returncode != 0:
            return "Error"
            
        return result.stdout.strip().replace('"', '') 
    except Exception as e:
        return "Timeout"

def main():
    print(f"Connecting to {AGENT_IP}...")
    
    while True:
        # --- FETCH DATA ---
        # We fetch all three metrics every loop
        gpu_temp = get_snmp_data(OID_TEMP)
        location = get_snmp_data(OID_LOCATION)
        contact  = get_snmp_data(OID_CONTACT)
        cpu_load = get_snmp_data(OID_CPU_LOAD)
        
        # --- DISPLAY DASHBOARD ---
        os.system('clear') # Use 'cls' if on Windows
        print("==========================================")
        print(f"       RASPBERRY PI SNMP DASHBOARD       ")
        print("==========================================")
        print(f" Target IP    :  {AGENT_IP}")
        print(f" Location     :  {location}")
        print(f" Contact      :  {contact}")
        print("------------------------------------------")
        print(f" GPU Temp     :  {gpu_temp} °C")
        print("==========================================")
        print("------------------------------------------")
        print(f" CPU Load     :  {cpu_load} %")
        print("==========================================")
        print(" Press Ctrl+C to exit")
        
        time.sleep(2)

if __name__ == "__main__":
    main()
