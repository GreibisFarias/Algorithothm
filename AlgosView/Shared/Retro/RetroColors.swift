//
//  RetroColors.swift
//  Algorithothm
//
//  Every color of the pixel-art design ("UCV project"). Use these instead of hex values,
//  so a change of the palette is done here once.
//

import SwiftUI

enum Retro {

    // MARK: Screen

    /// Dark purple behind everything.
    static let background = Color(retroHex: 0x171021)
    /// Cream, main text.
    static let text = Color(retroHex: 0xF3EDE0)
    /// Secondary text ("Ahora es tu turno...").
    static let mutedText = Color(retroHex: 0xCFC5D6)
    /// Wrong answers and error messages.
    static let error = Color(retroHex: 0xE8705E)

    // MARK: Accents (each card type has one, see RetroCardTheme)

    /// Orange of "Tipo 2 · Aprende y arma", also its main button.
    static let accent = Color(retroHex: 0xDD9A64)
    /// Solid shadow below an orange button.
    static let accentShadow = Color(retroHex: 0xA63E2F)
    /// Phosphor green: code on the monitor, right answers and the accent of "Tipo 1 · Predice".
    static let phosphor = Color(retroHex: 0x4CE07A)
    /// Solid shadow below a green button.
    static let phosphorShadow = Color(retroHex: 0x1F7A3E)
    /// Gold: achievements, "¡Muy fácil!", reminders.
    static let gold = Color(retroHex: 0xEAD18E)
    /// Light blue of "Tipo 3 · Arquitectura" and the avatar.
    static let sky = Color(retroHex: 0xB9D7DD)
    /// Shadow side of `sky`.
    static let skyShade = Color(retroHex: 0x7FA3AD)

    // MARK: Panels

    /// Dark boxes: "¿Qué hace?", options, the back button.
    static let panel = Color(retroHex: 0x2D192C)
    /// Outline of the dark boxes.
    static let panelStroke = Color(retroHex: 0x69283B)
    /// Dark layer over the screen behind a side menu.
    static let dim = Color(retroHex: 0x0A0610).opacity(0.72)
    /// Text of a disabled button ("Elige una opción").
    static let disabledText = Color(retroHex: 0xA99BB3)
    /// Something used or disabled: outline...
    static let ghostStroke = Color(retroHex: 0x4A3A52)
    /// ...and its text.
    static let ghostText = Color(retroHex: 0x6E5F78)

    // MARK: Monitor

    /// Beige case of the monitor, also the code blocks.
    static let bezel = Color(retroHex: 0xD4CAB2)
    /// Darker edge below the beige things.
    static let bezelShadow = Color(retroHex: 0x8A806E)
    /// The screen.
    static let screen = Color(retroHex: 0x0E1A12)
    /// Dim green: empty slots, comments.
    static let phosphorDim = Color(retroHex: 0x2F6B44)
    /// Band behind the line of code the text talks about.
    static let highlightedLine = Color(retroHex: 0x1F4A2C)
    /// Screen tint once an answer is checked.
    static let screenCorrect = Color(retroHex: 0x173A22)
    static let screenWrong = Color(retroHex: 0x3A1418)
}

extension Color {
    /// `Color(retroHex: 0xDD9A64)`, as the hex values of the design.
    init(retroHex hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
