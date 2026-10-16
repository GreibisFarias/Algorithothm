//
//  SortingSubmissionOverlay.swift
//  Algorithothm
//
//  Shown while the answer is checked: copies of the blocks float from their rows
//  into the function panel, the panel turns green or red, then the rating appears.
//

import SwiftUI

struct SortingSubmissionOverlay: View {
    let viewModel: SortingCardViewModel
    /// Blocks that already reached their slot in the panel.
    let landed: Set<UUID>
    /// Frames (global) of the blocks in the list, where the copies start flying from.
    let rowFrames: [UUID: CGRect]

    // Frames (global) of the slots in the panel, where the copies end.
    @State private var slotFrames: [UUID: CGRect] = [:]
    @State private var overlayOrigin: CGPoint = .zero

    @Environment(\.codeTheme) private var codeTheme

    var body: some View {
        ZStack {
            // Covers the whole card, which also blocks any interaction during the animation
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            if viewModel.phase == .feedback {
                DifficultyRatingView(onRate: rate)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                functionPanel
                    .transition(.opacity)

                ForEach(viewModel.blocks) { part in
                    flyingBlock(part)
                }
            }
        }
        .onGeometryChange(for: CGPoint.self) { $0.frame(in: .global).origin } action: {
            overlayOrigin = $0
        }
    }

    private var functionPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your function")
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                codeLine(viewModel.solution.setup)

                // Invisible slots: they give the flying blocks their final position
                ForEach(viewModel.blocks) { part in
                    codeLine(part.code)
                        .hidden()
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                            slotFrames[part.id] = $0
                        }
                }

                codeLine(viewModel.solution.ending)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(codeTheme.background, in: RoundedRectangle(cornerRadius: 8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(panelBackground, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(panelBorder, lineWidth: 2)
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase)
    }

    @ViewBuilder
    private func flyingBlock(_ part: CodePart) -> some View {
        let isLanded = landed.contains(part.id)
        // A row that is scrolled off screen has no frame, so its block just fades in at its slot
        let source = rowFrames[part.id]
        if let frame = (isLanded ? slotFrames[part.id] : source) ?? slotFrames[part.id] {
            codeLine(part.code)
                .frame(width: frame.width, height: frame.height, alignment: .leading)
                .position(x: frame.midX - overlayOrigin.x, y: frame.midY - overlayOrigin.y)
                .opacity(isLanded || source != nil ? 1 : 0)
        }
    }

    private func codeLine(_ code: String) -> some View {
        SortingCodeLine(code, language: viewModel.solution.language)
    }

    private var panelBackground: Color {
        switch viewModel.phase {
        case .result(isCorrect: true): Color.green.opacity(0.25)
        case .result(isCorrect: false): Color.red.opacity(0.25)
        default: Color(.secondarySystemGroupedBackground)
        }
    }

    private var panelBorder: Color {
        switch viewModel.phase {
        case .result(isCorrect: true): .green
        case .result(isCorrect: false): .red
        default: .clear
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        withAnimation { viewModel.rate(difficulty) }
    }
}
