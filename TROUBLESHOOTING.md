# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 🚫 Hook Not Working

#### Symptoms
- Prompts not being enhanced
- `/hooks` shows no matchers
- No persona context added to prompts

#### Solutions

1. **Check Hook Registration**
   ```bash
   # In Claude Code
   /hooks
   ```
   Should show UserPromptSubmit hook configured.

2. **Verify Installation**
   ```bash
   # Check if hook exists
   ls -la ~/.claude/hooks/bmad_enhance_simple.py
   
   # Test hook manually
   echo '{"prompt": "test"}' | python3 ~/.claude/hooks/bmad_enhance_simple.py
   ```

3. **Check Settings File**
   ```bash
   # Verify settings exist in project
   cat .claude/settings.json
   
   # Should contain UserPromptSubmit configuration
   ```

4. **Restart Claude Code**
   - Close Claude Code completely
   - Reopen and check `/hooks` again

### 🔴 "Command not found" Errors

#### For CLI tools (bmad-test, bmad-suggest)

1. **Source bashrc**
   ```bash
   source ~/.bashrc
   ```

2. **Check PATH**
   ```bash
   echo $PATH | grep -q "$HOME/bin" && echo "OK" || echo "Missing"
   ```

3. **Manually add to PATH**
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

### ⚠️ "Permission denied" Errors

#### Fix permissions
```bash
# Make hook executable
chmod +x ~/.claude/hooks/bmad_enhance_simple.py

# Fix CLI tools
chmod +x ~/bin/bmad-*

# Fix test scripts
chmod +x ./test-installation.sh
chmod +x ./run-tests.sh
```

### 📁 Path with Spaces Issues

#### Symptoms
- "No such file or directory" errors
- Path breaks at space character

#### Solution
The installer creates symlinks at `/tmp/bmad_enhance.py` to avoid spaces. If you still have issues:

```bash
# Create custom symlink
ln -sf "/path/with spaces/hook.py" /tmp/my_hook.py

# Update settings.json to use symlink
"command": "/usr/bin/python3 /tmp/my_hook.py"
```

### 🐍 Python Issues

#### "Python3 not found"
```bash
# Check Python installation
which python3

# If missing, install Python 3
# Ubuntu/Debian:
sudo apt-get install python3

# macOS:
brew install python3
```

#### Import errors
```bash
# The hook uses only standard library
# No additional packages needed
python3 -c "import json, sys, re" && echo "OK"
```

### 🎯 Wrong Persona Selected

#### Debug persona selection
```bash
# Enable debug mode
sed -i 's/debug=False/debug=True/' ~/.claude/hooks/bmad_enhance_simple.py

# Test with debug output
echo '{"prompt": "your test prompt"}' | python3 ~/.claude/hooks/bmad_enhance_simple.py 2>&1
```

#### Customize personas
Edit `~/.claude/hooks/bmad_enhance_simple.py` and modify:
- Keywords for better matching
- Priority rules in `select_persona()`
- Add new personas to `PERSONAS` dict

### 🔄 Hook Timeout Issues

#### If using Gemini API version
Switch to the simple version that doesn't require external API:
```bash
# Use bmad_enhance_simple.py instead of bmad_enhance.py
```

### 📝 Settings Not Loading

#### Check file location
Claude Code looks for settings in this order:
1. `.claude/settings.json` (project)
2. `.claude/settings.local.json` (project local)
3. `~/.claude/settings.json` (global)

#### Validate JSON
```bash
# Check for JSON syntax errors
python3 -m json.tool .claude/settings.json
```

### 🔍 Debugging Steps

1. **Enable verbose logging**
   ```python
   # In hook script, change:
   log_debug("message", debug=True)  # Always show debug
   ```

2. **Check stderr output**
   - Debug messages appear with `[BMAD DEBUG]` prefix
   - Look for these in Claude's output

3. **Manual testing pipeline**
   ```bash
   # Test each component
   ./test-installation.sh
   ./run-tests.sh
   ```

### 💡 Quick Fixes

```bash
# Complete reinstall
curl -sSL https://raw.githubusercontent.com/wolverin0/bmad-claude/main/install.sh | bash

# Reset configuration
rm -rf ~/.claude/hooks/bmad_*
rm -f .claude/settings.json
./install.sh

# Test specific prompt
bmad-test "your prompt here"
```

## Still Having Issues?

1. **Check GitHub Issues**: https://github.com/wolverin0/bmad-claude/issues
2. **Enable debug mode** and collect logs
3. **Run test suite** and note which tests fail
4. **Create issue** with:
   - Error messages
   - Output of `./test-installation.sh`
   - Claude Code version
   - Operating system

## FAQ

**Q: Do I need to restart Claude Code after installation?**
A: Yes, Claude Code loads hooks on startup.

**Q: Can I use this with existing hooks?**
A: Yes, the installer backs up existing settings.

**Q: Does this work offline?**
A: Yes, the simple version works completely offline.

**Q: Can I customize the personas?**
A: Yes, edit `~/.claude/hooks/bmad_enhance_simple.py`

**Q: Is my API key needed?**
A: No, the simple version doesn't use any API.