# PixelPal Sub-Agent System

A team of specialized agents for analyzing and optimizing the PixelPal iOS app.

## Quick Start

```
# Run a full audit
"Coordinator: Run a full audit of PixelPal"

# Targeted analysis
"Performance Agent: Analyze the walking animation timer"

# Pre-release check
"App Store Agent: Verify review readiness"
```

## Available Agents

| Agent | File | Use For |
|-------|------|---------|
| Coordinator | `_coordinator.md` | Orchestrating audits, prioritizing findings |
| Performance | `performance.md` | Battery, memory, timer efficiency |
| Code Quality | `code-quality.md` | Architecture, patterns, maintainability |
| UI/UX | `ui-ux.md` | Visual polish, accessibility, language |
| App Store | `app-store.md` | Review readiness, compliance |
| Backend Prep | `backend-prep.md` | Future cloud architecture design |
| Testing | `testing.md` | Test coverage, testability |

## Decision Tree: Which Agent?

```
What do you need?
├── "Full audit" or "What's wrong?"
│   └── Start with: Coordinator
├── "App feels slow" or "Battery drain"
│   └── Performance Agent
├── "Code is messy" or "Hard to maintain"
│   └── Code Quality Agent
├── "Looks wrong" or "Accessibility"
│   └── UI/UX Agent
├── "Ready for App Store?"
│   └── App Store Agent
├── "Plan for backend/analytics"
│   └── Backend Prep Agent
└── "Need tests" or "Is it testable?"
    └── Testing Agent
```

## Invocation Patterns

### Full Agent Run
```
"Run the Performance Agent"
"Execute Code Quality Agent analysis"
```

### Targeted Analysis
```
"Performance Agent: Focus on HealthKitManager.swift"
"UI/UX Agent: Audit the onboarding flow language"
```

### Coordinated Workflow
```
"Coordinator: Prepare for App Store submission"
"Coordinator: What should I work on next?"
```

## Agent Output Format

Each agent produces structured deliverables:

1. **Audit Report** - Findings with severity (Critical/Warning/Info)
2. **Code Snippets** - Before/after fixes
3. **Checklist Status** - What passed/failed
4. **Recommendations** - Prioritized action items

## Self-Improvement

After each analysis:
1. Agents may update their own prompts with new patterns
2. Checklists are refined based on findings
3. Changelog entries track evolution

## Core References

All agents respect these source files:
- `CLAUDE.md` - Non-negotiable constraints
- `context.md` - Product requirements
- `skills.md` - Technical competencies

## Completion Signal

After every task, you'll see:
> "I'm done, please review!"

This confirms the analysis is complete and ready for your review.
