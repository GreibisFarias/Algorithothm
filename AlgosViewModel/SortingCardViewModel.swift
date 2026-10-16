//
//  SortingCardViewModel.swift
//  Algorithothm
//
//  Handles what the user does on a sorting card: reorder blocks, change language,
//  submit and rate. The view only decides how each step is animated.
//

import Foundation
import SwiftUI   // Observation, and Array.move(fromOffsets:toOffset:)

@Observable
final class SortingCardViewModel {

    enum Phase: Equatable {
        case editing
        case assembling                 // blocks are flying into the function panel
        case result(isCorrect: Bool)    // panel turns green or red
        case feedback                   // "Good job" + difficulty rating
        case solved
    }

    let exercise: SortingExercise

    private(set) var solution: LoopSolution
    private(set) var blocks: [CodePart]
    private(set) var phase: Phase = .editing
    private(set) var showRetryHint = false

    private let strategy: SortingStrategy
    // Not wired to anything yet, this is where the FSRS rating will go.
    private let onRate: (ExerciseDifficulty) -> Void
    private var isLastSubmissionCorrect = false

    init(
        exercise: SortingExercise,
        language: ProgrammingLenguages = .swift,
        strategy: SortingStrategy = SortingStrategy(),
        onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }
    ) {
        self.exercise = exercise
        self.strategy = strategy
        self.onRate = onRate
        let solution = exercise.solution(in: language)
        self.solution = solution
        self.blocks = strategy.startingOrder(for: solution)
    }

    var language: ProgrammingLenguages {
        get { solution.language }
        set { select(newValue) }
    }

    var canEdit: Bool { phase == .editing }
    var isSolved: Bool { phase == .solved }

    // MARK: Intents

    func select(_ language: ProgrammingLenguages) {
        guard canEdit else { return }
        solution = exercise.solution(in: language)
        blocks = strategy.startingOrder(for: solution)
        showRetryHint = false
    }

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard canEdit else { return }
        blocks.move(fromOffsets: source, toOffset: destination)
        showRetryHint = false   // any change clears the previous result
    }

    /// Checks the current order and starts the submission. Returns nil if there is nothing to submit.
    @discardableResult
    func submit() -> Bool? {
        guard canEdit else { return nil }
        isLastSubmissionCorrect = strategy.isSolved(blocks, for: solution)
        showRetryHint = false
        phase = .assembling
        return isLastSubmissionCorrect
    }

    /// Once the blocks have landed, the panel shows if the order was right.
    func revealResult() {
        guard phase == .assembling else { return }
        phase = .result(isCorrect: isLastSubmissionCorrect)
    }

    /// A right answer goes to the rating, a wrong one back to editing with a hint.
    func finishSubmission() {
        guard case .result(let isCorrect) = phase else { return }
        if isCorrect {
            phase = .feedback
        } else {
            phase = .editing
            showRetryHint = true
        }
    }

    func rate(_ difficulty: ExerciseDifficulty) {
        guard phase == .feedback else { return }
        onRate(difficulty)
        phase = .solved
    }
}
