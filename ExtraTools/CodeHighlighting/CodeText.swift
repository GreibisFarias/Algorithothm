//
//  CodeText.swift
//  Algorithothm
//
//  Entry point of the module: turns code into a colored AttributedString and shows it.
//
//      CodeText(code, language: .swift)
//          .font(.footnote)        // the size is up to the caller, it is always monospaced
//

import SwiftUI

struct SyntaxHighlighter {
    let syntax: SyntaxDefinition
    let theme: CodeTheme

    func highlight(_ code: String) -> AttributedString {
        SyntaxTokenizer(syntax: syntax)
            .tokenize(code)
            .reduce(into: AttributedString()) { result, token in
                var piece = AttributedString(token.text)
                piece.foregroundColor = theme.color(for: token.kind)
                if token.kind == .keyword, theme.boldKeywords {
                    // keeps whatever font the caller set, only makes it bold
                    piece.inlinePresentationIntent = .stronglyEmphasized
                }
                result += piece
            }
    }
}

struct CodeText: View {
    let code: String
    let syntax: SyntaxDefinition

    @Environment(\.codeTheme) private var theme

    init(_ code: String, syntax: SyntaxDefinition) {
        self.code = code
        self.syntax = syntax
    }

    init(_ code: String, language: ProgrammingLenguages) {
        self.init(code, syntax: language.syntax)
    }

    var body: some View {
        Text(SyntaxHighlighter(syntax: syntax, theme: theme).highlight(code))
            .monospaced()
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(ProgrammingLenguages.allCases) { language in
                CodeText(mockData.HELLOBEO.codeByLenguage[language] ?? "", language: language)
                    .font(.footnote)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(CodeTheme.xcode.background, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
