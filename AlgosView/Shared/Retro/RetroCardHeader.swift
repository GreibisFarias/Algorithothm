//
//  RetroCardHeader.swift
//  Algorithothm
//
//  Header of every retro card: back button, card type and a bar with one segment per step
//  (front/back of a "Tipo 2" card, each question of a "Tipo 1" card).
//

import SwiftUI

struct RetroCardHeader: View {
    let theme: RetroCardTheme
    /// Text on the right, "1/10 · FRENTE".
    let stepLabel: String
    let steps: Int
    /// Zero based. Every segment up to this one is filled.
    let currentStep: Int
    var backLabel = "Volver al inicio"
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            RetroIconButton(pixels: PixelIcon.backArrow, accessibilityLabel: backLabel, action: onBack)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(theme.title)
                        .foregroundStyle(theme.accent)
                    Spacer()
                    Text(stepLabel)
                }
                .font(RetroFont.pixel(14, relativeTo: .caption))
                .lineLimit(1)

                HStack(spacing: 2) {
                    ForEach(0..<steps, id: \.self) { step in
                        step <= currentStep ? theme.accent : Color.clear
                    }
                }
                .frame(height: 8)
                .background(Retro.panel)
                .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .foregroundStyle(Retro.text)
    }
}
