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
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vmStudy: ArchitectureStudyViewModel

    /// TODO: conéctalos a la posición de la tarjeta dentro de la sesión.
    var cardIndex = 1
    var cardTotal = 3

    init(modelContext: ModelContext) {
        _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                StudyHeader(label: "TIPO 3 · ARQUITECTURA",
                            accent: Pixel.sky,
                            current: cardIndex, total: cardTotal,
                            onBack: { dismiss() })

                PixelMonitor {
                    TerminalPrompt(text: vmStudy.currentCard?.prompt ?? "Sin tarjeta activa")
                }

                // Un solo ViewModel compartido con el tablero
                DragAndHoldTecnicView(vmStudy: vmStudy)

                #if DEBUG
                Button("Reset") { vmStudy.resetSwiftData() }
                    .font(Pixel.font(12))
                    .foregroundStyle(Pixel.statusText)
                    .frame(maxWidth: .infinity)
                #endif
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)   // en pantallas grandes no rebota
        .background { PixelBackground(opacity: 0.14) }
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Previews

#Preview("Pantalla") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    return NavigationStack {
        DragAndHoldView(modelContext: container.mainContext)
    }
    .environmentObject(ValidationOfArch())
    .modelContainer(container)
}

#Preview("Piezas") {
    VStack(spacing: 24) {
        ArchNodeView(name: "View", size: CGSize(width: 120, height: 48), state: .connected, showsTopPort: false)
        ArchNodeView(name: "Controller", size: CGSize(width: 120, height: 48), state: .idle)
        ArchNodeView(name: "Repositorio", size: CGSize(width: 120, height: 48), state: .active)
    }
    .padding(40)
    .background(Pixel.board)
}
