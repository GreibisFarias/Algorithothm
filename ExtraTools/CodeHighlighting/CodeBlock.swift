//
//  CodeBlock.swift
//  Algorithothm
//
//  A whole function shown like in an editor: themed background and horizontal
//  scroll, so long lines are never wrapped.
//

import SwiftUI

struct CodeBlock: View {
    let code: String
    let language: ProgrammingLenguages

    @Environment(\.codeTheme) private var theme

    init(_ code: String, language: ProgrammingLenguages) {
        self.code = code
        self.language = language
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            CodeText(code, language: language)
                .font(.footnote)
                .fixedSize()
                .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.background, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.separator, lineWidth: 0.5)
        }
    }
}

#Preview {
    CodeBlock(mockData.HELLOBEO.codeByLenguage[.java] ?? "", language: .java)
        .padding()
}
