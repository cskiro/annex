---
name: mcp-server-creator
version: 0.1.0
description: Automated MCP server creation tool that generates production-ready Model Context Protocol servers with TypeScript/Python SDKs, configuration templates, and Claude Desktop integration
author: Connor
---

# MCP Server Creator

## Overview

This skill automates the creation of Model Context Protocol (MCP) servers by guiding users through an interactive process, generating project structure, SDK integration, and Claude Desktop configuration. It handles language selection, capability setup (tools/resources/prompts), transport configuration, and provides testing guidance to produce production-ready MCP servers.

## What is MCP?

The Model Context Protocol (MCP) is an open-source standard for connecting AI applications to external systems. Think of MCP like a USB-C port for AI applications—it provides a standardized way to connect AI models to data sources, tools, and workflows.

**MCP enables:**
- AI assistants accessing your data (Google Calendar, Notion, databases)
- Code generation using design files (Figma to web app)
- Enterprise chatbots querying organizational databases
- AI-driven automation (3D modeling, printing, deployment)

## When to Use This Skill

**Trigger Phrases:**
- "create an MCP server for [purpose]"
- "build a Model Context Protocol server"
- "set up MCP integration with [data source]"
- "generate MCP server to expose [tools/data]"
- "help me create a server for Claude Desktop"
- "scaffold an MCP server"

**Use Cases:**
- Exposing custom data sources to AI applications
- Creating tools for AI models to call
- Building enterprise integrations for Claude
- Developing workflow automation servers
- Rapid prototyping of MCP capabilities
- Learning MCP development patterns

## Response Style

- **Interactive**: Ask clarifying questions about server purpose and capabilities
- **Educational**: Explain MCP concepts and best practices
- **Language-aware**: Support TypeScript, Python, and other SDKs
- **Production-ready**: Generate complete, tested configurations
- **Integration-focused**: Ensure Claude Desktop compatibility

## Core Responsibilities

### 1. Requirements Gathering
- ✓ Understand server purpose and target AI application
- ✓ Identify data sources, tools, or workflows to expose
- ✓ Determine appropriate MCP capabilities (resources/tools/prompts)
- ✓ Select programming language and SDK
- ✓ Assess transport requirements (STDIO vs HTTP)

### 2. Project Setup
- ✓ Initialize project structure for chosen language
- ✓ Install MCP SDK and dependencies
- ✓ Configure build tooling (TypeScript/tsconfig, Python/uv)
- ✓ Set up environment variables and secrets management
- ✓ Create proper .gitignore for security

### 3. Server Implementation
- ✓ Generate server initialization code
- ✓ Implement tools with proper schemas (Zod/type hints)
- ✓ Implement resources with URI patterns
- ✓ Implement prompts for specialized workflows
- ✓ Configure transport (STDIO or HTTP)
- ✓ Add proper error handling and logging

### 4. Claude Desktop Integration
- ✓ Generate claude_desktop_config.json entry
- ✓ Provide absolute paths and proper arguments
- ✓ Configure environment variables securely
- ✓ Add restart instructions

### 5. Testing & Validation
- ✓ Provide testing workflow with MCP Inspector
- ✓ Generate example queries for Claude
- ✓ Validate tool schemas and responses
- ✓ Check logging configuration (no stdout for STDIO)
- ✓ Verify Claude Desktop integration

## Workflow

### Phase 1: Discovery & Language Selection

**Purpose**: Understand what the user wants to build and choose the right SDK

**Questions to Ask:**
1. **Server Purpose**
   - "What data source, tools, or workflows do you want to expose to AI?"
   - Examples: "Access PostgreSQL database", "Search Jira tickets", "Format code"

2. **Target AI Application**
   - Claude Desktop (most common)
   - Custom AI application
   - Multiple clients

3. **Programming Language Preference**
   - **TypeScript/Node.js** (recommended for web APIs, JavaScript ecosystem)
   - **Python** (recommended for data processing, ML workflows)
   - **Java/Spring AI** (enterprise Java applications)
   - **Kotlin** (Android/JVM applications)
   - **C#/.NET** (Windows/Azure applications)

4. **Capability Types Needed**
   - **Tools**: Functions AI can call (e.g., "get_weather", "search_database")
   - **Resources**: Data AI can read (e.g., file contents, API responses)
   - **Prompts**: Specialized templates for common tasks

**Output**: Clear understanding of server purpose, language choice, and capabilities needed

---

### Phase 2: Project Structure Generation

**Purpose**: Create proper project structure with SDK integration

**TypeScript Project Setup:**
```bash
# Create project directory
mkdir mcp-[server-name]
cd mcp-[server-name]

# Initialize npm project
npm init -y

# Install dependencies
npm install @modelcontextprotocol/sdk zod
npm install -D @types/node typescript

# Additional deps based on purpose (e.g., database clients, API libraries)
```

**TypeScript Configuration** (tsconfig.json):
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./build",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

**Package.json Scripts:**
```json
{
  "type": "module",
  "scripts": {
    "build": "tsc && node -e \"require('fs').chmodSync('build/index.js', '755')\"",
    "watch": "tsc --watch",
    "start": "node build/index.js"
  }
}
```

**Python Project Setup:**
```bash
# Create project with uv
uv init mcp-[server-name]
cd mcp-[server-name]

# Set up virtual environment
uv venv
source .venv/bin/activate

# Install MCP SDK
uv add "mcp[cli]"

# Additional deps (e.g., httpx, databases, etc.)
```

**File Structure:**
```
mcp-server-name/
├── src/
│   └── index.ts (or main.py)
├── build/ (TypeScript only)
├── .env.example
├── .gitignore
├── package.json / pyproject.toml
├── tsconfig.json (TypeScript only)
└── README.md
```

**Output**: Complete project structure with dependencies installed

---

### Phase 3: Server Implementation

**Purpose**: Generate core server code with requested capabilities

**TypeScript Server Template:**
```typescript
#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Initialize server
const server = new Server(
  {
    name: "server-name",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
      prompts: {},
    },
  }
);

// Example Tool
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "tool_name",
      description: "What this tool does",
      inputSchema: {
        type: "object",
        properties: {
          param: { type: "string", description: "Parameter description" }
        },
        required: ["param"]
      }
    }
  ]
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "tool_name") {
    const { param } = request.params.arguments;

    // Tool logic here
    const result = await performOperation(param);

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2)
        }
      ]
    };
  }

  throw new Error(`Unknown tool: ${request.params.name}`);
});

// Start server with STDIO transport
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);

  // CRITICAL: Never console.log() in STDIO mode!
  console.error("Server running on stdio");
}

main().catch(console.error);
```

**Python Server Template (FastMCP):**
```python
#!/usr/bin/env python3

from mcp.server.fastmcp import FastMCP
import os

# Initialize server
mcp = FastMCP("server-name")

@mcp.tool()
async def tool_name(param: str) -> str:
    """
    Description of what this tool does.

    Args:
        param: Parameter description

    Returns:
        Result description
    """
    # Tool logic here
    result = await perform_operation(param)
    return str(result)

@mcp.resource("resource://template/{id}")
async def get_resource(id: str) -> str:
    """Get resource by ID."""
    # Resource logic here
    return f"Resource content for {id}"

if __name__ == "__main__":
    mcp.run()
```

**Key Implementation Patterns:**

1. **Tool Definition**
   - Clear, descriptive names
   - Comprehensive descriptions (AI uses this!)
   - Strong typing with Zod/type hints
   - Proper error handling

2. **Resource Patterns**
   - URI templates for dynamic resources
   - Efficient data fetching (avoid heavy computation)
   - Proper MIME types

3. **Logging Rules**
   - **STDIO servers**: NEVER use console.log/print (corrupts JSON-RPC)
   - Use console.error / logging.error (stderr is safe)
   - **HTTP servers**: stdout is safe

**Output**: Fully implemented server with requested capabilities

---

### Phase 4: Environment & Security

**Purpose**: Secure secrets and configure environment

**Generate .env.example:**
```bash
# API Keys and Secrets
API_KEY=your_api_key_here
DATABASE_URL=postgresql://user:pass@localhost:5432/db

# Server Configuration
PORT=3000
LOG_LEVEL=info
```

**Generate .gitignore:**
```
# Dependencies
node_modules/
.venv/
__pycache__/

# Build outputs
build/
dist/
*.pyc

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp

# Logs
*.log

# OS
.DS_Store
Thumbs.db
```

**Security Best Practices:**
- ✓ Never commit .env files
- ✓ Use environment variables for all secrets
- ✓ Validate all inputs with schemas
- ✓ Implement proper error handling (don't leak internals)
- ✓ Use HTTPS for HTTP transport servers

**Output**: Secure configuration with secrets management

---

### Phase 5: Claude Desktop Integration

**Purpose**: Configure server in Claude Desktop for immediate use

**Configuration Location:**
- **macOS/Linux**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

**Generate Configuration Entry:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["/absolute/path/to/mcp-server-name/build/index.js"],
      "env": {
        "API_KEY": "your_api_key_here"
      }
    }
  }
}
```

**Python Configuration:**
```json
{
  "mcpServers": {
    "server-name": {
      "command": "uv",
      "args": [
        "--directory",
        "/absolute/path/to/mcp-server-name",
        "run",
        "main.py"
      ],
      "env": {
        "API_KEY": "your_api_key_here"
      }
    }
  }
}
```

**Critical Requirements:**
- ✅ **Use ABSOLUTE paths** (not relative like `./` or `~/`)
- ✅ Run `npm run build` before testing (TypeScript)
- ✅ Completely restart Claude Desktop (Cmd+Q on macOS)
- ✅ Valid JSON syntax (check with `python -m json.tool`)

**Output**: Complete Claude Desktop configuration with restart instructions

---

### Phase 6: Testing & Validation

**Purpose**: Verify server works correctly before deployment

**Testing Workflow:**

1. **Build Check (TypeScript)**
   ```bash
   npm run build
   # Should complete without errors
   # Verify build/index.js exists
   ```

2. **MCP Inspector Testing**
   ```bash
   # Install MCP Inspector
   npx @modelcontextprotocol/inspector node build/index.js

   # Or for Python
   npx @modelcontextprotocol/inspector uv run main.py
   ```
   - Opens browser interface to test tools/resources
   - Validates schemas and responses
   - Great for debugging before Claude integration

3. **Claude Desktop Integration Test**
   - Add to claude_desktop_config.json
   - Completely restart Claude Desktop
   - Check logs: `~/Library/Logs/Claude/mcp*.log`
   - Look for server in "🔌" (attachments) menu

4. **Functional Testing in Claude**
   Test with natural language queries:
   - "Use [server-name] to [perform action]"
   - "Can you [tool description]?"
   - Verify tool appears in suggestions
   - Check response accuracy

**Debugging Common Issues:**

| Issue | Cause | Solution |
|-------|-------|----------|
| Server not detected | Invalid path | Use absolute path, verify file exists |
| Tools don't appear | Build not run | Run `npm run build` |
| "Server error" | stdout logging | Remove console.log, use console.error |
| Connection timeout | Server crash | Check mcp-server-NAME.log for errors |
| Invalid config | JSON syntax | Validate JSON, check quotes/commas |

**Output**: Validated, working MCP server with test results

---

### Phase 7: Documentation & Handoff

**Purpose**: Provide user with complete documentation and next steps

**Generate README.md:**
```markdown
# MCP Server: [Name]

## Description
[What this server does and why it's useful]

## Capabilities

### Tools
- **tool_name**: Description of what it does
  - Parameters: param1 (type) - description
  - Returns: description

### Resources
- **resource://pattern/{id}**: Description

### Prompts
- **prompt_name**: Description

## Setup

### Prerequisites
- Node.js 18+ / Python 3.10+
- Claude Desktop or MCP-compatible client

### Installation

1. Clone/download this server
2. Install dependencies:
   ```bash
   npm install && npm run build
   # OR
   uv sync
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

4. Add to Claude Desktop config:
   ```json
   {
     "mcpServers": {
       "server-name": {
         "command": "node",
         "args": ["/absolute/path/to/build/index.js"],
         "env": {
           "API_KEY": "your_key"
         }
       }
     }
   }
   ```

5. Restart Claude Desktop completely

## Usage Examples

### Example 1: [Use Case]
Query: "[Natural language query]"
Expected: [What happens]

### Example 2: [Use Case]
Query: "[Natural language query]"
Expected: [What happens]

## Development

### Running Locally
```bash
npm run watch  # Auto-rebuild on changes
```

### Testing with MCP Inspector
```bash
npx @modelcontextprotocol/inspector node build/index.js
```

### Debugging
Logs location: `~/Library/Logs/Claude/mcp-server-[name].log`

## Security Notes
- Never commit .env file
- Rotate API keys regularly
- Validate all inputs
- Review logs for sensitive data

## License
[License]

## Support
[Contact/Issues]
```

**Provide Next Steps:**
```markdown
## Next Steps

1. ✅ Server code generated at: [path]
2. ⬜ Review and customize tool implementations
3. ⬜ Add your API keys to .env
4. ⬜ Run build: `npm run build` or test with `uv run`
5. ⬜ Test with MCP Inspector
6. ⬜ Add to Claude Desktop config
7. ⬜ Restart Claude Desktop
8. ⬜ Test with natural language queries
9. ⬜ Iterate and enhance based on usage

## Example Queries to Test:
- "[Example query 1]"
- "[Example query 2]"
- "[Example query 3]"
```

**Output**: Complete documentation and clear path to production use

---

## MCP Capability Deep-Dives

### Tools: AI-Callable Functions

**When to use**: AI needs to perform actions or fetch computed data

**Structure:**
- **Name**: Descriptive verb (e.g., "search_docs", "create_ticket")
- **Description**: Clear explanation (AI uses this to decide when to call)
- **Schema**: Input parameters with types and descriptions
- **Handler**: Async function returning structured content

**Example Tool Types:**
- Data fetching: "get_user_data", "search_products"
- Computation: "calculate_metrics", "analyze_sentiment"
- Actions: "send_email", "create_issue", "update_status"
- External APIs: "search_web", "translate_text"

### Resources: Data Exposure

**When to use**: AI needs to read data without side effects

**Structure:**
- **URI**: Pattern like "scheme://path/{param}"
- **MIME type**: Helps AI understand content format
- **Handler**: Returns content (text, JSON, binary)

**Example Resource Types:**
- File contents: "file:///path/to/file.txt"
- Database records: "db://users/{user_id}"
- API responses: "api://endpoint/{id}"
- Search results: "search://query/{term}"

### Prompts: Specialized Workflows

**When to use**: Provide templates for common tasks

**Structure:**
- **Name**: Descriptive identifier
- **Description**: When to use this prompt
- **Arguments**: Parameters to customize
- **Template**: Pre-filled prompt text

**Example Prompt Types:**
- Code review: Pre-filled checklist
- Bug triage: Structured investigation steps
- Documentation: Template with sections

---

## Language-Specific Guidance

### TypeScript Best Practices
- ✓ Use strict mode in tsconfig.json
- ✓ Leverage Zod for runtime validation
- ✓ Export types for reusability
- ✓ Use async/await consistently
- ✓ Handle errors with try/catch
- ✓ Build before testing!

### Python Best Practices (FastMCP)
- ✓ Use type hints (FastMCP reads them!)
- ✓ Write detailed docstrings (becomes tool descriptions)
- ✓ Use async functions for I/O
- ✓ Handle exceptions gracefully
- ✓ Log to stderr only in STDIO mode

### HTTP vs STDIO Transport

**STDIO (Default):**
- ✅ Simple local communication
- ✅ Used by Claude Desktop
- ❌ No stdout logging allowed
- ❌ Local processes only

**HTTP:**
- ✅ Remote server deployment
- ✅ stdout logging safe
- ✅ Multiple clients
- ❌ More complex setup (auth, HTTPS)

---

## Common Patterns & Templates

### Database Integration Server
**Tools**: query_database, get_schema, list_tables
**Resources**: db://tables/{table}/schema
**Example**: PostgreSQL, MySQL, MongoDB access

### API Wrapper Server
**Tools**: call_endpoint, search_api, get_resource
**Resources**: api://endpoints/{endpoint}
**Example**: Wrap REST APIs for AI consumption

### File System Server
**Resources**: file:///{path}
**Tools**: search_files, read_file, list_directory
**Example**: Secure file access with permissions

### Workflow Automation Server
**Tools**: trigger_workflow, check_status, get_results
**Prompts**: workflow_templates
**Example**: CI/CD, deployment, data pipelines

---

## Error Handling

### Validation Errors
```typescript
if (!isValid(input)) {
  throw new Error("Invalid input: expected format X, got Y");
}
```

### API Errors
```typescript
try {
  const result = await externalAPI.call();
  return result;
} catch (error) {
  console.error("API error:", error);
  return {
    content: [{
      type: "text",
      text: `Error: ${error.message}. Please try again.`
    }]
  };
}
```

### Resource Not Found
```typescript
if (!resource) {
  throw new Error(`Resource not found: ${uri}`);
}
```

---

## Success Criteria

- [ ] Project structure created with proper dependencies
- [ ] Server implements requested capabilities (tools/resources/prompts)
- [ ] All tools have proper schemas and descriptions
- [ ] Logging configured correctly (no stdout for STDIO)
- [ ] Environment variables configured securely
- [ ] .gitignore prevents committing secrets
- [ ] Claude Desktop config generated with absolute paths
- [ ] README provides clear setup and usage instructions
- [ ] Build completes without errors (TypeScript)
- [ ] MCP Inspector testing passes
- [ ] Server appears in Claude Desktop after restart
- [ ] Tools work correctly when invoked from Claude
- [ ] Error handling prevents crashes
- [ ] User has clear next steps for customization

---

## Important Reminders

1. **STDIO = No stdout logging** - Use console.error or file logging
2. **Build before test** - TypeScript requires `npm run build`
3. **Absolute paths only** - Claude Desktop config needs full paths
4. **Complete restart required** - Quit Claude Desktop entirely (Cmd+Q)
5. **Schemas matter** - AI uses descriptions to decide when to call tools
6. **Security first** - Never commit secrets, validate all inputs
7. **Test incrementally** - MCP Inspector before Claude integration
8. **Clear descriptions** - AI relies on your tool/resource descriptions

---

## Quick Reference

### Check Claude Desktop Logs
```bash
tail -f ~/Library/Logs/Claude/mcp.log
tail -f ~/Library/Logs/Claude/mcp-server-[name].log
```

### Validate Config JSON
```bash
python -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Test with MCP Inspector
```bash
npx @modelcontextprotocol/inspector [command] [args]
```

### Restart Claude Desktop
```bash
# macOS
osascript -e 'quit app "Claude"'
open -a Claude
```

---

**Remember**: MCP servers are like USB-C adapters for AI—they provide a standardized interface for AI models to access your data, tools, and workflows. Build once, use everywhere!
