//
//  RetroGallery.swift
//  Algorithothm
//
//  Every shared retro component in one preview, so you can see what exists before
//  building a new screen of the design. Open the canvas of this file.
//
//  HOW TO BUILD A NEW TYPE OF CARD
//
//  1. Add its theme in RetroCardTheme (title of the header, accent color, button).
//  2. Lay out the card like the existing ones:
//
//         ZStack {
//             RetroBackground()
//             VStack(spacing: 20) {
//                 RetroCardHeader(theme: .myType, stepLabel: "1/10", steps: 1, currentStep: 0, onBack: onClose)
//                     .padding(.horizontal, 24)
//                 ScrollView {
//                     RetroMonitor { MonitorCode(code: ..., language: language) }
//                     // the content of the card
//                 }
//                 .safeAreaInset(edge: .bottom) {
//                     Button("Comprobar", action: check).buttonStyle(RetroCardTheme.myType.button)
//                 }
//             }
//             if isFinished { RetroResultView(theme: .myType, summary: "1 de 1", onRate: onRate, onClose: onClose) }
//         }
//
//  3. Put it in a deck: RetroDeck(exercises: ..., theme: .myType) { exercise, deck in MyCard(...) }.
//     The deck gives the card the language the user picked, its position and what to call
//     when it's rated or closed.
//
//  Card files to copy from: MultipleChoiceCard (the simplest) and SortingInteractionCard.
//
//
//import SwiftUI
//
//#Preview("Components") {
//    ZStack {
//        RetroBackground()
//
//        ScrollView {
//            VStack(alignment: .leading, spacing: 24) {
//                RetroCardHeader(theme: .predice, stepLabel: "1/10 · 1/2", steps: 2, currentStep: 0) {}
//                RetroCardHeader(theme: .aprendeYArma, stepLabel: "1/10 · REVERSO", steps: 2, currentStep: 1) {}
//
//                RetroMonitor {
//                    MonitorCode(
//                        code: CodeExample("""
//                            func mayor(_ nums: [Int]) -> Int {
//                              var mayor = nums[0]
//                              for n in nums {
//                                if n > mayor { mayor = n }
//                              }
//                              return mayor
//                            }
//                            """, highlight: "if n > mayor { mayor = n }"),
//                        language: .swift
//                    )
//                }
//
//                RetroMonitor(screen: Retro.screenCorrect, border: Retro.phosphor) {
//                    MonitorCodeLine(code: "> monitor con resultado correcto", language: .swift, tint: Retro.phosphor)
//                }
//
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("¿QUÉ HACE?")
//                        .font(RetroFont.pixel(14, relativeTo: .caption))
//                        .foregroundStyle(Retro.accent)
//                    Text("Texto en un panel pixelado: .pixelPanel(Retro.panel)")
//                        .font(RetroFont.pixel(17))
//                }
//                .padding(18)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .pixelPanel(Retro.panel)
//
//                VStack(spacing: 12) {
//                    RetroOptionButton(text: "idle", state: .idle) {}
//                    RetroOptionButton(text: "selected", state: .selected) {}
//                    RetroOptionButton(text: "wrong", state: .wrong) {}
//                    RetroOptionButton(text: "correct", state: .correct) {}
//                }
//
//                Text("bloque de código: .retroBlock()")
//                    .font(RetroFont.terminal(17))
//                    .padding(.horizontal, 14)
//                    .frame(height: 44)
//                    .retroBlock()
//
//                HStack(spacing: 12) {
//                    RetroIconButton(pixels: PixelIcon.backArrow, accessibilityLabel: "Atrás") {}
//                    PixelIcon(pixels: PixelIcon.flip, color: Retro.accent)
//                        .frame(width: 22, height: 22)
//                }
//
//                Button("RetroButtonStyle.accent") {}
//                    .buttonStyle(RetroButtonStyle.accent)
//                Button("RetroButtonStyle.phosphor") {}
//                    .buttonStyle(RetroButtonStyle.phosphor)
//                Button("Desactivado") {}
//                    .buttonStyle(RetroButtonStyle.phosphor)
//                    .disabled(true)
//            }
//            .foregroundStyle(Retro.text)
//            .padding(24)
//        }
//    }
//}
//
//#Preview("Result") {
//    RetroResultView(theme: .aprendeYArma, summary: "¡Lo armaste a la primera!", onRate: { _ in }, onClose: {})
//}
