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
    "coyote-user": {
      "command": "coyote-mcp-server"
    }
  }
}
```

**VS Code MCP config** (`~/Library/Application Support/Code/User/mcp.json`):
```json
{
  "servers": {
    "coyote-user": {
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
    "coyote-user": {
      "command": "coyote-mcp-server",
      "args": []
    }
  }
}
```

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
- Server name: `coyote-user`
- Transport: stdio

### VS Code
- Config path: `~/Library/Application Support/Code/User/mcp.json`
- Server name: `coyote-user`
- Transport: stdio

### Windsurf
- Config path: `~/.codeium/windsurf/mcp_config.json`
- Server name: `coyote-user`
- Transport: stdio
- Plugin management: Available through Windsurf Cascade plugin store

## References
- [TypeScript MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Protocol Overview](https://modelcontextprotocol.io/docs/learn/architecture)
- [Build an MCP Server](https://modelcontextprotocol.io/docs/develop/build-server)
- [Windsurf MCP Documentation](https://docs.windsurf.com/windsurf/cascade/mcp)
