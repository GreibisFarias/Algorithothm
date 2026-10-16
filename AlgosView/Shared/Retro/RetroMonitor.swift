//
//  RetroMonitor.swift
//  Algorithothm
//
//  The beige computer monitor with its green screen, where the code is shown.
//
//      RetroMonitor {
//          MonitorCode(code: CodeExample(code, highlight: "if n > mayor {"), language: .swift)
//      }
//
//  Inside it, code is colored by the syntax highlighter (CodeText) with the `.monitor` theme.
//  Keep lines up to 39 characters at 18pt (42 at 17pt) so they fit an iPhone screen.
//

import SwiftUI

struct RetroMonitor<Content: View>: View {
    /// Tint of the screen, to show a result (`Retro.screenCorrect` / `.screenWrong`).
    var screen: Color = Retro.screen
    /// Outline around the screen, to show a result.
    var border: Color = .clear
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(screen)
        .padding(10)
        .pixelPanel(Retro.bezel, ledge: Retro.bezelShadow)
        .overlay {
            Rectangle()
                .strokeBorder(border, lineWidth: 3)
                .padding(4)
        }
        .environment(\.codeTheme, .monitor)
    }
}

/// A whole function on the monitor, with the line of `code.highlightedLine` highlighted.
struct MonitorCode: View {
    let code: CodeExample
    let language: ProgrammingLenguages
    /// 18 for code that is only read, 17 for code the user edits (it has to leave room for slots).
    var size: CGFloat = 18

    var body: some View {
        ForEach(Array(code.lines.enumerated()), id: \.offset) { index, line in
            MonitorCodeLine(code: line, language: language, size: size)
                .background(index == code.highlightedLine ? Retro.highlightedLine : .clear)
        }
    }
}

/// One line of code on the monitor, never wrapped. Its background spans the whole screen.
struct MonitorCodeLine: View {
    let code: String
    let language: ProgrammingLenguages
    var size: CGFloat = 17
    /// Paints the whole line in one color instead of highlighting it (the hint block of Tipo 2).
    var tint: Color?

    var body: some View {
        Group {
            if let tint {
                Text(code).foregroundStyle(tint)
            } else {
                CodeText(code, language: language)
            }
        }
        .font(RetroFont.terminal(size))
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension CodeTheme {
    /// Colors of the syntax highlighter on the green screen, always dark.
    static let monitor = CodeTheme(
        plain: Retro.phosphor,
        keyword: Color(retroHex: 0xFF7AB2),
        type: Color(retroHex: 0x7FD4F5),
        function: Retro.text,
        string: Color(retroHex: 0xF2C46B),
        number: Color(retroHex: 0xD9C97C),
        comment: Retro.phosphorDim,
        attribute: Color(retroHex: 0xCC9768),
        background: Retro.screen,
        boldKeywords: false     // VT323 has no bold, a fake one looks blurry
    )
}
