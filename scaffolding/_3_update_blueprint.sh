#!/bin/bash
# ==============================================================================
# OSGi Blueprint Configuration Generator - STEP 3
# Purpose: Registers the Java UIExtension as an OSGi service in OpenNMS.
# ==============================================================================
set -e
source ./_0_config.sh

# --- 1. Class and Path Logic ---
# Ensure we match the "Backup_restore" naming style from Step 2
CAMEL_NAME=$(echo "$PLUGIN_NAME" | sed 's/^\(.\)/\U\1/')
CLASS_NAME="${CAMEL_NAME}UIExtension"
FULL_CLASS_PATH="com.$COMPANY.$PLUGIN_NAME.$CLASS_NAME"

# Target path inside the plugins directory
BP_DIR="$PLUGIN_DIR/plugin/src/main/resources/OSGI-INF/blueprint"
BP_FILE="$BP_DIR/blueprint.xml"

echo -e "${CLR_GREEN}* Updating Blueprint for $PLUGIN_NAME...${CLR_NORMAL}"

# Ensure the directory exists (it should from the archetype, but safety first)
mkdir -p "$BP_DIR"

# --- 2. Blueprint Generation (Heredoc) ---
# This XML maps the Java 'setters' to the values OpenNMS needs to display the UI.
cat <<EOF > "$BP_FILE"
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0" 
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.osgi.org/xmlns/blueprint/v1.0.0 
                http://www.osgi.org/xmlns/blueprint/v1.0.0/blueprint.xsd">

    <service id="uiExtension" interface="org.opennms.integration.api.v1.ui.UIExtension">
        <bean class="$FULL_CLASS_PATH">
            <property name="id" value="$PLUGIN_NAME"/>
            
            <property name="menuEntry" value="$PLUGIN_DESCRIPTION"/>
            
            <property name="resourceRoot" value="ui-ext"/>
            
            <property name="moduleFileName" value="uiextension.es.js"/>
        </bean>
    </service>

</blueprint>
EOF

# --- 3. Final Verification ---
echo -e "${CLR_GREEN}✅ Blueprint created successfully!${CLR_NORMAL}"
echo "   - File: $BP_FILE"
echo "   - Class: $FULL_CLASS_PATH"
echo "   - Label: $PLUGIN_DESCRIPTION"