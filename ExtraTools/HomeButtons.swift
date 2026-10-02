//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI

struct HomeButtons: View {
    var body: some View {
        NavigationStack{
            VStack{
                HStack() {
                    NavigationLink{
                       DragAndHoldView()
                    }label: {
                        Rectangle()
                            .frame(width: 170, height: 190)
                            .cornerRadius(20)
                    }
                    Rectangle()
                        .frame(width: 170, height: 190)
                        .cornerRadius(20)
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
    }
}

#Preview {
    HomeButtons()
}
