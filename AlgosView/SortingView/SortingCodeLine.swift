//
//  SortingCodeLine.swift
//  Algorithothm
//
//  How a piece of code looks everywhere on the sorting card.
//

import SwiftUI

struct SortingCodeLine: View {
    let code: String
    let language: ProgrammingLenguages

    init(_ code: String, language: ProgrammingLenguages) {
        self.code = code
        self.language = language
    }

    var body: some View {
        CodeText(code, language: language)
            .font(.footnote)
            .lineLimit(nil)
    }
}
