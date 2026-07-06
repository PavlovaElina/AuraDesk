import SwiftUI

struct WidgetContainerView: View {
    let widget: WidgetItem

    var body: some View {
        Group {
            switch widget.type {
            case .clock:
                ClockWidgetView()
            }
        }
        .frame(width: widget.width, height: widget.height)
        .background(
            RoundedRectangle(cornerRadius: widget.cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(widget.backgroundOpacity)
        )
    }
}

#Preview {
    WidgetContainerView(
        widget: WidgetItem(
            type: .clock,
            x: 0,
            y: 0,
            width: 300,
            height: 170
        )
    )
}
