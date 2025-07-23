#!/bin/bash

# Test Claude Code Hooks
echo "=== Testing BMAD Hook Enhancement ==="

# Test different prompt types
prompts=(
    "create a user authentication system"
    "review this code for security vulnerabilities"
    "deploy the application to AWS"
    "analyze user engagement metrics"
    "write documentation for the API"
    "fix the database connection bug"
)

for prompt in "${prompts[@]}"; do
    echo -e "\n--- Testing: $prompt ---"
    result=$(echo "{\"prompt\": \"$prompt\"}" | python3 /tmp/bmad_enhance_simple.py 2>&1)
    persona=$(echo "$result" | grep "Selected persona:" | cut -d: -f2)
    command=$(echo "$result" | grep "^/" | head -1 | cut -d' ' -f1)
    echo "Persona:$persona"
    echo "Command: $command"
done