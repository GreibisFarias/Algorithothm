//
//  LanguageCarousel.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  "Indica el lenguaje que vas a estudiar": the orbs of the languages side by side, the one in
//  the middle is the selected one. Swipe or tap an orb to change it. Used by the onboarding
//  and by "Lenguaje" in the menu.
//

import SwiftUI

struct LanguageCarousel: View {
    @Binding var selection: ProgrammingLenguages

    /// The order of the design: Java · Swift · Python.
    private let languages: [ProgrammingLenguages] = [.java, .swift, .python]
    private let itemWidth: CGFloat = 230

    @State private var scrolledID: ProgrammingLenguages?

    var body: some View {
        VStack(spacing: 28) {
            HStack(alignment: .center, spacing: 12) {
                RetroImage("RetroMascot.png")
                    .scaledToFit()
                    .frame(width: 72, height: 80)
                    .accessibilityHidden(true)
                Text("Indica el lenguaje\nque vas a estudiar")
                    .font(RetroFont.pixel(24, relativeTo: .title2))
                    .lineSpacing(4)
                    .shadow(color: Retro.panelStroke, radius: 0, x: 2, y: 2)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)

            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(languages) { language in
                            item(language)
                                .frame(width: itemWidth)
                                .id(language)
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.72)
                                        .opacity(phase.isIdentity ? 1 : 0.55)
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrolledID, anchor: .center)
                // the selected orb sits in the middle, the other ones peek from the sides
                .safeAreaPadding(.horizontal, max(0, (proxy.size.width - itemWidth) / 2))
            }
            .frame(height: 300)
        }
        .onAppear { scrolledID = selection }
        .onChange(of: scrolledID) { _, language in
            if let language { selection = language }
        }
        // the selection can also change from outside (the saved one, once it loads)
        .onChange(of: selection) { _, language in
            if scrolledID != language { scrolledID = language }
        }
        .sensoryFeedback(.selection, trigger: selection)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lenguaje")
        .accessibilityValue(selection.rawValue)
        .accessibilityAdjustableAction { direction in
            guard let index = languages.firstIndex(of: selection) else { return }
            let next = direction == .increment ? index + 1 : index - 1
            guard languages.indices.contains(next) else { return }
            withAnimation { scrolledID = languages[next] }
        }
    }

    private func item(_ language: ProgrammingLenguages) -> some View {
        VStack(spacing: 18) {
            LanguageOrb(language: language)
                .frame(width: 210, height: 210)
                .shadow(color: .black.opacity(0.5), radius: 18, y: 10)
            Text(language.rawValue.uppercased())
                .font(RetroFont.pixel(40, relativeTo: .largeTitle))
                .tracking(2)
                .foregroundStyle(language == selection ? Retro.text : Retro.mutedText)
                .shadow(color: Retro.panelStroke, radius: 0, x: 3, y: 3)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(duration: 0.4)) { scrolledID = language }
        }
    }
}

#Preview {
    @Previewable @State var language: ProgrammingLenguages = .swift
    ZStack {
        RetroBackground()
        LanguageCarousel(selection: $language)
    }
    .foregroundStyle(Retro.text)
}
