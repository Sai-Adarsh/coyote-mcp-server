#!/bin/bash

# Coyote MCP Server - Cursor Setup Script
# This script installs and configures the Coyote MCP Server for Cursor

set -e

echo "🎯 Setting up Coyote MCP Server for Cursor..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This MCP server is designed for macOS only (requires osascript)${NC}"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install npm first.${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Installing Coyote MCP Server...${NC}"

# Install dependencies and build
npm install
npm run build

# Link globally so it can be used from anywhere
npm link

echo -e "${GREEN}✅ Coyote MCP Server installed globally${NC}"

# Cursor config directory and file
CURSOR_CONFIG_DIR="$HOME/.cursor"
CONFIG_FILE="$CURSOR_CONFIG_DIR/mcp.json"

# Create Cursor config directory if it doesn't exist
if [ ! -d "$CURSOR_CONFIG_DIR" ]; then
    echo -e "${BLUE}📁 Creating Cursor config directory...${NC}"
    mkdir -p "$CURSOR_CONFIG_DIR"
fi

# Create backup if config file exists
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}⚠️  Backing up existing config to: $BACKUP_FILE${NC}"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
fi

# MCP Server configuration
MCP_CONFIG='{
  "mcpServers": {
    "coyote-use": {
      "command": "coyote-mcp-server",
      "args": []
    }
  }
}'

# Check if config file exists and has content
if [ -f "$CONFIG_FILE" ] && [ -s "$CONFIG_FILE" ]; then
    echo -e "${BLUE}🔧 Merging with existing Cursor MCP configuration...${NC}"
    
    # Use Node.js to merge JSON configurations
    node -e "
    const fs = require('fs');
    const path = '$CONFIG_FILE';
    
    try {
        const existing = JSON.parse(fs.readFileSync(path, 'utf8'));
        const newConfig = $MCP_CONFIG;
        
        // Ensure mcpServers exists
        if (!existing.mcpServers) {
            existing.mcpServers = {};
        }
        
        // Add or update the coyote-use server
        existing.mcpServers['coyote-use'] = newConfig.mcpServers['coyote-use'];
        
        // Write back the merged configuration
        fs.writeFileSync(path, JSON.stringify(existing, null, 2));
        console.log('✅ Configuration merged successfully');
    } catch (error) {
        console.error('❌ Error merging configuration:', error.message);
        // If there's an error, write the new config
        fs.writeFileSync(path, JSON.stringify($MCP_CONFIG, null, 2));
        console.log('✅ New configuration written');
    }
    "
else
    echo -e "${BLUE}📝 Creating new Cursor MCP configuration...${NC}"
    echo "$MCP_CONFIG" | node -e "
    const fs = require('fs');
    let input = '';
    process.stdin.on('data', chunk => input += chunk);
    process.stdin.on('end', () => {
        const config = JSON.parse(input);
        fs.writeFileSync('$CONFIG_FILE', JSON.stringify(config, null, 2));
        console.log('✅ Configuration file created');
    });
    "
fi

echo -e "${GREEN}🎉 Coyote MCP Server setup complete for Cursor!${NC}"
echo ""
echo -e "${BLUE}📋 Configuration Summary:${NC}"
echo -e "   • Server: ${GREEN}coyote-use${NC}"
echo -e "   • Command: ${GREEN}coyote-mcp-server${NC}"
echo -e "   • Config: ${GREEN}$CONFIG_FILE${NC}"
echo -e "   • Scope: ${GREEN}Global (all projects)${NC}"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo -e "   1. ${YELLOW}Restart Cursor${NC} to load the new MCP configuration"
echo -e "   2. Open any project or create a new one"
echo -e "   3. Open ${YELLOW}Chat/Agent${NC} and look for MCP tools"
echo -e "   4. The ${YELLOW}run_applescript${NC} tool should be available"
echo -e "   5. You can toggle MCP tools on/off in the chat interface"
echo ""
echo -e "${BLUE}🔧 Available Tool:${NC}"
echo -e "   • ${GREEN}run_applescript${NC}: Execute AppleScript commands on macOS"
echo ""
echo -e "${BLUE}💡 Usage Examples:${NC}"
echo -e "   Ask Cursor Agent: \"${YELLOW}Use the run_applescript tool to display a notification${NC}\""
echo -e "   Or simply: \"${YELLOW}Show me a dialog with 'Hello from Cursor!'${NC}\""
echo -e "   Or: \"${YELLOW}Open Calculator using AppleScript${NC}\""
echo ""
echo -e "${BLUE}⚙️  Configuration Options:${NC}"
echo -e "   • ${YELLOW}Global config${NC}: ~/.cursor/mcp.json (affects all projects)"
echo -e "   • ${YELLOW}Project config${NC}: .cursor/mcp.json (project-specific)"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "   • Cursor MCP: ${BLUE}https://docs.cursor.com/en/context/mcp${NC}"
echo -e "   • MCP Protocol: ${BLUE}https://modelcontextprotocol.io/${NC}"
echo -e "   • Cursor Tools: ${BLUE}https://docs.cursor.com/en/tools${NC}"
echo ""

# Verify the configuration
echo -e "${BLUE}🔍 Verifying configuration...${NC}"
if [ -f "$CONFIG_FILE" ]; then
    if node -e "JSON.parse(require('fs').readFileSync('$CONFIG_FILE', 'utf8'))" 2>/dev/null; then
        echo -e "${GREEN}✅ Configuration file is valid JSON${NC}"
    else
        echo -e "${RED}❌ Configuration file has invalid JSON${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Configuration file was not created${NC}"
    exit 1
fi

echo -e "${GREEN}✨ Setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}💡 Pro Tip:${NC} You can also install MCP servers from Cursor's built-in"
echo -e "   tool store at ${YELLOW}https://docs.cursor.com/en/tools${NC} for one-click installation!"
