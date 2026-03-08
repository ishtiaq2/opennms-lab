To achieve Goal 1, we need to move from manual snmpget commands to an automated OpenNMS Poller. This involves three main steps: telling OpenNMS about the MIB, defining how to collect the data, and finally, how to display it as a graph.

🛠️ Phase 1: Upload the MIB
For OpenNMS to "humanize" the OIDs from your Raspberry Pi, it needs the MIB file in its internal library.

Copy the MIB to the Container:

Bash
# Run this from your opennms-lab root
podman cp ./plugins/RPI-MONITOR-MIB.txt opennms:/usr/share/snmp/mibs/
Compile the MIB (Optional but Recommended):
OpenNMS can use the raw text, but it's better to let the OpenNMS UI "scan" it so you can use the MIB Browser to verify the OIDs.

📊 Phase 2: Define Data Collection (datacollection-config.xml)
This is where we tell OpenNMS: "Go to this OID, name it rpiCpuTemp, and store it as a Gauge."

In OpenNMS, you will define a Group for your RPI metrics.

XML
<group name="rpi-stats" ifType="all">
    <mibObj oid=".1.3.6.1.4.1.8072.1.3.2.3.1.1.8.103.112.117.84.101.109.112" 
            instance="0" alias="rpiCpuTemp" type="gauge" />
</group>
Note: Since you are using NET-SNMP-EXTEND, the OID is quite long. It represents the "extended" output string for your gpuTemp script.

📈 Phase 3: Create the Graph Template (snmp-graph.properties)
Now that OpenNMS is storing the data, we need to tell it how to draw the chart.

Properties
# This would go in your etc/snmp-graph.properties.d/rpi-graph.properties
reports=rpi.cpu.temp

report.rpi.cpu.temp.name=Raspberry Pi CPU Temperature
report.rpi.cpu.temp.columns=rpiCpuTemp
report.rpi.cpu.temp.type=nodeSnmp
report.rpi.cpu.temp.command=--title="CPU Temperature" \
 DEF:temp={rrd1}:rpiCpuTemp:AVERAGE \
 LINE2:temp#ff0000:"Celsius" \
 GPRINT:temp:AVERAGE:"Avg \\: %8.2lf %s" \
 GPRINT:temp:MIN:"Min \\: %8.2lf %s" \
 GPRINT:temp:MAX:"Max \\: %8.2lf %s\\n"
🤖 Goal 1 Integration: Automation & Plugins
To keep your lab clean, you shouldn't edit these files inside the container manually. Instead:

Automation Submodule: Add a script that uses podman cp to push these XML configurations into the /opt/opennms/etc/ directory during setup.

Plugins Submodule: Store your RPI-MONITOR-MIB.txt and the rpi.xml collection files here. This allows you to version-control your custom monitoring logic.

🚀 Next Steps
To get this working, we need to ensure the Agent (your Raspberry Pi) is configured to share this data.

