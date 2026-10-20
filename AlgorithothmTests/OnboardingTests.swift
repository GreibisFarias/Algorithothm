//
//  OnboardingTests.swift
//  AlgorithothmTests
//
//  Created by Gregori Farias on 19/10/26.
//

import Foundation
import Testing
@testable import Algorithothm

@MainActor
struct OnboardingViewModelTests {

    @Test func goesThroughEveryStepInOrder() {
        let viewModel = OnboardingViewModel()
        #expect(viewModel.step == .welcome)
        #expect(!viewModel.canGoBack)

        viewModel.next()
        viewModel.next()
        viewModel.next()
        #expect(viewModel.step == .name)

        viewModel.name = "Greibis"
        viewModel.next()
        #expect(viewModel.step == .language)
        #expect(viewModel.isLastStep)

        viewModel.next()
        #expect(viewModel.step == .language)
    }

    @Test func theNameCantBeSkipped() {
        let viewModel = OnboardingViewModel()
        for _ in 0..<3 { viewModel.next() }

        viewModel.name = "   "
        #expect(!viewModel.canAdvance)
        viewModel.next()
        #expect(viewModel.step == .name)

        viewModel.name = "  Greibis "
        #expect(viewModel.trimmedName == "Greibis")
        #expect(viewModel.canAdvance)
    }

    @Test func goesBack() {
        let viewModel = OnboardingViewModel()
        viewModel.next()
        viewModel.back()
        #expect(viewModel.step == .welcome)
        viewModel.back()
        #expect(viewModel.step == .welcome)
    }

    @Test func startsWithTheLanguageItIsGiven() {
        #expect(OnboardingViewModel(language: .python).language == .python)
    }
}

@MainActor
struct ResultSummaryTests {

    @Test func predictCountsOnlyAnswersRightAtFirstTry() {
        let viewModel = MultipleChoiceCardViewModel(exercise: .doubleAll, language: .swift)
        // first question: a wrong pick, then the right one
        viewModel.select(viewModel.options.first { !$0.isCorrect }!)
        viewModel.submit()
        viewModel.select(viewModel.options.first(where: \.isCorrect)!)
        viewModel.submit()
        viewModel.advance()
        // second question: right at first try
        viewModel.select(viewModel.options.first(where: \.isCorrect)!)
        viewModel.submit()

        #expect(viewModel.resultSummary == "1 de 2 correctas")
    }

    @Test func sortingCountsTheAttempts() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .swift)
        viewModel.flip()
        let body = viewModel.solution.loopBody

        // wrong order first
        viewModel.place(body[3], inSlot: 1)
        viewModel.place(body[1], inSlot: 2)
        viewModel.place(body[2], inSlot: 3)
        viewModel.submit()
        viewModel.revealResult()
        viewModel.finishSubmission()
        // then the right one
        for slot in 1..<body.count { viewModel.place(body[slot], inSlot: slot) }
        viewModel.submit()

        #expect(viewModel.attempts == 2)
        #expect(viewModel.resultSummary == "Lo armaste en 2 intentos")
    }

    @Test func sortingAtFirstTry() {
        let viewModel = SortingCardViewModel(exercise: .twoSum, language: .swift)
        viewModel.flip()
        let body = viewModel.solution.loopBody
        for slot in 1..<body.count { viewModel.place(body[slot], inSlot: slot) }
        viewModel.submit()

        #expect(viewModel.resultSummary == "¡Lo armaste a la primera!")
    }
}
