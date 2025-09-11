#!/bin/bash

# Coyote MCP Server - Claude CLI Setup Script
# This script installs and configures the Coyote MCP Server for Claude CLI

set -e

echo "🤖 Setting up Coyote MCP Server for Claude CLI..."

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

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null && ! command -v claude-cli &> /dev/null; then
    echo -e "${YELLOW}⚠️  Claude CLI not found. You may need to install it first:${NC}"
    echo -e "   ${BLUE}pip install claude-cli${NC}"
    echo -e "   ${BLUE}or${NC}"
    echo -e "   ${BLUE}npm install -g @anthropic/claude-cli${NC}"
    echo ""
    echo -e "${BLUE}Continuing with MCP server setup...${NC}"
fi

echo -e "${BLUE}📦 Installing Coyote MCP Server...${NC}"

# Install dependencies and build
npm install
npm run build

# Link globally so it can be used from anywhere
npm link --force

echo -e "${GREEN}✅ Coyote MCP Server installed globally${NC}"

# Claude CLI config directory and file
CLAUDE_CLI_CONFIG_DIR="$HOME/.config/claude-cli"
CONFIG_FILE="$CLAUDE_CLI_CONFIG_DIR/mcp.json"

# Create Claude CLI config directory if it doesn't exist
if [ ! -d "$CLAUDE_CLI_CONFIG_DIR" ]; then
    echo -e "${BLUE}📁 Creating Claude CLI config directory...${NC}"
    mkdir -p "$CLAUDE_CLI_CONFIG_DIR"
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
    echo -e "${BLUE}🔧 Merging with existing Claude CLI MCP configuration...${NC}"
    
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
    echo -e "${BLUE}📝 Creating new Claude CLI MCP configuration...${NC}"
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

echo -e "${GREEN}🎉 Coyote MCP Server setup complete for Claude CLI!${NC}"
echo ""
echo -e "${BLUE}📋 Configuration Summary:${NC}"
echo -e "   • Server: ${GREEN}coyote-use${NC}"
echo -e "   • Command: ${GREEN}coyote-mcp-server${NC}"
echo -e "   • Config: ${GREEN}$CONFIG_FILE${NC}"
echo ""
echo -e "${BLUE}🚀 Usage Instructions:${NC}"
echo ""
echo -e "${YELLOW}Option 1 - Using config file (with print mode):${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --print \"Use AppleScript to show a dialog\"${NC}"
echo ""
echo -e "${YELLOW}Option 2 - Direct MCP server specification:${NC}"
echo -e "   ${GREEN}claude --mcp coyote-mcp-server --print \"Show me a notification with Hello World\"${NC}"
echo ""
echo -e "${YELLOW}Option 3 - Interactive mode:${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE${NC}"
echo -e "   Then ask: \"${YELLOW}Use AppleScript to open Calculator${NC}\""
echo ""
echo -e "${YELLOW}Option 4 - Bypass permissions (for automation):${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --print --dangerously-skip-permissions \"Use run_applescript tool\"${NC}"
echo ""
echo -e "${BLUE}🔧 Available Tool:${NC}"
echo -e "   • ${GREEN}run_applescript${NC}: Execute AppleScript commands on macOS"
echo ""
echo -e "${BLUE}💡 Usage Examples:${NC}"
echo -e "   ${YELLOW}# Basic usage (may require permission prompts):${NC}"
echo -e "   \"${YELLOW}Use AppleScript to display a notification with 'Hello from Claude CLI!'${NC}\""
echo -e "   \"${YELLOW}Run AppleScript to open Finder${NC}\""
echo -e "   \"${YELLOW}Execute AppleScript to show the current time${NC}\""
echo ""
echo -e "   ${YELLOW}# For testing/automation (skips permissions):${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --dangerously-skip-permissions --print \"Use AppleScript to open Calculator\"${NC}"
echo ""
echo -e "   ${YELLOW}# Allow specific tools:${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --allowed-tools \"run_applescript\" --print \"Use AppleScript to open Safari\"${NC}"
echo ""
echo -e "${BLUE}📚 Claude CLI Installation:${NC}"
echo -e "   If you don't have Claude CLI installed yet:"
echo -e "   • ${YELLOW}pip install claude-cli${NC}"
echo -e "   • ${YELLOW}npm install -g @anthropic/claude-cli${NC}"
echo ""
echo -e "${BLUE}📖 Documentation:${NC}"
echo -e "   • MCP Protocol: ${BLUE}https://modelcontextprotocol.io/${NC}"
echo -e "   • Anthropic Docs: ${BLUE}https://docs.anthropic.com/${NC}"
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
echo -e "${GREEN}🔧 Test the setup:${NC}"
echo -e "   ${GREEN}# Test with permission bypass:${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --dangerously-skip-permissions --print \"Test the AppleScript tool by showing a dialog with 'Setup Complete!'\"${NC}"
echo ""
echo -e "   ${GREEN}# Test with permission prompts:${NC}"
echo -e "   ${GREEN}claude --mcp-config $CONFIG_FILE --print \"Use AppleScript to open Calculator\"${NC}"
