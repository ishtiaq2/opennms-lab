#!/bin/bash
set -e

# -----------------------------------------------------------------
# 1. Wait for PostgreSQL
# -----------------------------------------------------------------
# Increased timeout to 90s for Raspberry Pi slow starts
echo "Waiting for PostgreSQL at $POSTGRES_HOST:5432..."
timeout=90 

while ! exec 6<>/dev/tcp/$POSTGRES_HOST/5432; do
  echo "PostgreSQL is not ready yet... ($timeout seconds left)"
  sleep 3
  timeout=$((timeout - 3))
  if [ $timeout -le 0 ]; then
    echo "ERROR: Timed out waiting for PostgreSQL."
    exit 1
  fi
done
exec 6>&-
echo "PostgreSQL is ready."

# -----------------------------------------------------------------
# 2. Configure OpenNMS Datasources
# -----------------------------------------------------------------
DATASOURCE_CFG="/opt/opennms/etc/opennms-datasources.xml"
echo "Updating database config in $DATASOURCE_CFG..."

# SAFER: Only replace localhost if it is followed by the Postgres port
# This prevents breaking internal 'localhost' JMX/RMI links
sed -i "s/localhost:5432/$POSTGRES_HOST:5432/g" "$DATASOURCE_CFG"
sed -i "s/127.0.0.1:5432/$POSTGRES_HOST:5432/g" "$DATASOURCE_CFG"

# Update User/Pass
sed -i "s/user-name=\".*\"/user-name=\"$POSTGRES_USER\"/g" "$DATASOURCE_CFG"
sed -i "s/password=\".*\"/password=\"$POSTGRES_PASSWORD\"/g" "$DATASOURCE_CFG"

# -----------------------------------------------------------------
# 3. Handle Config Overlays (Optional but Recommended)
# -----------------------------------------------------------------
# If you mounted local configs to /opt/opennms-etc-overlay in your compose file,
# this copies them into place now.
if [ -d "/opt/opennms-etc-overlay" ]; then
    echo "Applying configuration overlay..."
    cp -r /opt/opennms-etc-overlay/* /opt/opennms/etc/ || true
fi

# -----------------------------------------------------------------
# 4. Initialize and Start
# -----------------------------------------------------------------
echo "Setting up Java environment..."
/opt/opennms/bin/runjava -s

echo "Checking Database Schema (Install/Upgrade)..."
# We run this EVERY time. It skips automatically if the DB is up to date.
# This ensures seamless upgrades in the future.
/opt/opennms/bin/install -dis

echo "Starting OpenNMS..."
exec /opt/opennms/bin/opennms -f start