//
//  SortingDeck.swift
//  Algorithothm
//
//  The sorting exercises, shown one after the other.
//

import SwiftUI

struct SortingDeck: View {
    @State private var viewModel = SortingDeckViewModel()

    var body: some View {
        Group {
            if let exercise = viewModel.currentExercise {
                SortingInteractionCard(exercise: exercise, onRate: rate)
                    // a new card for each exercise, so it starts from a fresh state
                    .id(exercise.id)
                    .transition(.push(from: .trailing))
            } else {
                ContentUnavailableView {
                    Label("Deck complete", systemImage: "checkmark.seal")
                } description: {
                    Text("You ordered every loop in this deck.")
                } actions: {
                    Button("Start again") {
                        withAnimation { viewModel.restart() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Sorting")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let progress = viewModel.progress {
                ToolbarItem(placement: .topBarTrailing) {
                    Text(progress)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func rate(_ difficulty: ExerciseDifficulty) {
        Task {
            // leave a moment to see the "Solved ✓" before moving on
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation { viewModel.rate(difficulty) }
        }
    }
}

#Preview {
    NavigationStack {
        SortingDeck()
    }
}
