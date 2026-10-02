//
//  AlgoViewModel.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import Combine
import SwiftUI

class GetDataArchMock: ObservableObject{
    @Published var archmmv: [architectureModules]? = nil
    let dataSource = ArchDataSource()
    
    init () {
        getExercises()
    }
    
    func getExercises() {
        self.archmmv = dataSource.mvvm
    }
}

class ValidationOfArch: ObservableObject{
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert = false
    @Published var MockData = GetDataArchMock()
    
   public func validateAndConnect(from sourceID: UUID, at touchLocation: CGPoint) {
       guard var modules = MockData.archmmv else { return }
        guard let sourceIndex = MockData.archmmv?.firstIndex(where: { $0.id == sourceID }) else { return }
        let sourceNode = MockData.archmmv?[sourceIndex]
        
        // 1. Buscar en qué cuadrado soltaste el dedo
        let touchedNode = MockData.archmmv?.first(where: { element in
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
            
            // CORRECCIÓN CRÍTICA: Desempaquetado correcto del opcional Bool
            let isValidConnection = sourceNode?.targetId?.contains(targetNode.id ?? UUID()) ?? false
                        
                        if isValidConnection {
                            // ¡CORRECTO! Guarda la conexión en la lista
                            modules[sourceIndex].moduleMustBeConnected = targetNode.id
                        } else {
                            // ¡INCORRECTO! Resetea y muestra error
                            modules[sourceIndex].moduleMustBeConnected = nil
                            self.errorMessage = "That's not the correct answer!"
                            self.showErrorAlert = true
                        }
        } else {
            // Si soltó en el espacio vacío, simplemente resetea la conexión
            modules[sourceIndex].moduleMustBeConnected = nil
        }
       
       MockData.archmmv = modules
    }
}
