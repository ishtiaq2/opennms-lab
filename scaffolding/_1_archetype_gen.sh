#!/bin/bash
# ==============================================================================
# OpenNMS Plugin Scaffolding Script
# Purpose: Generates a plugin skeleton and cleans out archetype boilerplate
# ==============================================================================

set -e
source ./_0_config.sh

# Cleanup existing
if [ -d "$PLUGIN_DIR" ]; then
  echo -e "${CLR_RED}* Removing old plugin at $PLUGIN_DIR${CLR_NORMAL}"
  rm -rf "$PLUGIN_DIR"
fi  

# Create and Enter Plugins Root
mkdir -p "$PLUGINS_ROOT"
cd "$PLUGINS_ROOT"

# Generate
echo -e "${CLR_GREEN}* Generating $PLUGIN_NAME...${CLR_NORMAL}"
mvn archetype:generate -B \
  -DarchetypeGroupId=org.opennms.integration.api \
  -DarchetypeArtifactId=example-kar-plugin \
  -DarchetypeVersion=1.0.0 \
  -DgroupId=com.$COMPANY \
  -DartifactId=$PLUGIN_NAME \
  -Dversion=$PLUGIN_VERSION \
  -Dpackage=com.$COMPANY.$PLUGIN_NAME \
  -DpluginId=$PLUGIN_NAME \
  -DpluginName="$PLUGIN_DESCRIPTION"

# Cleanup Boilerplate using the absolute path
rm -rf "$PLUGIN_DIR/plugin/src/main/java/com/$COMPANY/$PLUGIN_NAME"/*
rm -rf "$PLUGIN_DIR/plugin/src/main/resources/events"/*
rm -rf "$PLUGIN_DIR/plugin/src/test"/*

echo -e "${CLR_GREEN}✅ Success! Project is in $PLUGIN_DIR${CLR_NORMAL}"