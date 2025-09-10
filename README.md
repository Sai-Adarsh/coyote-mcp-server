# Coyote MCP Server

A Model Context Protocol (MCP) server that enables AppleScript execution on macOS through the `run_applescript` tool.

## Quick Start

```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
npm run setup-claude-cli  # or setup-claude, setup-vscode, setup-windsurf, setup-cursor
```

## Usage Commands

**Interactive Mode (Recommended):**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json
```
Then type any command like:
- `Use AppleScript to show a dialog with 'Hello World'`
- `Use AppleScript to open Calculator`
- `Use AppleScript to open Safari and go to google.com`

**Quick Commands:**
```bash
# Test the setup
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to show a dialog with 'Hello World'"

# Open applications
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to open Calculator"
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to open Safari"

# Navigate websites
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to open Safari and go to google.com"

# Create notifications
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to show a notification with title 'Test' and message 'Hello from MCP'"
```

**Note:** Claude CLI will ask for permission before executing AppleScript commands. Grant permission when prompted to allow automation.

## Quick Setup Commands

| Client | Setup Command |
|--------|---------------|
| Claude CLI | `npm run setup-claude-cli` |
| Claude Desktop | `npm run setup-claude` |
| VS Code | `npm run setup-vscode` |
| Windsurf | `npm run setup-windsurf` |
| Cursor | `npm run setup-cursor` |
| All clients | `npm run setup-all` |

## Troubleshooting

**Command not found error after update:**
```bash
hash -r
```

## Development

```bash
npm run build    # Build the server
npm start        # Start manually for testing
```

## References

- [TypeScript MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Protocol Overview](https://modelcontextprotocol.io/docs/learn/architecture)
- [Build an MCP Server](https://modelcontextprotocol.io/docs/develop/build-server)
