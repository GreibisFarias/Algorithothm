//
//  RetroButtons.swift
//  Algorithothm
//
//  Buttons of the design. For the answers of a question see RetroOptionButton.
//

import SwiftUI

/// Big full-width button with a solid shadow below ("Gira la tarjeta", "Comprobar").
/// Disabled, it turns into the outlined dark box of the design ("Elige una opción").
///
///     Button("Comprobar", action: check)
///         .buttonStyle(theme.button)      // or RetroButtonStyle.accent / .phosphor
struct RetroButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    /// Color of the text and the icons of the label.
    let color: Color
    var face: Color = Retro.accent
    var shadow: Color = Retro.accentShadow

    /// Orange, "Tipo 2 · Aprende y arma".
    static let accent = RetroButtonStyle(color: Retro.background)
    /// Green, "Tipo 1 · Predice".
    static let phosphor = RetroButtonStyle(color: Retro.screen, face: Retro.phosphor, shadow: Retro.phosphorShadow)

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && isEnabled
        configuration.label
            .font(RetroFont.pixel(22, relativeTo: .title3))
            .foregroundStyle(isEnabled ? color : Retro.disabledText)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(isEnabled ? face : Retro.panel)
            .overlay { Rectangle().strokeBorder(isEnabled ? .clear : Retro.ghostStroke, lineWidth: 3) }
            .background(isEnabled ? shadow : .clear, in: Rectangle().offset(y: pressed ? 2 : 6))
            .offset(y: pressed ? 4 : 0)
            .animation(.easeOut(duration: 0.08), value: pressed)
    }
}

/// Small beige button, like a code block ("Fácil", "Medio", "Difícil").
struct RetroBlockButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(RetroFont.pixel(18))
            .frame(maxWidth: .infinity, minHeight: 44)
            .retroBlock(pressed: configuration.isPressed)
    }
}

/// 44pt square button with a pixel icon (the back arrow of the header).
struct RetroIconButton: View {
    let pixels: [CGRect]
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            PixelIcon(pixels: pixels, color: Retro.text)
                .frame(width: 20, height: 20)
                .background(Retro.panel)
                .overlay { Rectangle().strokeBorder(Retro.panelStroke, lineWidth: 2) }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}


