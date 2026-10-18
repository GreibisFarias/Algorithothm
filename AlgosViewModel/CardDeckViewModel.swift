//
//  CardDeckViewModel.swift
//  Algorithothm
//
//  Walks the user through a deck of exercises, one card at a time. Works for any card type.
//

import Foundation
import Observation

@Observable
final class CardDeckViewModel<Exercise: Identifiable> {

    let exercises: [Exercise]
    private(set) var currentIndex = 0

    init(exercises: [Exercise]) {
        self.exercises = exercises
    }

    var currentExercise: Exercise? {
        exercises.indices.contains(currentIndex) ? exercises[currentIndex] : nil
    }

    var isFinished: Bool { currentExercise == nil }

    /// "2/10", or nil once the deck is done.
    var progress: String? {
        isFinished ? nil : "\(currentIndex + 1)/\(exercises.count)"
    }

    // Not wired to FSRS yet, for now rating a card just moves to the next one.
    func rate(_ difficulty: ExerciseDifficulty) {
        guard !isFinished else { return }
        currentIndex += 1
    }

    func restart() {
        currentIndex = 0
    }
}
