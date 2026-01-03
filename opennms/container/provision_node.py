import requests
import json
import time

# --- CONFIGURATION ---
OPENNMS_URL = "http://localhost:8980/opennms"
USER = "admin"
PASSWORD = "admin"

REQ_NAME = "homelab_req"
NODE_LABEL = "rpi_x3_3"
NODE_IP = "192.168.0.38"
# Foreign ID must be unique. Using the IP as a string is a simple homelab strategy.
FOREIGN_ID = "192168038" 

HEADERS = {"Content-Type": "application/json", "Accept": "application/json"}
AUTH = (USER, PASSWORD)

def log(msg):
    print(f"▶ {msg}")

def check_response(response, step_name):
    if response.status_code in [200, 201, 202, 204]:
        print(f"  ✅ {step_name} Success")
    else:
        print(f"  ❌ {step_name} Failed ({response.status_code})")
        print(f"     Response: {response.text}")
        exit(1)

def main():
    s = requests.Session()
    s.auth = AUTH
    s.headers.update(HEADERS)
    
    # 1. Create Requisition
    # We check if it exists first to avoid overwriting existing nodes in a real scenario,
    # but for this script we will force create/update the header.
    log(f"Creating Requisition: {REQ_NAME}")
    payload = {
        "foreign-source": REQ_NAME,
        "date-stamp": "2023-01-01T00:00:00.000+00:00" # Placeholder date
    }
    # Note: To create, we POST to the collection
    resp = s.post(f"{OPENNMS_URL}/rest/requisitions", json=payload)
    
    # If it already exists (409 or similar), that's fine, we proceed.
    if resp.status_code == 400 and "exists" in resp.text: 
        print("  ℹ️  Requisition already exists. Proceeding...")
    else:
        check_response(resp, "Create Requisition")

    # 2. Add Node
    log(f"Adding Node: {NODE_LABEL} (ID: {FOREIGN_ID})")
    node_payload = {
        "foreign-id": FOREIGN_ID,
        "node-label": NODE_LABEL
    }
    resp = s.post(f"{OPENNMS_URL}/rest/requisitions/{REQ_NAME}/nodes", json=node_payload)
    check_response(resp, "Add Node")

    # 3. Add Interface
    log(f"Adding Interface: {NODE_IP}")
    intf_payload = {
        "ip-addr": NODE_IP,
        "snmp-primary": "P",  # P = Primary, S = Secondary, N = Not SNMP
        "status": 1           # 1 = Managed/Monitored
    }
    resp = s.post(f"{OPENNMS_URL}/rest/requisitions/{REQ_NAME}/nodes/{FOREIGN_ID}/interfaces", json=intf_payload)
    check_response(resp, "Add Interface")

    # 4. Add Service (SNMP)
    log("Adding Service: SNMP")
    svc_payload = {
        "service-name": "SNMP"
    }
    resp = s.post(f"{OPENNMS_URL}/rest/requisitions/{REQ_NAME}/nodes/{FOREIGN_ID}/interfaces/{NODE_IP}/services", json=svc_payload)
    check_response(resp, "Add Service")

    # 4.5 Add Service (ICMP) - Highly Recommended to add ICMP (Ping) as well
    log("Adding Service: ICMP")
    icmp_payload = {
        "service-name": "ICMP"
    }
    s.post(f"{OPENNMS_URL}/rest/requisitions/{REQ_NAME}/nodes/{FOREIGN_ID}/interfaces/{NODE_IP}/services", json=icmp_payload)
    print("  ✅ Add Service (ICMP) [Optional but added]")

    # 5. Synchronize (Import)
    # This step forces OpenNMS to read the "Pending" requisition and update the active database
    log("Synchronizing Requisition (Activating changes)...")
    resp = s.put(f"{OPENNMS_URL}/rest/requisitions/{REQ_NAME}/import")
    check_response(resp, "Synchronize")

    print("\n🎉 Success! The node is now provisioning. Check the UI in ~30 seconds.")

if __name__ == "__main__":
    main()