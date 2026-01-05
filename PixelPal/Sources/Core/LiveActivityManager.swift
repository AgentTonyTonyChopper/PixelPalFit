import ActivityKit
import Foundation

/// Manages the Pixel Pal Live Activity lifecycle.
@MainActor
class LiveActivityManager: ObservableObject {
    /// Whether a Live Activity is currently running.
    @Published var isActive: Bool = false

    /// The current Live Activity instance.
    private var currentActivity: Activity<PixelPalAttributes>?

    /// Timer for animation frame updates.
    private var animationTimer: Timer?

    /// Current animation frame (1 or 2).
    private var currentFrame: Int = 1

    /// Cached state for animation updates.
    private var cachedSteps: Int = 0
    private var cachedState: AvatarState = .neutral
    private var cachedGender: Gender = .male

    init() {
        // Check for any existing activities on launch
        checkForExistingActivity()
    }

    /// Checks if there's an existing Live Activity and restores reference to it.
    private func checkForExistingActivity() {
        if let existing = Activity<PixelPalAttributes>.activities.first {
            self.currentActivity = existing
            self.isActive = true
        }
    }

    /// Starts a new Live Activity with the given state.
    /// - Parameters:
    ///   - steps: Current step count.
    ///   - state: Current avatar state.
    ///   - gender: Selected gender.
    func startActivity(steps: Int, state: AvatarState, gender: Gender) {
        // Check if Live Activities are supported
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }

        // End any existing activity first
        if currentActivity != nil {
            endActivity()
        }

        // Cache the state for animation updates
        cachedSteps = steps
        cachedState = state
        cachedGender = gender
        currentFrame = 1

        let attributes = PixelPalAttributes()
        let contentState = PixelPalAttributes.ContentState(
            steps: steps,
            state: state,
            gender: gender,
            frame: currentFrame
        )

        do {
            let activity = try Activity<PixelPalAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil),
                pushType: nil // No push updates for v1
            )
            self.currentActivity = activity
            self.isActive = true
            print("Started Live Activity: \(activity.id)")

            // Start animation timer
            startAnimationTimer()
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }

    /// Starts a timer to toggle animation frames.
    private func startAnimationTimer() {
        stopAnimationTimer()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.toggleFrame()
            }
        }
    }

    /// Stops the animation timer.
    private func stopAnimationTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    /// Toggles the animation frame and updates the activity.
    private func toggleFrame() {
        guard let activity = currentActivity else { return }

        currentFrame = currentFrame == 1 ? 2 : 1

        let contentState = PixelPalAttributes.ContentState(
            steps: cachedSteps,
            state: cachedState,
            gender: cachedGender,
            frame: currentFrame
        )

        Task {
            await activity.update(
                ActivityContent(state: contentState, staleDate: nil)
            )
        }
    }

    /// Updates the Live Activity with new state.
    /// - Parameters:
    ///   - steps: Current step count.
    ///   - state: Current avatar state.
    ///   - gender: Selected gender.
    func updateActivity(steps: Int, state: AvatarState, gender: Gender) {
        guard let activity = currentActivity else {
            // No active activity, start one instead
            startActivity(steps: steps, state: state, gender: gender)
            return
        }

        // Update cached state
        cachedSteps = steps
        cachedState = state
        cachedGender = gender

        let contentState = PixelPalAttributes.ContentState(
            steps: steps,
            state: state,
            gender: gender,
            frame: currentFrame
        )

        Task {
            await activity.update(
                ActivityContent(state: contentState, staleDate: nil)
            )
        }
    }

    /// Ends the current Live Activity.
    func endActivity() {
        stopAnimationTimer()
        guard let activity = currentActivity else { return }

        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            self.currentActivity = nil
            self.isActive = false
            print("Ended Live Activity")
        }
    }

    /// Ends all Pixel Pal Live Activities (cleanup utility).
    func endAllActivities() {
        Task {
            for activity in Activity<PixelPalAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            self.currentActivity = nil
            self.isActive = false
        }
    }
}
