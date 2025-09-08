#!/bin/bash

# Coyote MCP Server - VS Code Setup Script

echo "🐺 Setting up Coyote MCP Server for VS Code..."

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

# Create VS Code User settings directory if it doesn't exist
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_MCP_FILE="$VSCODE_CONFIG_DIR/mcp.json"

mkdir -p "$VSCODE_CONFIG_DIR"

# Check if VS Code MCP config exists and backup if needed
if [ -f "$VSCODE_MCP_FILE" ]; then
    echo "📋 Backing up existing VS Code MCP config..."
    cp "$VSCODE_MCP_FILE" "$VSCODE_MCP_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create or update VS Code MCP config
echo "⚙️  Configuring VS Code MCP..."

# Read existing config or create new one
if [ -f "$VSCODE_MCP_FILE" ]; then
    # Parse existing config and add our server
    node -e "
    const fs = require('fs');
    const path = '$VSCODE_MCP_FILE';
    let config = {};
    
    try {
        config = JSON.parse(fs.readFileSync(path, 'utf8'));
    } catch (e) {
        config = {};
    }
    
    if (!config.servers) {
        config.servers = {};
    }
    
    if (!config.inputs) {
        config.inputs = [];
    }
    
    config.servers['coyote-user'] = {
        type: 'stdio',
        command: 'coyote-mcp-server'
    };
    
    fs.writeFileSync(path, JSON.stringify(config, null, 2));
    console.log('✅ Added coyote-user to existing VS Code MCP config');
    "
else
    # Create new config file
    cat > "$VSCODE_MCP_FILE" << 'EOF'
{
  "servers": {
    "coyote-user": {
      "type": "stdio",
      "command": "coyote-mcp-server"
    }
  },
  "inputs": []
}
EOF
    echo "✅ Created new VS Code MCP config"
fi

echo ""
echo "🎉 VS Code setup complete!"
echo ""
echo "Next steps:"
echo "1. Restart VS Code completely"
echo "2. Open GitHub Copilot Chat"
echo "3. Try asking: 'Use AppleScript to show a dialog with Hello World'"
echo ""
echo "The coyote-user MCP server is now configured for VS Code!"
echo ""
echo "For troubleshooting, check that the command works:"
echo "  coyote-mcp-server"
echo ""
