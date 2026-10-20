//
//  OnboardingNamePage.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  "¿Cómo te llamas?": the name the app uses to greet the user. It can be changed later
//  from "Editar nombre" in the menu.
//

import SwiftUI

struct OnboardingNamePage: View {
    @Binding var name: String
    /// Called with the return key, to go on without tapping the button.
    var onSubmit: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Retro.phosphor
                    .frame(width: 110, height: 80)
                    .opacity(0.18)
                    .blur(radius: 24)
                RetroImage("RetroMascot.png")
                    .scaledToFit()
                    .frame(width: 112, height: 120)
                    .accessibilityHidden(true)
            }

            Text("¿Cómo te llamas?")
                .font(RetroFont.pixel(34, relativeTo: .largeTitle))
                .tracking(1)
                .shadow(color: Retro.panelStroke, radius: 0, x: 3, y: 3)
                .accessibilityAddTraits(.isHeader)

            Text("Así te saludará la compu cada vez que vuelvas.")
                .font(RetroFont.pixel(17))
                .foregroundStyle(Retro.mutedText)
                .multilineTextAlignment(.center)

            RetroTextField(placeholder: "Tu nombre", text: $name, onSubmit: onSubmit)
                .focused($isFocused)
                .padding(.top, 8)
        }
        .padding(.horizontal, 24)
        // leaves room for the back button above and the button below, also with the keyboard up
        .padding(.top, 60)
        .padding(.bottom, OnboardingView.controlsHeight)
        .onAppear { isFocused = true }
    }
}

/// Text field on the green screen, with a blinking cursor feel: phosphor text on the monitor screen.
struct RetroTextField: View {
    let placeholder: String
    @Binding var text: String
    var onSubmit: () -> Void = {}

    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder).foregroundStyle(Retro.phosphorDim)
        )
        .font(RetroFont.terminal(26))
        .foregroundStyle(Retro.phosphor)
        .tint(Retro.phosphor)
        .textInputAutocapitalization(.words)
        .autocorrectionDisabled()
        .submitLabel(.next)
        .onSubmit(onSubmit)
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Retro.screen)
        .padding(8)
        .pixelPanel(Retro.bezel, ledge: Retro.bezelShadow)
        .accessibilityLabel(placeholder)
    }
}

#Preview {
    @Previewable @State var name = ""
    ZStack {
        RetroBackground()
        OnboardingNamePage(name: $name)
    }
    .foregroundStyle(Retro.text)
}
