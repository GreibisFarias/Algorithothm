//
//  OnboardingView.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  First launch: three welcome illustrations, the user's name and the language to study.
//  Swipe or use the button to move between steps. At the end the choices are saved and
//  the app goes on to the home screen.
//

import SwiftUI

struct OnboardingView: View {
    /// Height of the dots and the button at the bottom, so the pages keep their content above them.
    static let controlsHeight: CGFloat = 110

    @AppStorage(UserSettings.nameKey) private var savedName = ""
    @AppStorage(ProgrammingLenguages.storageKey) private var savedLanguage: ProgrammingLenguages = .swift
    @AppStorage(UserSettings.hasCompletedOnboardingKey) private var hasCompletedOnboarding = false

    @State private var viewModel = OnboardingViewModel()
    /// Which way the pages slide, so going back slides the other way.
    @State private var isGoingForward = true

    var body: some View {
        ZStack {
            page
                .id(viewModel.step)
                .transition(.asymmetric(
                    insertion: .move(edge: isGoingForward ? .trailing : .leading),
                    removal: .move(edge: isGoingForward ? .leading : .trailing)
                ))

            controls
        }
        .background(Retro.background)
        .foregroundStyle(Retro.text)
        .preferredColorScheme(.dark)
        .simultaneousGesture(swipe, isEnabled: viewModel.step != .language)
    }

    // MARK: Pages

    @ViewBuilder
    private var page: some View {
        switch viewModel.step {
        case .welcome:
            OnboardingIllustrationPage(
                image: "Onboarding1-Bienvenida.jpg",
                text: "¡Hola! Bienvenido a Proyecto Compu UCV"
            )
        case .logic:
            OnboardingIllustrationPage(
                image: "Onboarding2-Logica.jpg",
                text: "Esta es una aplicación para aprender lógica de programación"
            )
        case .architecture:
            OnboardingIllustrationPage(
                image: "Onboarding3-Arquitectura.jpg",
                text: "y arquitectura de software y hardware"
            )
        case .name:
            ZStack {
                RetroBackground()
                OnboardingNamePage(name: $viewModel.name, onSubmit: next)
            }
        case .language:
            ZStack {
                RetroBackground()
                LanguageCarousel(selection: $viewModel.language)
                    .padding(.top, 60)
                    .padding(.bottom, Self.controlsHeight)
            }
        }
    }

    // MARK: Controls

    private var controls: some View {
        VStack {
            HStack {
                if viewModel.canGoBack {
                    RetroIconButton(pixels: PixelIcon.backArrow, accessibilityLabel: "Atrás", action: back)
                        .transition(.opacity)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            VStack(spacing: 20) {
                pageDots

                Button(viewModel.isLastStep ? "Empezar" : "Siguiente", action: next)
                    .buttonStyle(RetroButtonStyle.phosphor)
                    .disabled(!viewModel.canAdvance)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }

    /// One pixel square per step, the current one longer and green.
    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingViewModel.Step.allCases, id: \.self) { step in
                Rectangle()
                    .fill(step == viewModel.step ? Retro.phosphor : Retro.ghostStroke)
                    .frame(width: step == viewModel.step ? 24 : 8, height: 8)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.step)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Paso \(viewModel.step.rawValue + 1) de \(OnboardingViewModel.Step.allCases.count)")
    }

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                if value.translation.width < -60 {
                    next()
                } else if value.translation.width > 60 {
                    back()
                }
            }
    }

    // MARK: Actions

    private func next() {
        guard viewModel.canAdvance else { return }
        if viewModel.isLastStep {
            finish()
            return
        }
        isGoingForward = true
        withAnimation(.easeInOut(duration: 0.35)) { viewModel.next() }
    }

    private func back() {
        guard viewModel.canGoBack else { return }
        isGoingForward = false
        withAnimation(.easeInOut(duration: 0.35)) { viewModel.back() }
    }

    private func finish() {
        savedName = viewModel.trimmedName
        savedLanguage = viewModel.language
        withAnimation(.easeInOut(duration: 0.4)) { hasCompletedOnboarding = true }
    }
}

/// One of the welcome illustrations of the design, the text is part of the image.
struct OnboardingIllustrationPage: View {
    let image: String
    /// What the illustration says, for VoiceOver.
    let text: String

    var body: some View {
        Color.clear
            .overlay {
                RetroImage(image)
                    .scaledToFill()
            }
            .overlay(alignment: .bottom) {
                // keeps the button readable over the image
                LinearGradient(colors: [.clear, Retro.background.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 220)
            }
            .clipped()
            .ignoresSafeArea()
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(text)
            .accessibilityAddTraits(.isImage)
    }
}

#Preview {
    OnboardingView()
}
