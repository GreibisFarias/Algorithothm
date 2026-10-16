//
//  SortingInteractionCard.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import SwiftUI

// MARK: - View (This view is just to check the mechanism I have created, of course we will change this when Jose give us the design.)
struct SortingInteractionCard: View {

    @State private var viewModel: SortingCardViewModel

    // Animation only: where each row is and which blocks already reached the function panel.
    @State private var rowFrames: [UUID: CGRect] = [:]
    @State private var landed: Set<UUID> = []

    init(exercise: SortingExercise, language: ProgrammingLenguages = .swift, onRate: @escaping (ExerciseDifficulty) -> Void = { _ in }) {
        _viewModel = State(initialValue: SortingCardViewModel(exercise: exercise, language: language, onRate: onRate))
    }

    var body: some View {
        ZStack {
            List {
                Section {
                    Text(viewModel.exercise.title).font(.headline)
                    Text(viewModel.exercise.description).foregroundStyle(.secondary)

                    LanguagePicker(languages: viewModel.exercise.languages, selection: $viewModel.language)
                        .disabled(!viewModel.canEdit)
                }

                Section("Examples") {
                    ForEach(viewModel.exercise.examples, id: \.self) { example in
                        Text(example).font(.system(.footnote, design: .monospaced))
                    }
                }

                // The setup and the ending are fixed, only the loop body can be moved
                Section {
                    ForEach(viewModel.blocks) { part in
                        codeLine(part.code)
                            // while the copy is flying, the original stays hidden in its row
                            .opacity(isOverlayVisible ? 0 : 1)
                            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                                rowFrames[part.id] = $0
                            }
                    }
                    .onMove(perform: viewModel.move)
                    .moveDisabled(viewModel.isSolved)
                } header: {
                    fixedCode(viewModel.solution.setup, caption: "Loop body — drag to reorder")
                } footer: {
                    fixedCode(viewModel.solution.ending)
                }

                Section {
                    Button(action: submit) {
                        Text(buttonTitle).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(viewModel.isSolved ? .green : .accentColor)
                    .disabled(!viewModel.canEdit)
                    .listRowBackground(Color.clear)

                    if viewModel.showRetryHint {
                        Text("Not quite. Check which line has to come first and try again.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }

            if isOverlayVisible {
                SortingSubmissionOverlay(viewModel: viewModel, landed: landed, rowFrames: rowFrames)
                    .transition(.opacity)
            }
        }

        //This would add like vibrations when the user makes a mistake or losses. Jus thought it could be cool to add that.
        .sensoryFeedback(.success, trigger: viewModel.phase == .result(isCorrect: true))
        .sensoryFeedback(.error, trigger: viewModel.phase == .result(isCorrect: false))
    }

    private var isOverlayVisible: Bool {
        switch viewModel.phase {
        case .editing, .solved: false
        case .assembling, .result, .feedback: true
        }
    }

    private func codeLine(_ code: String) -> some View {
        SortingCodeLine(code, language: viewModel.solution.language)
    }

    /// Code the user can't move, shown above and below the loop body.
    private func fixedCode(_ code: String, caption: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            codeLine(code)
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
        viewModel.isSolved ? "Solved ✓" : "Check answer"
    }

    // MARK: Animation of the submission

    private func submit() {
        landed = []
        guard let isCorrect = withAnimation(.easeOut(duration: 0.25), { viewModel.submit() }) else { return }

        Task {
            // let the panel appear and measure its slots before the blocks start flying
            await pause(0.35)

            // the blocks float one by one, in the order the user picked
            for part in viewModel.blocks {
                withAnimation(.spring(duration: 0.5, bounce: 0.2)) { _ = landed.insert(part.id) }
                await pause(0.25)
            }
            await pause(0.4)

            withAnimation { viewModel.revealResult() }
            await pause(1.0)

            if isCorrect {
                withAnimation(.spring(duration: 0.4)) { viewModel.finishSubmission() }
            } else {
                // blocks go back to their rows, keeping the order the user had
                withAnimation(.spring(duration: 0.5, bounce: 0.1)) { landed = [] }
                await pause(0.5)
                withAnimation(.easeOut(duration: 0.25)) { viewModel.finishSubmission() }
            }
        }
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
