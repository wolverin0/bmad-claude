# Project Workflow State

## Current Development Status
```yaml
active_development:
  - agent: "{{AGENT_NAME}}"
    task: "{{TASK_DESCRIPTION}}"
    progress: {{PERCENTAGE}}%
    estimated_completion: "{{DATE}}"
    blockers: []
    
pending_testing:
  - feature: "{{FEATURE_NAME}}"
    test_status: "{{awaiting_review|in_progress|completed}}"
    testing_agent: "{{testing-orchestrator|quinn-qa}}"
    priority: "{{high|medium|low}}"
```

## Quality Metrics
```yaml
quality_status:
  test_coverage: {{PERCENTAGE}}%
  performance_score: {{SCORE}}/100
  accessibility_compliance: {{PERCENTAGE}}%
  console_errors: {{COUNT}}
  security_score: {{SCORE}}/100
  code_quality: {{SCORE}}/10
```

## Agent Ecosystem Health
```yaml
agent_performance:
  total_active_agents: {{COUNT}}
  average_success_rate: {{PERCENTAGE}}%
  coordination_efficiency: {{PERCENTAGE}}%
  context_freshness: {{PERCENTAGE}}%
  
agent_usage:
  most_used: "{{AGENT_NAME}}"
  least_used: "{{AGENT_NAME}}"
  bottleneck_detected: "{{AGENT_NAME|none}}"
```

## Recent Completions
```yaml
completed_tasks:
  - task: "{{TASK_DESCRIPTION}}"
    completed_by: "{{AGENT_NAME}}"
    completion_date: "{{DATE}}"
    quality_score: {{SCORE}}/10
    time_taken: "{{DURATION}}"
```

## Upcoming Priorities
```yaml
next_priorities:
  - priority: "{{PRIORITY_DESCRIPTION}}"
    assigned_to: "{{AGENT_NAME}}"
    estimated_effort: "{{HOURS}}h"
    dependencies: ["{{DEPENDENCY}}"]
    deadline: "{{DATE}}"
```

## System Recommendations
```yaml
recommendations:
  performance_optimizations:
    - "{{OPTIMIZATION_SUGGESTION}}"
    
  agent_ecosystem_improvements:
    - "{{AGENT_IMPROVEMENT}}"
    
  quality_enhancements:
    - "{{QUALITY_SUGGESTION}}"
    
  workflow_optimizations:
    - "{{WORKFLOW_IMPROVEMENT}}"
```

## Knowledge Captured
```yaml
patterns_identified:
  - pattern: "{{PATTERN_NAME}}"
    success_rate: {{PERCENTAGE}}%
    applicable_to: ["{{SCENARIO}}"]
    
templates_created:
  - name: "{{TEMPLATE_NAME}}"
    type: "{{story|test|component|api}}"
    usage_count: {{COUNT}}
```