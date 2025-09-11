#!/bin/bash

# Coyote MCP Server - Complete Uninstall Script
# This script removes all configurations, files, and global installations

set -e

echo "🗑️  Uninstalling Coyote MCP Server completely..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define exact config file locations (no guessing)
CONFIG_FILES=(
    "$HOME/.config/claude_desktop_config.json"
    "$HOME/.config/claude-cli/mcp.json" 
    "$HOME/.codeium/windsurf/mcp_config.json"
    "$HOME/.cursor/mcp.json"
)

# Function to backup and remove config
backup_and_remove() {
    local config_file="$1"
    local server_name="$2"
    
    if [ -f "$config_file" ]; then
        echo -e "${BLUE}📄 Processing: $config_file${NC}"
        
        # Create backup
        local backup_file="${config_file}.backup.uninstall.$(date +%Y%m%d_%H%M%S)"
        cp "$config_file" "$backup_file"
        echo -e "${YELLOW}💾 Backed up to: $backup_file${NC}"
        
        # Check if file contains our server
        if grep -q "$server_name" "$config_file" 2>/dev/null; then
            # Use Node.js to remove our server from the config
            node -e "
            const fs = require('fs');
            const path = '$config_file';
            
            try {
                const config = JSON.parse(fs.readFileSync(path, 'utf8'));
                
                // Remove from mcpServers (Claude, Windsurf, Cursor, Claude CLI)
                if (config.mcpServers && config.mcpServers['$server_name']) {
                    delete config.mcpServers['$server_name'];
                    console.log('✅ Removed $server_name from mcpServers');
                }
                
                // Remove from servers (VS Code)
                if (config.servers && config.servers['$server_name']) {
                    delete config.servers['$server_name'];
                    console.log('✅ Removed $server_name from servers');
                }
                
                // Write back the cleaned configuration
                fs.writeFileSync(path, JSON.stringify(config, null, 2));
                console.log('✅ Updated configuration file');
                
                // If config is now empty, remove the file
                const hasServers = (config.mcpServers && Object.keys(config.mcpServers).length > 0) ||
                                 (config.servers && Object.keys(config.servers).length > 0);
                
                if (!hasServers) {
                    fs.unlinkSync(path);
                    console.log('🗑️  Removed empty configuration file');
                }
                
            } catch (error) {
                console.error('❌ Error processing config:', error.message);
                console.log('🗑️  Removing entire file due to error');
                fs.unlinkSync(path);
            }
            " 2>/dev/null || {
                echo -e "${YELLOW}⚠️  Could not parse JSON, removing entire file${NC}"
                rm -f "$config_file"
            }
        else
            echo -e "${GREEN}✅ File doesn't contain $server_name, leaving unchanged${NC}"
        fi
    else
        echo -e "${YELLOW}ℹ️  Config file not found: $config_file${NC}"
    fi
}

# Function to show what exists before removal
show_current_state() {
    echo -e "${BLUE}🔍 Current installation state:${NC}"
    
    echo -e "${YELLOW}Configuration files:${NC}"
    for config_file in "${CONFIG_FILES[@]}"; do
        if [ -f "$config_file" ]; then
            if grep -q "coyote-use" "$config_file" 2>/dev/null; then
                echo -e "   ✅ $config_file (contains coyote-use)"
            else
                echo -e "   📄 $config_file (exists, no coyote-use)"
            fi
        else
            echo -e "   ❌ $config_file (not found)"
        fi
    done
    
    echo -e "${YELLOW}Global binary:${NC}"
    BINARY_PATH=$(which coyote-mcp-server 2>/dev/null)
    if [ -n "$BINARY_PATH" ]; then
        echo -e "   ✅ $BINARY_PATH"
    else
        echo -e "   ❌ coyote-mcp-server (not in PATH)"
    fi
    echo ""
}

# Show current state before removal
show_current_state

echo -e "${BLUE}🧹 Cleaning up MCP configurations...${NC}"

# Define exact config file locations (no guessing)
CONFIG_FILES=(
    "$HOME/.config/claude_desktop_config.json"
    "$HOME/.config/claude-cli/mcp.json" 
    "$HOME/.codeium/windsurf/mcp_config.json"
    "$HOME/.cursor/mcp.json"
)

# Only process files that actually exist
for config_file in "${CONFIG_FILES[@]}"; do
    backup_and_remove "$config_file" "coyote-use"
done

echo -e "${BLUE}🗑️  Removing global npm installation...${NC}"

# Unlink and uninstall global package
npm unlink coyote-mcp-server 2>/dev/null || echo -e "${YELLOW}ℹ️  Package not linked${NC}"
npm uninstall -g coyote-mcp-server 2>/dev/null || echo -e "${YELLOW}ℹ️  Package not globally installed${NC}"

echo -e "${BLUE}🗑️  Removing binary files...${NC}"

# Get the actual npm global bin directory
NPM_BIN_DIR=$(npm config get prefix 2>/dev/null)/bin
if [ -d "$NPM_BIN_DIR" ] && [ -f "$NPM_BIN_DIR/coyote-mcp-server" ]; then
    echo -e "${YELLOW}🗑️  Removing: $NPM_BIN_DIR/coyote-mcp-server${NC}"
    rm -f "$NPM_BIN_DIR/coyote-mcp-server"
fi

# Check if it exists in current PATH and remove only if found
BINARY_PATH=$(which coyote-mcp-server 2>/dev/null)
if [ -n "$BINARY_PATH" ] && [ -f "$BINARY_PATH" ]; then
    echo -e "${YELLOW}🗑️  Removing: $BINARY_PATH${NC}"
    rm -f "$BINARY_PATH"
fi

echo -e "${BLUE}🧹 Cleaning npm cache...${NC}"
npm cache clean --force 2>/dev/null || echo -e "${YELLOW}ℹ️  Could not clean npm cache${NC}"

echo -e "${BLUE}🗑️  Removing backup files older than 30 days...${NC}"

# Only clean backup files in directories we know exist and created backups in
for config_file in "${CONFIG_FILES[@]}"; do
    if [ -f "$config_file" ] || [ -f "${config_file}.backup."* ]; then
        config_dir=$(dirname "$config_file")
        if [ -d "$config_dir" ]; then
            find "$config_dir" -name "*.backup.*" -mtime +30 -delete 2>/dev/null || true
        fi
    fi
done

echo ""
echo -e "${GREEN}✅ Coyote MCP Server uninstall complete!${NC}"
echo ""
echo -e "${BLUE}📋 What was removed:${NC}"
echo -e "   • All ${YELLOW}coyote-use${NC} server configurations"
echo -e "   • Global npm package ${YELLOW}coyote-mcp-server${NC}"
echo -e "   • Binary files from system PATH"
echo -e "   • npm cache entries"
echo ""
echo -e "${BLUE}📁 Backup files created:${NC}"
echo -e "   • Configuration backups saved with ${YELLOW}.backup.uninstall${NC} suffix"
echo -e "   • Old backups (>30 days) were cleaned up"
echo ""
echo -e "${BLUE}🔄 To complete cleanup:${NC}"
echo -e "   • Restart your MCP clients (Claude, VS Code, Windsurf, Cursor)"
echo -e "   • Clear terminal hash: ${YELLOW}hash -r${NC}"
echo ""
echo -e "${GREEN}✨ All clean! Thank you for using Coyote MCP Server.${NC}"
