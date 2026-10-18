//
//  MultipleChoiceTests.swift
//  AlgorithothmTests
//

import Foundation
import Testing
@testable import Algorithothm

@MainActor
struct MultipleChoiceCardViewModelTests {

    private func rightOption(_ viewModel: MultipleChoiceCardViewModel) -> ChoiceOption {
        viewModel.options.first(where: \.isCorrect)!
    }

    private func wrongOption(_ viewModel: MultipleChoiceCardViewModel) -> ChoiceOption {
        viewModel.options.first { !$0.isCorrect }!
    }

    @Test func usesTheLanguageItIsGiven() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .python)
        #expect(viewModel.language == .python)
        #expect(viewModel.code.code.hasPrefix("def duplicar_todos"))
    }

    @Test func cantSubmitWithoutAnOption() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .swift)
        #expect(!viewModel.canSubmit)
        #expect(viewModel.submit() == nil)
    }

    @Test func wrongOptionIsCrossedOutAndCantBePickedAgain() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .swift)
        let wrong = wrongOption(viewModel)
        viewModel.select(wrong)

        #expect(viewModel.submit() == false)
        #expect(viewModel.state(of: wrong) == .wrong)
        #expect(viewModel.showRetryHint)
        #expect(viewModel.phase == .answering)

        viewModel.select(wrong)
        #expect(!viewModel.canSubmit)
    }

    @Test func rightAnswerGoesToTheNextQuestionWithItsHighlight() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .swift)
        #expect(viewModel.code.highlightedLine == nil)

        viewModel.select(rightOption(viewModel))
        #expect(viewModel.submit() == true)
        #expect(viewModel.phase == .correct)
        #expect(viewModel.state(of: rightOption(viewModel)) == .correct)

        viewModel.advance()
        #expect(viewModel.questionIndex == 1)
        #expect(viewModel.phase == .answering)
        #expect(viewModel.selectedID == nil)
        #expect(viewModel.code.highlightedLine == 4)
    }

    @Test func lastRightAnswerEndsWithTheRating() {
        var rated: ExerciseDifficulty?
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .java) { rated = $0 }
        for _ in 0..<viewModel.questionCount {
            viewModel.select(rightOption(viewModel))
            viewModel.submit()
            viewModel.advance()
        }
        #expect(viewModel.phase == .feedback)

        viewModel.rate(.easy)
        #expect(viewModel.phase == .solved)
        #expect(rated == .easy)
    }

    @Test func optionsAreLockedOnceAnswered() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .swift)
        let right = rightOption(viewModel)
        viewModel.select(right)
        viewModel.submit()

        viewModel.select(wrongOption(viewModel))
        #expect(viewModel.selectedID == right.id)
    }
}

@MainActor
struct CardDeckViewModelTests {

    @Test func ratingMovesThroughTheDeckUntilFinished() {
        let deck = CardDeckViewModel(exercises: [SortingExercise.twoSum, .climbingStairs])
        #expect(deck.progress == "1/2")
        deck.rate(.easy)
        #expect(deck.currentExercise?.id == SortingExercise.climbingStairs.id)
        deck.rate(.hard)
        #expect(deck.isFinished)
        #expect(deck.progress == nil)
        deck.restart()
        #expect(deck.currentExercise?.id == SortingExercise.twoSum.id)
    }
}

/// The mock exercises follow the rules the card needs.
@MainActor
struct MultipleChoiceMockTests {

    @Test func thereAreTenExercisesInEveryLanguage() {
        #expect(MultipleChoiceExercise.all.count == 10)
        #expect(Set(MultipleChoiceExercise.all.map(\.id)).count == 10)
        for exercise in MultipleChoiceExercise.all {
            #expect(Set(exercise.languages) == Set(ProgrammingLenguages.allCases), "\(exercise.id)")
        }
    }

    @Test(arguments: MultipleChoiceExercise.all)
    func everyCardHasTwoQuestionsOfFourOptions(_ exercise: MultipleChoiceExercise) {
        for variant in exercise.variants {
            #expect(variant.questions.count == 2, "\(exercise.id) \(variant.language)")
            for question in variant.questions {
                #expect(question.options.count == 4)
                #expect(question.options.filter(\.isCorrect).count == 1)
                #expect(Set(question.options.map(\.text)).count == 4)
            }
        }
    }

    @Test(arguments: MultipleChoiceExercise.all)
    func codeFitsTheMonitor(_ exercise: MultipleChoiceExercise) {
        for variant in exercise.variants {
            let width = variant.code.split(separator: "\n").map(\.count).max() ?? 0
            #expect(width <= 39, "\(exercise.id) \(variant.language): line of \(width)")
        }
    }
}
