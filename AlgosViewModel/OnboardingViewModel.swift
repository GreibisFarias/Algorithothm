//
//  OnboardingViewModel.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  The steps of the onboarding: three welcome illustrations, the user's name and the
//  language they will study. The view decides how each step looks and animates.
//

import Foundation
import Observation

@Observable
final class OnboardingViewModel {

    enum Step: Int, CaseIterable {
        case welcome        // "¡Hola! Bienvenido a Proyecto Compu UCV"
        case logic          // "Esta es una aplicación para aprender lógica de programación"
        case architecture   // "y arquitectura de software y hardware"
        case name           // "¿Cómo te llamas?"
        case language       // "Indica el lenguaje que vas a estudiar"
    }

    private(set) var step: Step = .welcome
    var name = ""
    var language: ProgrammingLenguages

    init(language: ProgrammingLenguages = .swift) {
        self.language = language
    }

    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The name step can't be skipped without a name.
    var canAdvance: Bool {
        step != .name || !trimmedName.isEmpty
    }

    var canGoBack: Bool { step != .welcome }
    var isLastStep: Bool { step == Step.allCases.last }

    // MARK: Intents

    func next() {
        guard canAdvance, !isLastStep, let next = Step(rawValue: step.rawValue + 1) else { return }
        step = next
    }

    func back() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        step = previous
    }
}
