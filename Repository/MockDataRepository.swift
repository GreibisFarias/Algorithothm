//
//  MockDataRepository.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import Foundation

enum Dificulties{
    case Easy
    case Medium
    case Hard
}

enum TypeOfCard{
    case ArchitectureCard
    case BlocksCard
    case MultipleAnswerCard
}

struct flashcard {
    var difficulty: Dificulties
    var cardType: TypeOfCard
    var prompt: String
}


//MARK: MOCK BY LANGUAGE

enum codingLanguage {
    case swift
    case java
}



