# Coyote Use MCP Server Setup Progress

- [x] Clarify Project Requirements
- [x] Scaffold the Project
- [x] Customize the Project
- [ ] Install Required Extensions
- [x] Compile the Project
- [x] Create and Run Task
- [ ] Launch the Project
- [ ] Ensure Documentation is Complete

## Project Summary
- **Name**: Coyote Use MCP Server
- **Purpose**: Execute AppleScript commands via osascript on macOS
- **Tool**: `run_applescript` - executes AppleScript code and returns output
- **Status**: ✅ Built successfully, basic MCP JSON-RPC server working

## Usage
Add to Claude Desktop configuration:
```json
{
  "mcpServers": {
    "coyote.*use": {
      "command": "coyote-mcp-server"
    }
  }
}
```

Or use the absolute path if not globally installed:
```json
{
  "mcpServers": {
    "coyote.*use": {
      "command": "node",
      "args": ["<PROJECT_PATH>/build/index.js"]
    }
  }
}
```

## References
- [TypeScript MCP SDK Documentation](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Protocol Overview](https://modelcontextprotocol.io/docs/learn/architecture)
- [Build an MCP Server](https://modelcontextprotocol.io/docs/develop/build-server)

---

**Status**: MCP server built and working. Ready for testing with Claude Desktop.
