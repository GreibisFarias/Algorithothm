//
//  AlgosHomeView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import SwiftUI
import SwiftData

struct AlgosHomeView: View {
    @StateObject var validator = ValidationOfArch()
    @State private var isMenuOpen = false
    @Environment(\.modelContext) private var modelContext
    @StateObject var vmStudy: ArchitectureStudyViewModel
    
    init(modelContext: ModelContext){
      _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))

    }
    var body: some View {
        
        NavigationStack{
            
            HomeButtons(modelContext: modelContext)
                

        }
        // the home is light, its dark status bar text would be lost on the menu
        .statusBarHidden(isMenuOpen)
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
        
        return AlgosHomeView(modelContext: container.mainContext)
            .modelContainer(container)
}
