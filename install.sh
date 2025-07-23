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
REPO_URL="https://github.com/wolverin0/bmad-claude.git"

# Functions
print_header() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          BMAD Method for Claude Code Installer           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}🎯 What this does:${NC}"
    echo "• Uses Gemini AI to automatically select the best BMAD persona"
    echo "• No more guessing which persona to use - AI chooses for you"
    echo "• Enhances every Claude Code prompt with intelligent context"
    echo
    echo -e "${YELLOW}📋 Requirements:${NC}"
    echo "• Claude Code CLI (required)"
    echo "• Node.js & Gemini CLI (we'll install if missing)"  
    echo "• Free Gemini API key (we'll help you get one)"
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
    echo -e "${BLUE}🔍 Checking system requirements...${NC}"
    echo
    
    # Check Python 3
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is required but not installed"
        echo "        Install Python 3: https://python.org/downloads"
        exit 1
    fi
    print_success "Python 3 found: $(python3 --version)"
    
    # Check Claude Code CLI (required)
    if command -v claude &> /dev/null; then
        print_success "Claude Code CLI found"
    else
        print_error "Claude Code CLI not found. Please install it first:"
        echo "        Visit: https://claude.ai/code"
        exit 1
    fi
    
    # Check Node.js (required for Gemini CLI)
    if command -v node &> /dev/null; then
        print_success "Node.js found: $(node --version)"
    else
        print_error "Node.js is required for Gemini CLI"
        echo "        Install Node.js: https://nodejs.org"
        exit 1
    fi
    
    # Check Gemini CLI (required - core component)
    if command -v gemini &> /dev/null; then
        print_success "Gemini CLI found"
    else
        print_info "Gemini CLI not found - installing it now..."
        echo
        echo -e "${YELLOW}Installing Gemini CLI...${NC}"
        if npm install -g @google/generative-ai-cli; then
            print_success "Gemini CLI installed successfully"
        else
            print_error "Failed to install Gemini CLI"
            echo "        Try manually: npm install -g @google/generative-ai-cli"
            exit 1
        fi
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
    echo -e "${BLUE}Installing Gemini-powered hook...${NC}"
    
    # Copy the Gemini hook from project to system location
    if [ -f ".claude/hooks/bmad_gemini_hook.py" ]; then
        cp .claude/hooks/bmad_gemini_hook.py "$CLAUDE_DIR/hooks/"
        chmod +x "$CLAUDE_DIR/hooks/bmad_gemini_hook.py"
        print_success "Copied Gemini hook to system location"
    else
        print_error "Gemini hook not found in project"
        exit 1
    fi
    
    # Create symlink without spaces for hook
    ln -sf "$CLAUDE_DIR/hooks/bmad_gemini_hook.py" /tmp/bmad_gemini_hook.py
    
    print_success "Installed Gemini-powered enhancement hook"
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
            "command": "/usr/bin/python3 /tmp/bmad_gemini_hook.py"
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
    echo -e "${BLUE}🔑 Setting up Gemini API key...${NC}"
    echo
    echo -e "${YELLOW}IMPORTANT:${NC} The BMAD system requires a Gemini API key to function."
    echo "This is the core intelligence that selects the right BMAD persona for you."
    echo
    
    # Check if .env exists
    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        print_info "Creating .env from .env.example"
        cp .env.example .env
    fi
    
    # Check if API key is already configured
    if [ -f ".env" ] && grep -q "GEMINI_API_KEY=.*[^-].*" .env && ! grep -q "your-gemini-api-key-here" .env; then
        print_success "Gemini API key already configured"
    else
        echo -e "${YELLOW}📋 To get your FREE Gemini API key:${NC}"
        echo "1. Visit: https://makersuite.google.com/app/apikey"
        echo "2. Click 'Create API Key'"
        echo "3. Copy the key and paste it below"
        echo
        
        while true; do
            read -p "Enter your Gemini API key: " api_key
            if [ ! -z "$api_key" ] && [ "$api_key" != "your-gemini-api-key-here" ]; then
                # Use sed to replace the placeholder
                sed -i.bak "s/your-gemini-api-key-here/$api_key/" .env
                rm .env.bak 2>/dev/null || true
                print_success "API key configured successfully"
                break
            else
                print_error "Please enter a valid API key"
                echo
            fi
        done
    fi
    
    # Test the API key
    echo
    echo -e "${YELLOW}Testing Gemini connection...${NC}"
    if GEMINI_API_KEY=$(grep "GEMINI_API_KEY=" .env | cut -d'=' -f2) gemini -p "Hello" >/dev/null 2>&1; then
        print_success "Gemini API key is working!"
    else
        print_error "API key test failed. Please check your key."
        echo "You can update it later in the .env file"
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