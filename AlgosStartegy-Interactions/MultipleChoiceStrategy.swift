//
//  MultipleChoiceStrategy.swift
//  Algorithothm
//
//  The algorithm behind the "Predice" card: how the options are shown and which one is right.
//

import Foundation

struct MultipleChoiceStrategy {

    func isCorrect(_ option: ChoiceOption) -> Bool {
        option.isCorrect
    }

    /// The right answer is always first in the data, so the card shows the options shuffled.
    func shuffledOptions(of question: TraceQuestion) -> [ChoiceOption] {
        question.options.shuffled()
    }
}
