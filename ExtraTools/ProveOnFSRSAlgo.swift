//
//  ProveOnFSRSAlgo.swift
//  Algorithothm
//
//  Created by Greibis Farias on 8/10/26.
//

import Foundation
import SwiftFSRS
import SwiftUI
import Combine

// MARK: - 1. Modelos de Datos

/// Enum con los lenguajes de programación para los snippets de código[cite: 1]
enum ProgrammingLanguage: String, Codable, CaseIterable, Identifiable {
    case python = "Python"
    case javascript = "JavaScript"
    case cpp = "C++"
    case swift = "Swift"
    
    var id: String { self.rawValue }
}

/// Modelo de Flashcard adaptado para 4rays/swift-fsrs[cite: 1]
struct FlashcardModel: Identifiable {
    let id: String
    let titleKey: String
    let codeSnippets: [ProgrammingLanguage: String]
    let explanationKey: String
    
    // Objeto 'Card' provisto por 4rays/swift-fsrs
    var fsrsCard: Card = Card()
}

// MARK: - 2. Datos de Prueba (MockData)[cite: 1]

struct MockData {
    static var sampleCards: [FlashcardModel] = [
        FlashcardModel(
            id: "reverse_array",
            titleKey: "Invertir un Arreglo",
            codeSnippets: [
                .python: "def reverse_array(arr):\n    return arr[::-1]",
                .swift: "func reverseArray<T>(_ arr: [T]) -> [T] {\n    return arr.reversed()\n}",
                .javascript: "function reverseArray(arr) {\n  return arr.reverse();\n}",
                .cpp: "void reverseArray(vector<int>& arr) {\n  std::reverse(arr.begin(), arr.end());\n}"
            ],
            explanationKey: "Este algoritmo invierte los elementos de un arreglo en orden inverso."
        ),
        FlashcardModel(
            id: "two_pointers",
            titleKey: "Técnica de Dos Punteros",
            codeSnippets: [
                .python: "left, right = 0, len(arr) - 1",
                .swift: "var left = 0\nvar right = arr.count - 1",
                .javascript: "let left = 0, right = arr.length - 1;",
                .cpp: "int left = 0, right = arr.size() - 1;"
            ],
            explanationKey: "Utiliza dos índices para recorrer una estructura desde extremos opuestos."
        )
    ]
}

// MARK: - 3. ViewModel (Lógica de Negocio con 4rays/swift-fsrs)[cite: 1]

class FlashcardViewModel: ObservableObject {
    @Published var cards: [FlashcardModel] = MockData.sampleCards
    @Published var currentIndex: Int = 0
    @Published var selectedLanguage: ProgrammingLanguage = .swift
    @Published var showAnswer: Bool = false
    @Published var isFinished: Bool = false
    
    var currentCard: FlashcardModel? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    
    var scheduler = SchedulerType.longTerm.implementation
    var algoritm = FSRSAlgorithm.v5
    
    /// Procesa el repaso llamando directamente al método estático/enum de 4rays/swift-fsrs
    func reviewCurrentCard(rating: Rating) {
        guard let card = currentCard else { return }
        
        let now = Date()
        
        // Llamada nativa exacta de 4rays/swift-fsrs:
        let reviewResult = scheduler.schedule (
            card: card.fsrsCard,
            algorithm: algoritm,
            reviewRating: rating,
            reviewTime: now
            )
        
        // Guardamos la tarjeta con su nuevo estado y su nueva fecha 'due'
        cards[currentIndex].fsrsCard = reviewResult.postReviewCard
        
        print("--- TARJETA REVISADA (4rays/swift-fsrs) ---")
        print("Título: \(card.titleKey)")
        print("Próximo repaso (due): \(reviewResult.postReviewCard.due.formatted())")
        print("------------------------------------------")
        
        nextCard()
    }
    
    private func nextCard() {
        showAnswer = false
        if currentIndex + 1 < cards.count {
            currentIndex += 1
        } else {
            isFinished = true
        }
    }
    
    func restartDeck() {
        currentIndex = 0
        isFinished = false
        showAnswer = false
    }
}
// MARK: - 4. Vista en SwiftUI (Interfaz de Usuario)[cite: 1]

struct FSRSTRY: View {
    @StateObject private var viewModel = FlashcardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isFinished {
                    // Pantalla al terminar el mazo
                    VStack(spacing: 16) {
                        Text("🎉 ¡Mazo Completado!")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Todas las tarjetas han sido programadas.")
                            .foregroundColor(.secondary)
                        
                        Button("Volver a Empezar") {
                            viewModel.restartDeck()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if let card = viewModel.currentCard {
                    
                    // Selector de Lenguaje[cite: 1]
                    Picker("Lenguaje", selection: $viewModel.selectedLanguage) {
                        ForEach(ProgrammingLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Contenido de la Tarjeta[cite: 1]
                    VStack(alignment: .leading, spacing: 16) {
                        Text(card.titleKey)
                            .font(.title2)
                            .bold()
                        
                        if let snippet = card.codeSnippets[viewModel.selectedLanguage] {
                            Text(snippet)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                        }
                        
                        if viewModel.showAnswer {
                            Divider()
                            Text(card.explanationKey)
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Text("Próxima fecha agendada: \(card.fsrsCard.due.formatted())")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity( 0.3)))
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Botones de Acción
                    if !viewModel.showAnswer {
                        Button("Mostrar Respuesta") {
                            withAnimation {
                                viewModel.showAnswer = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    } else {
                        // Botones con las calificaciones de ReviewRating (.again, .hard, .good, .easy)
                        VStack(spacing: 8) {
                            Text("¿Qué tan fácil fue?")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 8) {
                                Button("Otra vez") {
                                    viewModel.reviewCurrentCard(rating: .again)
                                }
                                .tint(.red)
                                
                                Button("Difícil") {
                                    viewModel.reviewCurrentCard(rating: .hard)
                                }
                                .tint(.orange)
                                
                                Button("Bueno") {
                                    viewModel.reviewCurrentCard(rating: .good)
                                }
                                .tint(.blue)
                                
                                Button("Fácil") {
                                    viewModel.reviewCurrentCard(rating: .easy)
                                }
                                .tint(.green)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .padding(.vertical)
            .navigationTitle("4rays FSRS Demo")
        }
    }
}

#Preview {
    FSRSTRY()
}
