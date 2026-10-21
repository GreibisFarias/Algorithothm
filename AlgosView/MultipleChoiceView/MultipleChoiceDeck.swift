//
//  MultipleChoiceDeck.swift
//  Algorithothm
//
//  The "Tipo 1 · Predice" deck.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData
import SwiftFSRS

struct MultipleChoiceDeck: View {
    @StateObject private var vmStudy: ArchitectureStudyViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showFeedbackSheet = false
    
    init(modelContext: ModelContext) {
        _vmStudy = StateObject(
            wrappedValue: ArchitectureStudyViewModel(
                modelContext: modelContext,
                initialFilter: .multipleChoice
            )
        )
    }
    
    var body: some View {
        Group {
            if vmStudy.isFinished || vmStudy.activeCards.isEmpty {
                ContentUnavailableView(
                    "¡Todo al día!",
                    systemImage: "checkmark.seal.fill",
                    description: Text("No tienes ejercicios de opción múltiple pendientes por hoy.")
                )
            } else {
                RetroDeck(
                    exercises: vmStudy.activeCards.compactMap { $0.multipleChoiceExercise },
                    theme: .predice
                ) { exercise, deck in
                    MultipleChoiceCard(
                        exercise: exercise,
                        language: deck.language,
                        progress: deck.progress,
                        onRate: { difficulty in
                            deck.onRate(difficulty)
                            
                            showFeedbackSheet = true
                        },
                        onClose: {
                            deck.onClose()
                            dismiss()
                        }
                    )
                    .sheet(isPresented: $showFeedbackSheet) {
                        FeedBackView(studyVM: vmStudy)
                    }
                }
            }
        }
    }
}

// MARK: - Preview Corregido

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    return NavigationStack {
        MultipleChoiceDeck(modelContext: container.mainContext)
    }
    .modelContainer(container)
}
