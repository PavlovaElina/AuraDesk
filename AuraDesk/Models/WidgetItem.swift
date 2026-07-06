import Foundation
import SwiftUI

enum WidgetType: String, Codable, CaseIterable, Identifiable {
    case clock
    case note
    case calendar
    case battery
    case photo

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .clock:
            return "Clock"
        case .note:
            return "Note"
        case .calendar:
            return "Calendar"
        case .battery:
            return "Battery"
        case .photo:
            return "Photo"
        }
    }
}

enum WidgetColor: String, Codable, CaseIterable, Identifiable {
    case glass
    case blue
    case purple
    case pink
    case green
    case orange
    case gray

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .glass:
            return "Glass"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        case .green:
            return "Green"
        case .orange:
            return "Orange"
        case .gray:
            return "Gray"
        }
    }

    var color: Color {
        switch self {
        case .glass:
            return .white
        case .blue:
            return .blue
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .green:
            return .green
        case .orange:
            return .orange
        case .gray:
            return .gray
        }
    }
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
    var color: WidgetColor

    var noteText: String

    init(
        id: UUID = UUID(),
        type: WidgetType,
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        backgroundOpacity: Double = 0.75,
        cornerRadius: Double = 28,
        color: WidgetColor = .glass,
        noteText: String = "Write something..."
    ) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.backgroundOpacity = backgroundOpacity
        self.cornerRadius = cornerRadius
        self.color = color
        self.noteText = noteText
    }
}
