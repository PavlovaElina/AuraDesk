import SwiftUI

struct PhotoWidgetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(.white.opacity(0.12))

            VStack(spacing: 10) {
                Image(systemName: "photo")
                    .font(.system(size: 42))

                Text("Photo")
                    .font(.headline)

                Text("Image picker later")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
    }
}

#Preview {
    PhotoWidgetView()
        .frame(width: 240, height: 180)
}
