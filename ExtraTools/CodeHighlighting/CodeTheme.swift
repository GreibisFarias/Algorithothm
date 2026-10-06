//
//  CodeTheme.swift
//  Algorithothm
//
//  Colors used for each kind of token. Every color adapts to light and dark mode.
//

import SwiftUI
import UIKit

struct CodeTheme {
    var plain: Color
    var keyword: Color
    var type: Color
    var function: Color
    var string: Color
    var number: Color
    var comment: Color
    var attribute: Color
    var background: Color
    var boldKeywords = true

    func color(for kind: CodeTokenKind) -> Color {
        switch kind {
        case .plain: plain
        case .keyword: keyword
        case .type: type
        case .function: function
        case .string: string
        case .number: number
        case .comment: comment
        case .attribute: attribute
        }
    }
}

extension CodeTheme {
    /// Based on Xcode's default light and dark themes.
    static let xcode = CodeTheme(
        plain: Color(light: 0x1D1D1F, dark: 0xDFDFE0),
        keyword: Color(light: 0x9B2393, dark: 0xFF7AB2),
        type: Color(light: 0x3900A0, dark: 0xDABAFF),
        function: Color(light: 0x326D74, dark: 0x67B7A4),
        string: Color(light: 0xC41A16, dark: 0xFF8170),
        number: Color(light: 0x1C00CF, dark: 0xD9C97C),
        comment: Color(light: 0x5D6C79, dark: 0x7F8C98),
        attribute: Color(light: 0x815F03, dark: 0xCC9768),
        background: Color(light: 0xFFFFFF, dark: 0x1F1F24)
    )
}

extension EnvironmentValues {
    /// Theme used by every `CodeText` below. Change it with `.environment(\.codeTheme, ...)`.
    @Entry var codeTheme: CodeTheme = .xcode
}

private extension Color {
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
