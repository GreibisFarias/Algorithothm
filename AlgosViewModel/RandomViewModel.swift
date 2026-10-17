//
//  RandomViewModel.swift
//  Algorithothm
//
//  Created by Greibis Farias on 16/10/26.
//

import SwiftUI
import SwiftData
import SwiftFSRS
import Combine

@MainActor
class RandomStudyViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    @Published var currentIndex: Int = 0
    @Published var isFinished: Bool = false
    
    private var scheduler = SchedulerType.longTerm.implementation
    private var algorithm = FSRSAlgorithm.v5
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Obtiene TODAS las tarjetas de HOY (de cualquier tipo) mezcladas al azar
    var todayRandomCards: [FlashcardItem] {
        let now = Date()
        let descriptor = FetchDescriptor<FlashcardItem>(
            predicate: #Predicate { card in
                card.due <= now // Vencen hoy o están pendientes
            }
        )
        
        do {
            let cards = try modelContext.fetch(descriptor)
            return cards.shuffled() // Mezclado aleatorio para la vista Random
        } catch {
            print("❌ Error al obtener tarjetas aleatorias: \(error)")
            return []
        }
    }
    
    var currentCard: FlashcardItem? {
        let cards = todayRandomCards
        guard cards.indices.contains(currentIndex) else { return nil }
        return cards[currentIndex]
    }
    
    func completeCurrentCard(rating: Rating) {
        guard let cardItem = currentCard else { return }
        let now = Date()
        
        // 1. Procesa con FSRS
        let reviewResult = scheduler.schedule(
            card: cardItem.fsrsCard,
            algorithm: algorithm,
            reviewRating: rating,
            reviewTime: now
        )
        
        // 2. Guarda el nuevo 'due' en la base de datos persistente
        cardItem.fsrsCard = reviewResult.postReviewCard
        try? modelContext.save() // SwiftData persiste los cambios globalmente
        
        // 3. Evalúa el avance en la sesión
        if currentIndex >= todayRandomCards.count {
            if todayRandomCards.isEmpty {
                isFinished = true
            } else {
                currentIndex = 0
            }
        }
    }
}
