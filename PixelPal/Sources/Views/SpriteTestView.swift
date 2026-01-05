import SwiftUI

/// Test view to preview all sprite animations at once.
/// Access via: SpriteTestView() in ContentView or Xcode Preview
struct SpriteTestView: View {
    @State private var frame = 1

    let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Sprite Animation Test")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text("Frame: \(frame)")
                    .font(.caption)
                    .foregroundColor(.gray)

                // Male sprites
                VStack(spacing: 16) {
                    Text("MALE")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 20) {
                        spriteColumn(gender: "male", state: "vital", label: "Vital")
                        spriteColumn(gender: "male", state: "neutral", label: "Neutral")
                        spriteColumn(gender: "male", state: "low", label: "Low")
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)

                // Female sprites
                VStack(spacing: 16) {
                    Text("FEMALE")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 20) {
                        spriteColumn(gender: "female", state: "vital", label: "Vital")
                        spriteColumn(gender: "female", state: "neutral", label: "Neutral")
                        spriteColumn(gender: "female", state: "low", label: "Low")
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color.black)
        .onReceive(timer) { _ in
            frame = frame == 1 ? 2 : 1
        }
    }

    private func spriteColumn(gender: String, state: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image("\(gender)_\(state)_\(frame)")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)

            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    SpriteTestView()
}
