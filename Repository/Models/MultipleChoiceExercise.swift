//
//  MultipleChoiceExercise.swift
//  Algorithothm
//
//  "Tipo 1 · Predice" cards: the user reads a function, runs it in their head and answers
//  a few questions about it, each one with a single right option.
//

import Foundation

//subtype
struct ChoiceOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

/// One question about the function. All the questions of a card share the same code.
struct TraceQuestion: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    /// The piece of the prompt painted green, usually the input ("nums = [1, 2, 3]").
    let emphasis: String?
    /// The line of code the question points at, without its indentation.
    let highlight: String?
    /// The right answer is always first, the card shows them shuffled.
    let options: [ChoiceOption]

    /// - Parameters:
    ///   - answer: the right option.
    ///   - wrong: the other options, 1 to 4 of them (so the card shows 2 to 5).
    init(_ prompt: String, emphasis: String? = nil, highlight: String? = nil, answer: String, wrong: [String]) {
        precondition((1...4).contains(wrong.count), "Each question needs between 1 and 4 wrong answers")
        precondition(!wrong.contains(answer), "A wrong answer can't be the same as the right one")
        precondition(emphasis.map(prompt.contains) ?? true, "The emphasis has to be part of the prompt")

        self.prompt = prompt
        self.emphasis = emphasis
        self.highlight = highlight
        self.options = [ChoiceOption(text: answer, isCorrect: true)]
            + wrong.map { ChoiceOption(text: $0, isCorrect: false) }
    }
}

/// The function and its questions in one language.
struct MultipleChoiceVariant: Identifiable, Hashable {
    let language: ProgrammingLenguages
    let code: String
    let questions: [TraceQuestion]

    var id: ProgrammingLenguages { language }

    init(_ language: ProgrammingLenguages, code: String, questions: [TraceQuestion]) {
        precondition(!questions.isEmpty, "Each card needs at least one question")
        self.language = language
        self.code = code
        self.questions = questions
        // fails here, and not when the card is shown, if a highlight is not in the code
        questions.forEach { _ = CodeExample(code, highlight: $0.highlight) }
    }

    /// The code as it is shown for `question`, with its line highlighted.
    func code(for question: TraceQuestion) -> CodeExample {
        CodeExample(code, highlight: question.highlight)
    }
}

//Type
struct MultipleChoiceExercise: Identifiable {
    let id: String
    let title: String
    let variants: [MultipleChoiceVariant]

    init(id: String, title: String, variants: [MultipleChoiceVariant]) {
        precondition(!variants.isEmpty, "Each exercise needs to be written in at least one language")
        self.id = id
        self.title = title
        self.variants = variants
    }

    var languages: [ProgrammingLenguages] {
        variants.map(\.language)
    }

    /// The exercise in `language`, or the first one available if it is not written in it.
    func variant(in language: ProgrammingLenguages) -> MultipleChoiceVariant {
        variants.first { $0.language == language } ?? variants[0]
    }
}
