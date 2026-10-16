//
//  SortingStrategy.swift
//  Algorithothm
//
//  The algorithm behind the sorting card: how the blocks start and when an order is right.
//

import Foundation

struct SortingStrategy {

    //Compares the code and not the ids, so two blocks with the same text can be swapped.
    func isSolved(_ parts: [CodePart], for solution: LoopSolution) -> Bool {
        parts.map(\.code) == solution.loopBody.map(\.code)
    }

    /// The loop body in a random order that is never the solved one.
    func startingOrder(for solution: LoopSolution) -> [CodePart] {
        // if every block has the same text there is no wrong order to start from
        guard Set(solution.loopBody.map(\.code)).count > 1 else { return solution.loopBody }
        var shuffled = solution.loopBody
        repeat { shuffled.shuffle() } while isSolved(shuffled, for: solution)
        return shuffled
    }
}
