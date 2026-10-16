//
//  SortingDeckViewModel.swift
//  Algorithothm
//
//  Walks the user through the sorting exercises, one card at a time.
//

import Foundation
import Observation

@Observable
final class SortingDeckViewModel {

    let exercises: [SortingExercise]
    private(set) var currentIndex = 0

    init(exercises: [SortingExercise] = SortingExercise.all) {
        self.exercises = exercises
    }

    var currentExercise: SortingExercise? {
        exercises.indices.contains(currentIndex) ? exercises[currentIndex] : nil
    }

    var isFinished: Bool { currentExercise == nil }

    /// "2 of 3", or nil once the deck is done.
    var progress: String? {
        isFinished ? nil : "\(currentIndex + 1) of \(exercises.count)"
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
