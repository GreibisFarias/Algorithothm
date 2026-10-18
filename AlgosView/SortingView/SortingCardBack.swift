//
//  SortingCardBack.swift
//  Algorithothm
//
//  Back of the card ("Arma"): the function on the monitor with numbered empty slots, and the
//  blocks below it. The user drags each block into a slot; a block in a slot can be dragged
//  to another slot (they swap) or out of the monitor (it goes back down).
//

import SwiftUI

extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {
    /// Space of the whole card, shared by the slots, the drags and the submission overlay.
    static var sortingCard: NamedCoordinateSpace { .named("sortingCard") }
}

struct SortingCardBack: View {
    let viewModel: SortingCardViewModel
    /// Frames of the slots, the submission overlay makes the blocks fly from them.
    @Binding var slotFrames: [Int: CGRect]
    /// While the overlay is up, its flying copies replace the blocks of the monitor.
    let isSubmitting: Bool
    let onSubmit: () -> Void

    private struct BlockDrag {
        let part: CodePart
        let fromSlot: Int?
        var translation: CGSize = .zero
        var location: CGPoint = .zero
    }

    @State private var drag: BlockDrag?
    @State private var monitorFrame: CGRect = .zero

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                monitor
                    // the dragged block has to be drawn above its siblings
                    .zIndex(drag?.fromSlot != nil ? 1 : 0)

                Text("¿En qué orden van los bloques?")
                    .font(RetroFont.pixel(17))
                    .multilineTextAlignment(.center)

                pool
                    .zIndex(drag != nil && drag?.fromSlot == nil ? 1 : 0)

                if viewModel.showRetryHint {
                    Text("Casi. Revisa el orden de los bloques e inténtalo de nuevo.")
                        .font(RetroFont.pixel(15))
                        .foregroundStyle(Retro.error)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDisabled(drag != nil)
        .safeAreaInset(edge: .bottom) {
            Button("Comprobar", action: onSubmit)
                .buttonStyle(RetroCardTheme.aprendeYArma.button)
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 16)
        }
        .sensoryFeedback(.selection, trigger: viewModel.slots)
    }

    // MARK: Monitor

    private var monitor: some View {
        RetroMonitor {
            codeLines(viewModel.solution.setup)
            ForEach(viewModel.slots.indices, id: \.self) { index in
                slot(index)
                    .onGeometryChange(for: CGRect.self) { $0.frame(in: .sortingCard) } action: {
                        slotFrames[index] = $0
                    }
            }
            codeLines(viewModel.solution.ending)
        }
        .onGeometryChange(for: CGRect.self) { $0.frame(in: .sortingCard) } action: {
            monitorFrame = $0
        }
    }

    private func codeLines(_ code: String) -> some View {
        ForEach(Array(code.split(separator: "\n", omittingEmptySubsequences: false).enumerated()), id: \.offset) { _, line in
            MonitorCodeLine(code: String(line), language: viewModel.language)
        }
    }

    @ViewBuilder
    private func slot(_ index: Int) -> some View {
        let isHovered = hoveredSlot == index
        Group {
            if let part = viewModel.slots[index] {
                let isDragged = drag?.part == part
                MonitorBlock(part: part, language: viewModel.language, isHint: viewModel.isLocked(index))
                    .background(isHovered && !isDragged ? Retro.highlightedLine : .clear)
                    .offset(isDragged ? drag!.translation : .zero)
                    .contentShape(Rectangle())
                    .gesture(dragGesture(for: part, fromSlot: index), isEnabled: !viewModel.isLocked(index))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Hueco \(index + 1): \(part.singleLine)")
                    .accessibilityAction(named: "Quitar del hueco") {
                        withAnimation { viewModel.removeBlock(fromSlot: index) }
                    }
            } else {
                EmptySlot(
                    number: index + 1,
                    indentation: viewModel.solution.bodyIndentation,
                    isActive: isHovered || (drag == nil && viewModel.nextEmptySlot == index)
                )
                .background(isHovered ? Retro.highlightedLine : .clear)
            }
        }
        // while the copies fly in the overlay, the originals stay hidden
        .opacity(isSubmitting ? 0 : 1)
    }

    // MARK: Blocks below the monitor

    private var pool: some View {
        VStack(spacing: 10) {
            ForEach(Array(viewModel.pool.enumerated()), id: \.element.id) { index, part in
                poolBlock(part)
                    // staggered, like in the design
                    .frame(maxWidth: .infinity, alignment: index.isMultiple(of: 2) ? .leading : .trailing)
            }
        }
    }

    @ViewBuilder
    private func poolBlock(_ part: CodePart) -> some View {
        if viewModel.isPlaced(part) {
            // already in a slot: only its outline stays here
            Text(part.singleLine)
                .font(RetroFont.terminal(18))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundStyle(Retro.ghostText)
                .padding(.horizontal, 14)
                .frame(height: 40)
                .overlay { Rectangle().strokeBorder(Retro.ghostStroke, lineWidth: 2) }
                .accessibilityLabel("Bloque ya colocado: \(part.singleLine)")
        } else {
            let isDragged = drag?.part == part
            Text(part.singleLine)
                .font(RetroFont.terminal(17))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, 14)
                .frame(height: 44)
                .retroBlock()
                .scaleEffect(isDragged ? 1.05 : 1)
                .shadow(color: .black.opacity(isDragged ? 0.4 : 0), radius: 8, y: 6)
                .offset(isDragged ? drag!.translation : .zero)
                .gesture(dragGesture(for: part, fromSlot: nil))
                .accessibilityLabel("Bloque: \(part.singleLine)")
                .accessibilityAction(named: "Colocar en el siguiente hueco") {
                    guard let slot = viewModel.nextEmptySlot else { return }
                    withAnimation { viewModel.place(part, inSlot: slot) }
                }
        }
    }

    // MARK: Drag and drop

    private var hoveredSlot: Int? {
        guard let drag else { return nil }
        return slot(at: drag.location)
    }

    /// The slot under `location` that can take a block (the hint one can't).
    private func slot(at location: CGPoint) -> Int? {
        slotFrames
            .filter { !viewModel.isLocked($0.key) && $0.value.insetBy(dx: 0, dy: -8).contains(location) }
            .min { abs($0.value.midY - location.y) < abs($1.value.midY - location.y) }?
            .key
    }

    private func dragGesture(for part: CodePart, fromSlot: Int?) -> some Gesture {
        DragGesture(minimumDistance: 2, coordinateSpace: .sortingCard)
            .onChanged { value in
                guard viewModel.canEdit else { return }
                if drag == nil { drag = BlockDrag(part: part, fromSlot: fromSlot) }
                drag?.translation = value.translation
                drag?.location = value.location
            }
            .onEnded { value in
                drop(part, fromSlot: fromSlot, at: value.location)
            }
    }

    private func drop(_ part: CodePart, fromSlot: Int?, at location: CGPoint) {
        let target = slot(at: location)
        let leavesMonitor = fromSlot != nil && !monitorFrame.contains(location)

        guard target != nil || leavesMonitor else {
            // dropped nowhere: the block goes back to where it was
            withAnimation(.spring(duration: 0.3)) { drag = nil }
            return
        }

        // the block is drawn at its new place right away, it doesn't travel back first
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) { drag = nil }

        withAnimation(.spring(duration: 0.3)) {
            if let target {
                viewModel.place(part, inSlot: target)
            } else if let fromSlot {
                viewModel.removeBlock(fromSlot: fromSlot)
            }
        }
    }
}

// MARK: - Pieces of the monitor

/// The code of one block on the monitor. The hint block is painted orange, like in the design.
struct MonitorBlock: View {
    let part: CodePart
    let language: ProgrammingLenguages
    var isHint = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(part.code.split(separator: "\n").enumerated()), id: \.offset) { _, line in
                MonitorCodeLine(code: String(line), language: language, tint: isHint ? Retro.accent : nil)
            }
        }
    }
}

/// A numbered hole on the monitor, underlined with dashes. The active one shows a blinking cursor.
private struct EmptySlot: View {
    let number: Int
    let indentation: String
    let isActive: Bool

    var body: some View {
        let color = isActive ? Retro.phosphor : Retro.phosphorDim
        HStack(spacing: 0) {
            Text(indentation)
            HStack(spacing: 6) {
                Text("\(number)")
                if isActive {
                    Text("▌")
                        .phaseAnimator([1.0, 0.0]) { cursor, opacity in
                            cursor.opacity(opacity)
                        } animation: { _ in .linear(duration: 0.01).delay(0.5) }
                }
            }
            .frame(width: 200, height: 22, alignment: .leading)
            .overlay(alignment: .bottom) {
                DashedLine()
                    .stroke(color, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                    .frame(height: 2)
            }
        }
        .font(RetroFont.terminal(17))
        .foregroundStyle(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hueco \(number), vacío")
    }
}

private struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}
