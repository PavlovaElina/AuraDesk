import Foundation
import SwiftUI

enum WidgetType: String, Codable, CaseIterable, Identifiable {
    case clock
    case note
    case calendar
    case battery
    case photo
    case quote
    case timer
    case bookmark
    case weather

    var id: String { rawValue }

    var title: String {
        switch self {
        case .clock: return "Clock"
        case .note: return "Note"
        case .calendar: return "Calendar"
        case .battery: return "Battery"
        case .photo: return "Photo"
        case .quote: return "Quote"
        case .timer: return "Timer"
        case .bookmark: return "Bookmark"
        case .weather: return "Weather"
        }
    }
}

enum WidgetSizePreset: String, Codable, CaseIterable, Identifiable {
    case smallSquare
    case smallRectangle
    case mediumSquare
    case mediumRectangle
    case largeSquare
    case largeRectangle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .smallSquare: return "Small Square"
        case .smallRectangle: return "Small Rectangle"
        case .mediumSquare: return "Medium Square"
        case .mediumRectangle: return "Medium Rectangle"
        case .largeSquare: return "Large Square"
        case .largeRectangle: return "Large Rectangle"
        }
    }

    var size: CGSize {
        switch self {
        case .smallSquare:
            return CGSize(width: 140, height: 140)
        case .smallRectangle:
            return CGSize(width: 288, height: 140)
        case .mediumSquare:
            return CGSize(width: 288, height: 288)
        case .mediumRectangle:
            return CGSize(width: 436, height: 288)
        case .largeSquare:
            return CGSize(width: 436, height: 436)
        case .largeRectangle:
            return CGSize(width: 584, height: 436)
        }
    }
}

enum WidgetBackgroundKind: String, Codable, CaseIterable, Identifiable {
    case color
    case photo
    case video
    case album

    var id: String { rawValue }

    var title: String {
        switch self {
        case .color: return "Color"
        case .photo: return "Photo"
        case .video: return "Video"
        case .album: return "Album"
        }
    }
}

enum WidgetColor: String, Codable, CaseIterable, Identifiable {
    case glass
    case cream
    case blush
    case lavender
    case sky
    case mint
    case sage
    case peach
    case butter
    case graphite

    var id: String { rawValue }

    var title: String {
        switch self {
        case .glass: return "Glass"
        case .cream: return "Cream"
        case .blush: return "Blush"
        case .lavender: return "Lavender"
        case .sky: return "Sky"
        case .mint: return "Mint"
        case .sage: return "Sage"
        case .peach: return "Peach"
        case .butter: return "Butter"
        case .graphite: return "Graphite"
        }
    }

    var color: Color {
        switch self {
        case .glass:
            return .white
        case .cream:
            return Color(red: 0.96, green: 0.91, blue: 0.84)
        case .blush:
            return Color(red: 0.96, green: 0.78, blue: 0.82)
        case .lavender:
            return Color(red: 0.80, green: 0.76, blue: 0.94)
        case .sky:
            return Color(red: 0.72, green: 0.86, blue: 0.96)
        case .mint:
            return Color(red: 0.72, green: 0.93, blue: 0.84)
        case .sage:
            return Color(red: 0.72, green: 0.79, blue: 0.67)
        case .peach:
            return Color(red: 0.98, green: 0.76, blue: 0.61)
        case .butter:
            return Color(red: 0.98, green: 0.91, blue: 0.55)
        case .graphite:
            return Color(red: 0.18, green: 0.18, blue: 0.20)
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

    var sizePreset: WidgetSizePreset

    var backgroundKind: WidgetBackgroundKind
    var backgroundOpacity: Double
    var backgroundDimOpacity: Double
    var cornerRadius: Double
    var color: WidgetColor

    var mediaPath: String?
    var albumPaths: [String]
    var albumInterval: Double

    var noteText: String
    var quoteText: String
    var bookmarkTitle: String
    var bookmarkURL: String
    var timerMinutes: Int

    var weatherCity: String
    var weatherLatitude: Double
    var weatherLongitude: Double

    init(
        id: UUID = UUID(),
        type: WidgetType,
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        sizePreset: WidgetSizePreset = .smallRectangle,
        backgroundKind: WidgetBackgroundKind = .color,
        backgroundOpacity: Double = 0.75,
        backgroundDimOpacity: Double = 0.18,
        cornerRadius: Double = 28,
        color: WidgetColor = .glass,
        mediaPath: String? = nil,
        albumPaths: [String] = [],
        albumInterval: Double = 10,
        noteText: String = "Write something...",
        quoteText: String = "Make your desktop yours.",
        bookmarkTitle: String = "Open Link",
        bookmarkURL: String = "https://www.apple.com",
        timerMinutes: Int = 25,
        weatherCity: String = "Amsterdam",
        weatherLatitude: Double = 52.37,
        weatherLongitude: Double = 4.89
    ) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.sizePreset = sizePreset
        self.backgroundKind = backgroundKind
        self.backgroundOpacity = backgroundOpacity
        self.backgroundDimOpacity = backgroundDimOpacity
        self.cornerRadius = cornerRadius
        self.color = color
        self.mediaPath = mediaPath
        self.albumPaths = albumPaths
        self.albumInterval = albumInterval
        self.noteText = noteText
        self.quoteText = quoteText
        self.bookmarkTitle = bookmarkTitle
        self.bookmarkURL = bookmarkURL
        self.timerMinutes = timerMinutes
        self.weatherCity = weatherCity
        self.weatherLatitude = weatherLatitude
        self.weatherLongitude = weatherLongitude
    }
}
