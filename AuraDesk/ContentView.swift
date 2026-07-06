import SwiftUI

struct ContentView: View {
    private let canvasWidth: Double = 820
    private let canvasHeight: Double = 560

    private let startX: Double = 40
    private let startY: Double = 70
    private let slotWidth: Double = 300
    private let slotHeight: Double = 220
    private let widgetGap: Double = 20

    @State private var widgets: [WidgetItem] = [
        WidgetItem(
            type: .photo,
            x: 40,
            y: 70,
            width: 240,
            height: 180,
            color: .pink
        ),
        WidgetItem(
            type: .note,
            x: 40,
            y: 290,
            width: 260,
            height: 180,
            color: .purple,
            noteText: "Today:\n- Build AuraDesk\n- Add widgets"
        )
    ]

    @State private var dragStartPositions: [UUID: CGPoint] = [:]
    @State private var selectedWidgetID: UUID?
    @State private var settingsDraftWidget: WidgetItem?
    @State private var showingSettings = false
    @State private var isEditMode = true

    var body: some View {
        ZStack {
            if isEditMode {
                SlotGridBackgroundView(
                    startX: startX,
                    startY: startY,
                    slotWidth: slotWidth,
                    slotHeight: slotHeight,
                    width: canvasWidth,
                    height: canvasHeight
                )
            }

            ForEach($widgets) { $widget in
                DraggableWidgetView(
                    widget: $widget,
                    isEditMode: isEditMode,
                    isSelected: selectedWidgetID == widget.id,
                    onSelect: {
                        selectedWidgetID = widget.id
                    },
                    onDelete: {
                        deleteWidget(id: widget.id)
                    },
                    onOpenSettings: {
                        openSettings(for: widget.id)
                    },
                    onAddWidget: {
                        addDefaultWidget(shouldOpenSettings: true)
                    },
                    onDragEnded: {
                        widget.x = snapToSlotX(widget.x)
                        widget.y = snapToSlotY(widget.y)

                        if isOutOfBounds(widget) || overlapsWithOtherWidgets(widget) {
                            if let start = dragStartPositions[widget.id] {
                                widget.x = start.x
                                widget.y = start.y
                            }
                        }

                        dragStartPositions[widget.id] = nil
                    },
                    onDragChanged: { value in
                        if dragStartPositions[widget.id] == nil {
                            dragStartPositions[widget.id] = CGPoint(
                                x: widget.x,
                                y: widget.y
                            )
                        }

                        let start = dragStartPositions[widget.id] ?? CGPoint(
                            x: widget.x,
                            y: widget.y
                        )

                        widget.x = start.x + value.translation.width
                        widget.y = start.y + value.translation.height
                    }
                )
            }

            topToolbar
        }
        .frame(width: canvasWidth, height: canvasHeight)
        .background(Color.clear)
        .sheet(isPresented: $showingSettings) {
            if let draftBinding = settingsDraftBinding {
                WidgetSettingsView(
                    draftWidget: draftBinding,
                    onApply: {
                        applySettings()
                    },
                    onCancel: {
                        cancelSettings()
                    }
                )
            } else {
                Text("No widget selected")
                    .padding()
            }
        }
    }

    private var topToolbar: some View {
        VStack {
            HStack {
                Button(isEditMode ? "Done" : "Edit") {
                    isEditMode.toggle()

                    if !isEditMode {
                        selectedWidgetID = nil
                    }
                }
                .buttonStyle(.borderedProminent)

                if isEditMode {
                    Button("+ Add Widget") {
                        addDefaultWidget(shouldOpenSettings: true)
                    }

                    Button("Settings") {
                        if let selectedWidgetID {
                            openSettings(for: selectedWidgetID)
                        }
                    }
                    .disabled(selectedWidgetID == nil)

                    Button("Delete") {
                        if let selectedWidgetID {
                            deleteWidget(id: selectedWidgetID)
                        }
                    }
                    .disabled(selectedWidgetID == nil)
                }

                Spacer()
            }
            .padding()

            Spacer()
        }
    }

    private var settingsDraftBinding: Binding<WidgetItem>? {
        guard settingsDraftWidget != nil else {
            return nil
        }

        return Binding(
            get: {
                settingsDraftWidget!
            },
            set: { newValue in
                settingsDraftWidget = newValue
            }
        )
    }

    private func openSettings(for id: UUID) {
        guard let widget = widgets.first(where: { $0.id == id }) else {
            return
        }

        selectedWidgetID = id
        settingsDraftWidget = widget
        showingSettings = true
    }

    private func applySettings() {
        guard let draft = settingsDraftWidget,
              let index = widgets.firstIndex(where: { $0.id == draft.id }) else {
            return
        }

        var updatedWidget = draft

        updatedWidget.width = snapSize(updatedWidget.width)
        updatedWidget.height = snapSize(updatedWidget.height)
        updatedWidget.x = snapToSlotX(updatedWidget.x)
        updatedWidget.y = snapToSlotY(updatedWidget.y)

        let oldWidget = widgets[index]
        widgets[index] = updatedWidget

        if isOutOfBounds(updatedWidget) || overlapsWithOtherWidgets(updatedWidget) {
            widgets[index] = oldWidget
        }

        settingsDraftWidget = nil
        showingSettings = false
    }

    private func cancelSettings() {
        settingsDraftWidget = nil
        showingSettings = false
    }

    private func addDefaultWidget(shouldOpenSettings: Bool) {
        let size = defaultSize(for: .photo)
        let position = findAvailablePosition(width: size.width, height: size.height)

        let newWidget = WidgetItem(
            type: .photo,
            x: position.x,
            y: position.y,
            width: size.width,
            height: size.height,
            color: .pink,
            noteText: "New note"
        )

        widgets.append(newWidget)
        selectedWidgetID = newWidget.id

        if shouldOpenSettings {
            openSettings(for: newWidget.id)
        }
    }

    private func defaultSize(for type: WidgetType) -> CGSize {
        switch type {
        case .clock:
            return CGSize(width: 300, height: 170)
        case .note:
            return CGSize(width: 260, height: 180)
        case .calendar:
            return CGSize(width: 220, height: 180)
        case .battery:
            return CGSize(width: 220, height: 180)
        case .photo:
            return CGSize(width: 240, height: 180)
        }
    }

    private func deleteWidget(id: UUID) {
        widgets.removeAll { widget in
            widget.id == id
        }

        if selectedWidgetID == id {
            selectedWidgetID = nil
        }
    }

    private func findAvailablePosition(width: Double, height: Double) -> CGPoint {
        var column = 0

        while startX + Double(column) * slotWidth + width <= canvasWidth - widgetGap {
            var row = 0

            while startY + Double(row) * slotHeight + height <= canvasHeight - widgetGap {
                let candidate = CGRect(
                    x: startX + Double(column) * slotWidth,
                    y: startY + Double(row) * slotHeight,
                    width: width,
                    height: height
                )

                let hasOverlap = widgets.contains { widget in
                    candidate.intersects(
                        frame(for: widget).insetBy(
                            dx: -widgetGap / 2,
                            dy: -widgetGap / 2
                        )
                    )
                }

                if !hasOverlap {
                    return CGPoint(
                        x: candidate.origin.x,
                        y: candidate.origin.y
                    )
                }

                row += 1
            }

            column += 1
        }

        return CGPoint(x: startX, y: startY)
    }

    private func snapToSlotX(_ value: Double) -> Double {
        let relative = value - startX
        let column = (relative / slotWidth).rounded()
        return startX + column * slotWidth
    }

    private func snapToSlotY(_ value: Double) -> Double {
        let relative = value - startY
        let row = (relative / slotHeight).rounded()
        return startY + row * slotHeight
    }

    private func snapSize(_ value: Double) -> Double {
        (value / 20).rounded() * 20
    }

    private func overlapsWithOtherWidgets(_ widget: WidgetItem) -> Bool {
        let currentFrame = frame(for: widget).insetBy(
            dx: -widgetGap / 2,
            dy: -widgetGap / 2
        )

        return widgets.contains { otherWidget in
            guard otherWidget.id != widget.id else {
                return false
            }

            return currentFrame.intersects(frame(for: otherWidget))
        }
    }

    private func isOutOfBounds(_ widget: WidgetItem) -> Bool {
        widget.x < 0 ||
        widget.y < 0 ||
        widget.x + widget.width > canvasWidth ||
        widget.y + widget.height > canvasHeight
    }

    private func frame(for widget: WidgetItem) -> CGRect {
        CGRect(
            x: widget.x,
            y: widget.y,
            width: widget.width,
            height: widget.height
        )
    }
}

struct DraggableWidgetView: View {
    @Binding var widget: WidgetItem

    let isEditMode: Bool
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    let onOpenSettings: () -> Void
    let onAddWidget: () -> Void
    let onDragEnded: () -> Void
    let onDragChanged: (DragGesture.Value) -> Void

    @State private var isHovered = false

    var body: some View {
        WidgetContainerView(widget: $widget)
            .overlay(selectionBorder)
            .overlay(alignment: .topLeading) {
                deleteButton
            }
            .overlay(alignment: .bottom) {
                hoverToolbar
            }
            .position(
                x: widget.x + widget.width / 2,
                y: widget.y + widget.height / 2
            )
            .onTapGesture {
                if isEditMode {
                    onSelect()
                }
            }
            .onHover { hovering in
                isHovered = hovering
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard isEditMode else {
                            return
                        }

                        onSelect()
                        onDragChanged(value)
                    }
                    .onEnded { _ in
                        guard isEditMode else {
                            return
                        }

                        onDragEnded()
                    }
            )
            .contextMenu {
                if isEditMode {
                    Button("Settings") {
                        onOpenSettings()
                    }

                    Button("Add Widget") {
                        onAddWidget()
                    }

                    Divider()

                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                }
            }
    }

    private var selectionBorder: some View {
        RoundedRectangle(cornerRadius: widget.cornerRadius)
            .stroke(
                isEditMode && isSelected ? Color.blue : Color.clear,
                lineWidth: 3
            )
    }

    private var deleteButton: some View {
        Button {
            onDelete()
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 13, weight: .semibold))
                .padding(8)
                .background(.black.opacity(0.45))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .padding(8)
        .opacity(isEditMode && (isHovered || isSelected) ? 1 : 0)
    }

    private var hoverToolbar: some View {
        HStack(spacing: 14) {
            Button {
                onAddWidget()
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(.plain)

            Button {
                onOpenSettings()
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(.plain)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.black.opacity(0.38))
        .clipShape(Capsule())
        .padding(.bottom, 10)
        .opacity(isEditMode && (isHovered || isSelected) ? 1 : 0)
    }
}

struct SlotGridBackgroundView: View {
    let startX: Double
    let startY: Double
    let slotWidth: Double
    let slotHeight: Double
    let width: Double
    let height: Double

    var body: some View {
        Canvas { context, _ in
            var path = Path()

            var x = startX
            while x <= width {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
                x += slotWidth
            }

            var y = startY
            while y <= height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: width, y: y))
                y += slotHeight
            }

            context.stroke(
                path,
                with: .color(.white.opacity(0.18)),
                lineWidth: 1
            )
        }
        .frame(width: width, height: height)
        .allowsHitTesting(false)
    }
}

#Preview {
    ContentView()
}
