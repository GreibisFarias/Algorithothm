//
//  FeedBackView.swift
//  Algorithothm
//
//  Created by Greibis Farias on 2/10/26.
//

import SwiftUI
import SwiftData
import SwiftFSRS

struct FeedBackView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var studyVM: ArchitectureStudyViewModel // 👈 @ObservedObject para reactividad

    var body: some View {
        ZStack{
            RetroBackground()
            VStack(spacing: 12) {
                
                RetroDifficultyButton2(
                    difficulty: .easy,
                    action:  {studyVM.completeCurrentCard(rating: .easy)})
                
                RetroDifficultyButton2(
                    difficulty: .hard,
                    action:  {studyVM.completeCurrentCard(rating: .hard)})

                
                RetroDifficultyButton2(
                    difficulty: .medium,
                    action: {studyVM.completeCurrentCard(rating: .good)} )
              
                
                RetroDifficultyButton2(
                    difficulty: .again,
                    action: {studyVM.completeCurrentCard(rating: .again)} )
                
                
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - PREVIEW CORREGIDA
#Preview {
    // 1. Contenedor temporal en memoria para la vista previa
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    // 2. Instanciamos el ViewModel con el contexto de la preview
    let vm = ArchitectureStudyViewModel(modelContext: container.mainContext)
    
    return FeedBackView(studyVM: vm)
        .modelContainer(container)
}

private struct RetroDifficultyButton2: View {
    let difficulty: ExerciseDifficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                bars
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.resultTitle)
                        .font(RetroFont.pixel(20))
                    Text(difficulty.resultSubtitle)
                        .font(RetroFont.pixel(14))
                        .foregroundStyle(Retro.mutedText)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, minHeight: 68, alignment: .leading)
            .background(Retro.panel)
            .overlay { Rectangle().strokeBorder(difficulty.resultColor, lineWidth: 3) }
            .contentShape(Rectangle())
        }
        .buttonStyle(PressableStyle())
    }
    
    private var bars: some View {
        let lit = difficulty.resultBars
        return PixelArt(pixels: [
            PixelArt.Pixel(0, 4, 2, 3, lit >= 1 ? difficulty.resultColor : Retro.ghostStroke),
            PixelArt.Pixel(2.5, 2, 2, 5, lit >= 2 ? difficulty.resultColor : Retro.ghostStroke),
            PixelArt.Pixel(5, 0, 2, 7, lit >= 3 ? difficulty.resultColor : Retro.ghostStroke)
        ], grid: 7)
    }

}

private struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(y: configuration.isPressed ? 2 : 0)
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

private extension ExerciseDifficulty {
    /// The order of the design: hardest first.
    static let hardestFirst: [ExerciseDifficulty] = [.hard, .medium, .easy]

    var resultTitle: String {
        switch self {
        case .hard: "Fue difícil"
        case .medium: "Estuvo bien"
        case .easy: "¡Muy fácil!"
        case .again: "Demasiado complejo"
        }
    }

    var resultSubtitle: String {
        switch self {
        case .hard: "La repasarás pronto"
        case .medium: "Vuelve en unos días"
        case .easy: "Vuelve más adelante"
        case .again: "Volvera en pocas horas"
        }
    }

    var resultColor: Color {
        switch self {
        case .hard: Retro.accent
        case .medium: Retro.phosphor
        case .easy: Retro.gold
        case .again: Retro.bezel
            
        }
    }

    var resultBars: Int {
        switch self {
        case .hard: 1
        case .medium: 2
        case .easy: 3
        case .again: 0
        }
    }
}


