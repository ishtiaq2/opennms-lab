# Start with the official image
FROM opennms/horizon:33.1.8

# Copy my custom definitions into the image
# COPY datacollection-config.xml /opt/opennms/etc/datacollection-config.xml
# COPY netsnmp.xml /opt/opennms/etc/datacollection/netsnmp.xml
# COPY rpi.properties /opt/opennms/etc/snmp-graph.properties.d/rpi.properties

# Fix permissions so the 'opennms' user owns them
USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ensure ownership is correct if copying other config files later
RUN chown opennms:opennms /entrypoint.sh
RUN chown opennms:opennms /opt/opennms/etc/datacollection-config.xml
USER opennms
ENTRYPOINT ["/entrypoint.sh"]
