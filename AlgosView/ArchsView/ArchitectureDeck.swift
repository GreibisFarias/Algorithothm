//
//  ArchitectureDeck.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI

struct ArchitectureDeck: View {
    @StateObject var validition2 = ValidationOfArch()
    var body: some View {
        NavigationStack{
            VStack{
                DragAndHoldView()
                
                Button("next", action: validition2.nextCard)
            }
            
            .environmentObject(validition2)
        }
    }
}

#Preview {
    ArchitectureDeck()
}
