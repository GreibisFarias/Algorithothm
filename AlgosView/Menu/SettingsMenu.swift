//
//  SettingsMenu.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  Side menu of the home screen ("Ajustes"): the user's avatar and name, and the settings.
//  It slides in from the left over a dark layer; tapping the layer closes it.
//  For now only the name and the language can be changed, the rest say "Próximamente".
//

import SwiftUI

struct SettingsMenu: View {
    @Binding var isPresented: Bool

    @AppStorage(UserSettings.nameKey) private var name = ""
    @AppStorage(ProgrammingLenguages.storageKey) private var language: ProgrammingLenguages = .swift

    @State private var isEditingName = false
    @State private var draftName = ""
    @State private var isChoosingLanguage = false

    private let width: CGFloat = 300

    var body: some View {
        ZStack(alignment: .leading) {
            if isPresented {
                Retro.dim
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                    .accessibilityLabel("Cerrar menú")
                    .accessibilityAddTraits(.isButton)
                    .transition(.opacity)

                panel
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeOut(duration: 0.25), value: isPresented)
        .alert("Tu nombre", isPresented: $isEditingName) {
            TextField("Tu nombre", text: $draftName)
                .textInputAutocapitalization(.words)
            Button("Guardar") {
                let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty { name = trimmed }
            }
            Button("Cancelar", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $isChoosingLanguage) {
            LanguageSettingsScreen()
        }
    }

    // MARK: Panel

    private var panel: some View {
        VStack(alignment: .leading, spacing: 24) {
            profile

            DashedDivider()
                .frame(height: 4)

            VStack(spacing: 10) {
                SettingsMenuRow(title: "Lenguaje", value: language.rawValue, valueColor: Retro.accent, action: { isChoosingLanguage = true }) {
                    LanguageOrb(language: language)
                }
                SettingsMenuRow(title: "Idioma de la app", value: "Español", valueColor: Retro.sky, isAvailable: false, action: {}) {
                    PixelIcon(pixels: PixelIcon.language, color: Retro.sky)
                }
                SettingsMenuRow(title: "Recordatorio", value: "Hora del aviso", valueColor: Retro.gold, isAvailable: false, action: {}) {
                    PixelIcon(pixels: PixelIcon.bell, color: Retro.gold)
                }
                SettingsMenuRow(title: "Acerca de", value: "Proyecto Compu UCV", valueColor: Retro.phosphor, isAvailable: false, action: {}) {
                    PixelIcon(pixels: PixelIcon.info, color: Retro.phosphor)
                }
            }

            Spacer()

            Text("v \(appVersion)")
                .font(RetroFont.pixel(13, relativeTo: .caption))
                .foregroundStyle(Retro.disabledText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .frame(width: width, alignment: .leading)
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Retro.panel
                .ignoresSafeArea()
                // the pixel edge on the right of the panel
                .background(alignment: .trailing) {
                    Retro.panelStroke.frame(width: 4).offset(x: 4).ignoresSafeArea()
                }
                .shadow(color: .black.opacity(0.45), radius: 0, x: 10)
        }
        .foregroundStyle(Retro.text)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Ajustes")
    }

    private var profile: some View {
        HStack(spacing: 16) {
            PixelArt(pixels: PixelArt.avatar)
                .frame(width: 72, height: 72)
                .background(Retro.background)
                .pixelPanel(Retro.panelStroke)
                .accessibilityLabel("Avatar de \(displayName)")

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(RetroFont.pixel(28, relativeTo: .title))
                    .tracking(1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .shadow(color: Retro.background, radius: 0, x: 3, y: 3)

                Button("Editar nombre ▸") {
                    draftName = name
                    isEditingName = true
                }
                .font(RetroFont.pixel(14))
                .foregroundStyle(Retro.phosphor)
                .buttonStyle(.plain)
            }
        }
    }

    private var displayName: String {
        name.isEmpty ? UserSettings.defaultName : name
    }

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}

/// Dashed line of the design under the profile.
private struct DashedDivider: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                path.move(to: CGPoint(x: 0, y: proxy.size.height / 2))
                path.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height / 2))
            }
            .stroke(Retro.panelStroke, style: StrokeStyle(lineWidth: proxy.size.height, dash: [8, 4]))
        }
        .accessibilityHidden(true)
    }
}

/// The button that opens the menu, for the top left corner of the home screen.
struct SettingsMenuButton: View {
    let action: () -> Void

    var body: some View {
        RetroIconButton(pixels: PixelIcon.menu, accessibilityLabel: "Abrir menú de ajustes", action: action)
    }
}

#Preview {
    @Previewable @State var isPresented = true
    ZStack {
        RetroBackground()
        Button("Abrir") { isPresented = true }
        SettingsMenu(isPresented: $isPresented)
    }
}
