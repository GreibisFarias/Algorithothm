//
//  FSRSStrategy.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import SwiftFSRS


var allTheCardsData = allTheCard()

class FSRSStrategy{
    var flashcards = allTheCardsData.allaTheCards
    var currentIndex: Int = 0
    
    var scheduler = SchedulerType.longTerm.implementation
    var algorithm = FSRSAlgorithm.v5
    
    var currentCard: flashcard?  {
        guard currentIndex < flashcards.count else {return nil}
        return flashcards[currentIndex]
    }

    
    func reviewCurrentCard(rating: Rating) {
        guard let funCurrentCard = currentCard else { return }
        let now = Date()
        
        
        let reviewResult = scheduler.schedule(
            card: funCurrentCard.card,
            algorithm: algorithm,
            reviewRating: rating,
            reviewTime: now
        )
        
        flashcards[currentIndex].card = reviewResult.postReviewCard

    }
    
    var todayCards: [flashcard]{
        let now = Date()
        return flashcards.filter {
            card in card.card.due == now
        }
    }
    
}
