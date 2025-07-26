# Testing Handoff Document

## Development Completion Details
```yaml
development_summary:
  agent: "{{DEVELOPMENT_AGENT_NAME}}"
  feature: "{{FEATURE_DESCRIPTION}}"
  pr_number: "{{PR_NUMBER}}"
  completion_date: "{{DATE}}"
  
implementation_scope:
  story_id: "{{STORY_ID}}"
  epic: "{{EPIC_NAME}}"
  components_affected: ["{{COMPONENT}}"]
```

## Changes Made
```yaml
files_changed:
  added:
    - path: "{{FILE_PATH}}"
      purpose: "{{WHY_ADDED}}"
      
  modified:
    - path: "{{FILE_PATH}}"
      changes: "{{WHAT_CHANGED}}"
      
  deleted:
    - path: "{{FILE_PATH}}"
      reason: "{{WHY_DELETED}}"
```

## Testing Requirements
```yaml
test_requirements:
  critical_paths:
    - name: "{{PATH_NAME}}"
      description: "{{PATH_DESCRIPTION}}"
      priority: "{{critical|high|medium}}"
      
  edge_cases:
    - scenario: "{{EDGE_CASE_SCENARIO}}"
      expected_behavior: "{{EXPECTED_RESULT}}"
      
  regression_areas:
    - area: "{{AFFECTED_AREA}}"
      reason: "{{WHY_MIGHT_BREAK}}"
```

## Performance Targets
```yaml
performance_requirements:
  page_load:
    target: "{{MS}}ms"
    current: "{{MS}}ms"
    
  api_response:
    endpoint: "{{ENDPOINT}}"
    target: "{{MS}}ms"
    
  memory_usage:
    limit: "{{MB}}MB"
    baseline: "{{MB}}MB"
```

## Accessibility Requirements
```yaml
accessibility_checklist:
  - [ ] Keyboard navigation implemented
  - [ ] Screen reader labels added
  - [ ] Color contrast ratios meet WCAG AA
  - [ ] Focus indicators visible
  - [ ] Error messages are descriptive
  - [ ] Form fields have proper labels
```

## Integration Points
```yaml
external_dependencies:
  apis:
    - name: "{{API_NAME}}"
      endpoints: ["{{ENDPOINT}}"]
      
  services:
    - name: "{{SERVICE_NAME}}"
      integration_type: "{{TYPE}}"
      
  databases:
    - name: "{{DB_NAME}}"
      operations: ["{{OPERATION}}"]
```

## Known Issues
```yaml
known_limitations:
  - issue: "{{ISSUE_DESCRIPTION}}"
    workaround: "{{WORKAROUND}}"
    planned_fix: "{{WHEN}}"
```

## Test Data Requirements
```yaml
test_data:
  required_fixtures:
    - name: "{{FIXTURE_NAME}}"
      location: "{{PATH}}"
      
  test_accounts:
    - role: "{{USER_ROLE}}"
      credentials: "{{HOW_TO_ACCESS}}"
      
  sample_data:
    - type: "{{DATA_TYPE}}"
      location: "{{WHERE_TO_FIND}}"
```

## Documentation Updates
```yaml
documentation:
  updated:
    - "{{DOC_NAME}}"
    
  needs_update:
    - "{{DOC_NAME}}"
    
  new_required:
    - "{{WHAT_NEEDS_DOCUMENTING}}"
```

## Success Criteria
```yaml
acceptance_criteria:
  functional:
    - "{{CRITERIA}}"
    
  non_functional:
    - "{{CRITERIA}}"
    
  user_experience:
    - "{{CRITERIA}}"
```

## Notes for Testing Team
{{ADDITIONAL_CONTEXT_OR_SPECIAL_INSTRUCTIONS}}