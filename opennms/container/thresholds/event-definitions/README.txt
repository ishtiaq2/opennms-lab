podman exec opennms-container sh -c "grep -l 'highThresholdExceeded' \
/opt/opennms/etc/events/*.xml"

/opt/opennms/etc/events/opennms.default.threshold.events.xml


podman exec opennms-container grep -A 15 "highThresholdExceeded" \
/opt/opennms/etc/events/opennms.default.threshold.events.xml


 podman cp opennms-container:/opt/opennms/etc/events/opennms.default.threshold.events.xml .
 
  <logmsg dest="logndisplay">
    High threshold exceeded for service %service% metric %parm[ds]% on node &lt;a href="/opennms/element/node.jsp?node=%nodeid%"&gt;%parm[label]%&lt;/a&gt; interface %interface%
  </logmsg>

 podman cp opennms.default.threshold.events.xml opennms-container:/opt/opennms/etc/events/ 


# Force Eventd to reload its XML files
podman exec opennms-container /opt/opennms/bin/send-event \
  uei.opennms.org/internal/reloadDaemonConfig \
  --parm 'daemonName=eventd'