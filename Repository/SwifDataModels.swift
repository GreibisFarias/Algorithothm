//
//  SwifDataModels.swift
//  Algorithothm
//
//  Created by Greibis Farias on 16/10/26.
//

import SwiftData
import Foundation
import SwiftFSRS

@Model
public class FlashcardItem {
    @Attribute(.unique) public var id: String
    public var prompt: String
    public var difficultyRaw: String // "Easy", "Medium", "Hard"
    
    // Banderas/Atributos según tu TypeOfCard
    public var cardTypeRaw: String   // "Architecture", "Sorting", etc.
    public var isArchitecture: Bool
    
    // Almacenamiento local de los módulos de arquitectura para la UI interactiva
    public var sortingExrciseID: String?
    public var activeModulesData: Data?
    public var multipleChoiceExerciseId: String?
    
    // Propiedades nativas requeridas por el algoritmo FSRS para SQLite
    public var due: Date
    public var stability: Double
    public var difficulty: Double
    public var elapsedDays: Double
    public var scheduledDays: Double
    public var reps: Int
    public var lapses: Int
    public var statusRate: String
    public var lastReview: Date?
    
    // Propiedad computada puente con la librería SwiftFSRS
    public var fsrsCard: Card {
        get {
            Card(
                due: due,
                stability: stability,
                difficulty: difficulty,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
                lapses: lapses,
                status: Status(rawValue: statusRate) ?? .new,
                lastReview: lastReview
            )
        }
        set {
            due = newValue.due
            stability = newValue.stability
            difficulty = newValue.difficulty
            elapsedDays = newValue.elapsedDays
            scheduledDays = newValue.scheduledDays
            reps = newValue.reps
            lapses = newValue.lapses
            statusRate = newValue.status.rawValue
            lastReview = newValue.lastReview
        }
    }
    
    // Propiedad computada para leer/escribir fácilmente los módulos interactivos de la vista
    var activeModules: [architectureModules] {
        get {
            guard let activeModulesData,
                  let decoded = try? JSONDecoder().decode([architectureModules].self, from: activeModulesData) else {
                return []
            }
            return decoded
        }
        set {
            activeModulesData = try? JSONEncoder().encode(newValue)
        }
    }
    
    // Inicializador conveniente que toma tu struct `flashcard` original
    init(from originalCard: flashcard, id: String = UUID().uuidString) {
        self.id = id
        self.prompt = originalCard.prompt
        self.difficultyRaw = String(describing: originalCard.difficulty)
        
        // Extraemos y guardamos los módulos si la tarjeta es de Arquitectura
        switch originalCard.cardType {
            
        case .ArchitechtureCard(let modules):
            self.isArchitecture = true
            self.cardTypeRaw = "Architecture"
            self.activeModulesData = try? JSONEncoder().encode(modules)
            
        case .SortindCard(let sortingExercise):
            self.isArchitecture = false
            self.cardTypeRaw = "Sorting"
            self.activeModulesData = nil
            self.sortingExrciseID = sortingExercise.id
            
        case .MultipleAnswerCard(let multipleChoiceExercise):
            self.isArchitecture = false
            self.multipleChoiceExerciseId = multipleChoiceExercise.id
            self.cardTypeRaw = "MultipleCard"
            self.activeModulesData = nil
        }
        
        // Mapeamos los datos de la Card FSRS inicial
        self.due = originalCard.card.due
        self.stability = originalCard.card.stability
        self.difficulty = originalCard.card.difficulty
        self.elapsedDays = originalCard.card.elapsedDays
        self.scheduledDays = originalCard.card.scheduledDays
        self.reps = originalCard.card.reps
        self.lapses = originalCard.card.lapses
        self.statusRate = originalCard.card.status.rawValue
        self.lastReview = originalCard.card.lastReview
    }
}

extension FlashcardItem{
    var sortingExercise: SortingExercise? {
        guard cardTypeRaw == "Sorting", let exerciseID = sortingExrciseID else { return nil }
        return SortingExercise.all.first { $0.id == exerciseID }
    }
    
    var multipleChoiceExercise: MultipleChoiceExercise? {
        guard cardTypeRaw == "MultipleCard", let exerciseID = multipleChoiceExerciseId else {return nil}
        return MultipleChoiceExercise.all.first { $0.id == exerciseID }
    }
}
