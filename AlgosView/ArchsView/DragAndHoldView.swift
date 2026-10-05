//
//  DragAndHoldView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//

import SwiftUI


struct DragAndHoldView: View {
    let DatToday: flashRapid = mockData.HELLOBEO
    @State private var selectedOption: ProgrammingLenguages = .swift
    private var currentCod: String{
        DatToday.codeByLenguage[selectedOption] ?? "Sin codigo"
    }
    var body: some View {
        
        ZStack{
            
//            Text("")
//                .frame(width: 390, height: 780)
//                .background(.green)
//                .cornerRadius(40)
//            
            VStack{

                
               
            }
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(60)
            
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
