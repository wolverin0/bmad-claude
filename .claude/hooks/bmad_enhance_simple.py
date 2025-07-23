#!/usr/bin/env python3

"""
BMAD Method Enhancement Hook for Claude Code - Simple Version
Uses pattern matching instead of external API calls for reliability
"""

import json
import sys
import re
from datetime import datetime

def log_debug(message):
    """Log debug message to stderr"""
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
    
    # Debug scoring
    log_debug(f"Persona scores: {scores}")
    
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
    
    log_debug(f"Selected persona: {persona['title']}")
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
        
        log_debug(f"Processing: {original_prompt[:50]}...")
        
        # Enhance the prompt
        enhanced_prompt = enhance_prompt(original_prompt)
        
        # Output the enhanced prompt
        print(enhanced_prompt)
        
    except Exception as e:
        log_debug(f"Hook error: {e}")
        # On error, output original prompt
        print(original_prompt if original_prompt else "")

if __name__ == "__main__":
    main()