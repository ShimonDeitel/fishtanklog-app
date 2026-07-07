import SwiftUI

/// Bespoke palette for Fishtank Log -- Track aquarium water parameters, livestock, and maintenance schedule.
enum Theme {
    static let accent = Color(hex: "#2E9E9E")
    static let background = Color(hex: "#0B1E22")
    static let backgroundSecondary = Color(hex: "#102A2F")
    static let card = Color(hex: "#123339")
    static let textPrimary = Color(hex: "#E8F6F5")
    static let textSecondary = Color(hex: "#9FCFCB")

    static var titleFont: Font { Font.system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { Font.system(.body, design: .rounded) }
    static var captionFont: Font { Font.system(.caption, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
