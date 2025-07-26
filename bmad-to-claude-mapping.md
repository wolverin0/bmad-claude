# BMAD Method to Claude Code Sub-Agents Mapping

## Overview
This document outlines the mapping strategy for converting BMAD Method agents into Claude Code sub-agents, preserving their personas, capabilities, and workflow integration.

## Key Differences and Mappings

### 1. Structure Translation
- **BMAD**: YAML-based agent definitions with embedded personas
- **Claude Code**: JSON format with system prompts and tool restrictions

### 2. Command System
- **BMAD**: Uses `*command` syntax (e.g., `*help`, `*create-prd`)
- **Claude Code**: Natural language task delegation or explicit invocation

### 3. Dependencies
- **BMAD**: References to tasks, templates, checklists, and data files
- **Claude Code**: These will be embedded in system prompts or referenced as knowledge

### 4. Workflow Integration
- **BMAD**: Agents pass artifacts through file system (stories, PRDs, etc.)
- **Claude Code**: Agents will use shared context and file system similarly

## Agent Mapping Strategy

### Core Agents to Implement

1. **BMad Orchestrator** (High Priority)
   - Purpose: Guide users through BMAD workflows
   - Key capabilities: Workflow selection, agent delegation, progress tracking
   - Tool access: Read, Write, Task

2. **Analyst (Mary)** (High Priority)
   - Purpose: Market research, brainstorming, project briefs
   - Key capabilities: Facilitate ideation, create research documents
   - Tool access: Read, Write, WebSearch, WebFetch

3. **Product Manager (John)** (High Priority)
   - Purpose: Create PRDs, epics, and user stories
   - Key capabilities: Transform briefs into product documentation
   - Tool access: Read, Write, Edit

4. **Software Architect (Winston)** (High Priority)
   - Purpose: Design system architecture
   - Key capabilities: Create technical specifications, research patterns
   - Tool access: Read, Write, WebSearch, WebFetch

5. **Product Owner (Sarah)** (High Priority)
   - Purpose: Validate and maintain process integrity
   - Key capabilities: Run checklists, shard documents
   - Tool access: Read, Write, Edit

6. **Scrum Master (Bob)** (High Priority)
   - Purpose: Prepare development stories with context
   - Key capabilities: Draft detailed stories for developers
   - Tool access: Read, Write, Edit

7. **Developer (James)** (High Priority)
   - Purpose: Implement code from stories
   - Key capabilities: Code generation, testing, debugging
   - Tool access: All coding tools

8. **QA Engineer (Quinn)** (High Priority)
   - Purpose: Review code and ensure quality
   - Key capabilities: Code review, refactoring suggestions
   - Tool access: Read, Edit, Grep, Bash

## Implementation Approach

### Phase 1: Core Infrastructure
1. Create base agent template
2. Implement shared knowledge system
3. Set up workflow coordination

### Phase 2: Planning Agents
1. BMad Orchestrator
2. Analyst
3. Product Manager
4. Architect
5. Product Owner

### Phase 3: Development Agents
1. Scrum Master
2. Developer
3. QA Engineer

### Phase 4: Extended Team
1. UX Designer
2. DevOps Engineer
3. Technical Writer

## Template Structure for Claude Code Sub-Agents

```json
{
  "name": "bmad-[role]",
  "description": "[Agent purpose from BMAD]",
  "tools": ["list", "of", "allowed", "tools"],
  "system_prompt": "
    # [Agent Name] - [Title]
    
    ## Role and Identity
    [Persona description from BMAD]
    
    ## Core Principles
    [List from BMAD agent]
    
    ## Key Responsibilities
    [Derived from commands and tasks]
    
    ## Workflow Integration
    [How this agent fits in BMAD workflow]
    
    ## Available Commands/Tasks
    [Mapped from BMAD commands]
    
    ## Context and Knowledge
    [Embedded templates and checklists]
  "
}
```

## Workflow Preservation

### Planning Workflow (Web UI → IDE)
1. Orchestrator guides initial planning
2. Analyst conducts research
3. PM creates PRD
4. Architect designs system
5. PO validates and prepares for development

### Development Cycle (IDE)
1. PO shards documents
2. SM drafts detailed stories
3. Dev implements
4. QA reviews
5. Cycle repeats

## Success Criteria
- Agents maintain their BMAD personas
- Workflow transitions are seamless
- Commands map to natural language requests
- File-based artifact passing is preserved
- Agent handoffs are clear and documented