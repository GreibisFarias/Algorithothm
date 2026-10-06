//
//  ExerciseComponents.swift
//  Algorithothm
//
//  Pieces shared by every exercise card.
//

import SwiftUI

// This is where the FSRS rating will come from.
enum ExerciseDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

/// "Good job" card where the user rates how hard the exercise was.
struct DifficultyRatingView: View {
    var onRate: (ExerciseDifficulty) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Good job! 🎉")
                .font(.title2.bold())
            Text("How hard was this exercise?")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(ExerciseDifficulty.allCases, id: \.self) { difficulty in
                    Button(difficulty.rawValue) { onRate(difficulty) }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(24)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}

/// Segmented picker with the languages an exercise is written in. Hidden if there is only one.
struct LanguagePicker: View {
    let languages: [ProgrammingLenguages]
    @Binding var selection: ProgrammingLenguages

    var body: some View {
        if languages.count > 1 {
            Picker("Language", selection: $selection) {
                ForEach(languages) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
