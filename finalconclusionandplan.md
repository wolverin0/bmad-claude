# Complete BMAD Method + Gemini CLI + Claude Code Setup Guide

This guide will set up an automated system that:
1. Uses Gemini CLI with MCP to analyze your prompts
2. Automatically selects and applies the best BMAD personas
3. Enhances your prompts with proper context
4. Executes the enhanced prompts with Claude Code

## Table of Contents
- [Prerequisites](#prerequisites)
- [Step 1: Install Dependencies](#step-1-install-dependencies)
- [Step 2: Create BMAD MCP Server](#step-2-create-bmad-mcp-server)
- [Step 3: Configure Gemini CLI](#step-3-configure-gemini-cli)
- [Step 4: Create Wrapper Scripts](#step-4-create-wrapper-scripts)
- [Step 5: Test the System](#step-5-test-the-system)
- [Step 6: Advanced Usage](#step-6-advanced-usage)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting, ensure you have:
- Node.js 18+ installed
- Gemini CLI installed and configured
- Claude Code installed and configured
- A Google API key for Gemini
- Git (for cloning BMAD repository)

## Step 1: Install Dependencies

### 1.1 Install Required Tools

```bash
# Install Gemini CLI (if not already installed)
npm install -g @google/gemini-cli

# Verify installations
gemini --version
claude-code --version
node --version
```

### 1.2 Clone BMAD Repository for Reference

```bash
# Clone the BMAD method repository
git clone https://github.com/bmadcode/BMAD-METHOD.git
cd BMAD-METHOD
# Take note of the personas and commands available
ls -la
cd ..
```

## Step 2: Create BMAD MCP Server

### 2.1 Create Project Directory

```bash
mkdir bmad-mcp-server
cd bmad-mcp-server
```

### 2.2 Initialize Node.js Project

```bash
npm init -y
```

### 2.3 Install Dependencies

```bash
npm install @modelcontextprotocol/sdk node-fetch
npm install -D typescript @types/node tsx
```

### 2.4 Create TypeScript Configuration

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "allowJs": true,
    "outDir": "./build",
    "rootDir": "./src",
    "strict": true,
    "declaration": true,
    "declarationMap": true,
    "inlineSourceMap": true,
    "types": ["node"]
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "build"]
}
```

### 2.5 Update package.json

Replace the generated `package.json` with:

```json
{
  "name": "bmad-method-mcp-server",
  "version": "1.0.0",
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
  "keywords": ["mcp", "bmad", "ai", "prompting", "claude", "gemini"],
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
```

### 2.6 Create the MCP Server

Create `src/` directory and `src/index.ts`:

```bash
mkdir src
```

Create `src/index.ts`:

```typescript
#!/usr/bin/env node

/**
 * BMAD Method MCP Server
 * Automatically selects and applies the best BMAD persona based on user prompts
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// Enhanced BMAD Personas mapping based on the official repository
const BMAD_PERSONAS = {
  // Development personas
  'senior-dev': {
    name: 'Senior Developer',
    keywords: ['code', 'programming', 'development', 'function', 'class', 'algorithm', 'debug', 'refactor', 'implement', 'build', 'create', 'fix', 'bug'],
    command: '/dev',
    description: 'Expert software developer for coding tasks, debugging, and implementation',
    context: 'You are a Senior Developer with 10+ years of experience. You write clean, efficient, well-documented code and follow best practices. You consider performance, security, and maintainability in all solutions.'
  },
  'code-reviewer': {
    name: 'Code Reviewer',
    keywords: ['review', 'audit', 'quality', 'best practices', 'security', 'performance', 'analyze', 'check', 'validate', 'inspect'],
    command: '/review',
    description: 'Thorough code review and quality assessment specialist',
    context: 'You are an expert Code Reviewer focused on code quality, security, performance, and best practices. You provide detailed feedback with specific suggestions for improvement.'
  },
  'software-architect': {
    name: 'Software Architect',
    keywords: ['architecture', 'design', 'system', 'structure', 'patterns', 'scalability', 'microservices', 'api', 'database', 'infrastructure'],
    command: '/architect',
    description: 'System design and architectural guidance expert',
    context: 'You are a Software Architect who designs scalable, maintainable systems. You think about high-level structure, design patterns, technology choices, and long-term evolution of systems.'
  },
  'devops-engineer': {
    name: 'DevOps Engineer',
    keywords: ['deploy', 'deployment', 'ci/cd', 'docker', 'kubernetes', 'aws', 'cloud', 'pipeline', 'automation', 'infrastructure'],
    command: '/devops',
    description: 'DevOps and infrastructure automation specialist',
    context: 'You are a DevOps Engineer expert in CI/CD, containerization, cloud platforms, and infrastructure automation. You focus on reliable, automated deployment pipelines.'
  },
  
  // Analysis personas
  'data-analyst': {
    name: 'Data Analyst',
    keywords: ['data', 'analysis', 'statistics', 'visualization', 'insights', 'metrics', 'csv', 'database', 'query', 'chart'],
    command: '/analyze',
    description: 'Data analysis and statistical insights specialist',
    context: 'You are a Data Analyst expert in statistical analysis, data visualization, and extracting actionable insights from data. You use appropriate tools and methods for data exploration.'
  },
  'business-analyst': {
    name: 'Business Analyst',
    keywords: ['business', 'requirements', 'process', 'workflow', 'stakeholder', 'user story', 'specification', 'analysis'],
    command: '/business',
    description: 'Business process analysis and requirements specialist',
    context: 'You are a Business Analyst who bridges technical and business teams. You excel at gathering requirements, documenting processes, and translating business needs into technical specifications.'
  },
  
  // Creative personas
  'creative-writer': {
    name: 'Creative Writer',
    keywords: ['write', 'story', 'content', 'creative', 'narrative', 'blog', 'article', 'copy', 'marketing'],
    command: '/write',
    description: 'Creative writing and content creation specialist',
    context: 'You are a Creative Writer with expertise in storytelling, content creation, and engaging writing. You adapt your tone and style to the target audience and purpose.'
  },
  
  // Documentation personas
  'tech-writer': {
    name: 'Technical Writer',
    keywords: ['documentation', 'manual', 'guide', 'tutorial', 'explain', 'how-to', 'readme', 'api docs'],
    command: '/doc',
    description: 'Technical documentation and guide creation specialist',
    context: 'You are a Technical Writer who creates clear, comprehensive documentation. You structure information logically and write for your target audience\'s technical level.'
  },
  
  // Problem solving personas
  'problem-solver': {
    name: 'Problem Solver',
    keywords: ['problem', 'solve', 'issue', 'troubleshoot', 'solution', 'error', 'help', 'fix'],
    command: '/solve',
    description: 'General problem solving and troubleshooting specialist',
    context: 'You are a Problem Solver who approaches challenges systematically. You break down complex problems, consider multiple solutions, and provide clear step-by-step guidance.'
  },
  
  // Security personas
  'security-expert': {
    name: 'Security Expert',
    keywords: ['security', 'vulnerability', 'penetration', 'encryption', 'authentication', 'authorization', 'threat', 'secure'],
    command: '/security',
    description: 'Cybersecurity and security assessment specialist',
    context: 'You are a Security Expert focused on identifying vulnerabilities, implementing security best practices, and ensuring robust security measures in systems and code.'
  }
};

// Workflow patterns for multi-persona scenarios
const WORKFLOW_PATTERNS = [
  {
    triggers: ['analyze', 'then', 'implement'],
    sequence: ['data-analyst', 'senior-dev'],
    description: 'Analysis followed by implementation'
  },
  {
    triggers: ['review', 'and', 'fix'],
    sequence: ['code-reviewer', 'senior-dev'],
    description: 'Code review followed by fixes'
  },
  {
    triggers: ['debug', 'and', 'document'],
    sequence: ['problem-solver', 'tech-writer'],
    description: 'Debugging followed by documentation'
  },
  {
    triggers: ['design', 'and', 'implement'],
    sequence: ['software-architect', 'senior-dev'],
    description: 'Architecture design followed by implementation'
  },
  {
    triggers: ['secure', 'and', 'review'],
    sequence: ['security-expert', 'code-reviewer'],
    description: 'Security analysis followed by code review'
  }
];

class BMADMethodServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'bmad-method-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();
  }

  private setupToolHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'enhance_prompt',
            description: 'Automatically enhance prompts with the best BMAD persona(s) and commands',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The original prompt to enhance',
                },
                context: {
                  type: 'string',
                  description: 'Additional context about the task (optional)',
                },
                force_persona: {
                  type: 'string',
                  description: 'Force a specific persona (optional): ' + Object.keys(BMAD_PERSONAS).join(', '),
                },
              },
              required: ['prompt'],
            },
          },
          {
            name: 'suggest_persona',
            description: 'Suggest the best BMAD persona(s) for a given prompt without modifying it',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The prompt to analyze',
                },
              },
              required: ['prompt'],
            },
          },
          {
            name: 'list_personas',
            description: 'List all available BMAD personas and their commands',
            inputSchema: {
              type: 'object',
              properties: {},
            },
          },
          {
            name: 'detect_workflow',
            description: 'Detect if prompt requires multiple personas in sequence',
            inputSchema: {
              type: 'object',
              properties: {
                prompt: {
                  type: 'string',
                  description: 'The prompt to analyze for workflow patterns',
                },
              },
              required: ['prompt'],
            },
          },
        ],
      };
    });

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      switch (request.params.name) {
        case 'enhance_prompt':
          return await this.enhancePrompt(
            request.params.arguments?.prompt as string,
            request.params.arguments?.context as string,
            request.params.arguments?.force_persona as string
          );
        
        case 'suggest_persona':
          return await this.suggestPersona(request.params.arguments?.prompt as string);
        
        case 'list_personas':
          return await this.listPersonas();
        
        case 'detect_workflow':
          return await this.detectWorkflow(request.params.arguments?.prompt as string);
        
        default:
          throw new Error(`Unknown tool: ${request.params.name}`);
      }
    });
  }

  private async enhancePrompt(prompt: string, context?: string, forcePersona?: string): Promise<any> {
    try {
      let selectedPersonas: any[] = [];
      
      if (forcePersona && BMAD_PERSONAS[forcePersona as keyof typeof BMAD_PERSONAS]) {
        selectedPersonas = [BMAD_PERSONAS[forcePersona as keyof typeof BMAD_PERSONAS]];
      } else {
        const workflowAnalysis = this.analyzeWorkflow(prompt, context);
        
        if (workflowAnalysis.isWorkflow) {
          selectedPersonas = workflowAnalysis.personas;
        } else {
          const analysis = this.analyzePrompt(prompt, context);
          const persona = this.selectBestPersona(analysis);
          if (persona) {
            selectedPersonas = [persona];
          }
        }
      }
      
      if (selectedPersonas.length === 0) {
        return {
          content: [
            {
              type: 'text',
              text: prompt, // Return original prompt if no persona detected
            },
          ],
        };
      }

      const enhancedPrompt = this.buildEnhancedPrompt(prompt, selectedPersonas, context);
      
      return {
        content: [
          {
            type: 'text',
            text: enhancedPrompt,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: prompt, // Fallback to original prompt on error
          },
        ],
        isError: true,
      };
    }
  }

  private async suggestPersona(prompt: string): Promise<any> {
    const workflowAnalysis = this.analyzeWorkflow(prompt);
    
    if (workflowAnalysis.isWorkflow) {
      const personaNames = workflowAnalysis.personas.map(p => `${p.name} (${p.command})`).join(' → ');
      return {
        content: [
          {
            type: 'text',
            text: `🔄 **Workflow Detected**: ${workflowAnalysis.workflowType}\n📋 **Sequence**: ${personaNames}\n🔍 **Trigger Words**: ${workflowAnalysis.triggers.join(', ')}`,
          },
        ],
      };
    }

    const analysis = this.analyzePrompt(prompt);
    const persona = this.selectBestPersona(analysis);
    
    if (!persona) {
      return {
        content: [
          {
            type: 'text',
            text: 'No specific persona recommended. General problem-solving approach suggested.',
          },
        ],
      };
    }

    return {
      content: [
        {
          type: 'text',
          text: `🎯 **Recommended Persona**: ${persona.name}\n🔧 **Command**: ${persona.command}\n📋 **Description**: ${persona.description}\n🔍 **Detected Keywords**: ${analysis.detectedKeywords.join(', ')}\n📊 **Confidence**: ${analysis.confidence.toFixed(2)}`,
        },
      ],
    };
  }

  private async listPersonas(): Promise<any> {
    const personaList = Object.entries(BMAD_PERSONAS)
      .map(([key, persona]) => `• **${persona.name}** (${persona.command}): ${persona.description}`)
      .join('\n');

    return {
      content: [
        {
          type: 'text',
          text: `📚 **Available BMAD Personas**:\n\n${personaList}`,
        },
      ],
    };
  }

  private async detectWorkflow(prompt: string): Promise<any> {
    const analysis = this.analyzeWorkflow(prompt);
    
    return {
      content: [
        {
          type: 'text',
          text: `🔍 **Workflow Analysis**:\n\n**Is Workflow**: ${analysis.isWorkflow}\n**Type**: ${analysis.workflowType || 'Single task'}\n**Triggers**: ${analysis.triggers.join(', ')}\n**Personas**: ${analysis.personas.map(p => p.name).join(' → ')}`,
        },
      ],
    };
  }

  private analyzePrompt(prompt: string, context?: string): {
    detectedKeywords: string[];
    confidence: number;
    category: string;
  } {
    const fullText = `${prompt} ${context || ''}`.toLowerCase();
    const detectedKeywords: string[] = [];
    let maxMatches = 0;
    let bestCategory = 'general';
    const categoryScores: { [key: string]: number } = {};

    // Analyze keywords for each persona
    for (const [key, persona] of Object.entries(BMAD_PERSONAS)) {
      const matches = persona.keywords.filter(keyword => 
        fullText.includes(keyword.toLowerCase())
      );
      
      if (matches.length > 0) {
        detectedKeywords.push(...matches);
        categoryScores[key] = matches.length;
        
        if (matches.length > maxMatches) {
          maxMatches = matches.length;
          bestCategory = key;
        }
      }
    }

    // Calculate confidence based on keyword matches and specificity
    const confidence = Math.min(maxMatches / 2, 1.0); // Max confidence with 2+ keyword matches

    return {
      detectedKeywords: [...new Set(detectedKeywords)], // Remove duplicates
      confidence,
      category: bestCategory
    };
  }

  private analyzeWorkflow(prompt: string, context?: string): {
    isWorkflow: boolean;
    workflowType?: string;
    triggers: string[];
    personas: any[];
  } {
    const fullText = `${prompt} ${context || ''}`.toLowerCase();
    
    for (const pattern of WORKFLOW_PATTERNS) {
      const foundTriggers = pattern.triggers.filter(trigger => 
        fullText.includes(trigger.toLowerCase())
      );
      
      if (foundTriggers.length >= 2) { // Need at least 2 trigger words for workflow
        const personas = pattern.sequence.map(key => BMAD_PERSONAS[key as keyof typeof BMAD_PERSONAS]);
        
        return {
          isWorkflow: true,
          workflowType: pattern.description,
          triggers: foundTriggers,
          personas
        };
      }
    }
    
    return {
      isWorkflow: false,
      triggers: [],
      personas: []
    };
  }

  private selectBestPersona(analysis: any) {
    if (analysis.confidence < 0.25) { // Lower threshold for better coverage
      return null;
    }

    return BMAD_PERSONAS[analysis.category as keyof typeof BMAD_PERSONAS];
  }

  private buildEnhancedPrompt(
    originalPrompt: string,
    personas: any[],
    context?: string
  ): string {
    const commands = personas.map(p => p.command).join(' ');
    const personaContexts = personas.map(p => p.context).join('\n\n');
    
    let enhanced = `${commands}\n\n${personaContexts}\n\n`;
    
    if (context) {
      enhanced += `**Additional Context**: ${context}\n\n`;
    }
    
    enhanced += `**Task**: ${originalPrompt}`;
    
    return enhanced;
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('BMAD Method MCP server running on stdio');
  }
}

const server = new BMADMethodServer();
server.run().catch(console.error);
```

### 2.7 Build the Server

```bash
npm run build
```

## Step 3: Configure Gemini CLI

### 3.1 Create Gemini Settings Directory

```bash
mkdir -p ~/.gemini
```

### 3.2 Configure MCP Server

Create or edit `~/.gemini/settings.json`:

```bash
cat > ~/.gemini/settings.json << 'EOF'
{
  "mcpServers": {
    "bmad-method": {
      "command": "node",
      "args": [
        "/absolute/path/to/bmad-mcp-server/build/index.js"
      ],
      "env": {}
    }
  }
}
EOF
```

**Important**: Replace `/absolute/path/to/bmad-mcp-server` with your actual path:

```bash
# Get the absolute path
pwd
# Use this path in the settings.json file above
```

### 3.3 Test MCP Server Connection

```bash
# Test Gemini CLI with MCP
gemini /mcp
```

You should see the BMAD method server listed as connected.

## Step 4: Create Wrapper Scripts

### 4.1 Create the Main Enhancement Script

Create `~/bin/bmad-claude` (create ~/bin directory if it doesn't exist):

```bash
mkdir -p ~/bin

cat > ~/bin/bmad-claude << 'EOF'
#!/bin/bash

# BMAD Enhanced Claude Code Script
# Usage: bmad-claude "your prompt here"

set -e

# Configuration
GEMINI_MODEL="gemini-2.5-pro"
DEBUG=false

# Function to log debug messages
debug_log() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "[DEBUG] $1" >&2
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: bmad-claude [OPTIONS] \"prompt\""
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -d, --debug    Enable debug mode"
    echo "  -m, --model    Specify Gemini model (default: gemini-2.5-pro)"
    echo "  -f, --force    Force specific persona (e.g., senior-dev, code-reviewer)"
    echo "  -s, --suggest  Only suggest persona without execution"
    echo ""
    echo "Examples:"
    echo "  bmad-claude \"Create a REST API for user management\""
    echo "  bmad-claude -f senior-dev \"Fix this bug\""
    echo "  bmad-claude -s \"Analyze this data and create visualizations\""
    exit 0
}

# Parse command line arguments
FORCE_PERSONA=""
SUGGEST_ONLY=false
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            ;;
        -d|--debug)
            DEBUG=true
            shift
            ;;
        -m|--model)
            GEMINI_MODEL="$2"
            shift 2
            ;;
        -f|--force)
            FORCE_PERSONA="$2"
            shift 2
            ;;
        -s|--suggest)
            SUGGEST_ONLY=true
            shift
            ;;
        -*|--*)
            echo "Unknown option $1" >&2
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

# Check if prompt is provided
if [[ $# -eq 0 ]]; then
    echo "Error: No prompt provided" >&2
    show_usage
fi

# Combine all arguments as the prompt
USER_PROMPT="$*"

debug_log "Original prompt: $USER_PROMPT"
debug_log "Force persona: $FORCE_PERSONA"
debug_log "Suggest only: $SUGGEST_ONLY"

# Prepare the Gemini analysis prompt
if [[ "$SUGGEST_ONLY" == "true" ]]; then
    ANALYSIS_PROMPT="Use the bmad-method MCP server's suggest_persona tool to analyze this prompt: $USER_PROMPT"
else
    if [[ -n "$FORCE_PERSONA" ]]; then
        ANALYSIS_PROMPT="Use the bmad-method MCP server's enhance_prompt tool with force_persona='$FORCE_PERSONA' to enhance this prompt: $USER_PROMPT"
    else
        ANALYSIS_PROMPT="Use the bmad-method MCP server's enhance_prompt tool to enhance this prompt: $USER_PROMPT"
    fi
fi

debug_log "Analysis prompt: $ANALYSIS_PROMPT"

# Use Gemini CLI to analyze and enhance the prompt
echo "🔍 Analyzing prompt with Gemini + BMAD Method..." >&2

ENHANCED_RESULT=$(gemini -m "$GEMINI_MODEL" -p "$ANALYSIS_PROMPT" 2>/dev/null)

debug_log "Gemini result: $ENHANCED_RESULT"

# If suggest only, just show the suggestion
if [[ "$SUGGEST_ONLY" == "true" ]]; then
    echo "$ENHANCED_RESULT"
    exit 0
fi

# Extract the enhanced prompt (assume it's the last line or the whole result)
ENHANCED_PROMPT="$ENHANCED_RESULT"

debug_log "Enhanced prompt: $ENHANCED_PROMPT"

# Execute with Claude Code
echo "🚀 Executing enhanced prompt with Claude Code..." >&2
echo "" >&2

claude-code "$ENHANCED_PROMPT"
EOF

chmod +x ~/bin/bmad-claude
```

### 4.2 Add ~/bin to PATH

Add this to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Or for zsh users:
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 4.3 Create Additional Utility Scripts

Create `~/bin/bmad-suggest`:

```bash
cat > ~/bin/bmad-suggest << 'EOF'
#!/bin/bash
# Quick persona suggestion without execution
exec bmad-claude -s "$@"
EOF

chmod +x ~/bin/bmad-suggest
```

Create `~/bin/bmad-dev` (quick development mode):

```bash
cat > ~/bin/bmad-dev << 'EOF'
#!/bin/bash
# Force senior developer persona
exec bmad-claude -f senior-dev "$@"
EOF

chmod +x ~/bin/bmad-dev
```

Create `~/bin/bmad-review` (quick code review mode):

```bash
cat > ~/bin/bmad-review << 'EOF'
#!/bin/bash
# Force code reviewer persona
exec bmad-claude -f code-reviewer "$@"
EOF

chmod +x ~/bin/bmad-review
```

## Step 5: Test the System

### 5.1 Test MCP Server Connection

```bash
# Test MCP server is working
gemini /mcp

# Test listing personas
gemini "Use the bmad-method MCP server's list_personas tool"
```

### 5.2 Test Persona Suggestion

```bash
# Test persona suggestion
bmad-suggest "Create a REST API for user management"

# Expected output should show Senior Developer persona recommendation
```

### 5.3 Test Full Enhancement

```bash
# Test full enhancement and execution
bmad-claude "Fix the authentication bug in my login function"

# This should:
# 1. Analyze the prompt with Gemini
# 2. Apply appropriate BMAD persona
# 3. Execute with Claude Code
```

### 5.4 Test Different Scenarios

```bash
# Test data analysis workflow
bmad-claude "Analyze this CSV data and then create visualizations"

# Test documentation task
bmad-claude "Write documentation for this API endpoint"

# Test security review
bmad-claude "Review this code for security vulnerabilities"

# Test forced persona
bmad-claude -f software-architect "Design a microservices architecture"
```

## Step 6: Advanced Usage

### 6.1 Create Project-Specific Configurations

You can create project-specific BMAD configurations:

```bash
# In your project directory
mkdir .bmad
cat > .bmad/config.json << 'EOF'
{
  "defaultPersona": "senior-dev",
  "context": "This is a Node.js microservices project using TypeScript, Express, and MongoDB.",
  "customPersonas": {
    "api-dev": {
      "name": "API Developer",
      "command": "/api-dev",
      "context": "You are an API developer specializing in RESTful services, OpenAPI documentation, and microservices architecture."
    }
  }
}
EOF
```

### 6.2 Create Workflow Scripts

Create common workflow scripts:

```bash
# Code review workflow
cat > ~/bin/bmad-workflow-review << 'EOF'
#!/bin/bash
echo "=== STEP 1: Code Review ==="
bmad-review "$@"
echo ""
echo "=== STEP 2: Suggested Fixes ==="
bmad-dev "Based on the review above, provide specific fixes for the identified issues"
EOF

chmod +x ~/bin/bmad-workflow-review
```

### 6.3 Integration with Git Hooks

Create a pre-commit hook that uses BMAD for code review:

```bash
# In your project's .git/hooks/pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running BMAD code review on staged changes..."
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|py|go|java)$')

if [[ -n "$STAGED_FILES" ]]; then
    for file in $STAGED_FILES; do
        echo "Reviewing $file..."
        bmad-review "Review this file for issues: @$file" --quiet
    done
fi
EOF

chmod +x .git/hooks/pre-commit
```

### 6.4 Custom Context Files

Create context files for better results:

```bash
# Global context
mkdir -p ~/.gemini
cat > ~/.gemini/GEMINI.md << 'EOF'
# Global BMAD Context

## Coding Standards
- Use TypeScript for new JavaScript projects
- Follow clean code principles
- Write comprehensive tests
- Document APIs with OpenAPI/Swagger

## Preferred Technologies
- Backend: Node.js, Express, TypeScript
- Frontend: React, Next.js
- Database: PostgreSQL, Redis
- Cloud: AWS, Docker, Kubernetes

## Security Guidelines
- Always validate inputs
- Use parameterized queries
- Implement proper authentication
- Follow OWASP guidelines
EOF
```

## Troubleshooting

### Common Issues and Solutions

#### MCP Server Not Connecting

```bash
# Check if server is listed
gemini /mcp

# If not listed, verify path in settings.json
cat ~/.gemini/settings.json

# Test server manually
node /path/to/bmad-mcp-server/build/index.js
```

#### Command Not Found

```bash
# Verify PATH includes ~/bin
echo $PATH

# Re-source your shell configuration
source ~/.bashrc  # or ~/.zshrc
```

#### Gemini CLI Issues

```bash
# Check Gemini CLI installation
gemini --version

# Check authentication
gemini auth status

# Re-authenticate if needed
gemini auth login
```

#### Permission Errors

```bash
# Make scripts executable
chmod +x ~/bin/bmad-*

# Check directory permissions
ls -la ~/bin/
```

### Debug Mode

Enable debug mode for troubleshooting:

```bash
# Run with debug flag
bmad-claude -d "test prompt"

# Check Gemini CLI logs
gemini --verbose "test prompt"
```

### Testing Individual Components

```bash
# Test MCP server directly
echo '{"method": "tools/list", "params": {}}' | node /path/to/bmad-mcp-server/build/index.js

# Test Gemini CLI MCP integration
gemini "Use the bmad-method MCP server's list_personas tool"

# Test Claude Code directly
claude-code "test prompt"
```

## Conclusion

You now have a fully automated system that:

1. **Analyzes your prompts** using Gemini CLI's intelligence
2. **Selects optimal BMAD personas** automatically via MCP
3. **Enhances prompts** with proper context and commands
4. **Executes with Claude Code** for the best results

### Quick Reference Commands

```bash
# Basic usage
bmad-claude "your prompt here"

# Get persona suggestion only
bmad-suggest "your prompt here"

# Force specific persona
bmad-claude -f senior-dev "your prompt here"

# Quick developer mode
bmad-dev "your coding task"

# Quick review mode
bmad-review "review this code"

# Debug mode
bmad-claude -d "your prompt here"
```

The system will automatically detect:
- Single vs multi-persona workflows
- Appropriate BMAD personas based on context
- Workflow patterns that require sequential personas

Enjoy your enhanced AI coding experience! 🚀