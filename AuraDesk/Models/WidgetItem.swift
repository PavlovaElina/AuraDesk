import Foundation

enum WidgetType: String, Codable {
    case clock
}

struct WidgetItem: Identifiable, Codable {
    let id: UUID
    var type: WidgetType

    var x: Double
    var y: Double
    var width: Double
    var height: Double

    var backgroundOpacity: Double
    var cornerRadius: Double

    init(
        id: UUID = UUID(),
        type: WidgetType,
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        backgroundOpacity: Double = 0.75,
        cornerRadius: Double = 28
    ) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.backgroundOpacity = backgroundOpacity
        self.cornerRadius = cornerRadius
    }
}
