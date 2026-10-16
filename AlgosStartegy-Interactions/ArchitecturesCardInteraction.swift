//
//  DragAndHoldInteraction.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import SwiftUI
import Combine

struct architectureModules: Identifiable{
    var moduleMustBeConnected: Set<UUID> = []
    var id: UUID = UUID()
    var targetId: [UUID]? = nil
    var position: CGPoint
    var name: String
    var size: CGSize
    
}



class ValidationOfArch: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert = false
    @Published var Congrats: String? = nil
    @Published var showCongratsAlert = false
    
    public func validateAndConnect( validationModules: inout [architectureModules], from sourceID: UUID, at touchLocation: CGPoint ) {
        guard let sourceIndex = validationModules.firstIndex(where: { $0.id == sourceID }) else { return }
        let sourceNode = validationModules[sourceIndex]
        
        // 1. Buscar en qué cuadrado soltaste el dedo
        let touchedNode = validationModules.first(where: { element in
            let frame = CGRect(
                x: element.position.x - element.size.width / 2,
                y: element.position.y - element.size.height / 2,
                width: element.size.width,
                height: element.size.height
            )
            return frame.insetBy(dx: -10, dy: -10).contains(touchLocation)
        })
        
        // 2. Si soltaste el dedo dentro de algún cuadrado
        if let targetNode = touchedNode, targetNode.id != sourceID {
            
            //Desempaquetado correcto del opcional Bool
            let isValidConnection = sourceNode.targetId?.contains(targetNode.id) ?? false
            
            if isValidConnection {
                // ¡CORRECTO! Guarda la conexión en la lista
                validationModules[sourceIndex].moduleMustBeConnected.insert(targetNode.id)
                
                
                
                self.Congrats = "Well Done Dude"
                self.showCongratsAlert = true
            } else {
                // ¡INCORRECTO! Resetea y muestra error
                validationModules[sourceIndex].moduleMustBeConnected = []
                self.errorMessage = "That's not the correct answer!"
                self.showErrorAlert = true
            }
        } else {
            // Si soltó en el espacio vacío, simplemente resetea la conexión
            validationModules[sourceIndex].moduleMustBeConnected = []
        }
        
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



