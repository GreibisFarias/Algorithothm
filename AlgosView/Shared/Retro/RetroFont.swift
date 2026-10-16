//
//  RetroFont.swift
//  Algorithothm
//
//  The two fonts of the design, bundled in Algorithothm/Resources/Fonts:
//  - Pixelta: titles, labels and text. It has no accents or ¿¡, those characters fall back to
//    the system font (same as in the design export).
//  - VT323: code, it is monospaced. ~6.8pt per character at 17pt, so the monitor fits
//    about 42 characters at 17pt and 39 at 18pt.
//

import SwiftUI
import CoreText

enum RetroFont {
    /// The fonts are registered the first time one is used, so they also work in previews,
    /// where the App is not launched. Nothing to add to Info.plist.
    private static let registered: Void = {
        for name in ["Pixelta-Regular", "VT323-Regular"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else {
                assertionFailure("\(name).ttf is missing from the bundle")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()

    /// Pixel font. It grows with Dynamic Type, relative to `style`.
    static func pixel(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        _ = registered
        return .custom("Pixelta-Regular", size: size, relativeTo: style)
    }

    /// Code font. Fixed size, so the code always fits the monitor.
    static func terminal(_ size: CGFloat) -> Font {
        _ = registered
        return .custom("VT323-Regular", fixedSize: size)
    }
}
