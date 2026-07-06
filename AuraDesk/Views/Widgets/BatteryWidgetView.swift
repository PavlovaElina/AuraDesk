import SwiftUI
import IOKit.ps
internal import Combine

struct BatteryWidgetView: View {
    @State private var batteryLevel: Int?

    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: batteryIconName)
                .font(.system(size: 42))

            Text(batteryText)
                .font(.system(size: 34, weight: .semibold, design: .rounded))

            Text("Battery")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .onAppear {
            batteryLevel = readBatteryLevel()
        }
        .onReceive(timer) { _ in
            batteryLevel = readBatteryLevel()
        }
    }

    private var batteryText: String {
        guard let batteryLevel else {
            return "—"
        }

        return "\(batteryLevel)%"
    }

    private var batteryIconName: String {
        guard let batteryLevel else {
            return "battery.0percent"
        }

        switch batteryLevel {
        case 80...100:
            return "battery.100percent"
        case 50..<80:
            return "battery.75percent"
        case 25..<50:
            return "battery.50percent"
        default:
            return "battery.25percent"
        }
    }

    private func readBatteryLevel() -> Int? {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else {
            return nil
        }

        for source in sources {
            guard let description = IOPSGetPowerSourceDescription(snapshot, source)?
                .takeUnretainedValue() as? [String: Any] else {
                continue
            }

            if let capacity = description[kIOPSCurrentCapacityKey] as? Int {
                return capacity
            }
        }

        return nil
    }
}

#Preview {
    BatteryWidgetView()
        .frame(width: 220, height: 180)
}
