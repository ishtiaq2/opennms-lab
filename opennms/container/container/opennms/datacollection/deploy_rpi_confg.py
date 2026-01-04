#!/usr/bin/env python3

import subprocess
import sys

CONTAINER = "opennms-container"

COMMANDS = [
    # 1. Remove old RRD files (Safe check || true logic handled in python by ignoring exit code if needed, 
    # but strictly rm -rf usually succeeds even if empty)
    [
        "podman", "exec", CONTAINER,
        "rm", "-rf", "/opt/opennms/share/rrd/snmp/"
    ],

    # 2. Disable standard Net-SNMP (Renaming it is safer than delete)
    # We use the correct path: /opt/opennms/etc/datacollection/
    [
        "podman", "exec", CONTAINER,
        "mv", "/opt/opennms/etc/datacollection/netsnmp.xml", 
        "/opt/opennms/etc/datacollection/netsnmp.xml.disabled"
    ],

    # 3. Copy datacollection-config.xml
    [
        "podman", "cp",
        "datacollection-config.xml",
        f"{CONTAINER}:/opt/opennms/etc/datacollection-config.xml"
    ],

    # 4. Copy rpi.xml
    [
        "podman", "cp",
        "rpi.xml",
        f"{CONTAINER}:/opt/opennms/etc/datacollection/"
    ],

    # 5. Copy rpi.properties
    [
        "podman", "cp",
        "rpi.properties",
        f"{CONTAINER}:/opt/opennms/etc/snmp-graph.properties.d/"
    ],

    # 6. FIX PERMISSIONS (CRITICAL STEP)
    # Ensure the 'opennms' user owns the files we just copied
    [
        "podman", "exec", "-u", "0", CONTAINER,
        "chown", "-R", "opennms:opennms",
        "/opt/opennms/etc/datacollection-config.xml",
        "/opt/opennms/etc/datacollection/",
        "/opt/opennms/etc/snmp-graph.properties.d/"
    ],

    # 7. Restart OpenNMS container
    [
        "podman", "restart", CONTAINER
    ],
]


def run_command(cmd):
    # Join command for pretty printing
    cmd_str = ' '.join(cmd)
    print(f"\n▶ Running: {cmd_str}")
    
    try:
        # We suppress output for cleaner logs, but show stderr if it fails
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        # Special handling: If 'mv' fails because the file doesn't exist (already moved), we can ignore it
        if "mv" in cmd and "netsnmp.xml" in cmd_str:
            print("  ⚠️  File likely already moved/missing. Continuing...")
        else:
            print(f"❌ Command failed: {cmd_str}")
            sys.exit(e.returncode)


def main():
    print("=== OpenNMS SNMP Config Update Script ===")

    for cmd in COMMANDS:
        run_command(cmd)

    print("\n✅ Update Complete.")
    print("\n=== Debug command (wait 5 mins then run) ===")
    print(
        f"podman exec {CONTAINER} ls -l /opt/opennms/share/rrd/snmp/"
    )


if __name__ == "__main__":
    main()