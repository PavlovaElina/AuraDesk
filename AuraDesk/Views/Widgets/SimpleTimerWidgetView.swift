import SwiftUI
internal import Combine

struct SimpleTimerWidgetView: View {
    let minutes: Int

    @State private var remainingSeconds: Int = 0
    @State private var isRunning = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "timer")
                .font(.system(size: 32))

            Text(timeText)
                .font(.system(size: 34, weight: .semibold, design: .rounded))

            HStack(spacing: 12) {
                Button {
                    toggleTimer()
                } label: {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.plain)

                Button {
                    resetTimer()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.plain)
            }
            .font(.system(size: 18, weight: .semibold))
        }
        .onAppear {
            if remainingSeconds == 0 {
                remainingSeconds = minutes * 60
            }
        }
        .onChange(of: minutes) { _, newValue in
            remainingSeconds = newValue * 60
            isRunning = false
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }

            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                isRunning = false
            }
        }
    }

    private var timeText: String {
        let mins = remainingSeconds / 60
        let secs = remainingSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    private func toggleTimer() {
        if remainingSeconds <= 0 {
            remainingSeconds = minutes * 60
        }

        isRunning.toggle()
    }

    private func resetTimer() {
        remainingSeconds = minutes * 60
        isRunning = false
    }
}

#Preview {
    SimpleTimerWidgetView(minutes: 25)
        .frame(width: 140, height: 140)
}
