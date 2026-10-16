//
//  SortingDeck.swift
//  Algorithothm
//
//  The "Tipo 2 · Aprende y arma" deck.
//

import SwiftUI

struct SortingDeck: View {
    var body: some View {
        RetroDeck(exercises: SortingExercise.all, theme: .aprendeYArma) { exercise, deck in
            SortingInteractionCard(
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
        SortingDeck()
    }
}
