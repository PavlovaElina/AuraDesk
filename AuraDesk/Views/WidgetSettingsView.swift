import SwiftUI

struct WidgetSettingsView: View {
    @Binding var draftWidget: WidgetItem

    let onApply: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Widget Settings")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button("Cancel") {
                    onCancel()
                }

                Button("Apply") {
                    onApply()
                }
                .buttonStyle(.borderedProminent)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Preview")
                    .font(.headline)

                WidgetContainerView(widget: $draftWidget)
                    .frame(width: 260, height: 170)
                    .background(.black.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            Divider()

            Picker("Type", selection: $draftWidget.type) {
                ForEach(WidgetType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }

            Picker("Color", selection: $draftWidget.color) {
                ForEach(WidgetColor.allCases) { color in
                    Text(color.title).tag(color)
                }
            }

            VStack(alignment: .leading) {
                Text("Width: \(Int(draftWidget.width))")

                Slider(
                    value: $draftWidget.width,
                    in: 160...420,
                    step: 20
                )
            }

            VStack(alignment: .leading) {
                Text("Height: \(Int(draftWidget.height))")

                Slider(
                    value: $draftWidget.height,
                    in: 120...320,
                    step: 20
                )
            }

            VStack(alignment: .leading) {
                Text("Opacity: \(draftWidget.backgroundOpacity, specifier: "%.2f")")

                Slider(
                    value: $draftWidget.backgroundOpacity,
                    in: 0.1...1.0
                )
            }

            VStack(alignment: .leading) {
                Text("Corner radius: \(Int(draftWidget.cornerRadius))")

                Slider(
                    value: $draftWidget.cornerRadius,
                    in: 0...50
                )
            }

            if draftWidget.type == .note {
                VStack(alignment: .leading) {
                    Text("Note text")

                    TextEditor(text: $draftWidget.noteText)
                        .frame(height: 90)
                        .scrollContentBackground(.hidden)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            Spacer()
        }
        .padding(24)
        .frame(width: 420, height: 650)
    }
}

#Preview {
    WidgetSettingsView(
        draftWidget: .constant(
            WidgetItem(
                type: .note,
                x: 0,
                y: 0,
                width: 260,
                height: 180
            )
        ),
        onApply: {},
        onCancel: {}
    )
}
