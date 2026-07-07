import SwiftUI

struct MediaIslandView: View {
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "music.note")
                .font(.system(size: 16, weight: .semibold))

            VStack(alignment: .leading, spacing: 2) {
                Text("Media")
                    .font(.system(size: 13, weight: .semibold))

                Text("Background audio/video")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                skipBackward()
            } label: {
                Image(systemName: "gobackward.10")
            }
            .buttonStyle(.plain)

            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .buttonStyle(.plain)

            Button {
                skipForward()
            } label: {
                Image(systemName: "goforward.10")
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .frame(width: 360, height: 54)
        .background(.black.opacity(0.72))
        .clipShape(Capsule())
        .shadow(radius: 12)
    }

    private func skipBackward() {
        // Подключим к реальному video/audio player позже.
    }

    private func skipForward() {
        // Подключим к реальному video/audio player позже.
    }
}

#Preview {
    MediaIslandView()
}
