//
//  PixelIcon.swift
//  Algorithothm
//
//  Icons drawn on an 8×8 grid, like the SVGs of the design. To add one, copy the
//  `<rect x y width height>` of its SVG (viewBox "0 0 8 8") into a new static list.
//

import SwiftUI

struct PixelIcon: View {
    let pixels: [CGRect]
    var color: Color
    /// Size of the grid of the SVG's viewBox.
    var grid: CGFloat = 8

    var body: some View {
        Canvas { context, size in
            let unit = min(size.width, size.height) / grid
            for pixel in pixels {
                let rect = CGRect(x: pixel.minX * unit, y: pixel.minY * unit, width: pixel.width * unit, height: pixel.height * unit)
                context.fill(Path(rect), with: .color(color))
            }
        }
        .accessibilityHidden(true)
    }

    static let backArrow = [
        CGRect(x: 4, y: 1, width: 1, height: 1), CGRect(x: 3, y: 2, width: 1, height: 1),
        CGRect(x: 2, y: 3, width: 1, height: 2), CGRect(x: 3, y: 5, width: 1, height: 1),
        CGRect(x: 4, y: 6, width: 1, height: 1)
    ]

    static let flip = [
        CGRect(x: 2, y: 1, width: 4, height: 1), CGRect(x: 1, y: 2, width: 1, height: 4),
        CGRect(x: 2, y: 6, width: 4, height: 1), CGRect(x: 6, y: 2, width: 1, height: 1),
        CGRect(x: 5, y: 3, width: 3, height: 1)
    ]

    static let close = [
        CGRect(x: 1, y: 1, width: 1, height: 1), CGRect(x: 2, y: 2, width: 1, height: 1),
        CGRect(x: 3, y: 3, width: 2, height: 2), CGRect(x: 5, y: 5, width: 1, height: 1),
        CGRect(x: 6, y: 6, width: 1, height: 1), CGRect(x: 6, y: 1, width: 1, height: 1),
        CGRect(x: 5, y: 2, width: 1, height: 1), CGRect(x: 2, y: 5, width: 1, height: 1),
        CGRect(x: 1, y: 6, width: 1, height: 1)
    ]

    static let menu = [
        CGRect(x: 1, y: 1, width: 6, height: 1), CGRect(x: 1, y: 3.5, width: 6, height: 1),
        CGRect(x: 1, y: 6, width: 6, height: 1)
    ]

    /// Speech bubble ("Idioma de la app").
    static let language = [
        CGRect(x: 0, y: 1, width: 6, height: 1), CGRect(x: 0, y: 5, width: 6, height: 1),
        CGRect(x: 0, y: 1, width: 1, height: 5), CGRect(x: 5, y: 1, width: 1, height: 5),
        CGRect(x: 1, y: 5, width: 1, height: 2), CGRect(x: 2, y: 3, width: 2, height: 1),
        CGRect(x: 6, y: 3, width: 2, height: 1), CGRect(x: 6, y: 5, width: 2, height: 1)
    ]

    static let bell = [
        CGRect(x: 2, y: 1, width: 4, height: 1), CGRect(x: 1, y: 2, width: 1, height: 4),
        CGRect(x: 6, y: 2, width: 1, height: 4), CGRect(x: 0, y: 6, width: 8, height: 1),
        CGRect(x: 3, y: 7, width: 2, height: 1)
    ]

    static let info = [
        CGRect(x: 0, y: 0, width: 8, height: 1), CGRect(x: 0, y: 7, width: 8, height: 1),
        CGRect(x: 0, y: 0, width: 1, height: 8), CGRect(x: 7, y: 0, width: 1, height: 8),
        CGRect(x: 3.5, y: 2, width: 1, height: 1), CGRect(x: 3.5, y: 3.5, width: 1, height: 3)
    ]

    /// A plus-shaped twinkle, on a 5×5 grid (`grid: 5`).
    static let sparkle = [
        CGRect(x: 2, y: 0, width: 1, height: 5), CGRect(x: 0, y: 2, width: 5, height: 1)
    ]
}

/// Pixel art with more than one color, like the avatar. Same grid idea as PixelIcon.
struct PixelArt: View {
    struct Pixel {
        let rect: CGRect
        let color: Color

        init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, _ color: Color) {
            self.rect = CGRect(x: x, y: y, width: width, height: height)
            self.color = color
        }
    }

    let pixels: [Pixel]
    var grid: CGFloat = 16

    var body: some View {
        Canvas { context, size in
            let unit = min(size.width, size.height) / grid
            for pixel in pixels {
                let rect = pixel.rect
                context.fill(
                    Path(CGRect(x: rect.minX * unit, y: rect.minY * unit, width: rect.width * unit, height: rect.height * unit)),
                    with: .color(pixel.color)
                )
            }
        }
        .accessibilityHidden(true)
    }

    /// The person of the profile, on a 16×16 grid.
    static let avatar: [Pixel] = [
        Pixel(6, 2, 4, 1, Retro.sky), Pixel(5, 3, 6, 4, Retro.sky), Pixel(6, 7, 4, 1, Retro.sky),
        Pixel(9, 3, 2, 4, Retro.skyShade), Pixel(9, 7, 1, 1, Retro.skyShade), Pixel(7, 8, 2, 1, Retro.skyShade),
        Pixel(4, 9, 8, 1, Retro.sky), Pixel(3, 10, 10, 1, Retro.sky), Pixel(2, 11, 12, 5, Retro.sky),
        Pixel(10, 9, 2, 1, Retro.skyShade), Pixel(10, 10, 3, 1, Retro.skyShade), Pixel(10, 11, 4, 5, Retro.skyShade)
    ]
}
