//
//  MultipleChoiceCard.swift
//  Algorithothm
//
//  Created by Gregori Farias 06/8/26.

//
//  The user reads a function, traces it with the given input and picks an answer.
//  A wrong pick is crossed out and they try again, a right one shows the explanation
//  and then the difficulty rating.
//

import SwiftUI

// MARK: - View (Temporary design until Jose gives us the final one.)
struct MultipleChoiceCard: View {

    enum Phase: Equatable {
        case answering
        case correct        // right option in green + explanation
        case feedback       // "Good job" + difficulty rating
        case solved
    }

    
    let exercise: MultipleChoiceExercise
    // Not wired to anything yet, this is where the FSRS rating will go.
    var onRate: (ExerciseDifficulty) -> Void

    @State private var language: ProgrammingLenguages
    @State private var options: [ChoiceOption]
    @State private var selectedID: ChoiceOption.ID?
    @State private var wrongIDs: Set<ChoiceOption.ID> = []
    @State private var phase: Phase = .answering

    init(exercise: MultipleChoiceExercise, language: ProgrammingLenguages = .swift, onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }) {
        self.exercise = exercise
        self.onRate = onRate
        _language = State(initialValue: exercise.snippet(in: language).language)
        _options = State(initialValue: exercise.shuffledOptions())
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    codeSection
                    questionSection
                    actionSection
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))

            if phase == .feedback {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .transition(.opacity)
                DifficultyRatingView(onRate: rate)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .sensoryFeedback(.success, trigger: phase == .correct)
        .sensoryFeedback(.error, trigger: wrongIDs.count)
    }

    // MARK: Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(exercise.kind.label, systemImage: exercise.kind.systemImage)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tint)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.tint.opacity(0.12), in: Capsule())

            Text(exercise.title)
                .font(.title3.bold())
            Text(exercise.scenario)
                .foregroundStyle(.secondary)
        }
    }

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            LanguagePicker(languages: exercise.languages, selection: $language)
            CodeBlock(exercise.snippet(in: language).code, language: language)
        }
    }

    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.question)
                .font(.headline)

            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                optionRow(option, letter: letter(for: index))
            }

            if phase != .answering {
                Label(exercise.explanation, systemImage: "lightbulb")
                    .font(.callout)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else if !wrongIDs.isEmpty {
                Text("Not quite. Trace the code again line by line.")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
    }

    private var actionSection: some View {
        Button(action: primaryAction) {
            Text(buttonTitle).frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(phase == .solved ? .green : .accentColor)
        .disabled(isButtonDisabled)
    }

    // MARK: Option row

    private enum OptionState {
        case idle, selected, wrong, correct
    }

    private func optionRow(_ option: ChoiceOption, letter: String) -> some View {
        let state = state(of: option)
        return Button {
            selectedID = option.id
        } label: {
            HStack(spacing: 12) {
                Text(letter)
                    .font(.subheadline.bold())
                    .frame(width: 28, height: 28)
                    .background(tint(for: state).opacity(0.15), in: Circle())

                Text(option.text)
                    .font(.system(.body, design: .monospaced))
                    .strikethrough(state == .wrong)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let icon = icon(for: state) {
                    Image(systemName: icon)
                        .foregroundStyle(tint(for: state))
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(tint(for: state), lineWidth: state == .idle ? 0 : 2)
            }
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .opacity(state == .wrong ? 0.6 : 1)
        .disabled(phase != .answering || state == .wrong)
        .animation(.easeInOut(duration: 0.2), value: state)
    }

    private func state(of option: ChoiceOption) -> OptionState {
        if option.isCorrect, phase != .answering { return .correct }
        if wrongIDs.contains(option.id) { return .wrong }
        if selectedID == option.id { return .selected }
        return .idle
    }

    private func tint(for state: OptionState) -> Color {
        switch state {
        case .idle, .selected: .accentColor
        case .wrong: .red
        case .correct: .green
        }
    }

    private func icon(for state: OptionState) -> String? {
        switch state {
        case .idle, .selected: nil
        case .wrong: "xmark.circle.fill"
        case .correct: "checkmark.circle.fill"
        }
    }

    private func letter(for index: Int) -> String {
        String(UnicodeScalar(UInt8(ascii: "A") + UInt8(index)))
    }

    // MARK: Button

    private var buttonTitle: String {
        switch phase {
        case .answering: "Check answer"
        case .correct, .feedback: "Continue"
        case .solved: "Solved ✓"
        }
    }

    private var isButtonDisabled: Bool {
        switch phase {
        case .answering: selectedID == nil
        case .correct: false
        case .feedback, .solved: true
        }
    }

    // MARK: Actions

    private func primaryAction() {
        switch phase {
        case .answering: checkAnswer()
        case .correct: withAnimation(.spring(duration: 0.4)) { phase = .feedback }
        case .feedback, .solved: break
        }
    }

    private func checkAnswer() {
        guard let selected = options.first(where: { $0.id == selectedID }) else { return }

        withAnimation {
            if selected.isCorrect {
                phase = .correct
            } else {
                wrongIDs.insert(selected.id)
                selectedID = nil
            }
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        onRate(difficulty)
        withAnimation { phase = .solved }
    }
}

#Preview("Return value") {
    MultipleChoiceCard(exercise: .countIncreases)
}

#Preview("Variable trace · Python") {
    MultipleChoiceCard(exercise: .maxSubArrayTrace, language: .python)
}

#Preview("Pointers · Java") {
    MultipleChoiceCard(exercise: .twoPointersTrace, language: .java)
}
