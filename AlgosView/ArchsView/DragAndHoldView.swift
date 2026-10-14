//
//  DragAndHoldView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI


struct DragAndHoldView: View {
    var ola = ArchitectureStudyViewModel()
    var body: some View {
        
        ZStack{
           
            VStack{
                Text(ola.currentCard?.prompt ?? "ño")
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(60)
              
            }
           
            DragAndHoldTecnicView()
                .padding()
            
        }
        .padding()
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)  //
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 15)
    }    
}

#Preview {
    NavigationStack{
        DragAndHoldView()
            .environmentObject(ValidationOfArch())
    }
}
