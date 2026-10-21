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
    
    enum SessionFilter {
        case all
        case architecture
        case sorting
        case multipleChoice
    }
    
    @Published var currentIndex: Int = 0
    @Published var isFinished: Bool = false
    @Published var activeFilter: SessionFilter = .all {
        didSet {
            currentIndex = 0
            refreshActiveCards()
        }
    }
    
    @Published private(set) var activeCards: [FlashcardItem] = []
    
    private var modelContext: ModelContext
    private var scheduler = SchedulerType.longTerm.implementation
    private var algorithm = FSRSAlgorithm.v5
    
    init(modelContext: ModelContext, initialFilter: SessionFilter = .all) {
        self.modelContext = modelContext
        self.activeFilter = initialFilter
        seedInitialDataIfNeeded()
        refreshActiveCards()
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
    
    /// Carga reactiva de las tarjetas actuales según el filtro
    func refreshActiveCards() {
        let now = Date()
        let predicate: Predicate<FlashcardItem>
        
        switch activeFilter {
        case .all:
            predicate = #Predicate { $0.due <= now }
        case .architecture:
            predicate = #Predicate { $0.isArchitecture && $0.due <= now }
        case .sorting:
            predicate = #Predicate { $0.cardTypeRaw == "Sorting" && $0.due <= now }
        case .multipleChoice:
            predicate = #Predicate { $0.cardTypeRaw == "MultipleCard" && $0.due <= now }
        }
        
        let descriptor = FetchDescriptor<FlashcardItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.due)]
        )
        
        activeCards = (try? modelContext.fetch(descriptor)) ?? []
        isFinished = activeCards.isEmpty
    }
    
    /// Tarjeta actual de la sesión en curso
    var currentCard: FlashcardItem? {
        guard activeCards.indices.contains(currentIndex) else { return nil }
        return activeCards[currentIndex]
    }
    
    var activeArchitectureModules: [architectureModules] {
        get {
            guard let card = currentCard, card.isArchitecture else { return [] }
            return card.activeModules
        }
        set {
            if let card = currentCard, card.isArchitecture {
                card.activeModules = newValue
                try? modelContext.save()
            }
        }
    }
    
    /// Procesa la calificación con FSRS y refresca la lista
    func completeCurrentCard(rating: Rating) {
        guard let cardItem = currentCard else { return }
        let now = Date()
        
        let reviewResult = scheduler.schedule(
            card: cardItem.fsrsCard,
            algorithm: algorithm,
            reviewRating: rating,
            reviewTime: now
        )
        
        cardItem.fsrsCard = reviewResult.postReviewCard
        try? modelContext.save()
        
        // Recargar el mazo (la tarjeta procesada ya no cumplirá 'due <= now')
        refreshActiveCards()
        
        if currentIndex >= activeCards.count {
            currentIndex = 0
        }
    }
    
    func resetSwiftData() {
        do {
            try modelContext.delete(model: FlashcardItem.self)
            try modelContext.save()
            
            currentIndex = 0
            isFinished = false
            
            seedInitialDataIfNeeded()
            refreshActiveCards()
            
            print("🗑️ Base de datos reiniciada.")
        } catch {
            print("❌ Error al resetear SwiftData: \(error)")
        }
    }
}
