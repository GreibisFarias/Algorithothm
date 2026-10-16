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
        #expect(strategy.isSolved(solution.loopBody.map(Optional.some), for: solution))
    }

    @Test func wrongOrEmptySlotsAreRejected() {
        #expect(!strategy.isSolved(solution.loopBody.reversed(), for: solution))
        #expect(!strategy.isSolved(strategy.startingSlots(for: solution), for: solution))
    }

    @Test func onlyTheHintStartsInPlace() {
        let slots = strategy.startingSlots(for: solution)
        #expect(slots.count == solution.loopBody.count)
        #expect(slots[0] == solution.loopBody[0])
        #expect(slots.dropFirst().allSatisfy { $0 == nil })
    }

    @Test func poolHasEveryBlockAndIsNeverSolved() {
        for _ in 0..<50 {
            let pool = strategy.poolOrder(for: solution)
            #expect(!strategy.isSolved(pool, for: solution))
            #expect(Set(pool) == Set(solution.loopBody))
        }
    }
}

@MainActor
struct SortingCardViewModelTests {

    private func makeViewModel(onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }) -> SortingCardViewModel {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .python, onRate: onRate)
        viewModel.flip()
        return viewModel
    }

    private func solve(_ viewModel: SortingCardViewModel) {
        for (slot, part) in viewModel.solution.loopBody.enumerated() where !viewModel.isLocked(slot) {
            viewModel.place(part, inSlot: slot)
        }
    }

    @Test func usesTheLanguageItIsGiven() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .java)
        #expect(viewModel.language == .java)
        #expect(viewModel.side == .front)
    }

    @Test func flipsBetweenFrontAndBack() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .swift)
        viewModel.flip()
        #expect(viewModel.side == .back)
        viewModel.flip()
        #expect(viewModel.side == .front)
    }

    @Test func placingInAnOccupiedSlotSendsTheOldBlockBack() {
        let viewModel = makeViewModel()
        let body = viewModel.solution.loopBody
        viewModel.place(body[1], inSlot: 1)
        viewModel.place(body[2], inSlot: 1)

        #expect(viewModel.slots[1] == body[2])
        #expect(!viewModel.isPlaced(body[1]))
    }

    @Test func movingBetweenSlotsSwapsTheBlocks() {
        let viewModel = makeViewModel()
        let body = viewModel.solution.loopBody
        viewModel.place(body[1], inSlot: 1)
        viewModel.place(body[2], inSlot: 2)
        viewModel.place(body[1], inSlot: 2)

        #expect(viewModel.slots[1] == body[2])
        #expect(viewModel.slots[2] == body[1])
    }

    @Test func theHintCantBeMovedOrReplaced() {
        let viewModel = makeViewModel()
        let body = viewModel.solution.loopBody
        viewModel.place(body[1], inSlot: 0)
        viewModel.removeBlock(fromSlot: 0)
        viewModel.place(body[0], inSlot: 2)

        #expect(viewModel.slots[0] == body[0])
        #expect(viewModel.slots[2] == nil)
    }

    @Test func removingABlockEmptiesTheSlot() {
        let viewModel = makeViewModel()
        let part = viewModel.solution.loopBody[1]
        viewModel.place(part, inSlot: 3)
        viewModel.removeBlock(fromSlot: 3)

        #expect(viewModel.slots[3] == nil)
        #expect(viewModel.nextEmptySlot == 1)
    }

    @Test func cantSubmitUntilEverySlotIsFull() {
        let viewModel = makeViewModel()
        #expect(!viewModel.canSubmit)
        #expect(viewModel.submit() == nil)
        solve(viewModel)
        #expect(viewModel.canSubmit)
    }

    @Test func wrongAnswerGoesBackToEditingWithHint() {
        let viewModel = makeViewModel()
        let body = viewModel.solution.loopBody
        viewModel.place(body[3], inSlot: 1)
        viewModel.place(body[1], inSlot: 2)
        viewModel.place(body[2], inSlot: 3)

        #expect(viewModel.submit() == false)
        #expect(viewModel.phase == .assembling)
        viewModel.revealResult()
        #expect(viewModel.phase == .result(isCorrect: false))
        viewModel.finishSubmission()
        #expect(viewModel.phase == .editing)
        #expect(viewModel.showRetryHint)

        // moving a block clears the hint
        viewModel.removeBlock(fromSlot: 1)
        #expect(!viewModel.showRetryHint)
    }

    @Test func rightAnswerEndsSolvedAndReportsRating() {
        var rated: ExerciseDifficulty?
        let viewModel = makeViewModel { rated = $0 }
        solve(viewModel)

        #expect(viewModel.submit() == true)
        viewModel.revealResult()
        viewModel.finishSubmission()
        #expect(viewModel.phase == .feedback)
        viewModel.rate(.medium)
        #expect(viewModel.phase == .solved)
        #expect(rated == .medium)
    }

    @Test func nothingChangesWhileSubmitting() {
        let viewModel = makeViewModel()
        solve(viewModel)
        viewModel.submit()
        let slots = viewModel.slots

        viewModel.removeBlock(fromSlot: 1)
        viewModel.flip()
        #expect(viewModel.slots == slots)
        #expect(viewModel.side == .back)
        #expect(viewModel.submit() == nil)
    }
}

/// The mock exercises follow the rules the card needs.
@MainActor
struct SortingExerciseMockTests {

    @Test func thereAreTenExercisesInEveryLanguage() {
        #expect(SortingExercise.all.count == 10)
        #expect(Set(SortingExercise.all.map(\.id)).count == 10)
        for exercise in SortingExercise.all {
            #expect(Set(exercise.languages) == Set(ProgrammingLenguages.allCases), "\(exercise.id)")
        }
    }

    @Test(arguments: SortingExercise.all)
    func codeFitsTheMonitor(_ exercise: SortingExercise) {
        for variant in exercise.variants {
            let backWidth = variant.solution.fullCode.split(separator: "\n").map(\.count).max() ?? 0
            let frontWidth = variant.example.lines.map(\.count).max() ?? 0
            #expect(backWidth <= 42, "\(exercise.id) \(variant.language): back line of \(backWidth)")
            #expect(frontWidth <= 39, "\(exercise.id) \(variant.language): front line of \(frontWidth)")
        }
    }

    @Test(arguments: SortingExercise.all)
    func blocksCanBeToldApart(_ exercise: SortingExercise) {
        for variant in exercise.variants {
            let codes = variant.solution.loopBody.map(\.code)
            #expect(Set(codes).count == codes.count, "\(exercise.id) \(variant.language) has two identical blocks")
        }
    }
}
