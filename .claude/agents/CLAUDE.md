# Enhanced BMAD Method Agents Directory

This directory contains Enhanced BMAD Method agents - combining persona-based AI agents with advanced context management, persistent memory, and comprehensive testing orchestration.

## 📁 Agent Files

### Core BMAD Agents (Personas)
- `bmad-orchestrator.md` - Master coordinator with context management
- `bmad-analyst.md` - Business Analyst (Mary)
- `bmad-pm.md` - Product Manager (John)
- `bmad-architect.md` - System Architect (Winston)
- `bmad-po.md` - Product Owner (Sarah)
- `bmad-sm.md` - Scrum Master (Bob)
- `bmad-dev.md` - Developer (James)
- `bmad-qa.md` - QA Engineer (Quinn)
- `bmad-ux.md` - UX Designer (Sally)
- `bmad-devops.md` - DevOps Engineer (Alex)
- `bmad-tech-writer.md` - Technical Writer (Morgan)

### Infrastructure Agents
- `testing-orchestrator.md` - Comprehensive testing coordination
- `project-initializer.md` - Project setup and configuration

## 🚀 Agent Invocation

Agents can be invoked in multiple ways:
1. **Automatically** - Claude Code selects based on task description
2. **Explicitly** - Using Task tool with `subagent_type` parameter
3. **Via Orchestrator** - Using `*agent [name]` command
4. **Direct** - "Use bmad-analyst to research competitors"

## 🔄 Enhanced Workflow

### Planning Phase (Web UI)
1. `bmad-analyst` - Research and project brief
2. `bmad-pm` - PRD and user stories
3. `bmad-architect` - Technical architecture
4. `bmad-po` - Validation and alignment

### Development Phase (IDE)
1. `bmad-sm` - Detailed story creation
2. `bmad-dev` - Implementation
3. `bmad-qa` - Code review
4. `testing-orchestrator` - Comprehensive testing

### Supporting Roles (as needed)
- `bmad-ux` - UI/UX design
- `bmad-devops` - Infrastructure and CI/CD
- `bmad-tech-writer` - Documentation
- `project-initializer` - Project setup

## 🧠 Context Management

Each agent maintains persistent context in `.claude/context/`:
- `mary-analyst-context.md` - Research and insights
- `john-pm-context.md` - Product decisions
- `winston-architect-context.md` - Architecture patterns
- `sarah-po-context.md` - Validation results
- `bob-sm-context.md` - Story templates
- `james-dev-context.md` - Code patterns
- `quinn-qa-context.md` - Review patterns

## 📊 Agent Communication

### Enhanced Communication Channels
1. **File Artifacts** - PRDs, stories, code, test reports
2. **Context Files** - Persistent memory across sessions
3. **Workflow State** - Tracked in `.claude/workflow-state.md`
4. **Test Handoffs** - Structured testing requirements
5. **Health Metrics** - Performance tracking

### Testing Integration
- Development agents create `.claude/test-specs/testing-handoff.md`
- Testing orchestrator reads handoff and executes comprehensive tests
- Results stored in `.claude/test-reports/`
- Quality gate decisions block or approve deployment

## 🔧 Adding New Agents

### Manual Creation
1. Create `.md` file with YAML frontmatter:
   ```yaml
   ---
   name: agent-name
   description: Clear description of when to use this agent
   tools: Read, Write, Edit, Task, TodoWrite
   ---
   ```
2. Write detailed system prompt
3. Follow BMAD persona conventions
4. Create context file in `.claude/context/`

### Dynamic Creation
Use orchestrator command: `*create-agent [type] [name]`
- Automatically detects repeated patterns
- Creates specialized connector agents
- Initializes context and documentation

## 📈 Agent Health Monitoring

The orchestrator tracks agent performance:
- Usage frequency
- Success rates
- Task completion times
- Context freshness
- Collaboration patterns

Health status indicators:
- 🟢 **Healthy** - >90% success, regular usage
- 🟡 **Monitor** - 70-90% success, declining usage
- 🔴 **Action Needed** - <70% success, rare usage

## 🎯 Agent Capabilities

### Enhanced Orchestrator
- Coordinates all workflows
- Manages persistent context
- Monitors agent health
- Creates agents dynamically
- Handles testing orchestration

### Planning Agents
- Create comprehensive documentation
- Conduct research with persistent findings
- Define architecture with pattern library
- Validate alignment with process memory

### Development Agents
- Transform stories into code
- Maintain code pattern library
- Provide reviews with historical context
- Ensure architectural compliance

### Infrastructure Agents
- Comprehensive testing orchestration
- Project initialization and setup
- Cross-project learning
- Performance optimization

## 📝 Best Practices

1. **Let Agents Load Context** - They automatically read their context files
2. **Update Context After Tasks** - Agents should update their memory
3. **Use Testing Handoffs** - Structured communication for QA
4. **Monitor Health Metrics** - Check agent performance regularly
5. **Trust Agent Expertise** - Let each agent handle their domain

## 🚨 Important Notes

- Agents use Markdown with YAML frontmatter (not JSON)
- Context persists in `.claude/context/` automatically
- Testing is comprehensive and mandatory
- Console errors block deployment
- Agents can be retired with knowledge preservation