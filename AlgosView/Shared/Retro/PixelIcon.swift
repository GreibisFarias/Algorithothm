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

    var body: some View {
        Canvas { context, size in
            let unit = min(size.width, size.height) / 8
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
}
