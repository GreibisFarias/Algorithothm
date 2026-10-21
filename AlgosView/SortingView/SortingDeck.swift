//
//  SortingDeck.swift
//  Algorithothm
//
//  The "Tipo 2 · Aprende y arma" deck.
//

import SwiftUI

struct SortingDeck: View {
    @StateObject var vmStudy: ArchitectureStudyViewModel
    var body: some View {
        RetroDeck(exercises: SortingExercise.all, theme: .aprendeYArma) { exercise, deck in
            SortingInteractionCard(
                exercise: exercise,
                language: deck.language,
                progress: deck.progress,
                onRate: deck.onRate,
                onClose: deck.onClose, vmStudy: vmStudy
            )
        }
    }
}
//
//#Preview {
//    NavigationStack {
//        SortingDeck(vmStudy: <#ArchitectureStudyViewModel#>)
//    }
//}
