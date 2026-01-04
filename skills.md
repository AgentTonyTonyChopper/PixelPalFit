# Skills & Execution Checklist — Pixel Pal v1

This is the minimum competency list to ship the MVP. If a skill isn't required to ship v1, it's postponed.

## iOS Core
- Swift fundamentals (structs/enums, async/await, property wrappers)
- SwiftUI layout basics (HStack/VStack, alignment, sizing)
- State management (State, ObservableObject, AppStorage)

## HealthKit
- Capability setup and permission request
- HKStatisticsQuery for stepCount (cumulativeSum from startOfDay)
- Handling permission denial / no data

## ActivityKit (Live Activities + Dynamic Island)
- ActivityAttributes + ContentState design
- Request/start activity
- Update activity content (best-effort, not frequent)
- Dynamic Island regions (expanded/compact/minimal)
- Local UI animation using TimelineView(.periodic)

## WidgetKit (optional v1)
- TimelineProvider basics
- Reading from App Group UserDefaults
- StaticConfiguration widget view
- Conservative refresh schedule

## Asset pipeline
- Pixel art export: 32x32 PNG transparent
- Consistent naming conventions
- Crisp rendering in SwiftUI: interpolation(.none) + scaledToFit()
- Skeleton alignment across frames

## Entitlements & App review readiness
- HealthKit capability enabled
- App Groups enabled and matching IDs
- Live Activities enabled
- Clear reviewer path inside the app

## Non-technical but required
- Scope control: v1 ships with 12 sprites and 1 onboarding choice
- No shame language, no body-based degradation, only energy/posture changes
- Test on a real iPhone with Dynamic Island (or simulator where supported)

## "Done" definition
- Fresh install -> onboarding -> Health permission -> start Live Activity -> see sprite toggling
- Steps fetched successfully (or graceful empty state)
- Live Activity shows correct gender + state + step count
- Home Screen widget (if included) shows correct snapshot reliably
