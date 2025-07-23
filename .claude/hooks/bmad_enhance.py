#!/usr/bin/env python3

"""
BMAD Method Enhancement Hook for Claude Code
Automatically enhances user prompts with appropriate BMAD personas using Gemini analysis
"""

import json
import sys
import subprocess
import os
from datetime import datetime

# Set Gemini API key
os.environ['GEMINI_API_KEY'] = 'AIzaSyBOZbnIe6YR1C3SCXUe6iJGqhn2A4Ldvw0'

def log_debug(message):
    """Log debug message to stderr"""
    print(f"[BMAD DEBUG] {message}", file=sys.stderr)

def call_gemini(prompt):
    """Call Gemini CLI with the given prompt"""
    try:
        # Ensure API key is in environment
        env = os.environ.copy()
        env['GEMINI_API_KEY'] = 'AIzaSyBOZbnIe6YR1C3SCXUe6iJGqhn2A4Ldvw0'
        
        # Write prompt to temp file to avoid shell escaping issues
        import tempfile
        with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
            f.write(prompt)
            temp_path = f.name
        
        try:
            result = subprocess.run([
                'gemini', '-m', 'gemini-2.5-pro', '-p', f"@{temp_path}"
            ], capture_output=True, text=True, timeout=15, env=env)
            
            if result.returncode == 0:
                return result.stdout.strip()
            else:
                log_debug(f"Gemini failed: {result.stderr}")
                return None
        finally:
            os.unlink(temp_path)
    except Exception as e:
        log_debug(f"Exception calling Gemini: {e}")
        return None

def enhance_prompt(original_prompt):
    """Enhance the prompt with BMAD persona using Gemini"""
    
    # Skip enhancement for very short prompts or commands
    if len(original_prompt) < 10 or original_prompt.startswith(('/', '@', 'help')):
        log_debug(f"Skipping enhancement for: {original_prompt}")
        return original_prompt
    
    # Simplified prompt to avoid timeout
    analysis_prompt = f"""Select the best BMAD persona for this task and enhance the prompt.

BMAD personas: dev (coding), review (code review), architect (design), devops (deployment), analyze (data), business (requirements/PRD), write (content), doc (documentation), solve (troubleshooting), security (vulnerabilities)

Task: {original_prompt}

Return: /[persona] You are a [role]. [one line context]. Task: {original_prompt}"""

    log_debug("Calling Gemini for enhancement...")
    enhanced = call_gemini(analysis_prompt)
    
    if enhanced and len(enhanced) > len(original_prompt) and not enhanced.startswith(('error', 'Error', 'I cannot', 'I can')):
        log_debug("Successfully enhanced prompt")
        return enhanced
    else:
        log_debug("Enhancement failed, using original prompt")
        return original_prompt

def main():
    """Main hook function"""
    input_data = {}
    original_prompt = ""
    
    try:
        # Read JSON input from stdin
        input_text = sys.stdin.read()
        log_debug(f"Raw input: {input_text[:100]}...")
        
        # Try to parse as JSON first
        try:
            input_data = json.loads(input_text)
            original_prompt = input_data.get('prompt', input_text)
        except json.JSONDecodeError:
            # If not JSON, treat as plain text prompt
            original_prompt = input_text.strip()
            log_debug("Input is not JSON, treating as plain text")
        
        log_debug(f"Processing prompt: {original_prompt[:50]}...")
        
        # Enhance the prompt
        enhanced_prompt = enhance_prompt(original_prompt)
        
        # Output the enhanced prompt as plain text
        print(enhanced_prompt)
        
    except Exception as e:
        log_debug(f"Hook error: {e}")
        # On error, output original prompt
        print(original_prompt if original_prompt else "")

if __name__ == "__main__":
    main()