//
//  MultipleChoiceCard.swift
//  Algorithothm
//
//  Created by Gregori Farias 06/8/26.
//
//  "Tipo 1 · Predice" card: the user reads a function on the monitor, runs it in their head
//  and answers its questions one after the other. A wrong pick is crossed out and they try
//  again; after the last question comes the difficulty rating.
//

import SwiftUI

struct MultipleChoiceCard: View {

    @State private var viewModel: MultipleChoiceCardViewModel
    private let progress: String?
    
    private let onClose: () -> Void

    /// - Parameters:
    ///   - language: the one the user picked, the card doesn't let them change it.
    ///   - progress: position in the deck, shown in the header ("1/10").
    init(
        exercise: MultipleChoiceExercise,
        language: ProgrammingLenguages,
        progress: String? = nil,
        onRate: @escaping (ExerciseDifficulty) -> Void = { _ in },
        onClose: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: MultipleChoiceCardViewModel(exercise: exercise, language: language, onRate: onRate))
        self.progress = progress
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            RetroBackground()

            VStack(spacing: 20) {
                RetroCardHeader(
                    theme: .predice,
                    stepLabel: stepLabel,
                    steps: viewModel.questionCount,
                    currentStep: viewModel.questionIndex,
                    onBack: onClose
                )
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(spacing: 20) {
                        RetroMonitor {
                            MonitorCode(code: viewModel.code, language: viewModel.language)
                        }
                        .animation(.easeInOut(duration: 0.3), value: viewModel.code)

                        Text(prompt)
                            .font(RetroFont.pixel(18))
                            .lineSpacing(4)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .id(viewModel.question.id)
                            .transition(.opacity)

                        options

                        if viewModel.showRetryHint {
                            Text("Casi. Vuelve a recorrer el código línea por línea.")
                                .font(RetroFont.pixel(15))
                                .foregroundStyle(Retro.error)
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                .scrollBounceBehavior(.basedOnSize)
                .safeAreaInset(edge: .bottom) {
                    Button(buttonTitle, action: primaryAction)
                        .buttonStyle(RetroCardTheme.predice.button)
                        .disabled(!isButtonEnabled)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                }
            }
            .padding(.top, 12)

            if viewModel.phase == .feedback {
                RetroRatingOverlay(theme: .predice, onRate: rate)
            }
        }
        .foregroundStyle(Retro.text)
        .sensoryFeedback(.success, trigger: viewModel.phase == .correct)
        .sensoryFeedback(.error, trigger: viewModel.wrongIDs.count)
    }

    // MARK: Pieces

    private var options: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.options) { option in
                RetroOptionButton(text: option.text, state: viewModel.state(of: option)) {
                    viewModel.select(option)
                }
                .disabled(viewModel.phase != .answering)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Opciones")
    }

    /// The question with its input painted green, like in the design.
    private var prompt: AttributedString {
        var prompt = AttributedString(viewModel.question.prompt)
        if let emphasis = viewModel.question.emphasis, let range = prompt.range(of: emphasis) {
            prompt[range].foregroundColor = Retro.phosphor
        }
        return prompt
    }

    /// "1/10 · 1/2": card in the deck and question in the card.
    private var stepLabel: String {
        let question = "\(viewModel.questionIndex + 1)/\(viewModel.questionCount)"
        guard let progress else { return question }
        return "\(progress) · \(question)"
    }

    private var buttonTitle: String {
        switch viewModel.phase {
        case .answering: viewModel.canSubmit ? "Comprobar" : "Elige una opción"
        case .correct, .feedback: "Continuar"
        case .solved: "Resuelto ✓"
        }
    }

    private var isButtonEnabled: Bool {
        switch viewModel.phase {
        case .answering: viewModel.canSubmit
        case .correct: true
        case .feedback, .solved: false
        }
    }

    // MARK: Actions

    private func primaryAction() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch viewModel.phase {
            case .answering: viewModel.submit()
            case .correct: viewModel.advance()
            case .feedback, .solved: break
            }
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        withAnimation { viewModel.rate(difficulty) }
    }
}

#Preview("Duplicar todos · Swift") {
    MultipleChoiceCard(exercise: .doubleAll, language: .swift, progress: "1/10")
}

#Preview("Suma de dígitos · Python") {
    MultipleChoiceCard(exercise: .digitSum, language: .python, progress: "7/10")
}

#Preview("Búsqueda binaria · Java") {
    MultipleChoiceCard(exercise: .binarySearch, language: .java, progress: "10/10")
}
