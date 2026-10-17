//
//  ArchitectureDeck.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI
import SwiftData

struct ArchitectureDeck: View {
    @Environment(\.modelContext) private var modelContex
    @StateObject var validition2 = ValidationOfArch()
    var body: some View {
        NavigationStack{
            VStack{
                DragAndHoldView(modelContext: modelContex)
           
            }
            
            .environmentObject(validition2)
        }
    }
}

#Preview {
    ArchitectureDeck()
}
