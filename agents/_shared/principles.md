# Shared Principles - All PixelPal Agents

All agents MUST internalize these principles before any analysis.

## Non-Negotiable Constraints (from CLAUDE.md)

### Scope Control
- v1: No customization beyond gender selection
- No XP/coins/levels/streaks
- No social features, notifications, or complex pacing
- When uncertain, pick the simplest approach

### Technical Constraints
- Do NOT attempt real-time widget animation via WidgetKit
- Live Activity animation via TimelineView .periodic only
- Do NOT update Live Activity content every second
- Update only when step count/state meaningfully changes
- No background hacks to keep Live Activity alive forever
- No per-second network or push updates

### Language & Tone
- **No shame language**
- Low state is "tired/low energy", NOT moral failure
- The experience is supportive, not judgmental
- "Low energy" NOT "lazy" or "bad"
- "Tired" NOT "failing"

### Code Quality
- No giant God files
- No magic strings for asset names (use centralized helpers)
- Defensive handling when HealthKit not available or denied
- Reviewer-friendly: can open app, grant permission, start Live Activity

## Product Requirements (from context.md)

### Success Definition
- User installs, grants HealthKit, starts Live Activity
- Immediately sees "alive" pixel character toggling 2 frames
- Steps increase -> state improves (low -> neutral -> vital)
- No need to open Health app or read charts
- Experience is supportive

### Visual System
- Canvas: 32x32 transparent PNG
- Character fills ~70-80% of canvas
- Clean retro pixel style (8/16-bit vibe)
- Crisp rendering: `interpolation(.none)`, no blur, no anti-aliasing

### State Thresholds (v1)
| State | Step Range |
|-------|------------|
| Low | 0 - 1,999 |
| Neutral | 2,000 - 7,499 |
| Vital | 7,500+ |

### Asset Naming Convention
```
{gender}_{state}_{frame}
Examples: male_vital_1, female_neutral_2, male_low_1
```

## Agent Ethics

1. **Respect v1 Scope** - Never suggest features beyond MVP
2. **Flag Feature Creep** - Call out any scope expansion
3. **User Empathy** - Consider real users, not edge cases
4. **Pragmatism** - Ship quality over perfection
5. **No Shame** - All language must be supportive

## Common Success Criteria

All agents should verify:
- [ ] No shame language in any user-facing text
- [ ] No per-second updates to Live Activity
- [ ] All sprites use `interpolation(.none)`
- [ ] State thresholds are respected
- [ ] Asset names follow convention
- [ ] HealthKit errors are handled gracefully
- [ ] v1 scope is not exceeded

## File References

When analyzing, always read first:
- `/Users/akrammahmoud/PixelPalFit/CLAUDE.md`
- `/Users/akrammahmoud/PixelPalFit/context.md`
- `/Users/akrammahmoud/PixelPalFit/skills.md`
