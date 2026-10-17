//
//  FeedBackView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI
import SwiftData
import SwiftFSRS

struct FeedBackView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var studyVM: ArchitectureStudyViewModel // 👈 @ObservedObject para reactividad

    var body: some View {
        VStack(spacing: 12) {
            Button("Fácil") {
                studyVM.completeCurrentCard(rating: .easy)
            }
            .tint(.green)
            
            Button("Normal") {
                studyVM.completeCurrentCard(rating: .good)
            }
            .tint(.blue)
            
            Button("Difícil") {
                studyVM.completeCurrentCard(rating: .hard)
            }
            .tint(.red)
            
            Button("Otra vez") {
                studyVM.completeCurrentCard(rating: .again)
            }
            .tint(.gray)
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - PREVIEW CORREGIDA
#Preview {
    // 1. Contenedor temporal en memoria para la vista previa
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    // 2. Instanciamos el ViewModel con el contexto de la preview
    let vm = ArchitectureStudyViewModel(modelContext: container.mainContext)
    
    return FeedBackView(studyVM: vm)
        .modelContainer(container)
}
