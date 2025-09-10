# Coyote MCP Server

A Model Context Protocol (MCP) server that enables AppleScript execution on macOS through the `run_applescript` tool.

## Installation

### Quick Setup

```bash
git clone https://github.com/Sai-Adarsh/coyote-mcp-server.git
cd coyote-mcp-server
npm install
npm run build
```

**Automatic Configuration:**
- `npm run setup-claude` - Configure for Claude Desktop
- `npm run setup-vscode` - Configure for VS Code
- `npm run setup-windsurf` - Configure for Windsurf
- `npm run setup-cursor` - Configure for Cursor
- `npm run setup-claude-cli` - Configure for Claude CLI
- `npm run setup-all` - Configure for all supported clients

### Manual Configuration

After building, make the server globally available:
```bash
npm link
```

#### Supported Clients

| Client | Config Path | Server Name | Config Format |
|--------|-------------|-------------|---------------|
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` | `coyote.*use` | `{"mcpServers": {"coyote.*use": {"command": "coyote-mcp-server"}}}` |
| **VS Code** | `~/Library/Application Support/Code/User/mcp.json` | `coyote.*use` | `{"servers": {"coyote.*use": {"type": "stdio", "command": "coyote-mcp-server"}}, "inputs": []}` |
| **Windsurf** | `~/.codeium/windsurf/mcp_config.json` | `coyote.*use` | `{"mcpServers": {"coyote.*use": {"command": "coyote-mcp-server", "args": []}}}` |
| **Cursor** | `~/.cursor/mcp.json` | `coyote-user` | `{"mcpServers": {"coyote-user": {"command": "coyote-mcp-server", "args": []}}}` |
| **Claude CLI** | `~/.config/claude-cli/mcp.json` | `coyote-user` | `{"mcpServers": {"coyote-user": {"command": "coyote-mcp-server", "args": []}}}` |

## Usage

After setup, restart your client and use natural language to execute AppleScript:

**Example Commands:**
- "Use AppleScript to show a dialog with 'Hello World'"
- "Run AppleScript to open Calculator"
- "Execute AppleScript to display the current time"
- "Use AppleScript to open Safari and go to google.com"
- "Create a desktop notification saying 'Task completed'"

**Claude CLI Usage:**
```bash
# Basic usage (requires permission prompts)
claude --mcp-config ~/.config/claude-cli/mcp.json --print "Use AppleScript to show a dialog"

# Skip permissions for testing/automation
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Calculator"

# Allow specific tools
claude --mcp-config ~/.config/claude-cli/mcp.json --allowed-tools "run_applescript" --print "Use AppleScript to open Safari"

# Interactive mode
claude --mcp-config ~/.config/claude-cli/mcp.json
```

**Permission Options:**
- `--dangerously-skip-permissions` - Bypass all permission checks (recommended for testing)
- `--allowed-tools "run_applescript"` - Pre-approve the AppleScript tool
- `--permission-mode "bypassPermissions"` - Alternative permission bypass method

## Development

```bash
npm run build    # Build the server
npm start        # Start manually for testing
```

## Troubleshooting

**Claude CLI showing old version after update:**
If Claude CLI shows an outdated version error after running `claude update`, clear the shell's command cache:
```bash
hash -r
```

**Permission prompts not appearing:**
If Claude CLI asks for permission but no prompt appears, use one of these flags:
```bash
# For testing/automation (bypasses all permissions)
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "YOUR_COMMAND"

# Pre-approve specific tools
claude --mcp-config ~/.config/claude-cli/mcp.json --allowed-tools "run_applescript" --print "YOUR_COMMAND"
```

**Testing the MCP server:**
```bash
# Test with a simple dialog
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to show a dialog with 'Hello World'"

# Test app automation
claude --mcp-config ~/.config/claude-cli/mcp.json --dangerously-skip-permissions --print "Use AppleScript to open Calculator"
```

## References

- [TypeScript MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Protocol Overview](https://modelcontextprotocol.io/docs/learn/architecture)
- [Build an MCP Server](https://modelcontextprotocol.io/docs/develop/build-server)
