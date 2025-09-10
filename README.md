## Installation

### Quick Setup

**For Claude Desktop:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-claude
```

**For VS Code:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-vscode
```

**For Windsurf:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-windsurf
```

**For Cursor:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-cursor
```

**For Claude CLI:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-claude-cli
```

**For all clients:**
```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-all
```

This will:
1. Install dependencies
2. Build the MCP server
3. Automatically configure your chosen client(s)
4. Make the server globally available

### Manual Setup
If you prefer manual configuration:

```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm link  # Makes coyote-mcp-server command available globally
```

**Claude Desktop config** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "coyote.*use": {
      "command": "coyote-mcp-server"
    }
  }
}
```

**VS Code MCP config** (`~/Library/Application Support/Code/User/mcp.json`):
```json
{
  "servers": {
    "coyote.*use": {
      "type": "stdio",
      "command": "coyote-mcp-server"
    }
  },
  "inputs": []
}
```

**Windsurf MCP config** (`~/.codeium/windsurf/mcp_config.json`):
```json
{
  "mcpServers": {
    "coyote.*use": {
      "command": "coyote-mcp-server",
      "args": []
    }
  }
}
```

**Cursor MCP config** (`~/.cursor/mcp.json`):
```json
{
  "mcpServers": {
    "coyote-user": {
      "command": "coyote-mcp-server",
      "args": []
    }
  }
}
```

**Claude CLI MCP config** (`~/.config/claude-cli/mcp.json`):
```json
{
  "mcpServers": {
    "coyote-user": {
      "command": "coyote-mcp-server",
      "args": []
    }
  }
}
}
```

## Usage
After setup, restart your chosen client and you can use AppleScript automation:

**In Claude Desktop:**
- "Use AppleScript to show a dialog with 'Hello World'"
- "Run AppleScript to open Calculator"
- "Execute AppleScript to display the current time"
- "Use AppleScript to open Safari and go to google.com"

**In VS Code (GitHub Copilot Chat):**
- "Can you run AppleScript to show me the current time?"
- "Use AppleScript to open Calculator app"
- "Execute AppleScript to create a desktop notification"

**In Windsurf (Cascade):**
- "Use AppleScript to display a notification saying 'Hello from Windsurf!'"
- "Run AppleScript to open Finder"
- "Execute AppleScript to tell me the current date and time"

**In Cursor (Agent/Chat):**
- "Use the run_applescript tool to display a notification"
- "Show me a dialog with 'Hello from Cursor!'"
- "Open Calculator using AppleScript"

**In Claude CLI:**
- `claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to show a dialog"`
- `claude --mcp-config ~/.config/claude-cli/mcp.json --print --dangerously-skip-permissions "Show notification"`
- `claude --mcp-config ~/.config/claude-cli/mcp.json` (interactive mode)

## Development

### Building
```bash
npm run build
```

### Testing
```bash
npm start  # Start the server manually
# Then test from Claude Desktop or MCP Inspector
```

## Configuration Details

### Claude Desktop
- Config path: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Server name: `coyote.*use`
- Transport: stdio

### VS Code
- Config path: `~/Library/Application Support/Code/User/mcp.json`
- Server name: `coyote.*use`
- Transport: stdio

### Windsurf
- Config path: `~/.codeium/windsurf/mcp_config.json`
- Server name: `coyote.*use`
- Transport: stdio
- Plugin management: Available through Windsurf Cascade plugin store

### Cursor
- Config path: `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project-specific)
- Server name: `coyote-user`
- Transport: stdio
- Tool management: Available through Cursor chat interface with toggle controls

### Claude CLI
- Config path: `~/.config/claude-cli/mcp.json`
- Server name: `coyote-user`
- Transport: stdio
- Usage: Command-line interface with `--mcp-config` or `--mcp` flags
- Tool management: Available through Cursor chat interface with toggle controls

## References
- [TypeScript MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Protocol Overview](https://modelcontextprotocol.io/docs/learn/architecture)
- [Build an MCP Server](https://modelcontextprotocol.io/docs/develop/build-server)
- [Windsurf MCP Documentation](https://docs.windsurf.com/windsurf/cascade/mcp)
- [Cursor MCP Documentation](https://docs.cursor.com/en/context/mcp)
