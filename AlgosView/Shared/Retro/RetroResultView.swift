//
//  RetroResultView.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  "¡Bien hecho!" screen at the end of every retro card: how it went and how hard it felt.
//  The rating is what will feed FSRS. Every card type shows this same screen, only the
//  summary line and the accent of the progress bar change.
//
//      RetroResultView(theme: .predice, summary: "2 de 2 correctas", onRate: rate, onClose: close)
////
//
//import SwiftUI
//
//struct RetroResultView: View {
//    let theme: RetroCardTheme
//    /// Under the title, "2 de 2 correctas".
//    let summary: String
//    var onRate: (ExerciseDifficulty) -> Void
//    var onClose: () -> Void
//
//    var body: some View {
//        ZStack {
//            RetroBackground()
//
//            ScrollView {
//                VStack(spacing: 14) {
//                    header
//
//                    mascot
//                        .padding(.top, 8)
//
//                    Text("¡Bien hecho!")
//                        .font(RetroFont.pixel(40, relativeTo: .largeTitle))
//                        .tracking(1)
//                        .shadow(color: Retro.panelStroke, radius: 0, x: 3, y: 3)
//                        .accessibilityAddTraits(.isHeader)
//
//                    Text(summary)
//                        .font(RetroFont.pixel(16))
//                        .foregroundStyle(Retro.phosphor)
//
//                    Text("¿Cómo te sentiste\ncon este ejercicio?")
//                        .font(RetroFont.pixel(20))
//                        .lineSpacing(6)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 18)
//                        .padding(.bottom, 4)
//
//                    VStack(spacing: 12) {
//                        ForEach(ExerciseDifficulty.hardestFirst, id: \.self) { difficulty in
//                            RetroDifficultyButton(difficulty: difficulty) { onRate(difficulty) }
//                        }
//                    }
//                    .accessibilityElement(children: .contain)
//                    .accessibilityLabel("Dificultad del ejercicio")
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 12)
//                .padding(.bottom, 32)
//            }
//            .scrollBounceBehavior(.basedOnSize)
//        }
//        .foregroundStyle(Retro.text)
//    }
//
//    private var header: some View {
//        HStack(spacing: 12) {
//            RetroIconButton(pixels: PixelIcon.close, accessibilityLabel: "Cerrar y volver al inicio", action: onClose)
//            // the card is done: the whole bar is filled
//            theme.accent
//                .frame(height: 8)
//        }
//    }
//
//    private var mascot: some View {
//        ZStack {
//            Retro.phosphor
//                .frame(width: 150, height: 110)
//                .opacity(0.18)
//                .blur(radius: 30)
//                .offset(y: -15)
//
//            RetroImage("RetroMascot.png")
//                .scaledToFit()
//                .frame(width: 170, height: 180)
//                .accessibilityLabel("La compu sonriendo")
//
//            PixelIcon(pixels: PixelIcon.sparkle, color: Retro.gold, grid: 5)
//                .frame(width: 20, height: 20)
//                .offset(x: 81, y: -74)
//            PixelIcon(pixels: PixelIcon.sparkle, color: Retro.phosphor, grid: 5)
//                .frame(width: 14, height: 14)
//                .offset(x: -88, y: -23)
//        }
//        .frame(width: 190, height: 180)
//    }
//}
//
///// One answer to "¿Cómo te sentiste?": a dark box outlined in the color of the difficulty,
///// with a signal-bars icon, the answer and when the card comes back.
//private struct RetroDifficultyButton: View {
//    let difficulty: ExerciseDifficulty
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 16) {
//                bars
//                    .frame(width: 28, height: 28)
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(difficulty.resultTitle)
//                        .font(RetroFont.pixel(20))
//                    Text(difficulty.resultSubtitle)
//                        .font(RetroFont.pixel(14))
//                        .foregroundStyle(Retro.mutedText)
//                }
//                Spacer(minLength: 0)
//            }
//            .padding(.horizontal, 18)
//            .frame(maxWidth: .infinity, minHeight: 68, alignment: .leading)
//            .background(Retro.panel)
//            .overlay { Rectangle().strokeBorder(difficulty.resultColor, lineWidth: 3) }
//            .contentShape(Rectangle())
//        }
//        .buttonStyle(PressableStyle())
//    }
//
//    /// 1, 2 or 3 bars lit, like a signal: the easier it was, the more bars.
//    private var bars: some View {
//        let lit = difficulty.resultBars
//        return PixelArt(pixels: [
//            PixelArt.Pixel(0, 4, 2, 3, lit >= 1 ? difficulty.resultColor : Retro.ghostStroke),
//            PixelArt.Pixel(2.5, 2, 2, 5, lit >= 2 ? difficulty.resultColor : Retro.ghostStroke),
//            PixelArt.Pixel(5, 0, 2, 7, lit >= 3 ? difficulty.resultColor : Retro.ghostStroke)
//        ], grid: 7)
//    }
//}
//
///// Moves the button down a bit while it is pressed.
//private struct PressableStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .offset(y: configuration.isPressed ? 2 : 0)
//            .opacity(configuration.isPressed ? 0.85 : 1)
//    }
//}
//
//private extension ExerciseDifficulty {
//    /// The order of the design: hardest first.
//    static let hardestFirst: [ExerciseDifficulty] = [.hard, .medium, .easy]
//
//    var resultTitle: String {
//        switch self {
//        case .hard: "Fue difícil"
//        case .medium: "Estuvo bien"
//        case .easy: "¡Muy fácil!"
//        }
//    }
//
//    var resultSubtitle: String {
//        switch self {
//        case .hard: "La repasarás pronto"
//        case .medium: "Vuelve en unos días"
//        case .easy: "Vuelve más adelante"
//        }
//    }
//
//    var resultColor: Color {
//        switch self {
//        case .hard: Retro.accent
//        case .medium: Retro.phosphor
//        case .easy: Retro.gold
//        }
//    }
//
//    var resultBars: Int {
//        switch self {
//        case .hard: 1
//        case .medium: 2
//        case .easy: 3
//        case .again: 
//        }
//    }
//}
//
//#Preview {
//    RetroResultView(theme: .predice, summary: "2 de 2 correctas", onRate: { _ in }, onClose: {})
//}
