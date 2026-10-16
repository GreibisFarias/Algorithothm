//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI

// The NavigationStack comes from AlgosHomeView, nesting another one here breaks the navigation.
struct HomeButtons: View {
    // Temporary place to pick the language until there is an onboarding or settings screen.
    @AppStorage(ProgrammingLenguages.storageKey) private var language: ProgrammingLenguages = .swift

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
                    MultipleChoiceDeck()
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
    NavigationStack {
        HomeButtons()
    }
    .environmentObject(ValidationOfArch())
}
