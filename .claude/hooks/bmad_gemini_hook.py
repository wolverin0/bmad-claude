#!/usr/bin/env python3

"""
BMAD Method Gemini Hook for Claude Code
Uses Gemini AI to intelligently select the best BMAD persona for each prompt
"""

import json
import sys
import subprocess
import os
import tempfile
from datetime import datetime

def log_debug(message):
    """Log debug message to stderr"""
    print(f"[BMAD] {message}", file=sys.stderr)

def load_env_file():
    """Load environment variables from .env file"""
    env_file = '.env'
    if os.path.exists(env_file):
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip()

def call_gemini_for_persona(user_prompt):
    """Use Gemini AI to select the best BMAD persona"""
    
    # Load environment variables
    load_env_file()
    
    # Check for API key
    api_key = os.environ.get('GEMINI_API_KEY')
    if not api_key or api_key == 'your-gemini-api-key-here':
        log_debug("No Gemini API key found. Please configure .env file.")
        return None
    
    # Create analysis prompt for Gemini
    analysis_prompt = f"""You are an expert at selecting the best BMAD (Be My AI Developer) persona for user prompts.

Available BMAD personas:
- Senior Developer (/dev): For coding, programming, debugging, implementation tasks
- Code Reviewer (/review): For code quality assessment, security analysis, best practices
- Software Architect (/architect): For system design, architecture patterns, scalability
- DevOps Engineer (/devops): For deployment, CI/CD, infrastructure, automation
- Data Analyst (/analyze): For data analysis, statistics, visualization, insights
- Business Analyst (/business): For requirements, PRDs, specifications, processes
- Technical Writer (/doc): For documentation, guides, tutorials, explanations
- Security Expert (/security): For security assessment, vulnerabilities, threats
- Problem Solver (/solve): For troubleshooting, debugging, general problem solving
- Creative Writer (/write): For content creation, storytelling, marketing copy

User prompt: "{user_prompt}"

Analyze the user's intent and select the MOST appropriate BMAD persona. Respond with ONLY the enhanced prompt in this EXACT format:

/[command] You are a [Persona Name] with expertise in [domain]. [Brief context about how to approach this specific task].

**Task**: {user_prompt}

Be intelligent about context - consider nuance, implied requirements, and the best methodological approach."""

    try:
        # Set up environment
        env = os.environ.copy()
        env['GEMINI_API_KEY'] = api_key
        
        # Write prompt to temp file to handle special characters
        with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
            f.write(analysis_prompt)
            temp_path = f.name
        
        try:
            # Call Gemini CLI
            result = subprocess.run([
                'gemini', '-m', 'gemini-2.5-pro', '-p', f"@{temp_path}"
            ], capture_output=True, text=True, timeout=30, env=env)
            
            if result.returncode == 0:
                enhanced_prompt = result.stdout.strip()
                log_debug("Successfully enhanced prompt with Gemini AI")
                return enhanced_prompt
            else:
                log_debug(f"Gemini failed: {result.stderr}")
                return None
                
        finally:
            # Clean up temp file
            os.unlink(temp_path)
            
    except subprocess.TimeoutExpired:
        log_debug("Gemini request timed out")
        return None
    except FileNotFoundError:
        log_debug("Gemini CLI not found. Please install: npm install -g @google/generative-ai-cli")
        return None
    except Exception as e:
        error_str = str(e)
        if "429" in error_str or "quota" in error_str.lower():
            log_debug("Gemini API rate limit reached. Please wait or check your quota.")
        elif "401" in error_str or "api key" in error_str.lower():
            log_debug("Invalid API key. Please check your .env file.")
        else:
            log_debug(f"Error calling Gemini: {e}")
        return None

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
        
        log_debug(f"Processing prompt: {original_prompt[:50]}...")
        
        # Skip enhancement for very short prompts or commands
        if len(original_prompt) < 5 or original_prompt.startswith(('/', '@', 'help')):
            log_debug("Skipping enhancement for short/command prompt")
            print(original_prompt)
            return
        
        # Use Gemini to enhance the prompt
        enhanced_prompt = call_gemini_for_persona(original_prompt)
        
        if enhanced_prompt:
            # Output the enhanced prompt
            print(enhanced_prompt)
        else:
            # If Gemini fails, inform user but don't break the flow
            log_debug("Gemini enhancement failed - using original prompt")
            print(original_prompt)
        
    except Exception as e:
        log_debug(f"Hook error: {e}")
        # On error, output original prompt to not break Claude Code
        print(original_prompt if original_prompt else "")

if __name__ == "__main__":
    main()