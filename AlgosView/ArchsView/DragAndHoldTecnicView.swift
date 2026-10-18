//
//  DragAndHoldTecnicvIEW.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI
import Combine
import SwiftFSRS
import SwiftData

struct DragAndHoldTecnicView: View {
    var claseDrag = ArrowDrawning()
    @StateObject private var vmStudy: ArchitectureStudyViewModel
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var validator: ValidationOfArch

    init(modelContext: ModelContext){
      _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))

    }

    @State var moduleWhereArrowIs: UUID? = nil
    @State var whereYouLetTheArrow: CGPoint? = nil
    
    var body: some View {
        Group {
            if vmStudy.isFinished {
                Text("🎉 ¡Terminaste las arquitecturas de hoy!")
                    .font(.largeTitle)
                    .bold()
            } else if !vmStudy.todayArchitectureCards.isEmpty {
                // Obtenemos los módulos mutables de la tarjeta actual
                let modules = vmStudy.activeArchitectureModules
                
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
                            
                            for targetId in node.moduleMustBeConnected{
                                if let targetNode = modules.first(where: { $0.id == targetId }) {
                                    claseDrag.drawArrow(from: node.position, to: targetNode.position, in: context)
                                }
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
                                    var currentModules = vmStudy.activeArchitectureModules
                                    validator.validateAndConnect(validationModules: &currentModules, from: node.id, at: value.location)
                                    
                                    // Limpia los estados temporales de arrastre
                                    self.moduleWhereArrowIs = nil
                                    self.whereYouLetTheArrow = nil
                                }
                        )
                    }
                }
                .coordinateSpace(name: "Lienzo")
                .alert("Well done ", isPresented: $validator.showCongratsAlert) {
                    Button("next") {
                        vmStudy.completeCurrentCard(rating: .good)
                    }
//                    NavigationStack{
//                        NavigationLink{
//                            FeedBackView()
//                        }label: {
//                            Text("Feddback")
//                        }
//                    }
                }
                .coordinateSpace(name: "Lienzo") // Mismo espacio que el DragGesture
                .alert("Respuesta Incorrecta", isPresented: $validator.showErrorAlert) {
                    Button("Reintentar", role: .cancel) { }
                } message: {
                    Text(validator.errorMessage ?? "")
                }
            }else {
                Text("Cargando módulos...")
            }
            
            
        }
        
    }
}

#Preview {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
        
        // 2. Inyectar el context del contenedor de pruebas
        return DragAndHoldTecnicView(modelContext: container.mainContext)
            .environmentObject(ValidationOfArch())
            .modelContainer(container)
}

