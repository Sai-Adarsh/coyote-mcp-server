#!/bin/bash

# Coyote MCP Server - Claude Desktop Setup Script

echo "🐺 Setting up Coyote MCP Server for Claude Desktop..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This MCP server is designed for macOS only."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Install dependencies and build
echo "📦 Installing dependencies..."
npm install

echo "🔨 Building the MCP server..."
npm run build

# Make the command globally available
echo "🔗 Making coyote-mcp-server command available globally..."
npm link

# Create Claude Desktop config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

mkdir -p "$CLAUDE_CONFIG_DIR"

# Check if Claude config exists and backup if needed
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
    echo "📋 Backing up existing Claude Desktop config..."
    cp "$CLAUDE_CONFIG_FILE" "$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create or update Claude Desktop config
echo "⚙️  Configuring Claude Desktop..."

# Read existing config or create new one
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
    # Parse existing config and add our server
    node -e "
    const fs = require('fs');
    const path = '$CLAUDE_CONFIG_FILE';
    let config = {};
    
    try {
        config = JSON.parse(fs.readFileSync(path, 'utf8'));
    } catch (e) {
        config = {};
    }
    
    if (!config.mcpServers) {
        config.mcpServers = {};
    }
    
    config.mcpServers['coyote.*use'] = {
        command: 'coyote-mcp-server'
    };
    
    fs.writeFileSync(path, JSON.stringify(config, null, 2));
    console.log('✅ Added coyote.*use to existing Claude Desktop config');
    "
else
    # Create new config file
    cat > "$CLAUDE_CONFIG_FILE" << 'EOF'
{
  "mcpServers": {
    "coyote.*use": {
      "command": "coyote-mcp-server"
    }
  }
}
EOF
    echo "✅ Created new Claude Desktop config"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop completely (quit and reopen)"
echo "2. Try asking Claude: 'Use AppleScript to show a dialog with Hello World'"
echo ""
echo "The coyote.*use MCP server is now configured and ready to use!"
echo ""
echo "For troubleshooting, check that the command works:"
echo "  coyote-mcp-server"
echo ""
