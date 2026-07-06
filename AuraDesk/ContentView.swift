import SwiftUI

struct ContentView: View {
    @State private var widgets: [WidgetItem] = [
        WidgetItem(
            type: .clock,
            x: 100,
            y: 75,
            width: 300,
            height: 170
        )
    ]

    var body: some View {
        ZStack {
            ForEach($widgets) { $widget in
                DraggableWidgetView(widget: $widget)
            }
        }
        .frame(width: 700, height: 450)
        .background(Color.clear)
    }
}

struct DraggableWidgetView: View {
    @Binding var widget: WidgetItem
    @State private var dragStartX: Double?
    @State private var dragStartY: Double?

    var body: some View {
        WidgetContainerView(widget: widget)
            .position(
                x: widget.x + widget.width / 2,
                y: widget.y + widget.height / 2
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if dragStartX == nil {
                            dragStartX = widget.x
                            dragStartY = widget.y
                        }

                        widget.x = (dragStartX ?? widget.x) + value.translation.width
                        widget.y = (dragStartY ?? widget.y) + value.translation.height
                    }
                    .onEnded { _ in
                        dragStartX = nil
                        dragStartY = nil
                    }
            )
    }
}

#Preview {
    ContentView()
}
