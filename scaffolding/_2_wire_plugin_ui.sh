#!/bin/bash
# ==============================================================================
# OpenNMS Plugin Scaffolding Script - STEP 2: WIRE UI
# Purpose: Generates a UIExtension class compatible with the v1 API.
# ==============================================================================
set -e
source ./_0_config.sh

# --- Logic for Class Names ---
# Transform "backup_restore" -> "Backup_restore" to match your specific file
CAMEL_NAME=$(echo "$PLUGIN_NAME" | sed 's/^\(.\)/\U\1/')
CLASS_NAME="${CAMEL_NAME}UIExtension"
PACKAGE_NAME="com.$COMPANY.$PLUGIN_NAME"

# Path to the Java Source folder inside the plugins directory
DEST_DIR="$PLUGIN_DIR/plugin/src/main/java/com/$COMPANY/$PLUGIN_NAME"
mkdir -p "$DEST_DIR"

echo -e "${CLR_GREEN}* Generating $CLASS_NAME.java in $DEST_DIR...${CLR_NORMAL}"

# --- Generate the Java File ---
cat <<EOF > "$DEST_DIR/$CLASS_NAME.java"
package $PACKAGE_NAME;

import org.opennms.integration.api.v1.ui.UIExtension;

/**
 * Auto-generated UI Extension for $PLUGIN_DESCRIPTION
 * Compatible with OpenNMS Integration API v1.
 */
public class $CLASS_NAME implements UIExtension {
    private String id;
    private String menuEntry;
    private String moduleFileName;
    private String resourceRoot;

    @Override
    public String getExtensionId() {
        return id;
    }

    @Override
    public String getMenuEntry() {
        return menuEntry;
    }

    @Override
    public String getResourceRootPath() {
        return resourceRoot;
    }

    @Override
    public String getModuleFileName() {
        return moduleFileName;
    }

    @Override
    public Class<? extends UIExtension> getExtensionClass() {
        return this.getClass();
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setMenuEntry(String menuEntry) {
        this.menuEntry = menuEntry;
    }

    public void setModuleFileName(String moduleFileName) {
        this.moduleFileName = moduleFileName;
    }

    public void setResourceRoot(String resourceRoot) {
        this.resourceRoot = resourceRoot;
    }
}
EOF

echo -e "${CLR_GREEN}✅ Step 2 Complete: v1 UI Extension created.${CLR_NORMAL}"