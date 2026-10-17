//
//  AlgoViewModel.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftData
import SwiftFSRS


@MainActor
class ArchitectureStudyViewModel: ObservableObject {
    //    @Published var cardsStrategy = FSRSStrategy()
    @Published var currentIndex: Int = 0
    @Published var flashcards: [flashcard] = allTheCard().allaTheCards
    @Published var architechtureCards: [flashcard] = []
    @Published var isFinished: Bool = false
    private var modelContext: ModelContext
    
    private var scheduler = SchedulerType.longTerm.implementation
    private var algorithm = FSRSAlgorithm.v5
    
    // 2. Filtramos las tarjetas que tocan HOY basadas en el due real
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        seedInitialDataIfNeeded()
    }
    
    private func seedInitialDataIfNeeded() {
            let descriptor = FetchDescriptor<FlashcardItem>()
            let count = (try? modelContext.fetchCount(descriptor)) ?? 0
            
            if count == 0 {
                let dataSource = allTheCard()
                for card in dataSource.allaTheCards {
                    let newItem = FlashcardItem(from: card)
                    modelContext.insert(newItem)
                }
                try? modelContext.save()
                print("📦 Mazo inicial guardado exitosamente en SwiftData")
            }
        }
    
    /// Carga única de las tarjetas de arquitectura que tocan hoy
    var todayArchitectureCards: [FlashcardItem] {
        let now = Date()
        let descriptor = FetchDescriptor<FlashcardItem>(
            predicate: #Predicate { $0.isArchitecture && $0.due <= now },
            sortBy: [SortDescriptor(\.due)]
        )
    
    
    do {
        return try modelContext.fetch(descriptor)
    } catch {
        print("❌ Error al obtener las tarjetas de arquitectura: \(error)")
        return []
    }
}
    
    
    
    /// Tarjeta actual dentro de la sesión de arquitectura
    var currentCard: FlashcardItem? {
        let cards = todayArchitectureCards
        guard cards.indices.contains(currentIndex) else { return nil }
        return cards[currentIndex]
    }
    
    var activeArchitectureModules: [architectureModules] {
        get {
            guard let card = currentCard else { return [] }
            // Deserializas/recuperas los módulos según tu estructura en FlashcardItem
            return card.activeModules
        }
        set {
            if let card = currentCard {
                card.activeModules = newValue
                try? modelContext.save() // Guarda la nueva conexión en SwiftData inmediatamente
            }
        }
    }
    
    /// Procesa la calificación con FSRS y persiste en SwiftData
    func completeCurrentCard(rating: Rating) {
        guard let cardItem = currentCard else { return }
        let now = Date()
        
        // 1. Ejecutar el cálculo FSRS
        let reviewResult = scheduler.schedule(
            card: cardItem.fsrsCard,
            algorithm: algorithm,
            reviewRating: rating,
            reviewTime: now
        )
        
        // 2. Persistir el resultado guardando en el ModelContext
        cardItem.fsrsCard = reviewResult.postReviewCard
        try? modelContext.save()
        
        // 3. Evaluar el avance de la sesión
        // Como la tarjeta procesada ya no cumplirá 'due <= now', 'todayArchitectureCards.count' disminuye automáticamente
        if currentIndex >= todayArchitectureCards.count {
            if todayArchitectureCards.isEmpty {
                isFinished = true
            } else {
                currentIndex = 0
            }
        }
    }
    
}
    
    
    //func nextCard(){
    //        if MockData.currentCart < MockData.archs.count{
    //            MockData.currentCart += 1
    //        }
    //    }
    
    
    //struct GetDataArchMock{
    //    var archs: [[architectureModules]] = []
    //    var currentCart: Int = 0
    //
    //
    //    let dataSource = ArchDataSource()
    //
    //    init () {
    //        getExercises()
    //    }
    //
    //    mutating func getExercises() {
    //        self.archs = [dataSource.mvvm, dataSource.viper]
    //    }
    //
    //    var activeArchitecture: [architectureModules]? {
    //        get {
    //            guard archs.indices.contains(currentCart) else { return nil }
    //            return archs[currentCart]
    //        }
    //        set {
    //            if let newValue = newValue, archs.indices.contains(currentCart) {
    //                archs[currentCart] = newValue
    //            }
    //        }
    //    }
    //
    //}
    
    //var allTheCardsLocal = allTheCard()
    //var arrayOfCards = allTheCardsLocal.allaTheCards
    //
    //
    //var architechtureCards: [flashcard] = arrayOfCards.filter {
    //    card in switch card.cardType {
    //    case .ArchitechtureCard:
    //        return true
    //
    //    default:
    //        return false
    //    }
    //
    //}
    
