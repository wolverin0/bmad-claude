{
  "name": "bmad-method-mcp-server",
  "version": "0.1.0",
  "description": "MCP server for automatically applying BMAD Method personas to prompts",
  "main": "build/index.js",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node build/index.js",
    "dev": "tsx src/index.ts",
    "prepare": "npm run build"
  },
  "bin": {
    "bmad-mcp-server": "build/index.js"
  },
  "keywords": [
    "mcp",
    "bmad",
    "ai",
    "prompting",
    "claude"
  ],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0",
    "node-fetch": "^3.3.2"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "tsx": "^4.7.0",
    "typescript": "^5.3.0"
  },
  "engines": {
    "node": ">=18"
  }
}