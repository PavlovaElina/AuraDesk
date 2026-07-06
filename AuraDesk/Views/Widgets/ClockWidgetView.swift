import SwiftUI
internal import Combine

struct ClockWidgetView: View {
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 10) {
            Text(currentTime, style: .time)
                .font(.system(size: 42, weight: .semibold, design: .rounded))

            Text(currentTime, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .onReceive(timer) { newTime in
            currentTime = newTime
        }
    }
}

#Preview {
    ClockWidgetView()
        .frame(width: 300, height: 170)
}
