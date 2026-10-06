//
//  SyntaxDefinition.swift
//  Algorithothm
//
//  The rules that tell the tokenizer what each word of a language means.
//  To support a new language: add a preset below and map it in `ProgrammingLenguages.syntax`.
//

import Foundation

struct SyntaxDefinition {
    struct Delimiters {
        let open: String
        let close: String
    }

    let keywords: Set<String>
    let builtInTypes: Set<String>
    /// Words after which the next identifier is a function name (`func`, `def`...).
    let functionDeclarationKeywords: Set<String>
    let lineComment: String?
    let blockComment: Delimiters?
    /// Sorted longest first, so `"""` wins over `"`.
    let stringDelimiters: [String]
    /// `@` for Swift attributes, Java annotations and Python decorators.
    let attributePrefix: Character?
    /// `ListNode`, `HashMap`... are colored as types even if they are not in `builtInTypes`.
    let capitalizedWordsAreTypes: Bool

    init(
        keywords: Set<String>,
        builtInTypes: Set<String> = [],
        functionDeclarationKeywords: Set<String> = [],
        lineComment: String? = nil,
        blockComment: Delimiters? = nil,
        stringDelimiters: [String] = ["\""],
        attributePrefix: Character? = nil,
        capitalizedWordsAreTypes: Bool = true
    ) {
        self.keywords = keywords
        self.builtInTypes = builtInTypes
        self.functionDeclarationKeywords = functionDeclarationKeywords
        self.lineComment = lineComment
        self.blockComment = blockComment
        self.stringDelimiters = stringDelimiters.sorted { $0.count > $1.count }
        self.attributePrefix = attributePrefix
        self.capitalizedWordsAreTypes = capitalizedWordsAreTypes
    }
}

// MARK: - Presets

extension SyntaxDefinition {

    static let swift = SyntaxDefinition(
        keywords: [
            "func", "let", "var", "if", "else", "guard", "return", "for", "in", "while", "repeat",
            "break", "continue", "switch", "case", "default", "where", "struct", "class", "enum",
            "protocol", "extension", "init", "deinit", "self", "Self", "super", "nil", "true", "false",
            "import", "inout", "throws", "throw", "try", "catch", "do", "defer", "async", "await",
            "static", "private", "fileprivate", "internal", "public", "open", "final", "mutating",
            "lazy", "weak", "unowned", "some", "any", "as", "is", "typealias", "associatedtype", "subscript"
        ],
        builtInTypes: [
            "Int", "Double", "Float", "Bool", "String", "Character", "Array", "Dictionary", "Set",
            "Optional", "Void", "Any", "AnyObject", "Never"
        ],
        functionDeclarationKeywords: ["func"],
        lineComment: "//",
        blockComment: Delimiters(open: "/*", close: "*/"),
        stringDelimiters: ["\"\"\"", "\""],
        attributePrefix: "@"
    )

    static let python = SyntaxDefinition(
        keywords: [
            "def", "return", "if", "elif", "else", "for", "while", "in", "not", "and", "or", "is",
            "None", "True", "False", "class", "import", "from", "as", "pass", "break", "continue",
            "lambda", "yield", "try", "except", "finally", "raise", "with", "global", "nonlocal",
            "del", "assert", "async", "await", "self"
        ],
        builtInTypes: ["int", "float", "str", "bool", "list", "dict", "set", "tuple", "object"],
        functionDeclarationKeywords: ["def"],
        lineComment: "#",
        stringDelimiters: ["\"\"\"", "'''", "\"", "'"],
        attributePrefix: "@"
    )

    static let java = SyntaxDefinition(
        keywords: [
            "public", "private", "protected", "static", "final", "abstract", "class", "interface",
            "enum", "extends", "implements", "new", "return", "if", "else", "for", "while", "do",
            "break", "continue", "switch", "case", "default", "try", "catch", "finally", "throw",
            "throws", "this", "super", "null", "true", "false", "import", "package", "instanceof",
            "var", "void", "int", "long", "short", "byte", "char", "boolean", "double", "float"
        ],
        builtInTypes: ["String", "Integer", "Long", "Double", "Boolean", "Character", "Object"],
        lineComment: "//",
        blockComment: Delimiters(open: "/*", close: "*/"),
        stringDelimiters: ["\"\"\"", "\"", "'"],
        attributePrefix: "@"
    )
}

// MARK: - App languages

extension ProgrammingLenguages {
    var syntax: SyntaxDefinition {
        switch self {
        case .swift: .swift
        case .python: .python
        case .java: .java
        }
    }
}
