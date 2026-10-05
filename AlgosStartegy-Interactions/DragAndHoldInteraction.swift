//
//  DragAndHoldInteraction.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import SwiftUI

struct architectureModules: Identifiable{
    var moduleMustBeConnected: Set<UUID> = []
    var id: UUID = UUID()
    var targetId: [UUID]? = nil
    var position: CGPoint
    var name: String
    var size: CGSize
    
}


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

class ArrowDrawning{
    
    func drawArrow(from start: CGPoint, to end: CGPoint, in context: GraphicsContext) {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        context.stroke(path, with: .color(.black), lineWidth: 3)
        
        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowLength: CGFloat = 15
        let arrowAngle: CGFloat = .pi / 6
        
        var arrowHead = Path()
        arrowHead.move(to: end)
        arrowHead.addLine(to: CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        ))
        arrowHead.move(to: end)
        arrowHead.addLine(to: CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        ))
        context.stroke(arrowHead, with: .color(.blue), lineWidth: 3)
    }
    
}

enum TypeExercise{
    case arch(architectureModules)
}





