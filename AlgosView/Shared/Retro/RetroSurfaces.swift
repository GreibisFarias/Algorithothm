//
//  RetroSurfaces.swift
//  Algorithothm
//
//  Backgrounds and boxes of the design.
//

import SwiftUI

/// The background of every retro screen: the bookshelf, very dark. Put it at the bottom of a ZStack.
struct RetroBackground: View {
    var body: some View {
        Retro.background
            .overlay {
                if let image = UIImage(named: "RetroLibrary.jpg") {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.14)
                }
            }
            .clipped()
            .ignoresSafeArea()
    }
}

extension View {
    /// Box with the corners cut, like pixel art ("¿Qué hace?", the rating panel).
    /// `ledge` adds a darker 8pt edge at the bottom, like the monitor. Adds 4pt of margin.
    func pixelPanel(_ face: Color, ledge: Color? = nil) -> some View {
        background {
            ZStack {
                (ledge ?? face).padding(.bottom, ledge == nil ? -4 : -8)
                face.padding(.top, -4)
                face.padding(.horizontal, -4)
            }
        }
        .padding(4)
    }

    /// Beige block with a 4pt darker edge below: code blocks and small options.
    func retroBlock(pressed: Bool = false) -> some View {
        foregroundStyle(Retro.screen)
            .background(Retro.bezel)
            .background(Retro.bezelShadow.offset(y: pressed ? 1 : 4))
            .offset(y: pressed ? 3 : 0)
    }
}
