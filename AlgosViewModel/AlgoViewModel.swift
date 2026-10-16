//
//  AlgoViewModel.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftFSRS



class ArchitectureStudyViewModel: ObservableObject{
//    @Published var cardsStrategy = FSRSStrategy()
    @Published var currentIndex: Int = 0
    @Published var flashcards: [flashcard] = allTheCard().allaTheCards
    @Published var architechtureCards: [flashcard] = []
    @Published var isFinished: Bool = false
    
    private var scheduler = SchedulerType.longTerm.implementation
    private var algorithm = FSRSAlgorithm.v5

        // 2. Filtramos las tarjetas que tocan HOY basadas en el due real
    init() {
            loadTodayArchitectureCards()
        }
        
        /// Carga única de las tarjetas de arquitectura que tocan hoy
        func loadTodayArchitectureCards() {
            let now = Date()
            architechtureCards = flashcards.filter { card in
                let isArch = caseMatchArchitecture(card.cardType)
                let isDue = card.card.due <= now
                return isArch && isDue
            }
        }
        
        private func caseMatchArchitecture(_ type: TypeOfCard) -> Bool {
            switch type {
                case .ArchitechtureCard: return true
            default: return false
            }
        }
    
    var currentCard: flashcard? {
        guard architechtureCards.indices.contains(currentIndex) else { return nil }
        return architechtureCards[currentIndex]
    }
    
    var activeArchitectureModules: [architectureModules] {
        
        get{
            guard let card = currentCard else { return [] }
            
            if case .ArchitechtureCard(let validationModules) = card.cardType {
                return validationModules
            }
            return []
        }
        
        set{
            if let card = currentCard,
               let globalIndex = flashcards.firstIndex(where: { $0.prompt == card.prompt} ){
                flashcards[globalIndex].cardType = .ArchitechtureCard(newValue)
            }
        }
    }
    
    func completeCurrentCard(rating: Rating) {
            guard let card = currentCard else { return }
            let now = Date()
            
            // Ejecutamos el algoritmo de la librería 4rays/swift-fsrs
            let reviewResult = scheduler.schedule(
                card: card.card,
                algorithm: algorithm,
                reviewRating: rating,
                reviewTime: now
            )
            
            print("📅 Fecha anterior due: \(card.card.due)")
            print("🚀 Nueva fecha calculada por FSRS (due): \(reviewResult.postReviewCard.due)")
          
        if let globalIndex = flashcards.firstIndex(where: { $0.prompt == card.prompt }) {
                    flashcards[globalIndex].card = reviewResult.postReviewCard
                }
        
        if currentIndex + 1 < architechtureCards.count {
            print("array es \(architechtureCards.count)")
                currentIndex += 1
                print("indice es  \(currentIndex)")
                
            } else {
                isFinished = true
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

