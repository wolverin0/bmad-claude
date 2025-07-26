# Enhanced BMAD Method with Context Management for Claude Code

This repository contains the Enhanced BMAD Method - combining persona-based AI agents with advanced context management, persistent memory, and comprehensive testing orchestration for Claude Code.

## 🚀 What's New

The Enhanced BMAD Method integrates:
- **Persistent Context Management** - Agents maintain memory across sessions
- **Comprehensive Testing Orchestration** - Zero-regression development
- **Agent Health Monitoring** - Track performance and optimize workflows
- **Dynamic Agent Creation** - System creates specialized agents as needed
- **Cross-Project Learning** - Knowledge preserved and shared

## 📁 Project Structure

```
.claude/
├── agents/              # Enhanced BMAD agent definitions
├── context/             # Persistent agent memory
├── test-specs/          # Testing specifications
├── workflows/           # Development workflows
├── agent-analytics/     # Performance metrics
├── templates/           # Reusable patterns
└── commands/            # Utility scripts
```

## 🤖 Available Agents

### Core Orchestration
- **bmad-orchestrator** - Master orchestrator with context management, health monitoring, and dynamic agent creation

### Planning Phase Agents (Personas)
- **bmad-analyst** (Mary) - Business Analyst for market research and project briefs
- **bmad-pm** (John) - Product Manager for PRDs and user stories
- **bmad-architect** (Winston) - System Architect for technical design
- **bmad-po** (Sarah) - Product Owner for validation and alignment

### Development Phase Agents
- **bmad-sm** (Bob) - Scrum Master for detailed story creation
- **bmad-dev** (James) - Full Stack Developer for implementation
- **bmad-qa** (Quinn) - QA Architect for code review

### Supporting Agents
- **bmad-ux** (Sally) - UX Designer for interfaces and user experience
- **bmad-devops** (Alex) - DevOps Engineer for infrastructure
- **bmad-tech-writer** (Morgan) - Technical Writer for documentation

### Infrastructure Agents
- **testing-orchestrator** - Comprehensive testing coordination
- **project-initializer** - Set up existing projects with BMAD

## 🚀 Quick Start

### New Projects
```bash
# Start with workflow guidance
Use bmad-orchestrator for workflow guidance

# Or begin with research
Use bmad-analyst to research and create project brief
```

### Existing Projects
```bash
# Initialize BMAD + Context system
Use project-initializer to set up this codebase
```

## 📋 Enhanced Workflow

### Phase 1: Planning (Web UI)
1. **Research** → `bmad-analyst` creates project brief
2. **Product** → `bmad-pm` creates PRD and stories
3. **Architecture** → `bmad-architect` designs system
4. **Validation** → `bmad-po` ensures alignment

### Phase 2: Development (IDE)
1. **Stories** → `bmad-sm` creates detailed stories
2. **Code** → `bmad-dev` implements features
3. **Review** → `bmad-qa` ensures quality
4. **Testing** → `testing-orchestrator` validates everything

### Phase 3: Deployment
1. **Infrastructure** → `bmad-devops` sets up CI/CD
2. **Documentation** → `bmad-tech-writer` creates docs

## 🎮 Orchestrator Commands

The enhanced bmad-orchestrator supports:
- `*help` - Show available agents and workflows
- `*agent [name]` - Transform into specific agent
- `*workflow-guidance` - Get workflow recommendations
- `*context-status` - View agent contexts and health
- `*agent-health` - Display performance metrics
- `*test-orchestrate` - Start comprehensive testing
- `*init-project` - Initialize project with BMAD
- `*create-agent [type] [name]` - Create specialized agent

## 🧠 Context Management

### Persistent Memory
Each agent maintains context files:
- Research findings (Mary)
- Product decisions (John)
- Architecture patterns (Winston)
- Code patterns (James)
- Review feedback (Quinn)

### Agent Health Tracking
```yaml
# .claude/agent-analytics/health-metrics.yaml
agent_health:
  mary-analyst:
    usage_frequency: 12/week
    success_rate: 95%
    health_status: "healthy"
```

## 🧪 Testing Integration

### Comprehensive Coverage
- Unit Tests
- Integration Tests
- Workflow Tests (end-to-end)
- Performance Tests
- Accessibility Tests (WCAG)
- Console Error Monitoring

### Quality Gates
- Zero console errors policy
- Performance budgets enforced
- Accessibility compliance required
- Test coverage thresholds

## 📊 Advanced Features

### Dynamic Agent Creation
The orchestrator monitors patterns and creates specialized agents when needed:
- Connector agents for complex integrations
- Domain specialists for new technologies
- Performance optimizers for bottlenecks

### Cross-Project Learning
- Successful patterns saved as templates
- Knowledge preserved when agents retire
- Best practices shared across projects

### Tmux Integration
For 24/7 autonomous operation:
- `.claude/commands/start-bmad-project.sh`
- `.claude/commands/schedule-check-in.sh`
- `.claude/commands/send-agent-message.sh`

## 🛠️ Installation

1. Claude Code automatically detects agents in `.claude/agents/`
2. Each agent is a Markdown file with YAML frontmatter:

```markdown
---
name: agent-name
description: Agent purpose and capabilities
tools: Read, Write, Edit, Task, TodoWrite
---

Agent system prompt...
```

## 🏃 Usage Examples

### Complete Feature Development
```bash
"Add user authentication to my app"
# Orchestrator coordinates full workflow:
# Analyst → PM → Architect → Dev → QA → Testing
```

### Quick Implementation
```bash
"Implement user profile API"
# Goes directly to Dev (James)
```

### Quality Check
```bash
"Review and test the auth system"
# QA (Quinn) + Testing Orchestrator
```

## 📚 Best Practices

1. **Trust the Process** - Let agents handle their expertise
2. **Review Context** - Check `.claude/context/` for insights
3. **Monitor Health** - Use `*agent-health` regularly
4. **Test Everything** - Comprehensive testing prevents regressions
5. **Learn and Adapt** - System improves with usage

## 🔧 Customization

### Modify Agents
1. Edit files in `.claude/agents/`
2. Adjust prompts for your team
3. Update tool access in frontmatter
4. Add custom commands

### Create New Agents
1. Use `*create-agent` command
2. Or manually create in `.claude/agents/`
3. Follow BMAD persona conventions
4. Initialize context file

## 🚨 Troubleshooting

- **Agent Not Found**: Restart Claude Code to reload
- **Commands Not Working**: Use `*` prefix
- **Context Issues**: Check `.claude/context/`
- **Test Failures**: Review `.claude/test-reports/`

## 🔗 Resources

- [Original BMAD Method](https://github.com/bmadcode/BMAD-METHOD)
- [Claude Code Sub-Agents](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Context Management Patterns](/.claude/workflows/development-workflow.md)

## 📝 Key Differences from Original BMAD

1. **Persistent Memory** - Agents remember across sessions
2. **Health Monitoring** - Track and optimize performance
3. **Dynamic Creation** - System creates agents as needed
4. **Testing Integration** - Comprehensive quality assurance
5. **Cross-Project Learning** - Knowledge preservation

## License

Based on the BMAD Method (MIT License)