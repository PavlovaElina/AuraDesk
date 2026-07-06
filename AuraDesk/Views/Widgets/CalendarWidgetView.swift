import SwiftUI

struct CalendarWidgetView: View {
    private let today = Date()

    var body: some View {
        VStack(spacing: 10) {
            Text(today, format: .dateTime.month(.wide).year())
                .font(.headline)

            Text(today, format: .dateTime.day())
                .font(.system(size: 54, weight: .bold, design: .rounded))

            Text(today, format: .dateTime.weekday(.wide))
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CalendarWidgetView()
        .frame(width: 220, height: 180)
}
