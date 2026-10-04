//
//  AlgoViewModel.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import Combine
import SwiftUI

struct GetDataArchMock{
     var archs: [[architectureModules]] = []
     var currentCart: Int = 0
    
    
    let dataSource = ArchDataSource()
    
    init () {
        getExercises()
    }
    
    mutating func getExercises() {
        self.archs = [dataSource.mvvm, dataSource.viper]
    }
    
    var activeArchitecture: [architectureModules]? {
            get {
                guard archs.indices.contains(currentCart) else { return nil }
                return archs[currentCart]
            }
            set {
                if let newValue = newValue, archs.indices.contains(currentCart) {
                    archs[currentCart] = newValue
                }
            }
        }
}

class ValidationOfArch: ObservableObject{
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert = false
    @Published var Congrats: String? = nil
    @Published var showCongratsAlert = false
    @Published var MockData = GetDataArchMock()
    
    
   public func validateAndConnect(from sourceID: UUID, at touchLocation: CGPoint) {
       guard var modules = MockData.activeArchitecture else { return }
        guard let sourceIndex = modules.firstIndex(where: { $0.id == sourceID }) else { return }
        let sourceNode = modules[sourceIndex]
        
        // 1. Buscar en qué cuadrado soltaste el dedo
        let touchedNode = modules.first(where: { element in
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
                            modules[sourceIndex].moduleMustBeConnected = targetNode.id
                            self.Congrats = "Well Done Dude"
                            self.showCongratsAlert = true
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
       
       MockData.activeArchitecture = modules
    }
    
    func nextCard(){
        if MockData.currentCart < MockData.archs.count{
            MockData.currentCart += 1
        }
    }
}

