import SwiftUI

struct AvatarView: View {
    let state: AvatarState
    let gender: Gender

    @State private var frameIndex = 0

    // Timer for breathing animation (~0.8 seconds per frame)
    let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()

    var body: some View {
        let spriteName = SpriteAssets.spriteName(
            gender: gender,
            state: state,
            frame: frameIndex + 1
        )

        Image(spriteName)
            .resizable()
            .interpolation(.none) // Crisp pixel art
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .onReceive(timer) { _ in
                frameIndex = (frameIndex + 1) % 2
            }
    }
}
