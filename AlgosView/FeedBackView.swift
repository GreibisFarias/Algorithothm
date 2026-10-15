//
//  FeedBackView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI
import SwiftFSRS

struct FeedBackView: View {
    var studyVM =  ArchitectureStudyViewModel()
    var body: some View {
        VStack{
            Button("Facil"){
                studyVM.completeCurrentCard(rating: .easy)
            }
            .tint(.green)
            
            Button("Normal"){
                studyVM.completeCurrentCard(rating: .good)
            }
            .tint(.black)
            Button("Dificil"){
                studyVM.completeCurrentCard(rating: .hard)
            }
            .tint(.red)
            
            Button("Otra vez"){
                studyVM.completeCurrentCard(rating: .again)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    FeedBackView()
}
