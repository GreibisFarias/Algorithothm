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
    
    
    enum SubmissionState {
        case idle
        case correct
        case incorrect
    }
 
    
    let exercise: SortingExercise
    @State private var blocks: [CodePart]
    @State private var state: SubmissionState = .idle
 
    init(exercise: SortingExercise) {
        self.exercise = exercise
        _blocks = State(initialValue: exercise.shuffledParts())
    }
 
    var body: some View {
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
 
            //I had this idea of showing the user how the function would look as they change the parts, but it is up to you and the designer (Jose) to determine that.
            // Live preview of the function as currently arranged
            
            Section("Your function") {
                Text(blocks.map(\.code).joined(separator: "\n"))
                    .font(.system(.callout, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(previewBackground, in: RoundedRectangle(cornerRadius: 8))
                    .animation(.default, value: blocks)
            }
 
            //parts that we can move
            Section("Blocks — drag to reorder") {
                ForEach(blocks) { part in
                    Text(part.code)
                        .font(.system(.callout, design: .monospaced))
                        .lineLimit(nil)
                }
                .onMove { from, to in
                    blocks.move(fromOffsets: from, toOffset: to)
                    state = .idle   // any change clears the previous result
                }
            }
 
            Section {
                Button(action: submit) {
                    Text(buttonTitle).frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(state == .correct ? .green : .accentColor)
                .listRowBackground(Color.clear)
 
                if state == .incorrect {
                    Text("Not quite. Check which line has to come first and try again.")
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }
        }
        
        //This would add like vibrations when the user makes a mistake or losses. Jus thought it could be cool to add that.
        .sensoryFeedback(.success, trigger: state == .correct)
        .sensoryFeedback(.error, trigger: state == .incorrect)
    }
 
    private var buttonTitle: String {
        state == .correct ? "Solved ✓" : "Check answer"
    }
 
    private var previewBackground: Color {
        switch state {
        case .idle: Color(.indigo).opacity(0.20)
        case .correct: .green.opacity(0.15)
        case .incorrect: .red.opacity(0.15)
        }
    }
 
    private func submit() {
        state = SortingExercise.isSolved(blocks) ? .correct : .incorrect
    }
}
 
#Preview {
    SortingInteractionCard(exercise: .sortDescending)
}
