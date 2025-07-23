#!/bin/bash

# Comprehensive Test Suite for BMAD Claude

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_output="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    echo -n "Testing $test_name... "
    
    if eval "$test_command" | grep -q "$expected_output"; then
        echo -e "${GREEN}✓${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "  Expected: $expected_output"
        echo "  Got: $(eval "$test_command")"
    fi
}

echo -e "${BLUE}=== BMAD Claude Test Suite ===${NC}\n"

# Test 1: Hook Installation
echo -e "${YELLOW}1. Hook Installation Tests${NC}"
run_test "Hook script exists" "test -f .claude/hooks/bmad_enhance_simple.py && echo 'exists'" "exists"
run_test "Hook is executable" "test -x .claude/hooks/bmad_enhance_simple.py && echo 'executable'" "executable"

# Test 2: Persona Selection
echo -e "\n${YELLOW}2. Persona Selection Tests${NC}"
run_test "Dev persona for coding" "echo '{\"prompt\": \"create a function to validate emails\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/dev"
run_test "Business analyst for PRD" "echo '{\"prompt\": \"develop a PRD for mobile app\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/business"
run_test "Security for vulnerabilities" "echo '{\"prompt\": \"check for security vulnerabilities\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/security"
run_test "DevOps for deployment" "echo '{\"prompt\": \"deploy to kubernetes cluster\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/devops"
run_test "Data analyst for metrics" "echo '{\"prompt\": \"analyze user engagement metrics\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/analyze"
run_test "Tech writer for docs" "echo '{\"prompt\": \"write documentation for API\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/doc"
run_test "Architect for design" "echo '{\"prompt\": \"design microservices architecture\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/architect"

# Test 3: Edge Cases
echo -e "\n${YELLOW}3. Edge Case Tests${NC}"
run_test "Short prompt handling" "echo '{\"prompt\": \"hi\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "hi"
run_test "Command prompt skip" "echo '{\"prompt\": \"/help\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "/help"
run_test "Special chars handling" "echo '{\"prompt\": \"test with special @#$ chars\"}' | python3 .claude/hooks/bmad_enhance_simple.py" "Task"

# Test 4: CLI Tools
echo -e "\n${YELLOW}4. CLI Tools Tests${NC}"
if command -v bmad-test &> /dev/null; then
    run_test "bmad-test command" "bmad-test 'create API' 2>/dev/null" "/dev"
else
    echo -e "bmad-test command... ${YELLOW}SKIPPED (not in PATH)${NC}"
fi

if command -v bmad-suggest &> /dev/null; then
    run_test "bmad-suggest command" "bmad-suggest 'review code' 2>&1" "Code Reviewer"
else
    echo -e "bmad-suggest command... ${YELLOW}SKIPPED (not in PATH)${NC}"
fi

# Test 5: Configuration
echo -e "\n${YELLOW}5. Configuration Tests${NC}"
run_test "Claude settings exists" "test -f .claude/settings.json && echo 'exists'" "exists"
run_test "Hook configured in settings" "grep -q 'UserPromptSubmit' .claude/settings.json && echo 'configured'" "configured"
run_test "Python command in settings" "grep -q 'python3' .claude/settings.json && echo 'found'" "found"

# Test 6: Performance
echo -e "\n${YELLOW}6. Performance Tests${NC}"
echo -n "Testing enhancement speed... "
START=$(date +%s.%N)
echo '{"prompt": "create a complex authentication system with OAuth2"}' | python3 .claude/hooks/bmad_enhance_simple.py > /dev/null 2>&1
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
if (( $(echo "$DIFF < 0.1" | bc -l) )); then
    echo -e "${GREEN}✓${NC} (${DIFF}s - excellent)"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${YELLOW}⚠${NC} (${DIFF}s - slow)"
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 7: Error Handling
echo -e "\n${YELLOW}7. Error Handling Tests${NC}"
run_test "Invalid JSON handling" "echo 'not json' | python3 .claude/hooks/bmad_enhance_simple.py" "Task"
run_test "Empty input handling" "echo '' | python3 .claude/hooks/bmad_enhance_simple.py" ""

# Summary
echo -e "\n${BLUE}=== Test Summary ===${NC}"
echo -e "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed. Please check the output above.${NC}"
    exit 1
fi