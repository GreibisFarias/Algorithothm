//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI
import SwiftData

// The NavigationStack comes from AlgosHomeView, nesting another one here breaks the navigation.
struct HomeButtons: View {
    @AppStorage(ProgrammingLenguages.storageKey) private var language: ProgrammingLenguages = .swift
    @StateObject var vmStudy: ArchitectureStudyViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext){
        _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))
        
    }

    var body: some View {
        VStack{
            Picker("Language", selection: $language) {
                ForEach(ProgrammingLenguages.allCases) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 348)
            .padding(.bottom, 8)

            HStack() {
                NavigationLink{
                   ArchitectureDeck()
                }label: {
                    deckButton("Architecture")
                }
                NavigationLink{
                    SortingDeck()
                }label: {
                    deckButton("Sorting")
                }
            }
            HStack{
                NavigationLink{
                    MultipleChoiceDeck(modelContext: modelContext)
                }label: {
                    deckButton("Predict")
                }
                Rectangle()
                    .frame(width: 170, height: 190)
                    .cornerRadius(20)
            }
        }
    }

    private func deckButton(_ title: String) -> some View {
        Rectangle()
            .frame(width: 170, height: 190)
            .cornerRadius(20)
            .overlay {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
        
        // 2. Inyectar el mainContext del contenedor
        return NavigationStack {
            HomeButtons(modelContext: container.mainContext)
        }
        .modelContainer(container) // Inyecta el contenedor en la jerarquía
        .environmentObject(ValidationOfArch())
}
