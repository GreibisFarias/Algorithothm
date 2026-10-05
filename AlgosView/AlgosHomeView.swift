//
//  AlgosHomeView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import SwiftUI

struct AlgosHomeView: View {
    @StateObject var validator = ValidationOfArch()
    
    var body: some View {
        
        NavigationStack{
            HomeButtons()
                
        }
        .environmentObject(validator)
    }
}
#Preview {
    AlgosHomeView()
    
}
