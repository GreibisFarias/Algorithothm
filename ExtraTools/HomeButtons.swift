//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI

// The NavigationStack comes from AlgosHomeView, nesting another one here breaks the navigation.
struct HomeButtons: View {
    var body: some View {
        VStack{
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
                Rectangle()
                    .frame(width: 170, height: 190)
                    .cornerRadius(20)
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
