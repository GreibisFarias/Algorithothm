//
//  MockDataRepository.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import Foundation
import SwiftFSRS

enum Dificulties{
    case Easy
    case Medium
    case Hard
}

enum TypeOfCard{
    case ArchitechtureCard([architectureModules])
    case SortindCard(SortingExercise)
    case MultipleAnswerCard
}

struct flashcard {
    var difficulty: Dificulties
    var cardType: TypeOfCard
    var prompt: String = ""
    
    var card: Card = Card()
}


//MARK: MOCK BY LANGUAGE

enum codingLanguage {
    case swift
    case java
}


var archs = ArchDataSource()

class allTheCard{
        var mvvmArchsCard = flashcard(difficulty: .Easy, cardType: .ArchitechtureCard(archs.mvvm), prompt: "Hola")
        var viperArchsCard = flashcard(difficulty: .Medium, cardType: .ArchitechtureCard(archs.viper), prompt: "Adios")
        var sortFirst = flashcard(difficulty: .Easy, cardType: .SortindCard(.sortDescending), prompt: "jaja")
    
    lazy var allaTheCards: [flashcard] = [mvvmArchsCard, viperArchsCard, sortFirst]
}


