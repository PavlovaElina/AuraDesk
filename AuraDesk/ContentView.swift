import SwiftUI

struct ContentView: View {
    let widgets: [WidgetItem] = [
        WidgetItem(
            type: .clock,
            x: 0,
            y: 0,
            width: 300,
            height: 170
        )
    ]

    var body: some View {
        ZStack {
            ForEach(widgets) { widget in
                WidgetContainerView(widget: widget)
                    .position(x: widget.x + widget.width / 2,
                              y: widget.y + widget.height / 2)
            }
        }
        .frame(width: 500, height: 320)
        .background(Color.clear)
    }
}

#Preview {
    ContentView()
}
