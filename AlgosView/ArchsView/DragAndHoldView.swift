//
//  DragAndHoldView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI
import SwiftFSRS
import SwiftData

struct DragAndHoldView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var vmStudy: ArchitectureStudyViewModel
    
    // Inicializador explícito para pasar el modelContext al ViewModel
    init(modelContext: ModelContext) {
        _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))
    }

    var body: some View {
        ZStack {
            
            VStack {
        
                Text(vmStudy.currentCard?.prompt ?? "Sin tarjeta activa")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let due = vmStudy.currentCard?.due {
                    Text("Due: \(due.formatted(date: .numeric, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(60)
                
                Button("Reset") {
                    vmStudy.resetSwiftData()
                }
            }
            
            
            // Inyectamos el modelContext a la vista hija
            DragAndHoldTecnicView(modelContext: modelContext)
                .padding()
        }
        .padding()
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 15)
    }
}

// MARK: - PREVIEW
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    return NavigationStack {
        DragAndHoldView(modelContext: container.mainContext)
            .environmentObject(ValidationOfArch())
            .modelContainer(container)
    }
}
