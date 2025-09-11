#!/usr/bin/env node

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { spawn } from "child_process";
import { z } from "zod";

// Redirect stderr to prevent log pollution in stdio transport
const originalStderr = process.stderr.write;
process.stderr.write = function(chunk: any, encoding?: any, callback?: any) {
  // Only allow actual errors, not info/debug logs
  if (typeof chunk === 'string' && (chunk.includes('[info]') || chunk.includes('[debug]') || chunk.includes('MCP server starting'))) {
    return true;
  }
  return originalStderr.call(process.stderr, chunk, encoding, callback);
};

// Create an MCP server
const server = new McpServer({
  name: "coyote-use",
  version: "1.0.0"
});

// Add the AppleScript tool
server.registerTool(
  "run_applescript",
  {
    title: "Run AppleScript",
    description: "Executes an AppleScript command using osascript on macOS.",
    inputSchema: {
      script: z.string().describe("AppleScript code to execute.")
    }
  },
  async ({ script }) => {
    return new Promise((resolve) => {
      const proc = spawn("osascript", ["-e", script]);
      let output = "";
      let error = "";
      
      proc.stdout.on("data", (data) => {
        output += data.toString();
      });
      
      proc.stderr.on("data", (data) => {
        error += data.toString();
      });
      
      proc.on("close", (code) => {
        const result = code === 0 
          ? (output.trim() || "Command executed successfully")
          : `Error: ${error.trim() || "Unknown error"}`;
          
        resolve({
          content: [{ 
            type: "text", 
            text: result 
          }]
        });
      });
    });
  }
);

// Start the server
async function main() {
  try {
    const transport = new StdioServerTransport();
    await server.connect(transport);
  } catch (error) {
    // Only log actual errors to stderr
    console.error("Server error:", error);
    process.exit(1);
  }
}

main();
