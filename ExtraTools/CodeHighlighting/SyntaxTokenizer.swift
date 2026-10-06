//
//  SyntaxTokenizer.swift
//  Algorithothm
//
//  Splits code into tokens (keyword, type, function, string...) using a SyntaxDefinition.
//  It is a lightweight lexer, good enough for coloring short snippets, not a real parser.
//

import Foundation

enum CodeTokenKind {
    case plain
    case keyword
    case type
    case function
    case string
    case number
    case comment
    case attribute
}

struct CodeToken: Equatable {
    let kind: CodeTokenKind
    let text: String
}

struct SyntaxTokenizer {
    let syntax: SyntaxDefinition

    func tokenize(_ code: String) -> [CodeToken] {
        var lexer = Lexer(syntax: syntax, characters: Array(code))
        return lexer.run()
    }
}

// MARK: - Lexer

private struct Lexer {
    let syntax: SyntaxDefinition
    let characters: [Character]
    var position = 0
    /// Last identifier read, used to detect `func name` / `def name`.
    var previousWord: String?

    init(syntax: SyntaxDefinition, characters: [Character]) {
        self.syntax = syntax
        self.characters = characters
    }

    mutating func run() -> [CodeToken] {
        var tokens: [CodeToken] = []
        while position < characters.count {
            let token = nextToken()
            // glue consecutive plain text together so the AttributedString has fewer runs
            if token.kind == .plain, let last = tokens.last, last.kind == .plain {
                tokens[tokens.count - 1] = CodeToken(kind: .plain, text: last.text + token.text)
            } else {
                tokens.append(token)
            }
        }
        return tokens
    }

    private mutating func nextToken() -> CodeToken {
        let start = position
        let character = characters[position]

        if let prefix = syntax.lineComment, matches(prefix) {
            advance(while: { $0 != "\n" })
            return token(.comment, from: start)
        }
        if let block = syntax.blockComment, matches(block.open) {
            position += block.open.count
            advance(pastNext: block.close)
            return token(.comment, from: start)
        }
        if let delimiter = syntax.stringDelimiters.first(where: matches) {
            scanString(closedBy: delimiter)
            return token(.string, from: start)
        }
        if character.isASCIIDigit {
            scanNumber()
            return token(.number, from: start)
        }
        if character == syntax.attributePrefix, let next = peek(1), next.isIdentifierStart {
            position += 1
            advance(while: \.isIdentifierPart)
            return token(.attribute, from: start)
        }
        if character.isIdentifierStart {
            advance(while: \.isIdentifierPart)
            let word = String(characters[start..<position])
            let kind = classify(word)
            previousWord = word
            return CodeToken(kind: kind, text: word)
        }

        position += 1
        if !character.isWhitespace { previousWord = nil }
        return token(.plain, from: start)
    }

    private func classify(_ word: String) -> CodeTokenKind {
        if syntax.keywords.contains(word) { return .keyword }
        if let previousWord, syntax.functionDeclarationKeywords.contains(previousWord) { return .function }
        if syntax.builtInTypes.contains(word) { return .type }
        if nextNonWhitespace() == "(" { return .function }
        if syntax.capitalizedWordsAreTypes, word.first?.isUppercase == true { return .type }
        return .plain
    }

    // MARK: Scanning helpers

    private mutating func scanString(closedBy delimiter: String) {
        let isMultiline = delimiter.count > 1
        position += delimiter.count
        while position < characters.count {
            if characters[position] == "\\" {
                position = min(position + 2, characters.count)
                continue
            }
            if matches(delimiter) {
                position += delimiter.count
                return
            }
            // an unclosed single-line string stops at the end of the line
            if !isMultiline, characters[position] == "\n" { return }
            position += 1
        }
    }

    /// Digits, hex/suffix letters (`0xFF`, `10L`), `_` separators and a decimal point followed by a digit.
    /// `1..<n` stays as the number `1` followed by the range operator.
    private mutating func scanNumber() {
        while position < characters.count {
            let character = characters[position]
            if character.isLetter || character.isNumber || character == "_" {
                position += 1
            } else if character == ".", peek(1)?.isASCIIDigit == true {
                position += 1
            } else {
                return
            }
        }
    }

    private func matches(_ text: String) -> Bool {
        var index = position
        for character in text {
            guard index < characters.count, characters[index] == character else { return false }
            index += 1
        }
        return true
    }

    private func peek(_ offset: Int) -> Character? {
        let index = position + offset
        return index < characters.count ? characters[index] : nil
    }

    private func nextNonWhitespace() -> Character? {
        characters[position...].first { !$0.isWhitespace }
    }

    private mutating func advance(while condition: (Character) -> Bool) {
        while position < characters.count, condition(characters[position]) {
            position += 1
        }
    }

    /// Moves past the next `text`, or to the end if it never appears (an unclosed comment).
    private mutating func advance(pastNext text: String) {
        while position < characters.count {
            if matches(text) {
                position += text.count
                return
            }
            position += 1
        }
    }

    private func token(_ kind: CodeTokenKind, from start: Int) -> CodeToken {
        CodeToken(kind: kind, text: String(characters[start..<position]))
    }
}

private extension Character {
    var isASCIIDigit: Bool { isASCII && isNumber }
    var isIdentifierStart: Bool { isLetter || self == "_" || self == "$" }
    var isIdentifierPart: Bool { isIdentifierStart || isNumber }
}
