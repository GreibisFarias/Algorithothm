//
//  SortingCardFront.swift
//  Algorithothm
//
//  Front of the card ("Aprende"): a solved function with the important line highlighted
//  and an explanation of what it does.
//

import SwiftUI

struct SortingCardFront: View {
    let viewModel: SortingCardViewModel
    let onFlip: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RetroMonitor {
                    MonitorCode(code: viewModel.example, language: viewModel.language)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("¿QUÉ HACE?")
                        .font(RetroFont.pixel(14, relativeTo: .caption))
                        .foregroundStyle(Retro.accent)
                        .tracking(1)
                    Text(viewModel.exercise.explanation)
                        .font(RetroFont.pixel(17))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .pixelPanel(Retro.panel)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Text("Ahora es tu turno: arma un código de este estilo.")
                    .font(RetroFont.pixel(16))
                    .foregroundStyle(Retro.mutedText)
                    .multilineTextAlignment(.center)

                Button(action: onFlip) {
                    HStack(spacing: 10) {
                        PixelIcon(pixels: PixelIcon.flip, color: Retro.background)
                            .frame(width: 22, height: 22)
                        Text("Gira la tarjeta")
                    }
                }
                .buttonStyle(RetroCardTheme.aprendeYArma.button)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
    }
}
