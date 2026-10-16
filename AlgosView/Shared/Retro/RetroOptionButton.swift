//
//  RetroOptionButton.swift
//  Algorithothm
//
//  One answer of a question: dark box with an outline, green and glowing when selected.
//  Stack them with 12pt of spacing for a list of options.
//

import SwiftUI

enum RetroOptionState {
    case idle
    case selected   // "▸ " + green glow
    case wrong      // "✗ " + crossed out, can't be picked again
    case correct    // "✓ " + green
}

struct RetroOptionButton: View {
    let text: String
    let state: RetroOptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(prefix + text)
                .font(RetroFont.pixel(20))
                .strikethrough(state == .wrong)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundStyle(foreground)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                .background(background)
                .overlay { Rectangle().strokeBorder(stroke, lineWidth: 3) }
                .shadow(color: glow, radius: 8)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state == .wrong)
        .animation(.easeInOut(duration: 0.2), value: state)
        .accessibilityAddTraits(state == .selected ? .isSelected : [])
        .accessibilityValue(accessibilityValue)
    }

    private var prefix: String {
        switch state {
        case .idle: ""
        case .selected: "▸ "
        case .wrong: "✗ "
        case .correct: "✓ "
        }
    }

    private var foreground: Color {
        switch state {
        case .idle: Retro.text
        case .selected, .correct: Retro.phosphor
        case .wrong: Retro.error
        }
    }

    private var background: Color {
        switch state {
        case .idle, .wrong: Retro.panel
        case .selected: Retro.screen
        case .correct: Retro.screenCorrect
        }
    }

    private var stroke: Color {
        switch state {
        case .idle: Retro.panelStroke
        case .selected, .correct: Retro.phosphor
        case .wrong: Retro.error.opacity(0.6)
        }
    }

    private var glow: Color {
        switch state {
        case .selected, .correct: Retro.phosphor.opacity(0.35)
        case .idle, .wrong: .clear
        }
    }

    private var accessibilityValue: String {
        switch state {
        case .idle, .selected: ""
        case .wrong: "Incorrecta"
        case .correct: "Correcta"
        }
    }
}
