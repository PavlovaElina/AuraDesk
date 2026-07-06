import SwiftUI

struct WidgetContainerView: View {
    @Binding var widget: WidgetItem

    var body: some View {
        Group {
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
            }
        }
        .frame(width: widget.width, height: widget.height)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: widget.cornerRadius))
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: widget.cornerRadius)
            .fill(widgetBackground)
            .opacity(widget.backgroundOpacity)
    }

    private var widgetBackground: AnyShapeStyle {
        if widget.color == .glass {
            return AnyShapeStyle(.ultraThinMaterial)
        }

        return AnyShapeStyle(widget.color.color)
    }
}

#Preview {
    WidgetContainerView(
        widget: .constant(
            WidgetItem(
                type: .clock,
                x: 0,
                y: 0,
                width: 300,
                height: 170
            )
        )
    )
}
