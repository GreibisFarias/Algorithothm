//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI

// The NavigationStack comes from AlgosHomeView, nesting another one here breaks the navigation.
// The language is chosen in the onboarding and changed from the menu (SettingsMenu).
struct HomeButtons: View {
    var body: some View {
        VStack{
            NavigationLink{
                RandomDeck()
            }label: {
                randomButton("Mix deck")
            }
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
    
    private func randomButton(_ title: String) -> some View {
        Rectangle()
            .frame(width: 345, height: 120)
            .cornerRadius(20)
            .overlay{
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.green)
            }
    }
}

#Preview {
    NavigationStack {
        HomeButtons()
    }
    .environmentObject(ValidationOfArch())
}
