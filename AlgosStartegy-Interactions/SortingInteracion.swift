//
//  SortingInteracion.swift
//  Algorithothm
//
//  Created by Greibis Farias on 29/9/26.
//

import Foundation
import SwiftUI

//subtype
struct CodePart: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let order: Int
}
 

//Type
struct SortingExercise: Identifiable {
    let id: String
    let title: String
    let description: String
    let examples: [String]
    let parts: [CodePart]
 
    init(id: String, title: String, description: String, examples: [String], parts: [String]) {
        precondition(parts.count == 4, "Each exercise must have exactly 4 parts")
        self.id = id
        self.title = title
        self.description = description
        self.examples = examples
    
        self.parts = parts.enumerated().map { CodePart(code: $0.element, order: $0.offset) }
    }
 
    
    //Validation funcs of the type
    static func isSolved(_ parts: [CodePart]) -> Bool {
        for i in 1..<parts.count {
            let previous = parts[i - 1]
            let current = parts[i]

            if current.order != previous.order + 1 {
                return false
            }
        }
        return true
    }
 
    
    func shuffledParts() -> [CodePart] {
        var shuffled = parts
        repeat { shuffled.shuffle() } while Self.isSolved(shuffled)
        return shuffled
    }
}
 
//Mock exercise because that ones you created did not give me the building blocks I needed, but it makes sense becasue I guess that part of my responsability was to create the type too,
extension SortingExercise {
    static let sortDescending = SortingExercise(
        id: "sort-descending",
        title: "Build the function that orders numbers from bigger to smaller",
        description: "Drag the blocks into the right order so the function returns the numbers sorted from largest to smallest.",
        examples: [
            "sortDescending([3, 1, 2])     → [3, 2, 1]",
            "sortDescending([5, 9, 0, 9])  → [9, 9, 5, 0]",
            "sortDescending([])            → []"
        ],
        parts: [
            "func sortDescending(_ numbers: [Int]) -> [Int] {",
            "    var result = numbers",
            "    result.sort { $0 > $1 }",
            "    return result\n}"
        ]
    )
}
 
// MARK: - View (This view is just to check the mechanism I have created, of course we will change this when Jose give us the design.)
struct SortingInteractionCard: View {
    
    enum Phase: Equatable {
        case editing
        case assembling                 // blocks are flying into the function panel
        case result(isCorrect: Bool)    // panel turns green or red
        case feedback                   // "Good job" + difficulty rating
        case solved
    }
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
 
    
    let exercise: SortingExercise
    // Not wired to anything yet, this is where the FSRS rating will go.
    var onRate: (Difficulty) -> Void
    
    @State private var blocks: [CodePart]
    @State private var phase: Phase = .editing
    @State private var showRetryHint = false
    
    // Frames (global) of the blocks in the list and of their slots in the function panel,
    // used to make copies of the blocks float between them.
    @State private var rowFrames: [UUID: CGRect] = [:]
    @State private var slotFrames: [UUID: CGRect] = [:]
    @State private var overlayOrigin: CGPoint = .zero
    @State private var landed: Set<UUID> = []
 
    init(exercise: SortingExercise, onRate: @escaping (Difficulty) -> Void = { _ in }) {
        self.exercise = exercise
        self.onRate = onRate
        _blocks = State(initialValue: exercise.shuffledParts())
    }
 
    var body: some View {
        ZStack {
            List {
                Section {
                    Text(exercise.title).font(.headline)
                    Text(exercise.description).foregroundStyle(.secondary)
                }
     
                Section("Examples") {
                    ForEach(exercise.examples, id: \.self) { example in
                        Text(example).font(.system(.footnote, design: .monospaced))
                    }
                }
     
                //parts that we can move
                Section("Blocks — drag to reorder") {
                    ForEach(blocks) { part in
                        codeText(part)
                            .lineLimit(nil)
                            // while the copy is flying, the original stays hidden in its row
                            .opacity(isOverlayVisible ? 0 : 1)
                            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                                rowFrames[part.id] = $0
                            }
                    }
                    .onMove { from, to in
                        blocks.move(fromOffsets: from, toOffset: to)
                        showRetryHint = false   // any change clears the previous result
                    }
                    .moveDisabled(phase == .solved)
                }
     
                Section {
                    Button(action: submit) {
                        Text(buttonTitle).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(phase == .solved ? .green : .accentColor)
                    .disabled(phase != .editing)
                    .listRowBackground(Color.clear)
     
                    if showRetryHint {
                        Text("Not quite. Check which line has to come first and try again.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            
            if isOverlayVisible {
                submissionOverlay
                    .transition(.opacity)
            }
        }
        
        //This would add like vibrations when the user makes a mistake or losses. Jus thought it could be cool to add that.
        .sensoryFeedback(.success, trigger: phase == .result(isCorrect: true))
        .sensoryFeedback(.error, trigger: phase == .result(isCorrect: false))
    }
    
    // MARK: Overlay
    
    private var isOverlayVisible: Bool {
        switch phase {
        case .editing, .solved: false
        case .assembling, .result, .feedback: true
        }
    }
    
    private var submissionOverlay: some View {
        ZStack {
            // Covers the whole card, which also blocks any interaction during the animation
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            
            if phase == .feedback {
                feedbackView
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                functionPanel
                    .transition(.opacity)
                
                ForEach(blocks) { part in
                    flyingBlock(part)
                }
            }
        }
        .onGeometryChange(for: CGPoint.self) { $0.frame(in: .global).origin } action: {
            overlayOrigin = $0
        }
    }
    
    private var functionPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your function")
                .font(.headline)
            
            // Invisible slots: they give the flying blocks their final position
            VStack(alignment: .leading, spacing: 4) {
                ForEach(blocks) { part in
                    codeText(part)
                        .hidden()
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: {
                            slotFrames[part.id] = $0
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(panelBackground, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(panelBorder, lineWidth: 2)
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.3), value: phase)
    }
    
    @ViewBuilder
    private func flyingBlock(_ part: CodePart) -> some View {
        let isLanded = landed.contains(part.id)
        // A row that is scrolled off screen has no frame, so its block just fades in at its slot
        let source = rowFrames[part.id]
        if let frame = (isLanded ? slotFrames[part.id] : source) ?? slotFrames[part.id] {
            codeText(part)
                .frame(width: frame.width, height: frame.height, alignment: .leading)
                .position(x: frame.midX - overlayOrigin.x, y: frame.midY - overlayOrigin.y)
                .opacity(isLanded || source != nil ? 1 : 0)
        }
    }
    
    private var feedbackView: some View {
        VStack(spacing: 16) {
            Text("Good job! 🎉")
                .font(.title2.bold())
            Text("How hard was this exercise?")
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(difficulty.rawValue) { rate(difficulty) }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(24)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
    
    private func codeText(_ part: CodePart) -> some View {
        Text(part.code)
            .font(.system(.callout, design: .monospaced))
    }
 
    private var buttonTitle: String {
        phase == .solved ? "Solved ✓" : "Check answer"
    }
 
    private var panelBackground: Color {
        switch phase {
        case .result(isCorrect: true): Color.green.opacity(0.25)
        case .result(isCorrect: false): Color.red.opacity(0.25)
        default: Color(.secondarySystemGroupedBackground)
        }
    }
    
    private var panelBorder: Color {
        switch phase {
        case .result(isCorrect: true): .green
        case .result(isCorrect: false): .red
        default: .clear
        }
    }
    
    // MARK: Actions
 
    private func submit() {
        let isCorrect = SortingExercise.isSolved(blocks)
        showRetryHint = false
        landed = []
        withAnimation(.easeOut(duration: 0.25)) { phase = .assembling }
        
        Task {
            // let the panel appear and measure its slots before the blocks start flying
            await pause(0.35)
            
            // the blocks float one by one, in the order the user picked
            for part in blocks {
                withAnimation(.spring(duration: 0.5, bounce: 0.2)) { _ = landed.insert(part.id) }
                await pause(0.25)
            }
            await pause(0.4)
            
            withAnimation { phase = .result(isCorrect: isCorrect) }
            await pause(1.0)
            
            if isCorrect {
                withAnimation(.spring(duration: 0.4)) { phase = .feedback }
            } else {
                // blocks go back to their rows, keeping the order the user had
                withAnimation(.spring(duration: 0.5, bounce: 0.1)) { landed = [] }
                await pause(0.5)
                withAnimation(.easeOut(duration: 0.25)) {
                    phase = .editing
                    showRetryHint = true
                }
            }
        }
    }
    
    private func rate(_ difficulty: Difficulty) {
        onRate(difficulty)
        withAnimation { phase = .solved }
    }
    
    private func pause(_ seconds: Double) async {
        try? await Task.sleep(for: .seconds(seconds))
    }
}
 
#Preview {
    SortingInteractionCard(exercise: .sortDescending)
}
