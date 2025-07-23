#!/bin/bash

# BMAD Method for Claude Code - Installation Script
# This script sets up the complete BMAD enhancement system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.bmad-claude"
CLAUDE_DIR="$HOME/.claude"
BIN_DIR="$HOME/bin"
REPO_URL="https://github.com/yourusername/bmad-claude.git"

# Functions
print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          BMAD Method for Claude Code Installer           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

check_requirements() {
    echo -e "${BLUE}Checking requirements...${NC}"
    
    # Check Python 3
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is required but not installed"
        exit 1
    fi
    print_success "Python 3 found: $(python3 --version)"
    
    # Check Node.js (optional for MCP server)
    if command -v node &> /dev/null; then
        print_success "Node.js found: $(node --version) (optional)"
    else
        print_info "Node.js not found (optional for MCP server)"
    fi
    
    # Check Claude Code
    if command -v claude &> /dev/null; then
        print_success "Claude Code CLI found"
    else
        print_error "Claude Code CLI not found. Please install it first:"
        echo "        Visit: https://claude.ai/code"
        exit 1
    fi
    
    echo
}

create_directories() {
    echo -e "${BLUE}Creating directories...${NC}"
    
    # Create necessary directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CLAUDE_DIR/hooks"
    mkdir -p "$BIN_DIR"
    mkdir -p "$HOME/.local/share/bmad-claude/logs"
    
    print_success "Created directory structure"
    echo
}

install_hook() {
    echo -e "${BLUE}Installing Claude Code hook...${NC}"
    
    # Create the hook script
    cat > "$CLAUDE_DIR/hooks/bmad_enhance_simple.py" << 'EOF'
#!/usr/bin/env python3

"""
BMAD Method Enhancement Hook for Claude Code
Automatically selects and applies the best persona for each prompt
"""

import json
import sys
import re
from datetime import datetime

def log_debug(message, debug=False):
    """Log debug message to stderr"""
    if debug:
        print(f"[BMAD DEBUG] {message}", file=sys.stderr)

# BMAD Personas with keywords for pattern matching
PERSONAS = {
    'senior-dev': {
        'keywords': ['code', 'coding', 'program', 'function', 'class', 'algorithm', 'debug', 'implement', 'build', 'create', 'fix', 'bug', 'develop', 'script', 'api', 'method'],
        'command': '/dev',
        'title': 'Senior Developer',
        'context': 'You are a Senior Developer with expertise in software development, debugging, and implementation. Focus on clean, efficient, well-documented code following best practices.'
    },
    'code-reviewer': {
        'keywords': ['review', 'audit', 'quality', 'security', 'performance', 'analyze code', 'check', 'validate', 'inspect'],
        'command': '/review',
        'title': 'Code Reviewer',
        'context': 'You are a Code Reviewer focused on code quality, security, performance, and best practices. Provide detailed feedback with specific improvement suggestions.'
    },
    'business-analyst': {
        'keywords': ['prd', 'requirement', 'specification', 'business', 'process', 'workflow', 'user story', 'stakeholder', 'document'],
        'command': '/business',
        'title': 'Business Analyst',
        'context': 'You are a Business Analyst expert in requirements gathering, process documentation, and creating comprehensive specifications that bridge business needs and technical implementation.'
    },
    'architect': {
        'keywords': ['architecture', 'design', 'system', 'structure', 'pattern', 'scalability', 'microservice', 'database', 'infrastructure'],
        'command': '/architect',
        'title': 'Software Architect',
        'context': 'You are a Software Architect who designs scalable, maintainable systems. Consider high-level structure, design patterns, and long-term system evolution.'
    },
    'devops': {
        'keywords': ['deploy', 'deployment', 'ci/cd', 'docker', 'kubernetes', 'aws', 'cloud', 'pipeline', 'automation'],
        'command': '/devops',
        'title': 'DevOps Engineer',
        'context': 'You are a DevOps Engineer expert in CI/CD, containerization, cloud platforms, and infrastructure automation.'
    },
    'data-analyst': {
        'keywords': ['data', 'analysis', 'statistics', 'visualization', 'insights', 'metrics', 'csv', 'query', 'chart', 'report'],
        'command': '/analyze',
        'title': 'Data Analyst',
        'context': 'You are a Data Analyst expert in statistical analysis, data visualization, and extracting actionable insights from data.'
    },
    'tech-writer': {
        'keywords': ['documentation', 'manual', 'guide', 'tutorial', 'explain', 'readme', 'how-to', 'instructions'],
        'command': '/doc',
        'title': 'Technical Writer',
        'context': 'You are a Technical Writer who creates clear, comprehensive documentation. Structure information logically for the target audience.'
    },
    'security': {
        'keywords': ['security', 'vulnerability', 'penetration', 'encryption', 'authentication', 'threat', 'secure', 'exploit'],
        'command': '/security',
        'title': 'Security Expert',
        'context': 'You are a Security Expert focused on identifying vulnerabilities and implementing robust security measures.'
    },
    'problem-solver': {
        'keywords': ['problem', 'solve', 'issue', 'troubleshoot', 'error', 'help', 'fix issue', 'debug error'],
        'command': '/solve',
        'title': 'Problem Solver',
        'context': 'You are a Problem Solver who approaches challenges systematically, breaking down complex problems and providing clear solutions.'
    }
}

def select_persona(prompt):
    """Select the best persona based on keyword matching"""
    prompt_lower = prompt.lower()
    
    # Check for high-priority exact matches first
    if 'prd' in prompt_lower or 'product requirement' in prompt_lower:
        return PERSONAS['business-analyst']
    if 'review' in prompt_lower and ('code' in prompt_lower or 'pr' in prompt_lower):
        return PERSONAS['code-reviewer']
    if 'security' in prompt_lower or 'vulnerability' in prompt_lower:
        return PERSONAS['security']
    if 'deploy' in prompt_lower or 'ci/cd' in prompt_lower:
        return PERSONAS['devops']
    if 'document' in prompt_lower or 'readme' in prompt_lower:
        return PERSONAS['tech-writer']
    
    scores = {}
    
    # Score each persona based on keyword matches
    for persona_key, persona in PERSONAS.items():
        score = 0
        for keyword in persona['keywords']:
            if keyword in prompt_lower:
                # Give more weight to longer, more specific keywords
                score += len(keyword) * 1.5 if len(keyword) > 5 else len(keyword)
        scores[persona_key] = score
    
    # Get the persona with highest score
    best_persona = max(scores, key=scores.get)
    
    # Only return if score is above threshold
    if scores[best_persona] > 3:
        return PERSONAS[best_persona]
    
    # Default to problem solver for general queries
    return PERSONAS['problem-solver']

def enhance_prompt(original_prompt):
    """Enhance the prompt with BMAD persona"""
    
    # Skip enhancement for very short prompts or commands
    if len(original_prompt) < 5 or original_prompt.startswith(('/', '@', 'help')):
        return original_prompt
    
    # Select appropriate persona
    persona = select_persona(original_prompt)
    
    # Format enhanced prompt
    enhanced = f"{persona['command']} {persona['context']}\n\n**Task**: {original_prompt}"
    
    log_debug(f"Selected persona: {persona['title']}", debug=False)
    return enhanced

def main():
    """Main hook function"""
    original_prompt = ""
    
    try:
        # Read input from stdin
        input_text = sys.stdin.read()
        
        # Try to parse as JSON first
        try:
            input_data = json.loads(input_text)
            original_prompt = input_data.get('prompt', input_text)
        except json.JSONDecodeError:
            # If not JSON, treat as plain text prompt
            original_prompt = input_text.strip()
        
        # Enhance the prompt
        enhanced_prompt = enhance_prompt(original_prompt)
        
        # Output the enhanced prompt
        print(enhanced_prompt)
        
    except Exception as e:
        # On error, output original prompt
        print(original_prompt if original_prompt else "")

if __name__ == "__main__":
    main()
EOF

    chmod +x "$CLAUDE_DIR/hooks/bmad_enhance_simple.py"
    print_success "Installed enhancement hook"
    echo
}

configure_claude() {
    echo -e "${BLUE}Configuring Claude Code...${NC}"
    
    # Get current working directory and handle spaces
    CURRENT_DIR=$(pwd)
    
    # Create symlink without spaces for hook
    ln -sf "$CLAUDE_DIR/hooks/bmad_enhance_simple.py" /tmp/bmad_enhance.py
    
    # Create or update Claude settings
    if [ -f "$CURRENT_DIR/.claude/settings.json" ]; then
        print_info "Found existing .claude/settings.json - backing up"
        cp "$CURRENT_DIR/.claude/settings.json" "$CURRENT_DIR/.claude/settings.json.backup"
    fi
    
    # Create .claude directory if it doesn't exist
    mkdir -p "$CURRENT_DIR/.claude"
    
    # Write settings
    cat > "$CURRENT_DIR/.claude/settings.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(mkdir:*)",
      "Bash(npm:*)", 
      "Bash(node:*)",
      "Bash(python:*)",
      "Bash(python3:*)",
      "Write",
      "Edit"
    ],
    "deny": []
  },
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/usr/bin/python3 /tmp/bmad_enhance.py"
          }
        ]
      }
    ]
  }
}
EOF
    
    print_success "Configured Claude Code settings"
    echo
}

setup_environment() {
    echo -e "${BLUE}Setting up environment...${NC}"
    
    # Check if .env exists
    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        print_info "Creating .env from .env.example"
        cp .env.example .env
        
        # Check if user wants to configure API key now
        echo
        read -p "Do you want to configure your Gemini API key now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Get your API key from: https://makersuite.google.com/app/apikey"
            read -p "Enter your Gemini API key: " api_key
            if [ ! -z "$api_key" ]; then
                # Use sed to replace the placeholder
                sed -i.bak "s/your-gemini-api-key-here/$api_key/" .env
                rm .env.bak
                print_success "API key configured"
            else
                print_info "You can configure it later in .env file"
            fi
        else
            print_info "You can configure your API key later in .env file"
        fi
    elif [ -f ".env" ]; then
        print_success "Environment file already exists"
    fi
    
    echo
}

install_cli_tools() {
    echo -e "${BLUE}Installing CLI tools...${NC}"
    
    # Create wrapper scripts
    cat > "$BIN_DIR/bmad-test" << 'EOF'
#!/bin/bash
# Test BMAD enhancement on a prompt
echo '{"prompt": "'"$1"'"}' | python3 ~/.claude/hooks/bmad_enhance_simple.py
EOF
    
    cat > "$BIN_DIR/bmad-suggest" << 'EOF'
#!/bin/bash
# Get persona suggestion for a prompt
result=$(echo '{"prompt": "'"$1"'"}' | python3 ~/.claude/hooks/bmad_enhance_simple.py 2>&1)
persona=$(echo "$result" | grep "Selected persona:" | cut -d: -f2)
command=$(echo "$result" | grep "^/" | head -1 | cut -d' ' -f1)
echo "Suggested persona:$persona ($command)"
EOF
    
    # Make scripts executable
    chmod +x "$BIN_DIR/bmad-test"
    chmod +x "$BIN_DIR/bmad-suggest"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.bashrc
        print_info "Added $BIN_DIR to PATH - run 'source ~/.bashrc' or open new terminal"
    fi
    
    print_success "Installed CLI tools"
    echo
}

create_test_suite() {
    echo -e "${BLUE}Creating test suite...${NC}"
    
    cat > "$INSTALL_DIR/test-installation.sh" << 'EOF'
#!/bin/bash

# Test BMAD Claude Installation

echo "=== Testing BMAD Claude Installation ==="
echo

# Test hook directly
echo "1. Testing hook enhancement..."
test_prompts=(
    "create a REST API"
    "review this code"
    "write documentation"
    "deploy to AWS"
    "analyze user data"
)

for prompt in "${test_prompts[@]}"; do
    echo -n "   Testing: $prompt ... "
    result=$(echo "{\"prompt\": \"$prompt\"}" | python3 ~/.claude/hooks/bmad_enhance_simple.py 2>&1)
    if echo "$result" | grep -q "^/"; then
        echo "✓"
    else
        echo "✗"
    fi
done

echo
echo "2. Testing CLI tools..."
if command -v bmad-test &> /dev/null; then
    echo "   ✓ bmad-test found"
else
    echo "   ✗ bmad-test not found"
fi

if command -v bmad-suggest &> /dev/null; then
    echo "   ✓ bmad-suggest found"
else
    echo "   ✗ bmad-suggest not found"
fi

echo
echo "3. Testing Claude integration..."
if [ -f ".claude/settings.json" ]; then
    echo "   ✓ Claude settings configured"
else
    echo "   ✗ Claude settings missing"
fi

echo
echo "=== Test Complete ==="
echo "To test in Claude Code, run: /hooks"
EOF
    
    chmod +x "$INSTALL_DIR/test-installation.sh"
    ln -sf "$INSTALL_DIR/test-installation.sh" ./test-installation.sh
    
    print_success "Created test suite"
    echo
}

print_completion() {
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            Installation Complete! 🎉                     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Run: source ~/.bashrc (or open new terminal)"
    echo "2. Restart Claude Code"
    echo "3. Test with: ./test-installation.sh"
    echo "4. In Claude Code, run: /hooks"
    echo
    echo -e "${YELLOW}Quick test:${NC}"
    echo "   bmad-test \"create a user authentication system\""
    echo
    echo -e "${GREEN}Happy coding with BMAD enhanced Claude! 🚀${NC}"
}

# Main installation flow
main() {
    print_header
    check_requirements
    create_directories
    setup_environment
    install_hook
    configure_claude
    install_cli_tools
    create_test_suite
    print_completion
}

# Run installation
main "$@"