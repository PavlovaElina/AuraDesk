import SwiftUI
internal import Combine
import AVKit

struct WidgetContainerView: View {
    @Binding var widget: WidgetItem

    var body: some View {
        ZStack {
            widgetBackground

            backgroundDim

            widgetContent
        }
        .frame(width: widget.width, height: widget.height)
        .clipShape(RoundedRectangle(cornerRadius: widget.cornerRadius))
    }

    @ViewBuilder
    private var widgetBackground: some View {
        switch widget.backgroundKind {
        case .color:
            colorBackground

        case .photo:
            if let path = widget.mediaPath,
               let image = NSImage(contentsOfFile: path) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                colorBackground
            }

        case .video:
            if let path = widget.mediaPath {
                VideoBackgroundView(path: path)
            } else {
                colorBackground
            }

        case .album:
            AlbumBackgroundView(
                paths: widget.albumPaths,
                interval: widget.albumInterval
            )
        }
    }

    private var colorBackground: some View {
        RoundedRectangle(cornerRadius: widget.cornerRadius)
            .fill(widgetBackgroundStyle)
            .opacity(widget.backgroundOpacity)
    }

    private var backgroundDim: some View {
        Rectangle()
            .fill(.black.opacity(widget.backgroundDimOpacity))
            .allowsHitTesting(false)
    }

    @ViewBuilder
    private var widgetContent: some View {
        switch widget.type {
        case .clock:
            ClockWidgetView()

        case .note:
            NoteWidgetView(text: $widget.noteText)

        case .calendar:
            CalendarWidgetView()

        case .battery:
            BatteryWidgetView()

        case .photo:
            PhotoWidgetView()

        case .quote:
            QuoteWidgetView(text: widget.quoteText)

        case .timer:
            SimpleTimerWidgetView(minutes: widget.timerMinutes)

        case .bookmark:
            BookmarkWidgetView(
                title: widget.bookmarkTitle,
                urlString: widget.bookmarkURL
            )

        case .weather:
            WeatherWidgetView(
                city: widget.weatherCity,
                latitude: widget.weatherLatitude,
                longitude: widget.weatherLongitude
            )
        }
    }

    private var widgetBackgroundStyle: AnyShapeStyle {
        if widget.color == .glass {
            return AnyShapeStyle(.ultraThinMaterial)
        }

        return AnyShapeStyle(widget.color.color)
    }
}

struct VideoBackgroundView: View {
    let path: String

    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .disabled(true)
            .onAppear {
                let url = URL(fileURLWithPath: path)
                let player = AVPlayer(url: url)
                player.isMuted = true
                player.play()

                self.player = player
            }
            .onDisappear {
                player?.pause()
                player = nil
            }
    }
}

struct AlbumBackgroundView: View {
    let paths: [String]
    let interval: Double

    @State private var currentIndex = 0

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(
            every: max(interval, 1),
            on: .main,
            in: .common
        )
        .autoconnect()
    }

    var body: some View {
        Group {
            if let image = currentImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.4))
            }
        }
        .onReceive(timer) { _ in
            guard !paths.isEmpty else {
                return
            }

            currentIndex = (currentIndex + 1) % paths.count
        }
    }

    private var currentImage: NSImage? {
        guard !paths.isEmpty else {
            return nil
        }

        let safeIndex = min(currentIndex, paths.count - 1)
        return NSImage(contentsOfFile: paths[safeIndex])
    }
}

#Preview {
    WidgetContainerView(
        widget: .constant(
            WidgetItem(
                type: .quote,
                x: 0,
                y: 0,
                width: 288,
                height: 140,
                color: .blush
            )
        )
    )
}
