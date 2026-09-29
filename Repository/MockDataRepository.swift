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
    case ArchitechtureCard
    case BlocksCard
    case MultipleAnsweCard
}

struct flashcard {
    var Dificulty: Dificulties
    var CardType: TypeOfCard
    var prompt: String
}


//MARK: MOCK BY LENGUAGE

enum codingLenguag{
    case swift
    case java
}
