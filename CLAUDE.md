# Enhanced BMAD Method with Context Management

This project uses the Enhanced BMAD Method - combining persona-based AI agents with advanced context management, persistent memory, and comprehensive testing orchestration.

## 🚀 Quick Start

### For New Projects
```bash
# Get workflow guidance
Use bmad-orchestrator for workflow guidance

# Or start with specific agent
Use bmad-analyst to research and create project brief
```

### For Existing Projects
```bash
# Initialize BMAD + Context system
Use project-initializer to set up this codebase for AI-enhanced development
```

## 🤖 Agent System Overview

### Core BMAD Agents (Personas)
- **bmad-orchestrator** - Master coordinator with context management
- **bmad-analyst** (Mary) - Business Analyst for research and ideation
- **bmad-pm** (John) - Product Manager for PRDs and user stories
- **bmad-architect** (Winston) - System Architect for technical design
- **bmad-po** (Sarah) - Product Owner for validation and process
- **bmad-sm** (Bob) - Scrum Master for detailed story creation
- **bmad-dev** (James) - Developer for implementation
- **bmad-qa** (Quinn) - QA Engineer for code review
- **bmad-ux** (Sally) - UX Designer for interfaces
- **bmad-devops** (Alex) - DevOps Engineer for infrastructure
- **bmad-tech-writer** (Morgan) - Technical Writer for documentation

### Infrastructure Agents
- **testing-orchestrator** - Comprehensive testing coordination
- **project-initializer** - Project setup and configuration

## 📋 Automatic Agent Selection

When responding to user requests, the appropriate BMAD agent is automatically selected:

### Planning & Analysis Tasks
- **Market research, competitive analysis, brainstorming** → `bmad-analyst` (Mary)
- **Creating PRDs, epics, user stories** → `bmad-pm` (John)
- **System design, architecture decisions** → `bmad-architect` (Winston)
- **Document validation, sharding, process integrity** → `bmad-po` (Sarah)

### Development Tasks
- **Creating detailed development stories** → `bmad-sm` (Bob)
- **Code implementation, debugging, testing** → `bmad-dev` (James)
- **Code review, quality assurance** → `bmad-qa` (Quinn)

### Quality Assurance
- **Comprehensive testing orchestration** → `testing-orchestrator`
- **Code quality review** → `bmad-qa` (Quinn)

### Supporting Tasks
- **UI/UX design, wireframes, mockups** → `bmad-ux` (Sally)
- **CI/CD pipelines, deployment setup** → `bmad-devops` (Alex)
- **API documentation, user guides** → `bmad-tech-writer` (Morgan)

### Coordination & Setup
- **Workflow guidance, agent selection help** → `bmad-orchestrator`
- **Project initialization** → `project-initializer`

## 🔄 Enhanced Workflow

### Phase 1: Planning (Web UI)
1. **Research & Ideation** → bmad-analyst creates project brief
2. **Product Definition** → bmad-pm creates PRD and stories
3. **Architecture Design** → bmad-architect designs system
4. **Validation** → bmad-po ensures alignment

### Phase 2: Development (IDE)
1. **Story Preparation** → bmad-sm creates detailed stories
2. **Implementation** → bmad-dev writes code
3. **Quality Review** → bmad-qa reviews implementation
4. **Testing** → testing-orchestrator runs comprehensive tests

### Phase 3: Deployment
1. **Infrastructure** → bmad-devops sets up CI/CD
2. **Documentation** → bmad-tech-writer creates docs

## 🧠 Context Management System

### Persistent Memory
Each agent maintains context in `.claude/context/`:
- Research findings and market analysis (Mary)
- Product decisions and PRD history (John)
- Architecture choices and patterns (Winston)
- Validation results and process checks (Sarah)
- Story templates and sprint history (Bob)
- Code patterns and implementation notes (James)
- Review patterns and quality metrics (Quinn)

### Directory Structure
```
.claude/
├── agents/              # BMAD agent definitions
├── context/             # Persistent agent contexts
├── test-specs/          # Testing specifications
├── workflows/           # Workflow documentation
├── agent-analytics/     # Performance metrics
├── templates/           # Reusable patterns
└── commands/            # Utility scripts
```

## 🎮 Orchestrator Commands

The bmad-orchestrator supports these commands:
- `*help` - Show available agents and workflows
- `*agent [name]` - Transform into specific agent
- `*workflow-guidance` - Get workflow recommendations
- `*context-status` - View context files and health
- `*agent-health` - Display performance metrics
- `*test-orchestrate` - Start comprehensive testing
- `*init-project` - Initialize project with BMAD
- `*create-agent [type] [name]` - Create specialized agent

## 🧪 Testing Integration

### Comprehensive Testing
The testing-orchestrator coordinates:
- Unit Tests (component validation)
- Integration Tests (API/service testing)
- Workflow Tests (end-to-end validation)
- Performance Tests (speed and resources)
- Accessibility Tests (WCAG compliance)
- Console Monitoring (zero errors policy)

### Testing Workflow
1. Developer completes implementation
2. Creates testing handoff document
3. Testing orchestrator analyzes changes
4. Runs comprehensive test suite
5. Provides quality gate decision

## 📊 Agent Health Monitoring

### Performance Tracking
- Usage frequency and success rates
- Average task completion times
- Context freshness and quality
- Cross-agent collaboration efficiency

### Dynamic Agent Creation
When patterns emerge:
- Orchestrator detects repeated needs
- Creates specialized connector agents
- Optimizes workflow efficiency
- Preserves knowledge in templates

## 🔧 Advanced Features

### Cross-Project Learning
- Successful patterns saved to templates
- Knowledge preserved when agents retire
- Patterns shared across projects
- Continuous improvement loop

### Tmux Integration
For persistent, autonomous operation:
- `.claude/commands/start-bmad-project.sh` - Start with tmux layout
- `.claude/commands/schedule-check-in.sh` - Schedule agent tasks
- `.claude/commands/send-agent-message.sh` - Inter-agent messaging

### Git Integration
- Development agents follow 30-minute commit rule
- Automatic work preservation
- Clear commit messages with context

## 📚 Best Practices

1. **Start with Context**: Use project-initializer for existing projects
2. **Follow the Flow**: Planning → Development → Testing → Deployment
3. **Trust the Process**: Let agents handle their expertise areas
4. **Review Results**: Check context files and test reports
5. **Iterate Efficiently**: Use test feedback to guide improvements

## 🚨 Important Notes

- All agent commands start with `*` when using orchestrator
- Agents maintain specific personas and expertise
- Context persists across sessions automatically
- Testing is comprehensive and mandatory
- Console errors block deployment

## 🎯 Example Usage

```bash
# Start a new feature
"Help me add user authentication to my app"
→ Orchestrator coordinates: Analyst → PM → Architect → Dev → QA → Testing

# Quick implementation
"Implement a REST API for user profiles"
→ Goes directly to Dev (James) for implementation

# Quality check
"Review and test the authentication system"
→ QA (Quinn) + Testing Orchestrator for comprehensive validation
```

This enhanced system combines the best of both worlds: familiar BMAD personas with advanced infrastructure for persistent memory, comprehensive testing, and continuous improvement.