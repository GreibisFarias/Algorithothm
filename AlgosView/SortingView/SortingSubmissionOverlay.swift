//
//  SortingSubmissionOverlay.swift
//  Algorithothm
//
//  Shown while the answer is checked: copies of the blocks float from their slots into a
//  bigger monitor with the whole function, its screen turns green or red, then the rating appears.
//

import SwiftUI

struct SortingSubmissionOverlay: View {
    let viewModel: SortingCardViewModel
    /// Slots whose block already reached the big monitor.
    let landed: Set<Int>
    /// Frames of the slots on the card, where the copies start flying from.
    let sourceFrames: [Int: CGRect]

    // Frames of the slots of the big monitor, where the copies end.
    @State private var targetFrames: [Int: CGRect] = [:]
    @State private var overlayOrigin: CGPoint = .zero

    var body: some View {
        ZStack {
            // Covers the whole card, which also blocks any interaction during the animation
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            if viewModel.phase == .feedback {
                RetroRatingView(theme: .aprendeYArma, onRate: rate)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                functionPanel
                    .transition(.opacity)

                ForEach(viewModel.slots.indices, id: \.self) { index in
                    flyingBlock(index)
                }
            }
        }
        .onGeometryChange(for: CGPoint.self) { $0.frame(in: .sortingCard).origin } action: {
            overlayOrigin = $0
        }
    }

    private var functionPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TU FUNCIÓN")
                .font(RetroFont.pixel(14, relativeTo: .caption))
                .foregroundStyle(Retro.accent)
                .tracking(1)

            RetroMonitor(screen: screenColor, border: borderColor) {
                codeLines(viewModel.solution.setup)

                // Invisible slots: they give the flying blocks their final position
                ForEach(viewModel.slots.indices, id: \.self) { index in
                    block(at: index)
                        .hidden()
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .sortingCard) } action: {
                            targetFrames[index] = $0
                        }
                }

                codeLines(viewModel.solution.ending)
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.phase)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func flyingBlock(_ index: Int) -> some View {
        let isLanded = landed.contains(index)
        if let frame = isLanded ? targetFrames[index] : sourceFrames[index] {
            block(at: index)
                .environment(\.codeTheme, .monitor)
                .frame(width: frame.width, height: frame.height, alignment: .topLeading)
                .position(x: frame.midX - overlayOrigin.x, y: frame.midY - overlayOrigin.y)
        }
    }

    @ViewBuilder
    private func block(at index: Int) -> some View {
        if let part = viewModel.slots[index] {
            MonitorBlock(part: part, language: viewModel.language, isHint: viewModel.isLocked(index))
        }
    }

    private func codeLines(_ code: String) -> some View {
        ForEach(Array(code.split(separator: "\n", omittingEmptySubsequences: false).enumerated()), id: \.offset) { _, line in
            MonitorCodeLine(code: String(line), language: viewModel.language)
        }
    }

    private var screenColor: Color {
        switch viewModel.phase {
        case .result(isCorrect: true): Retro.screenCorrect
        case .result(isCorrect: false): Retro.screenWrong
        default: Retro.screen
        }
    }

    private var borderColor: Color {
        switch viewModel.phase {
        case .result(isCorrect: true): Retro.phosphor
        case .result(isCorrect: false): Retro.error
        default: .clear
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        withAnimation { viewModel.rate(difficulty) }
    }
}
