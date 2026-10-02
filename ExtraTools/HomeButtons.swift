//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI

struct HomeButtons: View {
    var body: some View {
 
        HStack(spacing: 15) {
            Rectangle()
                .frame(width: 170, height: 190)
                .cornerRadius(20)
        }
    }
}

#Preview {
    HomeButtons()
}
