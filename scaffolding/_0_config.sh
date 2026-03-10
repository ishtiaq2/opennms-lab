#!/bin/bash
# ==============================================================================
# OPENNMS PLUGIN WORKSPACE CONFIGURATION
# ==============================================================================

# --- 1. PLUGIN IDENTITY ---
PLUGIN_NAME="my_first_plugin"
PLUGIN_VERSION="1.0.0"
PLUGIN_DESCRIPTION="My First Plugin Dashboard"
COMPANY="mycompany"

# --- 2. PATH CALCULATIONS ---
BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PLUGINS_ROOT="$BASE_DIR/plugins"
PLUGIN_DIR="$PLUGINS_ROOT/$PLUGIN_NAME"

# --- 3. DYNAMIC JAVA CONTEXT ---
# This converts 'my_first_plugin' to 'MyFirstPlugin'
camel_name=$(echo "$PLUGIN_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Your requested format: MyFirstPlugin_UIExtension
class_name="${camel_name}_UIExtension"

# Package path remains standard directory format
package_path="com/${COMPANY}/${PLUGIN_NAME}"

# --- 4. UI/TERMINAL FORMATTING ---
CLR_GREEN='\033[0;32m'
CLR_CYAN='\033[0;36m'
CLR_YELLOW='\033[0;33m'
CLR_NORMAL='\033[0m'

# --- 5. ENVIRONMENT VALIDATION & LOGGING ---
if [ ! -d "$PLUGINS_ROOT" ]; then
    echo -e "${CLR_YELLOW}dir: ${PLUGINS_ROOT} not found. Creating it...${CLR_NORMAL}"
    mkdir -p "$PLUGINS_ROOT"
fi

echo -e "${CLR_CYAN}====================================================${CLR_NORMAL}"
echo -e "${CLR_GREEN}✅ Configuration Updated & Loaded${CLR_NORMAL}"
echo -e "${CLR_CYAN}----------------------------------------------------${CLR_NORMAL}"
echo -e "📦 Plugin:      ${CLR_YELLOW}${PLUGIN_NAME}${CLR_NORMAL}"
echo -e "📂 Target Dir:  ${PLUGIN_DIR}"
echo -e "☕ Java Class:  ${CLR_YELLOW}${class_name}${CLR_NORMAL}"
echo -e "📂 Workspace:   ${BASE_DIR}"
echo -e "${CLR_CYAN}====================================================${CLR_NORMAL}"