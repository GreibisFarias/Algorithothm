//
//  MultipleChoiceDeck.swift
//  Algorithothm
//
//  The "Tipo 1 · Predice" deck.
//

import SwiftUI

struct MultipleChoiceDeck: View {
    var body: some View {
        RetroDeck(exercises: MultipleChoiceExercise.all, theme: .predice) { exercise, deck in
            MultipleChoiceCard(
                exercise: exercise,
                language: deck.language,
                progress: deck.progress,
                onRate: deck.onRate,
                onClose: deck.onClose
            )
        }
    }
}

#Preview {
    NavigationStack {
        MultipleChoiceDeck()
    }
}
