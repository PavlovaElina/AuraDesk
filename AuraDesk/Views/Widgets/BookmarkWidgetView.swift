import SwiftUI

struct BookmarkWidgetView: View {
    let title: String
    let urlString: String

    var body: some View {
        Button {
            openURL()
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "link")
                    .font(.system(size: 34))

                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text(urlString)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
    }

    private func openURL() {
        guard let url = URL(string: urlString) else {
            return
        }

        NSWorkspace.shared.open(url)
    }
}

#Preview {
    BookmarkWidgetView(
        title: "Apple",
        urlString: "https://www.apple.com"
    )
    .frame(width: 288, height: 140)
}
