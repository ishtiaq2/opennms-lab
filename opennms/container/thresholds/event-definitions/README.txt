podman exec opennms-container sh -c "grep -l 'highThresholdExceeded' \
/opt/opennms/etc/events/*.xml"

/opt/opennms/etc/events/opennms.default.threshold.events.xml


podman exec opennms-container grep -A 15 "highThresholdExceeded" \
/opt/opennms/etc/events/opennms.default.threshold.events.xml


 podman cp opennms-container:/opt/opennms/etc/events/opennms.default.threshold.events.xml .