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
        ZStack{
            
            NavigationStack{
                
                HomeButtons(modelContext: modelContext)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background{
                        RetroBackground()
                            .ignoresSafeArea()
                    }
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading) {
                            SettingsMenuButton { isMenuOpen = true }
                        }
                    }
            }
            
            // the home is light, its dark status bar text would be lost on the menu
            SettingsMenu(isPresented: $isMenuOpen)
        }
        .statusBarHidden(isMenuOpen)
    }
    
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    return AlgosHomeView(modelContext: container.mainContext)
        .modelContainer(container)
}
