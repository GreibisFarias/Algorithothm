//
//  DragAndHoldTecnicvIEW.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI
import Combine
import SwiftFSRS


//MARK: GENERAL DRAG AND HOLD VIEW
struct DragAndHoldTecnicView: View {
    var vm = GetDataArchMock()
    @StateObject var vmStudy = ArchitectureStudyViewModel()
    @EnvironmentObject var validator: ValidationOfArch
    
    @State var moduleWhereArrowIs: UUID? = nil
    @State var whereYouLetTheArrow: CGPoint? = nil
    
    var body: some View {
        Group {
            if vmStudy.isFinished {
                Text("🎉 ¡Terminaste las arquitecturas de hoy!")
                    .font(.largeTitle)
                    .bold()
            } else if !vmStudy.architechtureCards.isEmpty {
                
                LoadedExerciseView(vmStudy: vmStudy, moduleWhereArrowIs: $moduleWhereArrowIs, whereYouLetTheArrow: $whereYouLetTheArrow)
            }else {
                Text("Cargando módulos...")
            }
            
            
        }
        
    }
}


//MARK: TECNIQUE VIEW
//This is the view that is visible only when the user hasnt finished and it is not loading.
struct LoadedExerciseView: View {
    
    @ObservedObject var vmStudy: ArchitectureStudyViewModel
    @Binding var moduleWhereArrowIs: UUID?
    @Binding var whereYouLetTheArrow: CGPoint?
    @EnvironmentObject var validator: ValidationOfArch

    var body: some View {
        
        ZStack {
            // A. CANVAS DE DIBUJO DE FLECHAS
            let modules = vmStudy.activeArchitectureModules
            
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
                            drawArrow(from: node.position, to: targetNode.position, in: context)
                        }
                    }
                    
                    // Dibuja la flecha si hay un punto final válido
                    if let endPoint = targetPoint {
                        drawArrow(from: node.position, to: endPoint, in: context)
                    }
                }
            }
            
            // B. NODOS / MÓDULOS EN PANTALLA
            ForEach(modules) { node in
                CloudCell(node: node)
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
    }
}


//MARK: Clouds that represnets every element of the view
struct CloudCell: View {
    
    let node: architectureModules
    var body: some View {
        ZStack {
            Image(systemName: "cloud.fill")
                .resizable()
                .frame(width: node.size.width, height: node.size.height)
            
            Text(node.name)
                .foregroundColor(.white)
                .bold()
        }
    }
}


//MARK: Function that draws the arrows
extension LoadedExerciseView {
        
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
#Preview {
    DragAndHoldTecnicView()
        .environmentObject(ValidationOfArch())
}
