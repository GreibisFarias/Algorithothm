//
//  RetroDeck.swift
//  Algorithothm
//
//  A deck of retro cards: shows the exercises one after the other in the language the user
//  picked, and a "deck complete" screen at the end. Each card type only says how to build its card.
//
//      RetroDeck(exercises: SortingExercise.all, theme: .aprendeYArma) { exercise, deck in
//          SortingInteractionCard(exercise: exercise, language: deck.language,
//                                 progress: deck.progress, onRate: deck.onRate, onClose: deck.onClose)
//      }
//

import SwiftUI

/// What a card needs from the deck it is in.
struct RetroDeckContext {
    let language: ProgrammingLenguages
    /// "3/10"
    let progress: String?
    /// Call it once the user rated the card, the deck moves to the next one.
    let onRate: (ExerciseDifficulty) -> Void
    /// Back to the home screen.
    let onClose: () -> Void
}

struct RetroDeck<Exercise: Identifiable, Card: View>: View {
    @AppStorage(ProgrammingLenguages.storageKey) private var language: ProgrammingLenguages = .swift
    @State private var viewModel: CardDeckViewModel<Exercise>
    @Environment(\.dismiss) private var dismiss

    private let theme: RetroCardTheme
    private let card: (Exercise, RetroDeckContext) -> Card

    init(
        exercises: [Exercise],
        theme: RetroCardTheme,
        @ViewBuilder card: @escaping (Exercise, RetroDeckContext) -> Card
    ) {
        _viewModel = State(initialValue: CardDeckViewModel(exercises: exercises))
        self.theme = theme
        self.card = card
    }

    var body: some View {
        Group {
            if let exercise = viewModel.currentExercise {
                card(exercise, context)
                    // a new card for each exercise, so it starts from a fresh state
                    .id("\(exercise.id)-\(language.id)")
                    .transition(.push(from: .trailing))
            } else {
                deckComplete
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    private var context: RetroDeckContext {
        RetroDeckContext(language: language, progress: viewModel.progress, onRate: rate, onClose: { dismiss() })
    }

    private var deckComplete: some View {
        ZStack {
            RetroBackground()

            VStack(spacing: 20) {
                HStack {
                    RetroIconButton(pixels: PixelIcon.backArrow, accessibilityLabel: "Volver al inicio") { dismiss() }
                    Spacer()
                }

                Spacer()

                RetroMonitor {
                    MonitorCodeLine(code: "> mazo completado", language: language, size: 22, tint: Retro.phosphor)
                    MonitorCodeLine(code: "> \(viewModel.exercises.count)/\(viewModel.exercises.count) tarjetas", language: language, size: 22, tint: Retro.phosphor)
                }

                Text("¡Terminaste todas las tarjetas de este mazo!")
                    .font(RetroFont.pixel(17))
                    .foregroundStyle(theme.accent)
                    .multilineTextAlignment(.center)

                Spacer()

                Button("Empezar de nuevo") {
                    withAnimation { viewModel.restart() }
                }
                .buttonStyle(theme.button)
            }
            .foregroundStyle(Retro.text)
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        Task {
            // leave a moment to close the rating before moving on
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation { viewModel.rate(difficulty) }
        }
    }
}
