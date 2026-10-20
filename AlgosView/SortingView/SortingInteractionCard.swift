//
//  SortingInteractionCard.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//
//  "Tipo 2 · Aprende y arma" card: a front that teaches with a solved example and a back where
//  the user builds a similar function. Flipping, submitting and the animations live here.
//

import SwiftUI

struct SortingInteractionCard: View {

    @State private var viewModel: SortingCardViewModel
    private let progress: String?
    private let onClose: () -> Void

    // Animation only: where each slot is and which blocks already reached the big monitor.
    @State private var slotFrames: [Int: CGRect] = [:]
    @State private var landed: Set<Int> = []

    /// - Parameters:
    ///   - language: the one the user picked, the card doesn't let them change it.
    ///   - progress: position in the deck, shown in the header ("1/10").
    ///   - onClose: the back button of the front side.
    init(
        exercise: SortingExercise,
        language: ProgrammingLenguages,
        progress: String? = nil,
        onRate: @escaping (ExerciseDifficulty) -> Void = { _ in },
        onClose: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: SortingCardViewModel(exercise: exercise, language: language, onRate: onRate))
        self.progress = progress
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            RetroBackground()

            VStack(spacing: 18) {
                RetroCardHeader(
                    theme: .aprendeYArma,
                    stepLabel: stepLabel,
                    steps: 2,
                    currentStep: viewModel.side == .front ? 0 : 1,
                    backLabel: viewModel.side == .front ? "Volver al inicio" : "Volver al frente de la tarjeta",
                    onBack: back
                )
                .padding(.horizontal, 24)

                ZStack {
                    SortingCardFront(viewModel: viewModel, onFlip: flip)
                        .modifier(CardFace(angle: viewModel.side == .front ? 0 : -180))

                    SortingCardBack(viewModel: viewModel, slotFrames: $slotFrames, isSubmitting: isOverlayVisible, onSubmit: submit)
                        .modifier(CardFace(angle: viewModel.side == .back ? 0 : 180))
                }
            }
            .padding(.top, 12)

            if isOverlayVisible {
                SortingSubmissionOverlay(viewModel: viewModel, landed: landed, sourceFrames: slotFrames)
                    .transition(.opacity)
            }

            if viewModel.phase == .feedback {
                RetroResultView(theme: .aprendeYArma, summary: viewModel.resultSummary, onRate: rate, onClose: onClose)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .coordinateSpace(.sortingCard)
        .foregroundStyle(Retro.text)
        //This would add like vibrations when the user makes a mistake or losses. Jus thought it could be cool to add that.
        .sensoryFeedback(.success, trigger: viewModel.phase == .result(isCorrect: true))
        .sensoryFeedback(.error, trigger: viewModel.phase == .result(isCorrect: false))
    }

    private var isOverlayVisible: Bool {
        switch viewModel.phase {
        case .editing, .feedback, .solved: false
        case .assembling, .result: true
        }
    }

    /// "1/10 · FRENTE"
    private var stepLabel: String {
        let side = viewModel.side == .front ? "FRENTE" : "REVERSO"
        guard let progress else { return side }
        return "\(progress) · \(side)"
    }

    // MARK: Actions

    private func back() {
        if viewModel.side == .back {
            flip()
        } else {
            onClose()
        }
    }

    private func flip() {
        withAnimation(.easeInOut(duration: 0.5)) { viewModel.flip() }
    }

    private func submit() {
        landed = []
        guard let isCorrect = withAnimation(.easeOut(duration: 0.25), { viewModel.submit() }) else { return }

        Task {
            // let the panel appear and measure its slots before the blocks start flying
            await pause(0.35)

            // the blocks float one by one, from the first slot to the last
            for index in viewModel.slots.indices {
                withAnimation(.spring(duration: 0.5, bounce: 0.2)) { _ = landed.insert(index) }
                await pause(0.25)
            }
            await pause(0.4)

            withAnimation { viewModel.revealResult() }
            await pause(1.0)

            if isCorrect {
                withAnimation(.spring(duration: 0.4)) { viewModel.finishSubmission() }
            } else {
                // blocks go back to their slots, keeping the order the user had
                withAnimation(.spring(duration: 0.5, bounce: 0.1)) { landed = [] }
                await pause(0.5)
                withAnimation(.easeOut(duration: 0.25)) { viewModel.finishSubmission() }
            }
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        withAnimation { viewModel.rate(difficulty) }
    }

    private func pause(_ seconds: Double) async {
        try? await Task.sleep(for: .seconds(seconds))
    }
}

/// One face of the card. It turns around the vertical axis and hides once it is edge-on,
/// so the other face shows up for the second half of the turn.
private struct CardFace: ViewModifier, Animatable {
    var angle: Double

    nonisolated var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    func body(content: Content) -> some View {
        let isFacingUser = abs(angle) < 90
        content
            .opacity(isFacingUser ? 1 : 0)
            .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.4)
            .allowsHitTesting(isFacingUser)
            .accessibilityHidden(!isFacingUser)
    }
}

#Preview("Filtrar pares · Swift") {
    SortingInteractionCard(exercise: .evenWords, language: .swift, progress: "1/10")
}

#Preview("FizzBuzz · Python") {
    SortingInteractionCard(exercise: .fizzBuzz, language: .python, progress: "5/10")
}

#Preview("Dos sumas · Java") {
    SortingInteractionCard(exercise: .twoSum, language: .java, progress: "7/10")
}
