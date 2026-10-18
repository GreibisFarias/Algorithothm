//
//  SortingStrategy.swift
//  Algorithothm
//
//  The algorithm behind the sorting card: how the blocks start and when an order is right.
//

import Foundation

struct SortingStrategy {

    /// How many blocks are already in their slot when the card starts, as a hint.
    var givenBlocks = 1

    //Compares the code and not the ids, so two blocks with the same text can be swapped.
    func isSolved(_ parts: [CodePart], for solution: LoopSolution) -> Bool {
        parts.map(\.code) == solution.loopBody.map(\.code)
    }

    /// Every slot is filled and with the right block.
    func isSolved(_ slots: [CodePart?], for solution: LoopSolution) -> Bool {
        let parts = slots.compactMap(\.self)
        return parts.count == slots.count && isSolved(parts, for: solution)
    }

    /// The slots of the monitor when the card starts: the hint blocks in place, the rest empty.
    func startingSlots(for solution: LoopSolution) -> [CodePart?] {
        solution.loopBody.enumerated().map { index, part in
            index < givenBlocks ? part : nil
        }
    }

    /// The blocks below the monitor, in a random order that is never the solved one.
    func poolOrder(for solution: LoopSolution) -> [CodePart] {
        // if every block has the same text there is no wrong order to start from
        guard Set(solution.loopBody.map(\.code)).count > 1 else { return solution.loopBody }
        var shuffled = solution.loopBody
        repeat { shuffled.shuffle() } while isSolved(shuffled, for: solution)
        return shuffled
    }
}
