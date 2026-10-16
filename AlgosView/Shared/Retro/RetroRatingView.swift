//
//  RetroRatingView.swift
//  Algorithothm
//
//  "Good job" panel at the end of every retro card, where the user rates how hard it was.
//  Its answer is what will feed FSRS.
//

import SwiftUI

struct RetroRatingView: View {
    let theme: RetroCardTheme
    var onRate: (ExerciseDifficulty) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("¡BUEN TRABAJO!")
                .font(RetroFont.pixel(24, relativeTo: .title2))
                .foregroundStyle(theme.accent)
            Text("¿Qué tan difícil fue?")
                .font(RetroFont.pixel(17))

            HStack(spacing: 10) {
                ForEach(ExerciseDifficulty.allCases, id: \.self) { difficulty in
                    Button(difficulty.label) { onRate(difficulty) }
                        .buttonStyle(RetroBlockButtonStyle())
                }
            }
            .padding(.top, 4)
        }
        .foregroundStyle(Retro.text)
        .padding(24)
        .frame(maxWidth: .infinity)
        .pixelPanel(Retro.panel)
        .padding(.horizontal, 24)
    }
}

/// The rating over a dark layer that covers the card. Put it at the top of the card's ZStack.
struct RetroRatingOverlay: View {
    let theme: RetroCardTheme
    var onRate: (ExerciseDifficulty) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .transition(.opacity)
            RetroRatingView(theme: theme, onRate: onRate)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
    }
}

private extension ExerciseDifficulty {
    var label: String {
        switch self {
        case .easy: "Fácil"
        case .medium: "Medio"
        case .hard: "Difícil"
        }
    }
}
