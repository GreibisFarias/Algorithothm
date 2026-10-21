//
//  AlgorithothmApp.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import SwiftUI
import SwiftData

@main
struct AlgorithothmApp: App {
    @Environment(\.modelContext) private var modelContext
    var sharedModelContainer: ModelContainer = {
            let schema = Schema([
                FlashcardItem.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("No se pudo crear el ModelContainer de SwiftData: \(error)")
            }
        }()

        var body: some Scene {
            WindowGroup {
                AlgosHomeView(modelContext: modelContext)
            }
            .modelContainer(sharedModelContainer) // 👈 Inyecta el contenedor a todo el árbol de vistas
        }
}
