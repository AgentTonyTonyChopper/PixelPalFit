# Context — Pixel Pal v1 (Deep Spec)

## One sentence
A tiny pixel "trainer buddy" that lives in your Dynamic Island/Lock Screen and reflects your daily movement momentum via posture and a simple two-frame "breathing" toggle.

## The objective (what success looks like)
- User installs, grants HealthKit, starts Live Activity.
- Immediately sees an "alive" pixel character toggling 2 frames.
- Steps increase -> state eventually improves (low -> neutral -> vital).
- User does NOT need to open the Health app or read charts.
- The experience is supportive, not shameful.

## Scope boundaries
### v1 includes
- 2 gender options: male/female (selection only)
- 3 states: vital / neutral / low
- 2 frames per state (breathing toggle)
- HealthKit today steps
- Live Activity with Dynamic Island + Lock Screen UI
- Shared store (App Group) so widget/extension can read state
- Minimal in-app UI: onboarding + enable live activity + current snapshot

### v1 explicitly excludes
- Customization (hair, outfits, palettes)
- XP/coins/levels/streaks
- Social features
- Notifications
- Complex pacing/baseline logic
- Always-on "forever" background behavior

## Platform reality
- WidgetKit is not for continuous animation. It's snapshot-based and OS-throttled.
- The "penguin toggling frames at the top" behavior is achieved via Live Activity UI with local SwiftUI timing (TimelineView periodic). That is the target.

## Visual system
### Sprite rules
- Canvas: 32x32
- Transparent PNG
- Character fills ~70–80% of canvas
- Clean retro pixel style (8/16-bit vibe), limited palette
- Crisp rendering: no blur, no anti-aliasing

### Gender differentiation
- Same skeleton and proportions across genders and states
- Differences limited to hair silhouette and clothing outline
- No sexualization, no exaggerated anatomy

### State design (no shame)
- Vital: upright, confident, slightly bouncy
- Neutral: relaxed, steady breathing
- Low: tired posture (slouch/head tilt), not gross or "bad"

## State engine (v1 thresholds)
- low: 0..1999
- neutral: 2000..7499
- vital: 7500+

This is intentionally simple to ship quickly. Later versions can use pace vs time-of-day or baseline trends.

## Asset naming (strict)
male_vital_1.png / male_vital_2.png
male_neutral_1.png / male_neutral_2.png
male_low_1.png / male_low_2.png
female_vital_1.png / female_vital_2.png
female_neutral_1.png / female_neutral_2.png
female_low_1.png / female_low_2.png

In the asset catalog, omit extensions and use names:
male_vital_1, male_vital_2, ...

## Architecture (recommended)
### Targets
- PixelPalApp (SwiftUI app)
- PixelPalWidgetExtension (WidgetKit + ActivityKit)

### Shared storage
- App Group UserDefaults suite
- Store a snapshot struct:
  - steps: Int
  - state: String (vital|neutral|low)
  - gender: String (male|female)
  - updatedAt: Date

### HealthKit flow
- On app launch/on refresh:
  - request permission if needed
  - fetch today steps using HKStatisticsQuery cumulativeSum
  - compute state
  - save snapshot
  - update Live Activity content

### Live Activity animation
- Live Activity content state updates rarely.
- UI toggles frames locally using TimelineView periodic (0.6–1.0 sec).
- Frame selection:
  - based on gender + state + time parity
  - Example: "\(gender)_\(state)_\(frame)" where frame is 1/2

### Home Screen widget (optional v1)
- Reads snapshot from App Group store
- Displays static state (can still use TimelineView, but do not promise always-on animation)
- Conservative refresh schedule (30–60 min)

## Reviewer-proof UX (important)
- Provide a simple "Enable Live Activity" button.
- Provide a "Refresh Steps" button for manual update.
- Display current permission status and last updated time in-app.
- If HealthKit denied: show a clear prompt with instructions.

## Risks & mitigations
- Risk: user expects constant updates -> mitigate with clear copy: "Updates periodically."
- Risk: Live Activity ends -> mitigate with "Restart Pixel Pal" button.
- Risk: sprites look blurry -> mitigate with interpolation(.none) and correct scaling.

## Definition of done
- Works on-device with Dynamic Island (or supported simulator)
- Live Activity shows toggling sprite (2-frame), correct gender, step count
- Step thresholds change the displayed state correctly
- No crashes on permission denial
