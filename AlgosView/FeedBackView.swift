//
//  FeedBackView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI
import SwiftFSRS

struct FeedBackView: View {
    var FSRSViewModel = FSRSStrategy()
    var body: some View {
        VStack{
            Button("Facil"){
                FSRSViewModel.reviewCurrentCard(rating: .easy)
            }
            .tint(.green)
            
            Button("Normal"){
                FSRSViewModel.reviewCurrentCard(rating: .good)
            }
            .tint(.black)
            Button("Dificil"){
                FSRSViewModel.reviewCurrentCard(rating: .hard)
            }
            .tint(.red)
            
            Button("Otra vez"){
                FSRSViewModel.reviewCurrentCard(rating: .again)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    FeedBackView()
}
