import SwiftUI

struct QuoteWidgetView: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "quote.opening")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    QuoteWidgetView(text: "Make your desktop yours.")
        .frame(width: 288, height: 140)
}
