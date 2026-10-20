//
//  SortingCardViewModel.swift
//  Algorithothm
//
//  Handles what the user does on a sorting card: flip it, drop blocks into the slots of the
//  monitor, submit and rate. The view only decides how each step is animated.
//

import Foundation
import Observation

@Observable
final class SortingCardViewModel {

    enum Side {
        case front      // the solved example and what it does
        case back       // the function the user builds
    }

    enum Phase: Equatable {
        case editing
        case assembling                 // blocks are flying into the function panel
        case result(isCorrect: Bool)    // panel turns green or red
        case feedback                   // "Good job" + difficulty rating
        case solved
    }

    let exercise: SortingExercise
    let variant: SortingVariant

    private(set) var side: Side = .front
    /// Every block of the loop body, in the order they are shown below the monitor.
    private(set) var pool: [CodePart]
    /// What is in each slot of the monitor. The right answer is `solution.loopBody`.
    private(set) var slots: [CodePart?]
    private(set) var phase: Phase = .editing
    private(set) var showRetryHint = false
    /// How many times the user checked the function.
    private(set) var attempts = 0

    private let strategy: SortingStrategy
    // Not wired to anything yet, this is where the FSRS rating will go.
    private let onRate: (ExerciseDifficulty) -> Void
    private var isLastSubmissionCorrect = false

    /// - Parameter language: the language the user picked, the card has no picker of its own.
    init(
        exercise: SortingExercise,
        language: ProgrammingLenguages,
        strategy: SortingStrategy = SortingStrategy(),
        onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }
    ) {
        self.exercise = exercise
        self.strategy = strategy
        self.onRate = onRate
        let variant = exercise.variant(in: language)
        self.variant = variant
        self.pool = strategy.poolOrder(for: variant.solution)
        self.slots = strategy.startingSlots(for: variant.solution)
    }

    var solution: LoopSolution { variant.solution }
    var example: CodeExample { variant.example }
    var language: ProgrammingLenguages { variant.language }

    var canEdit: Bool { phase == .editing }
    var isSolved: Bool { phase == .solved }
    var canSubmit: Bool { canEdit && side == .back && !slots.contains(nil) }

    /// Line of the result screen.
    var resultSummary: String {
        attempts <= 1 ? "¡Lo armaste a la primera!" : "Lo armaste en \(attempts) intentos"
    }

    /// The slot the next block goes to, where the cursor blinks.
    var nextEmptySlot: Int? { slots.firstIndex(of: nil) }

    func isLocked(_ slot: Int) -> Bool { slot < strategy.givenBlocks }

    func isPlaced(_ part: CodePart) -> Bool { slots.contains(part) }

    func slot(of part: CodePart) -> Int? { slots.firstIndex(of: part) }

    // MARK: Intents

    func flip() {
        guard canEdit else { return }
        side = side == .front ? .back : .front
    }

    /// Puts a block in a slot. If it came from another slot the two blocks swap places,
    /// if it came from below the monitor the block that was in the slot goes back down.
    func place(_ part: CodePart, inSlot slot: Int) {
        guard canEdit, slots.indices.contains(slot), !isLocked(slot), pool.contains(part) else { return }
        let origin = self.slot(of: part)
        guard origin != slot else { return }
        if let origin, isLocked(origin) { return }

        let previous = slots[slot]
        slots[slot] = part
        if let origin { slots[origin] = previous }
        showRetryHint = false   // any change clears the previous result
    }

    /// Sends the block of a slot back below the monitor.
    func removeBlock(fromSlot slot: Int) {
        guard canEdit, slots.indices.contains(slot), !isLocked(slot), slots[slot] != nil else { return }
        slots[slot] = nil
        showRetryHint = false
    }

    /// Checks the current order and starts the submission. Returns nil if there is nothing to submit.
    @discardableResult
    func submit() -> Bool? {
        guard canSubmit else { return nil }
        isLastSubmissionCorrect = strategy.isSolved(slots, for: solution)
        attempts += 1
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
