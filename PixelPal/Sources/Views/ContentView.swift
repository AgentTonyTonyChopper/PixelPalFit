import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @StateObject private var liveActivityManager = LiveActivityManager()

    @State private var avatarState: AvatarState = .low
    @State private var gender: Gender = .male

    /// Whether onboarding is complete (gender selected + HealthKit authorized).
    private var isOnboardingComplete: Bool {
        return SharedData.hasSelectedGender && healthManager.isAuthorized
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if !isOnboardingComplete {
                OnboardingView()
            } else {
                mainContentView
            }
        }
        .onAppear {
            loadSavedData()
            if healthManager.isAuthorized {
                healthManager.fetchData()
            }
        }
        .onChange(of: healthManager.currentSteps) { _ in
            updateState()
        }
        .onChange(of: healthManager.isAuthorized) { authorized in
            if authorized {
                healthManager.fetchData()
            }
        }
    }

    // MARK: - Main Content

    private var mainContentView: some View {
        VStack(spacing: 30) {
            Spacer()

            // Avatar
            AvatarView(state: avatarState, gender: gender)

            // State & Steps
            VStack(spacing: 8) {
                Text(avatarState.description)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))

                Text("\(Int(healthManager.currentSteps)) steps today")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let lastUpdate = SharedData.loadLastUpdateDate() {
                    Text("Updated \(lastUpdate.formatted(date: .omitted, time: .shortened))")
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.6))
                }
            }

            Spacer()

            // Live Activity Controls
            liveActivityControls

            // Refresh Button
            Button(action: {
                healthManager.fetchData()
                updateState()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh")
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .padding(.vertical, 8)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - Live Activity Controls

    private var liveActivityControls: some View {
        VStack(spacing: 12) {
            if liveActivityManager.isActive {
                Button(action: {
                    liveActivityManager.endActivity()
                }) {
                    HStack {
                        Image(systemName: "stop.circle.fill")
                        Text("Stop Pixel Pal")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)

                Text("Live Activity is running")
                    .font(.caption)
                    .foregroundColor(.green.opacity(0.8))
            } else {
                Button(action: {
                    liveActivityManager.startActivity(
                        steps: Int(healthManager.currentSteps),
                        state: avatarState,
                        gender: gender
                    )
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Start Pixel Pal")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)

                Text("Show on Lock Screen & Dynamic Island")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - State Management

    private func loadSavedData() {
        if let savedGender = SharedData.loadGender() {
            gender = savedGender
        }
        avatarState = SharedData.loadState()
    }

    private func updateState() {
        let newState = AvatarLogic.determineState(steps: healthManager.currentSteps)
        self.avatarState = newState

        // Save to shared container for Widget
        SharedData.saveState(state: newState, steps: healthManager.currentSteps)

        // Update Live Activity if active
        if liveActivityManager.isActive {
            liveActivityManager.updateActivity(
                steps: Int(healthManager.currentSteps),
                state: newState,
                gender: gender
            )
        }
    }
}
