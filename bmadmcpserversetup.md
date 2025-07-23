BMAD Method MCP Server
Automatically selects and applies the best BMAD persona based on your Claude Code prompts.
Features

🎯 Smart Persona Detection: Analyzes your prompt to select the best BMAD persona
🔧 Auto-Enhancement: Automatically prepends the appropriate persona and command
📊 Confidence Scoring: Shows how confident the system is in its persona selection
🔍 Keyword Analysis: Explains why a particular persona was chosen
📚 Full Persona Library: Access to all BMAD method personas

Setup Instructions
1. Install Dependencies
bashnpm install
npm run build
2. Configure Claude Code MCP
Add to your Claude Code MCP configuration file (~/.config/claude-code/mcp_servers.json):
json{
  "mcpServers": {
    "bmad-method": {
      "command": "node",
      "args": ["/path/to/bmad-method-mcp-server/build/index.js"],
      "env": {}
    }
  }
}
3. Available Tools
Once configured, you'll have access to these tools in Claude Code:

enhance_prompt: Automatically enhance your prompt with the best persona
suggest_persona: Get persona recommendations without modifying your prompt
list_personas: View all available personas and commands

Usage Examples
Automatic Enhancement
bash# Before
claude-code "Create a REST API for user management"

# With MCP enhancement
claude-code --tool enhance_prompt "Create a REST API for user management"
The server will automatically detect this is a development task and apply the Senior Developer persona with /dev command.
Getting Suggestions
bashclaude-code --tool suggest_persona "Review this code for security issues"
# Suggests: Code Reviewer persona (/review)
How It Works

Intent Analysis: Analyzes your prompt for keywords and patterns
Persona Matching: Matches detected intent to the best BMAD persona
Confidence Scoring: Ensures high-confidence matches only
Prompt Enhancement: Prepends the persona context and command
Execution: Sends enhanced prompt to Claude

Supported Personas

Senior Developer (/dev) - Coding, programming, development
Code Reviewer (/review) - Code audits, quality assessment
Software Architect (/architect) - System design, architecture
Data Analyst (/analyze) - Data analysis, statistics
Business Analyst (/business) - Requirements, processes
Creative Writer (/write) - Content creation, storytelling
Technical Writer (/doc) - Documentation, guides
Problem Solver (/solve) - General troubleshooting

Configuration
Extending Personas
To add more personas, update the BMAD_PERSONAS object in src/index.ts:
typescript'new-persona': {
  name: 'New Persona Name',
  keywords: ['keyword1', 'keyword2', 'keyword3'],
  command: '/newcmd',
  description: 'Description of what this persona does'
}
Adjusting Confidence Threshold
Modify the confidence threshold in the selectBestPersona method:
typescriptif (analysis.confidence < 0.3) { // Adjust this value (0.1 to 1.0)
  return null;
}
Integration with BMAD Repository
To fully integrate with the official BMAD repository:

Clone the BMAD repo: git clone https://github.com/bmadcode/BMAD-METHOD
Update fetchPersonaPrompt() to read actual persona files
Implement dynamic persona loading from the repo structure

typescriptprivate async fetchPersonaPrompt(persona: any): Promise<string> {
  const fs = await import('fs/promises');
  const path = `./BMAD-METHOD/personas/${persona.command.slice(1)}.md`;
  return await fs.readFile(path, 'utf-8');
}
Advanced Usage
Pre-hooks in Claude Code
You can create shell functions to automatically enhance prompts:
bash# Add to your .bashrc or .zshrc
bmad_code() {
  local prompt="$*"
  local enhanced=$(claude-code --tool enhance_prompt "$prompt" | grep -A 100 "Enhanced Prompt" | tail -n +3)
  echo "Using enhanced prompt: $enhanced"
  claude-code "$enhanced"
}

# Usage
bmad_code "Debug this Python function"
Custom Workflows
Create custom commands for specific workflows:
bash# Code review workflow
alias code_review="claude-code --tool enhance_prompt --persona code-reviewer"

# Architecture planning
alias arch_plan="claude-code --tool enhance_prompt --persona architect"

# Data analysis
alias analyze_data="claude-code --tool enhance_prompt --persona data-analyst"
Troubleshooting
Common Issues

MCP Server Not Found: Ensure the path in your config is correct
Node Version: Requires Node.js 18+
Permissions: Make sure the server file is executable

Debug Mode
Run with debug logging:
bashDEBUG=* node build/index.js
Contributing
To contribute new personas or improvements:

Fork the repository
Add your persona to the BMAD_PERSONAS object
Test with various prompts
Submit a pull request

License
MIT License - feel free to modify and distribute.