//
//  UserSettings.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  Keys of what the user chose, saved with @AppStorage. The programming language has its own
//  key next to its enum (ProgrammingLenguages.storageKey).
//

import Foundation

enum UserSettings {
    /// The name the user gave in the onboarding or in "Editar nombre".
    static let nameKey = "userName"
    /// Set once the onboarding is finished, so it is only shown the first time.
    static let hasCompletedOnboardingKey = "hasCompletedOnboarding"

    /// Name shown when the user didn't give one.
    static let defaultName = "Estudiante"
}
