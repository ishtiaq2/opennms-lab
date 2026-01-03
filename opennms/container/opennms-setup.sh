#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- CONFIGURATION ---
# Define the directories where your files live
PG_DIR="postgres"
NMS_DIR="opennms"

# Define the filenames (Make sure these match what is inside the folders!)
PG_COMPOSE_FILE="postgres14-container-compose.yml"
NMS_COMPOSE_FILE="opennms-container-compose.yml"

NETWORK_NAME="nms-internal-lan"
PG_CONTAINER_NAME="postgres-container"
NMS_CONTAINER_NAME="opennms-container"

echo "=========================================="
echo "      OpenNMS & Postgres Redeployer       "
echo "=========================================="

# ---------------------------------------------------------
# PHASE 1: CLEANUP
# ---------------------------------------------------------
echo "[1/5] Cleaning up old containers and volumes..."

# 1. Stop and remove OpenNMS
if podman ps -a --format "{{.Names}}" | grep -q "$NMS_CONTAINER_NAME"; then
    echo "  - Stopping $NMS_CONTAINER_NAME..."
    podman stop $NMS_CONTAINER_NAME || true
    podman rm $NMS_CONTAINER_NAME || true
fi

# 2. Stop and remove Postgres
if podman ps -a --format "{{.Names}}" | grep -q "$PG_CONTAINER_NAME"; then
    echo "  - Stopping $PG_CONTAINER_NAME..."
    podman stop $PG_CONTAINER_NAME || true
    podman rm $PG_CONTAINER_NAME || true
fi

# 3. Aggressive Volume Cleanup
# This removes the named config volume so fresh changes are picked up.
# We try multiple name variations because podman-compose sometimes prefixes them.
echo "  - Removing OpenNMS configuration volumes..."
podman volume rm opennms-etc 2>/dev/null || true
podman volume rm opennms_opennms-etc 2>/dev/null || true
podman volume rm conttainer_opennms-etc 2>/dev/null || true

# 4. Remove "Ghost" Volumes (Dangling/Unused)
# This cleans up anonymous volumes left behind by failed containers.
echo "  - Pruning all unused (ghost) volumes..."
podman volume prune -f

# 5. Remove old images to ensure a fresh build
echo "  - Pruning old images..."
podman image prune -f

# ---------------------------------------------------------
# PHASE 2: NETWORK
# ---------------------------------------------------------
echo "[2/5] Checking Network..."
if ! podman network exists $NETWORK_NAME; then
    echo "  - Creating network $NETWORK_NAME..."
    podman network create $NETWORK_NAME
else
    echo "  - Network $NETWORK_NAME already exists."
fi

# ---------------------------------------------------------
# PHASE 3: DATABASE
# ---------------------------------------------------------
echo "[3/5] Starting Database..."

pushd $PG_DIR > /dev/null
    if [ ! -f "$PG_COMPOSE_FILE" ]; then
        echo "ERROR: Could not find $PG_COMPOSE_FILE inside $PG_DIR/"
        echo "Please check the filename."
        exit 1
    fi
    
    echo "  - Syncing environment variables..."
    cp ../nms.env .env

    podman-compose -f $PG_COMPOSE_FILE up -d
popd > /dev/null

echo "  - Waiting for Postgres to initialize ..."
until podman exec $PG_CONTAINER_NAME pg_isready -U postgres; do
  sleep 2
done


# ---------------------------------------------------------
# PHASE 4: OPENNMS
# ---------------------------------------------------------
echo "[4/5] Building and Starting OpenNMS..."

pushd $NMS_DIR > /dev/null
    if [ ! -f "$NMS_COMPOSE_FILE" ]; then
        echo "ERROR: Could not find $NMS_COMPOSE_FILE inside $NMS_DIR/"
        echo "Please check the filename."
        exit 1
    fi
    
    echo "  - Syncing environment variables..."
    cp ../nms.env .env
    
    echo "  - Building OpenNMS image..."
    podman-compose -f $NMS_COMPOSE_FILE build --no-cache

    echo "  - Starting OpenNMS container..."
    podman-compose -f $NMS_COMPOSE_FILE up -d
popd > /dev/null

# ---------------------------------------------------------
# PHASE 5: VERIFICATION
# ---------------------------------------------------------
echo "=========================================="
echo "           DEPLOYMENT COMPLETE            "
echo "=========================================="
echo "You can follow the logs by running: podman logs -f $NMS_CONTAINER_NAME"