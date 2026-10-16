//
//  SortingTests.swift
//  AlgorithothmTests
//

import Foundation
import Testing
@testable import Algorithothm

@MainActor
struct SortingStrategyTests {
    let strategy = SortingStrategy()
    let solution = SortingExercise.twoSum.solution(in: .swift)

    @Test func solvedOrderIsAccepted() {
        #expect(strategy.isSolved(solution.loopBody, for: solution))
    }

    @Test func reversedOrderIsRejected() {
        #expect(!strategy.isSolved(solution.loopBody.reversed(), for: solution))
    }

    @Test func startingOrderIsNeverSolved() {
        for _ in 0..<50 {
            let order = strategy.startingOrder(for: solution)
            #expect(!strategy.isSolved(order, for: solution))
            #expect(Set(order.map(\.code)) == Set(solution.loopBody.map(\.code)))
        }
    }
}

@MainActor
struct SortingCardViewModelTests {

    @Test func wrongAnswerGoesBackToEditingWithHint() {
        let viewModel = SortingCardViewModel(exercise: .twoSum)

        #expect(viewModel.submit() == false)
        #expect(viewModel.phase == .assembling)
        viewModel.revealResult()
        #expect(viewModel.phase == .result(isCorrect: false))
        viewModel.finishSubmission()
        #expect(viewModel.phase == .editing)
        #expect(viewModel.showRetryHint)
    }

    @Test func rightAnswerEndsSolvedAndReportsRating() {
        var rated: ExerciseDifficulty?
        let viewModel = SortingCardViewModel(exercise: .twoSum) { rated = $0 }
        solve(viewModel)

        #expect(viewModel.submit() == true)
        viewModel.revealResult()
        viewModel.finishSubmission()
        #expect(viewModel.phase == .feedback)
        viewModel.rate(.medium)
        #expect(viewModel.phase == .solved)
        #expect(rated == .medium)
    }

    @Test func movingABlockClearsTheHint() {
        let viewModel = SortingCardViewModel(exercise: .twoSum)
        viewModel.submit()
        viewModel.revealResult()
        viewModel.finishSubmission()

        viewModel.move(fromOffsets: [0], toOffset: 2)
        #expect(!viewModel.showRetryHint)
    }

    @Test func nothingChangesWhileSubmitting() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .swift)
        let blocks = viewModel.blocks
        viewModel.submit()

        viewModel.move(fromOffsets: [0], toOffset: 2)
        viewModel.select(.python)
        #expect(viewModel.submit() == nil)
        #expect(viewModel.blocks == blocks)
        #expect(viewModel.language == .swift)
    }

    @Test func changingLanguageLoadsThatSolution() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .swift)
        viewModel.language = .python
        #expect(viewModel.solution.language == .python)
    }

    /// Reorders the blocks into the solution, one move at a time.
    private func solve(_ viewModel: SortingCardViewModel) {
        for (target, part) in viewModel.solution.loopBody.enumerated() {
            let from = viewModel.blocks.indices.first { $0 >= target && viewModel.blocks[$0].code == part.code }!
            viewModel.move(fromOffsets: [from], toOffset: target)
        }
    }
}

@MainActor
struct SortingDeckViewModelTests {

    @Test func ratingMovesThroughTheDeckUntilFinished() {
        let deck = SortingDeckViewModel(exercises: [.twoSum, .climbingStairs])
        #expect(deck.progress == "1 of 2")
        deck.rate(.easy)
        #expect(deck.currentExercise?.id == SortingExercise.climbingStairs.id)
        deck.rate(.hard)
        #expect(deck.isFinished)
        #expect(deck.progress == nil)
        deck.restart()
        #expect(deck.currentExercise?.id == SortingExercise.twoSum.id)
    }
}
