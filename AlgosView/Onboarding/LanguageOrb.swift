//
//  LanguageOrb.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  The glass orb of each programming language. Swift uses the orb of the design; Python and
//  Java are drawn here until their images are exported. To use a real one, add its PNG to
//  Algorithothm/Resources and return its name from `orbImage`.
//

import SwiftUI

struct LanguageOrb: View {
    let language: ProgrammingLenguages

    var body: some View {
        if let image = language.orbImage {
            RetroImage(image)
                .scaledToFit()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack {
                Circle()
                    .fill(RadialGradient(
                        colors: [language.orbColors.light, language.orbColors.base, language.orbColors.dark],
                        center: UnitPoint(x: 0.35, y: 0.3),
                        startRadius: side * 0.05,
                        endRadius: side * 0.6
                    ))
                Circle()
                    .strokeBorder(language.orbColors.dark, lineWidth: side * 0.035)

                Text(language.orbSymbol)
                    .font(RetroFont.pixel(side * 0.34))
                    .foregroundStyle(language.orbColors.symbol)
                    .shadow(color: language.orbColors.dark, radius: 0, x: side * 0.02, y: side * 0.02)

                // the shine of the glass
                Capsule()
                    .fill(.white.opacity(0.35))
                    .frame(width: side * 0.28, height: side * 0.1)
                    .rotationEffect(.degrees(-35))
                    .offset(x: -side * 0.22, y: -side * 0.3)
                PixelIcon(pixels: PixelIcon.sparkle, color: .white.opacity(0.8), grid: 5)
                    .frame(width: side * 0.07, height: side * 0.07)
                    .offset(x: side * 0.28, y: -side * 0.22)
            }
            .frame(width: side, height: side)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}

private extension ProgrammingLenguages {
    /// File of the orb of the design, nil while it is drawn as a placeholder.
    var orbImage: String? {
        switch self {
        case .swift: "OrbSwift.png"
        case .python, .java: nil
        }
    }

    var orbSymbol: String {
        switch self {
        case .swift: "S"
        case .python: "PY"
        case .java: "J"
        }
    }

    var orbColors: (light: Color, base: Color, dark: Color, symbol: Color) {
        switch self {
        case .swift:
            (Color(retroHex: 0xF6B27A), Color(retroHex: 0xD9572B), Color(retroHex: 0x6E2412), Color(retroHex: 0xFFE3C9))
        case .python:
            (Color(retroHex: 0x8DB8E8), Color(retroHex: 0x3B6FB6), Color(retroHex: 0x1A2F55), Color(retroHex: 0xFFD43B))
        case .java:
            (Color(retroHex: 0xF6D58A), Color(retroHex: 0xD98A1F), Color(retroHex: 0x6B3A0C), Color(retroHex: 0xFFF3D6))
        }
    }
}

#Preview {
    HStack {
        ForEach(ProgrammingLenguages.allCases) { language in
            LanguageOrb(language: language)
                .frame(width: 110, height: 110)
        }
    }
    .padding()
    .background(Retro.background)
}
