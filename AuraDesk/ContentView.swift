import SwiftUI
import Combine
struct ContentView: View {
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.opacity(0.08)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text(currentTime, style: .time)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))

                Text(currentTime, format: .dateTime.weekday(.wide).day().month(.wide))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
            )
            .shadow(radius: 16)
        }
        .frame(width: 500, height: 320)
        .onReceive(timer) { newTime in
            currentTime = newTime
        }
    }
}

#Preview {
    ContentView()
}
