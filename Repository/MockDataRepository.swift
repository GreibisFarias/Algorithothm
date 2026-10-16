//
//  MockDataRepository.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import Foundation
import SwiftFSRS


//MARK: Variables 
var archs = ArchDataSource()

//MARK: MODELS

enum codingLanguage {
    case swift
    case java
}

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


// MARK: DataSource

class ArchDataSource {
    
    var viewModule: architectureModules = architectureModules(
        position: CGPoint(x: 100, y: 180),
        name: "View",
        size: CGSize(width: 150, height: 100)
    )
    var viewModelModule: architectureModules  = architectureModules(
        position: CGPoint(x: 250, y: 380),
        name: "ViewModel",
        size: CGSize(width: 150, height: 100)
    )
    var modelModule: architectureModules  = architectureModules(
        position: CGPoint(x: 100, y: 580),
        name: "Model",
        size: CGSize(width: 150, height: 100)
    )
    
    lazy var mvvm: [architectureModules] = [viewModule, viewModelModule, modelModule]
    lazy var viper: [architectureModules] = [viperViewModule, viperEntityModule, viperRouterModule, viperPresenterModule, viperInteractorModule]
    
    init() {
        createRelations()
        createViperRelations()
    }
    
    func createRelations() {
        // 3. Reglas de validación: View -> ViewModel -> Model
        self.viewModule.targetId = [self.viewModelModule.id]
        self.viewModelModule.targetId = [self.modelModule.id]
    }
    
    // VIPER
    var viperViewModule = architectureModules(
        position: CGPoint(x: 100, y: 100),
        name: "View",
        size: CGSize(width: 150, height: 100)
    )
    var viperPresenterModule = architectureModules(
        position: CGPoint(x: 300, y: 100),
        name: "Presenter",
        size: CGSize(width: 150, height: 100)
    )
    var viperInteractorModule = architectureModules(
        position: CGPoint(x: 300, y: 300),
        name: "Interactor",
        size: CGSize(width: 150, height: 100)
    )
    var viperEntityModule = architectureModules(
        position: CGPoint(x: 300, y: 500),
        name: "Entity",
        size: CGSize(width: 150, height: 100)
    )
    var viperRouterModule = architectureModules(
        position: CGPoint(x: 100, y: 300),
        name: "Router",
        size: CGSize(width: 150, height: 100)
    )

    func createViperRelations() {
        // La View notifica eventos al Presenter
        self.viperViewModule.targetId = [self.viperPresenterModule.id]
        
        // El Presenter coordina con Interactor y Router
        self.viperPresenterModule.targetId = [self.viperInteractorModule.id, self.viperRouterModule.id]
        
        // El Interactor accede/manipula la Entity (modelo de negocio)
        self.viperInteractorModule.targetId = [self.viperEntityModule.id]
    }
}



class allTheCard{
        var mvvmArchsCard = flashcard(difficulty: .Easy, cardType: .ArchitechtureCard(archs.mvvm), prompt: "Hola")
        var viperArchsCard = flashcard(difficulty: .Medium, cardType: .ArchitechtureCard(archs.viper), prompt: "Adios")
        var sortFirst = flashcard(difficulty: .Easy, cardType: .SortindCard(.climbingStairs), prompt: "jaja")
    
    lazy var allaTheCards: [flashcard] = [mvvmArchsCard, viperArchsCard, sortFirst]
}


