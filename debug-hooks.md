# Debugging Claude Code Hooks

## 1. Check Hook Registration
```bash
/hooks
```
This command shows all registered hooks. You should see:
- UserPromptSubmit with your hook command

## 2. Enable Debug Mode in Hook

Edit the hook to set DEBUG=true:
```python
def log_debug(message):
    """Log debug message to stderr"""
    print(f"[BMAD DEBUG] {message}", file=sys.stderr)
```

## 3. View Hook Execution in UI

When a hook runs, you'll see:
- The enhanced prompt in the `<user-prompt-submit-hook>` tag
- Any stderr output (like our debug messages)
- The MCP server status messages

## 4. Test Hook Manually

```bash
# Test with sample input
echo '{"prompt": "create a REST API"}' | python3 /tmp/bmad_enhance_simple.py

# Test with different prompts
echo '{"prompt": "review this code"}' | python3 /tmp/bmad_enhance_simple.py
```

## 5. Check Hook Logs

The hook writes debug info to stderr, which appears in Claude's output:
```
[BMAD DEBUG] Processing: create a REST API...
[BMAD DEBUG] Selected persona: Senior Developer
```

## 6. Verify Hook is Active

Look for these indicators:
1. **Prompt Enhancement**: Your prompts get persona context added
2. **MCP Server Messages**: "MCP STDERR (bmad-method): BMAD Method MCP server running on stdio"
3. **Persona Selection**: Different prompts trigger different personas

## 7. Common Issues

### Hook Not Running
- Check `/hooks` command
- Verify settings.json is in .claude/ directory
- Ensure hook script is executable
- Restart Claude Code after changes

### Wrong Persona Selected
- Check keyword matching in hook
- Review persona selection logic
- Test with more specific keywords

### Hook Errors
- Check for Python syntax errors
- Verify all imports are available
- Test hook script manually first

## Current Hook Status

✅ **Hook is ACTIVE and WORKING**
- Registered in settings.json
- Successfully enhancing prompts
- Correctly selecting personas based on content
- No errors in execution