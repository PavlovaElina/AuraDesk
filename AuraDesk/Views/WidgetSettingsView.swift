import SwiftUI
import AppKit
internal import UniformTypeIdentifiers

struct WidgetSettingsView: View {
    @Binding var draftWidget: WidgetItem

    let onApply: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(20)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    preview

                    Divider()

                    mainSettings

                    backgroundSettings

                    contentSettings
                }
                .padding(20)
            }
        }
        .frame(width: 460, height: 620)
    }

    private var header: some View {
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
    }

    private var preview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Preview")
                .font(.headline)

            WidgetContainerView(widget: $draftWidget)
                .scaleEffect(previewScale)
                .frame(
                    width: draftWidget.width * previewScale,
                    height: draftWidget.height * previewScale
                )
                .background(.black.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private var previewScale: Double {
        let maxPreviewWidth = 360.0
        let maxPreviewHeight = 220.0

        let widthScale = maxPreviewWidth / draftWidget.width
        let heightScale = maxPreviewHeight / draftWidget.height

        return min(1.0, widthScale, heightScale)
    }

    private var mainSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Type", selection: $draftWidget.type) {
                ForEach(WidgetType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }

            Picker("Size", selection: $draftWidget.sizePreset) {
                ForEach(WidgetSizePreset.allCases) { preset in
                    Text(preset.title).tag(preset)
                }
            }
            .onChange(of: draftWidget.sizePreset) { _, newPreset in
                applySizePreset(newPreset)
            }

            VStack(alignment: .leading) {
                Text("Width: \(Int(draftWidget.width))")

                Slider(
                    value: $draftWidget.width,
                    in: 140...584,
                    step: 8
                )
            }

            VStack(alignment: .leading) {
                Text("Height: \(Int(draftWidget.height))")

                Slider(
                    value: $draftWidget.height,
                    in: 140...436,
                    step: 8
                )
            }

            VStack(alignment: .leading) {
                Text("Corner radius: \(Int(draftWidget.cornerRadius))")

                Slider(
                    value: $draftWidget.cornerRadius,
                    in: 0...50
                )
            }
        }
    }

    private var backgroundSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Background")
                .font(.headline)

            Picker("Background Type", selection: $draftWidget.backgroundKind) {
                ForEach(WidgetBackgroundKind.allCases) { kind in
                    Text(kind.title).tag(kind)
                }
            }

            if draftWidget.backgroundKind == .color {
                Picker("Color", selection: $draftWidget.color) {
                    ForEach(WidgetColor.allCases) { color in
                        Text(color.title).tag(color)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Background opacity: \(draftWidget.backgroundOpacity, specifier: "%.2f")")

                    Slider(
                        value: $draftWidget.backgroundOpacity,
                        in: 0.1...1.0
                    )
                }
            }

            if draftWidget.backgroundKind == .photo {
                Button("Choose Photo") {
                    choosePhoto()
                }

                Text(draftWidget.mediaPath == nil ? "No photo selected" : "Photo selected")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if draftWidget.backgroundKind == .video {
                Button("Choose Video") {
                    chooseVideo()
                }

                Text(draftWidget.mediaPath == nil ? "No video selected" : "Video selected")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if draftWidget.backgroundKind == .album {
                Button("Choose Album Photos") {
                    chooseAlbumPhotos()
                }

                Text("\(draftWidget.albumPaths.count) photos selected")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading) {
                    Text("Change every \(Int(draftWidget.albumInterval)) sec")

                    Slider(
                        value: $draftWidget.albumInterval,
                        in: 3...120,
                        step: 1
                    )
                }
            }

            VStack(alignment: .leading) {
                Text("Dark overlay: \(draftWidget.backgroundDimOpacity, specifier: "%.2f")")

                Slider(
                    value: $draftWidget.backgroundDimOpacity,
                    in: 0.0...0.7
                )
            }
        }
    }

    private var contentSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .font(.headline)

            if draftWidget.type == .note {
                VStack(alignment: .leading) {
                    Text("Note text")

                    TextEditor(text: $draftWidget.noteText)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            if draftWidget.type == .quote {
                VStack(alignment: .leading) {
                    Text("Quote text")

                    TextEditor(text: $draftWidget.quoteText)
                        .frame(height: 90)
                        .scrollContentBackground(.hidden)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            if draftWidget.type == .bookmark {
                TextField("Title", text: $draftWidget.bookmarkTitle)
                TextField("URL", text: $draftWidget.bookmarkURL)
            }

            if draftWidget.type == .timer {
                Stepper(
                    "Minutes: \(draftWidget.timerMinutes)",
                    value: $draftWidget.timerMinutes,
                    in: 1...180
                )
            }

            if draftWidget.type == .weather {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weather")

                    TextField("City", text: $draftWidget.weatherCity)

                    HStack {
                        TextField(
                            "Latitude",
                            value: $draftWidget.weatherLatitude,
                            format: .number
                        )

                        TextField(
                            "Longitude",
                            value: $draftWidget.weatherLongitude,
                            format: .number
                        )
                    }

                    Text("For now, enter coordinates manually. Later we will add city search.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func applySizePreset(_ preset: WidgetSizePreset) {
        let size = preset.size
        draftWidget.width = size.width
        draftWidget.height = size.height
    }

    private func choosePhoto() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]

        if panel.runModal() == .OK {
            draftWidget.mediaPath = panel.url?.path
            draftWidget.backgroundKind = .photo
        }
    }

    private func chooseVideo() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.movie, .video]

        if panel.runModal() == .OK {
            draftWidget.mediaPath = panel.url?.path
            draftWidget.backgroundKind = .video
        }
    }

    private func chooseAlbumPhotos() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]

        if panel.runModal() == .OK {
            draftWidget.albumPaths = panel.urls.map(\.path)
            draftWidget.backgroundKind = .album
        }
    }
}

#Preview {
    WidgetSettingsView(
        draftWidget: .constant(
            WidgetItem(
                type: .quote,
                x: 0,
                y: 0,
                width: 288,
                height: 140
            )
        ),
        onApply: {},
        onCancel: {}
    )
}
