//
//  SortingExercise.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//
//  "Aprende y arma" cards: the front shows a function that is already solved, the back asks
//  the user to build a similar one by dropping the blocks of its loop body in order.
//

import Foundation

//subtype: one draggable block of the loop body. It can span several lines (an `if` with its body, for example)
struct CodePart: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let order: Int

    /// The block in a single line, as it is shown in the pill the user drags.
    var singleLine: String {
        code.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: " ")
    }
}

struct LoopSolution: Identifiable, Hashable {
    /// Code on the monitor is indented with 2 spaces so it fits the screen.
    static let indentation = "  "

    let language: ProgrammingLenguages
    let setup: String           // signature, initial variables and the loop header
    let loopBody: [CodePart]    // the blocks the user orders, in the right order
    let ending: String          // closes the loop and returns

    var id: ProgrammingLenguages { language }

    /// - Parameter bodyIndentLevel: how many levels the loop body is indented, so the mock data
    ///   can write the blocks without the indentation of the loop (only their own, relative one).
    init(language: ProgrammingLenguages, setup: String, loopBody: [String], ending: String, bodyIndentLevel: Int = 2) {
        precondition(loopBody.count >= 3, "The loop body needs at least 3 blocks: 1 is given as a hint and the rest are ordered")
        let indentation = String(repeating: Self.indentation, count: bodyIndentLevel)

        self.language = language
        self.setup = setup
        self.ending = ending
        self.loopBody = loopBody.enumerated().map { index, block in
            let indented = block
                .split(separator: "\n", omittingEmptySubsequences: false)
                .map { indentation + $0 }
                .joined(separator: "\n")
            return CodePart(code: indented, order: index)
        }
    }

    /// Indentation of the loop body, used to line up the empty slots with the code.
    var bodyIndentation: String {
        String(loopBody[0].code.prefix { $0 == " " })
    }

    /// The whole function, as it looks once it is solved.
    var fullCode: String {
        ([setup] + loopBody.map(\.code) + [ending]).joined(separator: "\n")
    }
}

/// One exercise written in one language: the example of the front and the function of the back.
struct SortingVariant: Identifiable, Hashable {
    let example: CodeExample
    let solution: LoopSolution

    var language: ProgrammingLenguages { solution.language }
    var id: ProgrammingLenguages { language }

    init(_ language: ProgrammingLenguages, example: String, highlight: String, setup: String, loopBody: [String], ending: String) {
        self.example = CodeExample(example, highlight: highlight)
        self.solution = LoopSolution(language: language, setup: setup, loopBody: loopBody, ending: ending)
    }
}

//Type
struct SortingExercise: Identifiable {
    let id: String
    let title: String
    let explanation: String     // "¿Qué hace?" of the front, it explains the example
    let variants: [SortingVariant]

    init(id: String, title: String, explanation: String, variants: [SortingVariant]) {
        precondition(!variants.isEmpty, "Each exercise needs to be written in at least one language")
        self.id = id
        self.title = title
        self.explanation = explanation
        self.variants = variants
    }

    var languages: [ProgrammingLenguages] {
        variants.map(\.language)
    }

    /// The exercise in `language`, or the first one available if it is not written in it.
    func variant(in language: ProgrammingLenguages) -> SortingVariant {
        variants.first { $0.language == language } ?? variants[0]
    }

    func solution(in language: ProgrammingLenguages) -> LoopSolution {
        variant(in: language).solution
    }
}
