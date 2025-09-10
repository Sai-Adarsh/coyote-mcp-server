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

**Test the setup:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to show a dialog with 'Hello World'"
```

**Open applications:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Calculator"
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Safari"
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open TextEdit"
```

**Navigate websites:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Safari and go to google.com"
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Safari and go to yahoo.com"
```

**Create notifications:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to show a notification with title 'Test' and message 'Hello from MCP'"
```

**Automate Calculator:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Calculator and perform calculation 25 + 75"
```

**Create text documents:**
```bash
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open TextEdit and create a document with text 'Hello from Coyote MCP'"
```

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
