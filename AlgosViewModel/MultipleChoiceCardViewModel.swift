//
//  MultipleChoiceCardViewModel.swift
//  Algorithothm
//
//  Handles what the user does on a "Predice" card: pick an option, check it, move on to the
//  next question and rate the card at the end. A wrong pick is crossed out and they try again.
//

import Foundation
import Observation

@Observable
final class MultipleChoiceCardViewModel {

    enum Phase: Equatable {
        case answering
        case correct        // the right option in green, waiting for "Continuar"
        case feedback       // "Good job" + difficulty rating
        case solved
    }

    let exercise: MultipleChoiceExercise
    let variant: MultipleChoiceVariant

    private(set) var questionIndex = 0
    /// The options of the current question, in the order they are shown.
    private(set) var options: [ChoiceOption]
    private(set) var selectedID: ChoiceOption.ID?
    private(set) var wrongIDs: Set<ChoiceOption.ID> = []
    private(set) var phase: Phase = .answering
    /// Questions answered right without a wrong pick before.
    private(set) var correctAtFirstTry = 0

    private let strategy: MultipleChoiceStrategy
    // Not wired to anything yet, this is where the FSRS rating will go.
    private let onRate: (ExerciseDifficulty) -> Void

    /// - Parameter language: the language the user picked, the card has no picker of its own.
    init(
        exercise: MultipleChoiceExercise,
        language: ProgrammingLenguages,
        strategy: MultipleChoiceStrategy = MultipleChoiceStrategy(),
        onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }
    ) {
        self.exercise = exercise
        self.strategy = strategy
        self.onRate = onRate
        let variant = exercise.variant(in: language)
        self.variant = variant
        self.options = strategy.shuffledOptions(of: variant.questions[0])
    }

    var language: ProgrammingLenguages { variant.language }
    var question: TraceQuestion { variant.questions[questionIndex] }
    var questionCount: Int { variant.questions.count }
    /// The code with the line of the current question highlighted.
    var code: CodeExample { variant.code(for: question) }

    var canSubmit: Bool { phase == .answering && selectedID != nil }
    var isSolved: Bool { phase == .solved }
    var showRetryHint: Bool { phase == .answering && !wrongIDs.isEmpty }

    /// Line of the result screen, "2 de 2 correctas".
    var resultSummary: String {
        "\(correctAtFirstTry) de \(questionCount) correctas"
    }

    func state(of option: ChoiceOption) -> RetroOptionState {
        if wrongIDs.contains(option.id) { return .wrong }
        if phase != .answering, strategy.isCorrect(option) { return .correct }
        if selectedID == option.id { return .selected }
        return .idle
    }

    // MARK: Intents

    func select(_ option: ChoiceOption) {
        guard phase == .answering, !wrongIDs.contains(option.id) else { return }
        selectedID = option.id
    }

    /// Checks the selected option. Returns nil if there is nothing to check.
    @discardableResult
    func submit() -> Bool? {
        guard canSubmit, let selected = options.first(where: { $0.id == selectedID }) else { return nil }
        if strategy.isCorrect(selected) {
            if wrongIDs.isEmpty { correctAtFirstTry += 1 }
            phase = .correct
            return true
        }
        wrongIDs.insert(selected.id)
        selectedID = nil
        return false
    }

    /// After a right answer: the next question, or the rating if it was the last one.
    func advance() {
        guard phase == .correct else { return }
        guard questionIndex + 1 < questionCount else {
            phase = .feedback
            return
        }
        questionIndex += 1
        options = strategy.shuffledOptions(of: question)
        selectedID = nil
        wrongIDs = []
        phase = .answering
    }

    func rate(_ difficulty: ExerciseDifficulty) {
        guard phase == .feedback else { return }
        onRate(difficulty)
        phase = .solved
    }
}
