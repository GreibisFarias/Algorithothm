//
//  DragAndHoldTecnicvIEW.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI
import Combine



struct DragAndHoldTecnicView: View {
    var vm = GetDataArchMock()
    var claseDrag = ArrowDrawning()
    @EnvironmentObject var validator: ValidationOfArch
    
    
    @State var moduleWhereArrowIs: UUID? = nil
    @State var whereYouLetTheArrow: CGPoint? = nil
    
    var body: some View {
        
        if let modules = validator.MockData.activeArchitecture {
            ZStack {
                // A. CANVAS DE DIBUJO DE FLECHAS
                Canvas { context, size in
                    for node in modules {
                        var targetPoint: CGPoint? = nil
                        
                        // Si se está arrastrando la flecha en tiempo real
                        if moduleWhereArrowIs == node.id, let dragPoint = whereYouLetTheArrow {
                            targetPoint = dragPoint
                        }
                        // Si ya tiene una conexión validada guardada
                        else if let connectedWith = node.moduleMustBeConnected,
                                let targetNode = modules.first(where: { $0.id == connectedWith }) {
                            targetPoint = targetNode.position
                        }
                        
                        // Dibuja la flecha si hay un punto final válido
                        if let endPoint = targetPoint {
                            claseDrag.drawArrow(from: node.position, to: endPoint, in: context)
                        }
                    } 
                }
                
                // B. NODOS / MÓDULOS EN PANTALLA
                ForEach(modules) { node in
                    ZStack {
                        Image(systemName: "cloud.fill")
                            .resizable()
                            .frame(width: node.size.width, height: node.size.height)
                        
                        Text(node.name)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .position(node.position)
                    .gesture(
                        DragGesture(coordinateSpace: .named("Lienzo")) // Coordenadas locales precisas
                            .onChanged { value in
                                self.moduleWhereArrowIs = node.id
                                self.whereYouLetTheArrow = value.location
                            }
                            .onEnded { value in
                                // 2. Llama a la validación al soltar la flecha
                                validator.validateAndConnect(from: node.id, at: value.location)
                                
                                // Limpia los estados temporales de arrastre
                                self.moduleWhereArrowIs = nil
                                self.whereYouLetTheArrow = nil
                            }
                    )
                }
            }
            .coordinateSpace(name: "Lienzo")
            .alert("Well done ", isPresented: $validator.showCongratsAlert) {
                NavigationStack{
                    NavigationLink{
                        FeedBackView()
                    }label: {
                        Text("Feddback")
                    }
                }
            }
            .coordinateSpace(name: "Lienzo") // Mismo espacio que el DragGesture
            .alert("Respuesta Incorrecta", isPresented: $validator.showErrorAlert) {
                Button("Reintentar", role: .cancel) { }
            } message: {
                Text(validator.errorMessage ?? "")
            }
        } else {
            Text("Cargando módulos...")
                .onAppear {
                    validator.MockData.getExercises()
                }
        }
    }
}

#Preview {
    
    DragAndHoldTecnicView()
        .environmentObject(ValidationOfArch())
}
