//
//  RetroCardTheme.swift
//  Algorithothm
//
//  What changes from one type of card to another: its name in the header, its accent color and
//  its main button. The header, the rating and the deck take it, so a new type of card only
//  needs a new theme here.
//

import SwiftUI

struct RetroCardTheme {
    /// Shown at the top of the card, "TIPO 1 · PREDICE".
    let title: String
    /// Header, progress bar, rating title.
    let accent: Color
    /// "Comprobar", "Continuar"...
    let button: RetroButtonStyle

    static let predice = RetroCardTheme(title: "TIPO 1 · PREDICE", accent: Retro.phosphor, button: .phosphor)
    static let aprendeYArma = RetroCardTheme(title: "TIPO 2 · APRENDE Y ARMA", accent: Retro.accent, button: .accent)
}
