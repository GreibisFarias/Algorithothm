//
//  SortingInteracion.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation

//subtype: one draggable block of the loop body. It can span several lines (an `if` with its body, for example)
struct CodePart: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let order: Int
}


struct LoopSolution: Identifiable, Hashable {
    let language: ProgrammingLenguages
    let setup: String           // signature, initial variables and the loop header
    let loopBody: [CodePart]    // the blocks the user orders, in the right order
    let ending: String          // closes the loop and returns

    var id: ProgrammingLenguages { language }

    /// - Parameter bodyIndentLevel: how many levels (4 spaces each) the loop body is indented,
    ///   so the mock data can write the blocks without leading spaces.
    init(language: ProgrammingLenguages, setup: String, loopBody: [String], ending: String, bodyIndentLevel: Int = 2) {
        precondition(loopBody.count >= 2, "The loop body needs at least 2 blocks to be ordered")
        let indentation = String(repeating: "    ", count: bodyIndentLevel)

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

    //Validation funcs of the type
    //Compares the code and not the ids, so two blocks with the same text can be swapped.
    func isSolved(_ parts: [CodePart]) -> Bool {
        parts.map(\.code) == loopBody.map(\.code)
    }

    func shuffledBody() -> [CodePart] {
        // if every block has the same text there is no wrong order to start from
        guard Set(loopBody.map(\.code)).count > 1 else { return loopBody }
        var shuffled = loopBody
        repeat { shuffled.shuffle() } while isSolved(shuffled)
        return shuffled
    }

    /// The whole function, as it looks once it is solved.
    var fullCode: String {
        ([setup] + loopBody.map(\.code) + [ending]).joined(separator: "\n")
    }
}

//Type
struct SortingExercise: Identifiable {
    let id: String
    let title: String
    let description: String
    let examples: [String]
    let solutions: [LoopSolution]

    init(id: String, title: String, description: String, examples: [String], solutions: [LoopSolution]) {
        precondition(!solutions.isEmpty, "Each exercise needs the solution in at least one language")
        self.id = id
        self.title = title
        self.description = description
        self.examples = examples
        self.solutions = solutions
    }

    var languages: [ProgrammingLenguages] {
        solutions.map(\.language)
    }

    /// The solution in `language`, or the first one available if the exercise is not written in it.
    func solution(in language: ProgrammingLenguages) -> LoopSolution {
        solutions.first { $0.language == language } ?? solutions[0]
    }
}
