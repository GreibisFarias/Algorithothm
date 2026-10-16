//
//  CodeExample.swift
//  Algorithothm
//
//  Code shown on the monitor of the retro cards, used by every card type.
//

import Foundation

/// A function shown on the monitor, with the line the text talks about highlighted.
struct CodeExample: Hashable {
    let code: String
    let highlightedLine: Int?

    /// - Parameter highlight: the text of the line to highlight, without its indentation. Nil for none.
    init(_ code: String, highlight: String?) {
        self.code = code
        guard let highlight else {
            self.highlightedLine = nil
            return
        }
        let index = code.split(separator: "\n", omittingEmptySubsequences: false)
            .firstIndex { $0.trimmingCharacters(in: .whitespaces) == highlight }
        precondition(index != nil, "The highlighted line has to be one of the lines of the code")
        self.highlightedLine = index
    }

    var lines: [String] {
        code.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }
}
