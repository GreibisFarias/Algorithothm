//
//  MultipleChoiceInteraction.swift
//  Algorithothm
//
//  "Trace the code" exercises: the user reads a function, runs it in their head
//  with the given input and picks the right answer.
//

import Foundation

//What the question is about. Used for the label of the card, the text of the question is free.
enum TraceQuestionKind {
    case returnValue        // "What does the function return?"
    case variableValue      // "What is `result` after the second iteration?"
    case pointerPosition    // "Where is `right` when `left` is at index 2?"

    var label: String {
        switch self {
        case .returnValue: "Return value"
        case .variableValue: "Variable trace"
        case .pointerPosition: "Pointers"
        }
    }

    var systemImage: String {
        switch self {
        case .returnValue: "arrow.uturn.backward"
        case .variableValue: "list.number"
        case .pointerPosition: "arrow.left.and.right"
        }
    }
}

//subtype
struct ChoiceOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

//The function shown in one language
struct CodeSnippet: Identifiable, Hashable {
    let language: ProgrammingLenguages
    let code: String

    var id: ProgrammingLenguages { language }
}

//Type
struct MultipleChoiceExercise: Identifiable {
    let id: String
    let title: String
    let kind: TraceQuestionKind
    let scenario: String            // "We run the function with nums = [5, 7, 6, 5, 6]"
    let snippets: [CodeSnippet]
    let question: String
    let options: [ChoiceOption]
    let explanation: String         // shown once the user gets it right

    /// - Parameters:
    ///   - answer: the right option.
    ///   - wrongAnswers: the other options, 1 to 4 of them (so the card shows 2 to 5).
    init(
        id: String,
        title: String,
        kind: TraceQuestionKind,
        scenario: String,
        snippets: [CodeSnippet],
        question: String,
        answer: String,
        wrongAnswers: [String],
        explanation: String
    ) {
        precondition(!snippets.isEmpty, "Each exercise needs the code in at least one language")
        precondition((1...4).contains(wrongAnswers.count), "Each exercise needs between 1 and 4 wrong answers")
        precondition(!wrongAnswers.contains(answer), "A wrong answer can't be the same as the right one")

        self.id = id
        self.title = title
        self.kind = kind
        self.scenario = scenario
        self.snippets = snippets
        self.question = question
        self.options = [ChoiceOption(text: answer, isCorrect: true)]
            + wrongAnswers.map { ChoiceOption(text: $0, isCorrect: false) }
        self.explanation = explanation
    }

    var languages: [ProgrammingLenguages] {
        snippets.map(\.language)
    }

    /// The code in `language`, or the first one available if the exercise is not written in it.
    func snippet(in language: ProgrammingLenguages) -> CodeSnippet {
        snippets.first { $0.language == language } ?? snippets[0]
    }

    /// The right answer is always first in `options`, so the card has to show them shuffled.
    func shuffledOptions() -> [ChoiceOption] {
        options.shuffled()
    }
}
