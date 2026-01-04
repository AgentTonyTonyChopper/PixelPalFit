import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @State private var selectedGender: Gender? = nil
    @State private var showHealthKitStep = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Pixel Pal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Your ambient walking companion.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            if !showHealthKitStep {
                // Step 1: Gender Selection
                genderSelectionView
            } else {
                // Step 2: HealthKit Permission
                healthKitPermissionView
            }
        }
        .background(Color.black)
    }

    // MARK: - Gender Selection Step

    private var genderSelectionView: some View {
        VStack(spacing: 24) {
            Text("Choose your Pixel Pal")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            HStack(spacing: 40) {
                genderButton(for: .male)
                genderButton(for: .female)
            }

            if selectedGender != nil {
                Button(action: {
                    if let gender = selectedGender {
                        SharedData.saveGender(gender)
                        withAnimation {
                            showHealthKitStep = true
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.bottom, 50)
    }

    private func genderButton(for gender: Gender) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedGender = gender
            }
        }) {
            VStack(spacing: 12) {
                // Preview sprite (using neutral state, frame 1)
                Image(SpriteAssets.spriteName(gender: gender, state: .neutral, frame: 1))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)

                Text(gender.displayName)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedGender == gender ? Color.white : Color.white.opacity(0.3),
                        lineWidth: selectedGender == gender ? 2 : 1
                    )
            )
        }
    }

    // MARK: - HealthKit Permission Step

    private var healthKitPermissionView: some View {
        VStack(spacing: 20) {
            if let gender = selectedGender {
                // Show selected character
                Image(SpriteAssets.spriteName(gender: gender, state: .vital, frame: 1))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }

            Text("Let's get moving!")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            Text("Pixel Pal needs access to your step count to reflect your daily energy.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: {
                healthManager.requestAuthorization { _ in }
            }) {
                Text("Connect HealthKit")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding(.bottom, 50)
    }
}
