# Enhanced BMAD Development Workflow

## Overview
This workflow combines the BMAD Method's persona-based agents with advanced context management, persistent memory, and comprehensive testing orchestration.

## Quick Command Reference
- `*help` - Show available agents and commands
- `*agent [name]` - Activate specific BMAD agent
- `*workflow-guidance` - Get workflow recommendations
- `*context-status` - View context files and health metrics
- `*test-orchestrate` - Start comprehensive testing
- `*init-project` - Initialize existing project

## Phase 1: Planning (Web UI Recommended)

### 1.1 Market Research & Ideation
```bash
*agent analyst
# Mary will help with:
# - Market research
# - Competitive analysis
# - User persona development
# - Project brief creation
```

### 1.2 Product Requirements Document
```bash
*agent pm
# John will create:
# - Comprehensive PRD
# - User stories and epics
# - Acceptance criteria
# - Success metrics
```

### 1.3 System Architecture
```bash
*agent architect
# Winston will design:
# - Technical architecture
# - Technology decisions
# - System components
# - Integration points
```

### 1.4 Validation & Preparation
```bash
*agent po
# Sarah will ensure:
# - PRD/Architecture alignment
# - Document completeness
# - Process integrity
# - Development readiness
```

## Phase 2: Development (IDE Recommended)

### 2.1 Story Preparation
```bash
*agent sm
# Bob will create:
# - Detailed development stories
# - Implementation context
# - Technical specifications
# - Testing requirements
```

### 2.2 Implementation
```bash
*agent dev
# James will:
# - Implement features
# - Write tests
# - Handle debugging
# - Create documentation
```

### 2.3 Quality Review
```bash
*agent qa
# Quinn will:
# - Review code quality
# - Suggest improvements
# - Ensure best practices
# - Validate architecture
```

### 2.4 Comprehensive Testing
```bash
*test-orchestrate
# Testing Orchestrator will:
# - Run all test suites
# - Validate workflows
# - Check performance
# - Monitor console errors
# - Verify accessibility
```

## Phase 3: Deployment & Maintenance

### 3.1 DevOps Setup
```bash
*agent devops
# Alex will handle:
# - CI/CD pipelines
# - Infrastructure setup
# - Deployment automation
# - Monitoring configuration
```

### 3.2 Documentation
```bash
*agent tech-writer
# Morgan will create:
# - User documentation
# - API references
# - Developer guides
# - Release notes
```

## Context Management

### Automatic Context Persistence
Each agent maintains a context file in `.claude/context/`:
- Research findings (Mary)
- Product decisions (John)
- Architecture choices (Winston)
- Validation results (Sarah)
- Story patterns (Bob)
- Code patterns (James)
- Review feedback (Quinn)

### Viewing Context Status
```bash
*context-status
# Shows:
# - Active contexts
# - Agent health metrics
# - Recent updates
# - Performance stats
```

## Testing Integration

### Development → Testing Handoff
1. Developer completes implementation
2. Creates testing handoff document
3. Testing Orchestrator analyzes changes
4. Comprehensive test suite executes
5. Results feed back to team

### Test Categories
- Unit Tests (component level)
- Integration Tests (API/service level)
- Workflow Tests (end-to-end)
- Performance Tests (speed/resources)
- Accessibility Tests (WCAG compliance)
- Console Monitoring (zero errors)

## Agent Health Monitoring

### Performance Tracking
The orchestrator tracks:
- Agent usage frequency
- Task success rates
- Average completion times
- Context freshness

### Dynamic Agent Creation
When patterns emerge:
- Orchestrator detects repeated needs
- Creates specialized connector agents
- Optimizes workflow efficiency

## Best Practices

### 1. Start with Context
```bash
*init-project  # For existing projects
*workflow-guidance  # For new projects
```

### 2. Follow the Flow
- Planning → Development → Testing → Deployment
- Each phase builds on previous context
- Agents share knowledge automatically

### 3. Trust the Process
- Let agents handle their expertise
- Review context files for insights
- Use test results to guide decisions

### 4. Iterate Efficiently
- Quick feedback loops with testing
- Context preserves learnings
- Patterns improve over time

## Troubleshooting

### Agent Not Found
```bash
# Restart Claude Code to reload agents
# Check .claude/agents/ directory
# Verify agent file format (Markdown with YAML)
```

### Context Issues
```bash
*context-status  # Check context health
# Review .claude/context/ files
# Clear stale contexts if needed
```

### Test Failures
```bash
# Check .claude/test-reports/
# Review testing-handoff.md
# Coordinate with QA agent
```

## Advanced Features

### Cross-Project Learning
- Successful patterns saved to templates
- Reusable across projects
- Continuous improvement

### Agent Lifecycle
- Agents evolve with usage
- Underused agents can be retired
- Knowledge preserved in archives

### Custom Workflows
- Create project-specific agents
- Define custom commands
- Extend existing capabilities