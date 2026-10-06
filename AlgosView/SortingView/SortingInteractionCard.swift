//
//  SortingInteractionCard.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import SwiftUI

// MARK: - View (This view is just to check the mechanism I have created, of course we will change this when Jose give us the design.)
struct SortingInteractionCard: View {

    enum Phase: Equatable {
        case editing
        case assembling                 // blocks are flying into the function panel
        case result(isCorrect: Bool)    // panel turns green or red
        case feedback                   // "Good job" + difficultad rating
        case solved
    }

    typealias Difficulty = ExerciseDifficulty


    let exercise: SortingExercise
    // Not wired to anything yet, this is where the FSRS rating will go.
    var onRate: (Difficulty) -> Void

    @State private var solution: LoopSolution
    @State private var blocks: [CodePart]
    @State private var phase: Phase = .editing
    @State private var showRetryHint = false

    // Frames (global) of the blocks in the list and of their slots in the function panel,
    // used to make copies of the blocks float between them.
    @State private var rowFrames: [UUID: CGRect] = [:]
    @State private var slotFrames: [UUID: CGRect] = [:]
    @State private var overlayOrigin: CGPoint = .zero
    @State private var landed: Set<UUID> = []

    @Environment(\.codeTheme) private var codeTheme

    init(exercise: SortingExercise, language: ProgrammingLenguages = .swift, onRate: @escaping (Difficulty) -> Void = { _ in }) {
        self.exercise = exercise
        self.onRate = onRate
        let solution = exercise.solution(in: language)
        _solution = State(initialValue: solution)
        _blocks = State(initialValue: solution.shuffledBody())
    }

    var body: some View {
        ZStack {
            List {
                Section {
                    Text(exercise.title).font(.headline)
                    Text(exercise.description).foregroundStyle(.secondary)

                    LanguagePicker(languages: exercise.languages, selection: languageSelection)
                        .disabled(phase != .editing)
                }

                Section("Examples") {
                    ForEach(exercise.examples, id: \.self) { example in
                        Text(example).font(.system(.footnote, design: .monospaced))
                    }
                }

                // The setup and the ending are fixed, only the loop body can be moved
                Section {
                    ForEach(blocks) { part in
                        codeText(part.code)
                            // while the copy is flying, the original stays hidden in its row
                            .opacity(isOverlayVisible ? 0 : 1)
                            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                                rowFrames[part.id] = $0
                            }
                    }
                    .onMove { from, to in
                        blocks.move(fromOffsets: from, toOffset: to)
                        showRetryHint = false   // any change clears the previous result
                    }
                    .moveDisabled(phase == .solved)
                } header: {
                    fixedCode(solution.setup, caption: "Loop body — drag to reorder")
                } footer: {
                    fixedCode(solution.ending)
                }

                Section {
                    Button(action: submit) {
                        Text(buttonTitle).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(phase == .solved ? .green : .accentColor)
                    .disabled(phase != .editing)
                    .listRowBackground(Color.clear)

                    if showRetryHint {
                        Text("Not quite. Check which line has to come first and try again.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }

            if isOverlayVisible {
                submissionOverlay
                    .transition(.opacity)
            }
        }

        //This would add like vibrations when the user makes a mistake or losses. Jus thought it could be cool to add that.
        .sensoryFeedback(.success, trigger: phase == .result(isCorrect: true))
        .sensoryFeedback(.error, trigger: phase == .result(isCorrect: false))
    }

    // MARK: Overlay

    private var isOverlayVisible: Bool {
        switch phase {
        case .editing, .solved: false
        case .assembling, .result, .feedback: true
        }
    }

    private var submissionOverlay: some View {
        ZStack {
            // Covers the whole card, which also blocks any interaction during the animation
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            if phase == .feedback {
                DifficultyRatingView(onRate: rate)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                functionPanel
                    .transition(.opacity)

                ForEach(blocks) { part in
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
                codeText(solution.setup)

                // Invisible slots: they give the flying blocks their final position
                ForEach(blocks) { part in
                    codeText(part.code)
                        .hidden()
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                            slotFrames[part.id] = $0
                        }
                }

                codeText(solution.ending)
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
        .animation(.easeInOut(duration: 0.3), value: phase)
    }

    @ViewBuilder
    private func flyingBlock(_ part: CodePart) -> some View {
        let isLanded = landed.contains(part.id)
        // A row that is scrolled off screen has no frame, so its block just fades in at its slot
        let source = rowFrames[part.id]
        if let frame = (isLanded ? slotFrames[part.id] : source) ?? slotFrames[part.id] {
            codeText(part.code)
                .frame(width: frame.width, height: frame.height, alignment: .leading)
                .position(x: frame.midX - overlayOrigin.x, y: frame.midY - overlayOrigin.y)
                .opacity(isLanded || source != nil ? 1 : 0)
        }
    }

    private func codeText(_ code: String) -> some View {
        CodeText(code, language: solution.language)
            .font(.footnote)
            .lineLimit(nil)
    }

    /// Code the user can't move, shown above and below the loop body.
    private func fixedCode(_ code: String, caption: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            codeText(code)
                .opacity(0.75)
            if let caption {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .textCase(nil)
        .padding(.vertical, 4)
    }

    private var buttonTitle: String {
        phase == .solved ? "Solved ✓" : "Check answer"
    }

    private var panelBackground: Color {
        switch phase {
        case .result(isCorrect: true): Color.green.opacity(0.25)
        case .result(isCorrect: false): Color.red.opacity(0.25)
        default: Color(.secondarySystemGroupedBackground)
        }
    }

    private var panelBorder: Color {
        switch phase {
        case .result(isCorrect: true): .green
        case .result(isCorrect: false): .red
        default: .clear
        }
    }

    private var languageSelection: Binding<ProgrammingLenguages> {
        Binding(get: { solution.language }, set: select)
    }

    // MARK: Actions

    private func select(_ language: ProgrammingLenguages) {
        solution = exercise.solution(in: language)
        blocks = solution.shuffledBody()
        showRetryHint = false
    }

    private func submit() {
        let isCorrect = solution.isSolved(blocks)
        showRetryHint = false
        landed = []
        withAnimation(.easeOut(duration: 0.25)) { phase = .assembling }

        Task {
            // let the panel appear and measure its slots before the blocks start flying
            await pause(0.35)

            // the blocks float one by one, in the order the user picked
            for part in blocks {
                withAnimation(.spring(duration: 0.5, bounce: 0.2)) { _ = landed.insert(part.id) }
                await pause(0.25)
            }
            await pause(0.4)

            withAnimation { phase = .result(isCorrect: isCorrect) }
            await pause(1.0)

            if isCorrect {
                withAnimation(.spring(duration: 0.4)) { phase = .feedback }
            } else {
                // blocks go back to their rows, keeping the order the user had
                withAnimation(.spring(duration: 0.5, bounce: 0.1)) { landed = [] }
                await pause(0.5)
                withAnimation(.easeOut(duration: 0.25)) {
                    phase = .editing
                    showRetryHint = true
                }
            }
        }
    }

    private func rate(_ difficulty: Difficulty) {
        onRate(difficulty)
        withAnimation { phase = .solved }
    }

    private func pause(_ seconds: Double) async {
        try? await Task.sleep(for: .seconds(seconds))
    }
}

#Preview("Two Sum") {
    SortingInteractionCard(exercise: .twoSum)
}

#Preview("Reverse Linked List · Python") {
    SortingInteractionCard(exercise: .reverseLinkedList, language: .python)
}

#Preview("Climbing Stairs · Java") {
    SortingInteractionCard(exercise: .climbingStairs, language: .java)
}
