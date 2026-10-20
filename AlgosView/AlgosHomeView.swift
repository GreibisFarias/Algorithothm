//
//  AlgosHomeView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 28/9/26.
//

import SwiftUI
import SwiftData

struct AlgosHomeView: View {
    @StateObject var validator = ValidationOfArch()
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            NavigationStack{

                HomeButtons()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SettingsMenuButton { isMenuOpen = true }
                        }
                    }
            }
            .environmentObject(validator)

            // over the NavigationStack, so it also covers the navigation bar
            SettingsMenu(isPresented: $isMenuOpen)
        }
        // the home is light, its dark status bar text would be lost on the menu
        .statusBarHidden(isMenuOpen)
    }
}
#Preview {
    AlgosHomeView()
    
}
