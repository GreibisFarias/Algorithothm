//
//  LanguageSettingsScreen.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  "Lenguaje" of the menu: the same carousel as the onboarding, to change the language
//  the cards are shown in. Nothing changes until "Guardar".
//

import SwiftUI

struct LanguageSettingsScreen: View {
    @AppStorage(ProgrammingLenguages.storageKey) private var savedLanguage: ProgrammingLenguages = .swift
    @Environment(\.dismiss) private var dismiss

    @State private var language: ProgrammingLenguages = .swift

    var body: some View {
        ZStack {
            RetroBackground()

            VStack(spacing: 0) {
                HStack {
                    RetroIconButton(pixels: PixelIcon.close, accessibilityLabel: "Cerrar sin cambiar") { dismiss() }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()
                LanguageCarousel(selection: $language)
                Spacer()

                Button("Guardar") {
                    savedLanguage = language
                    dismiss()
                }
                .buttonStyle(RetroButtonStyle.phosphor)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .foregroundStyle(Retro.text)
        .preferredColorScheme(.dark)
        .onAppear { language = savedLanguage }
    }
}

#Preview {
    LanguageSettingsScreen()
}
