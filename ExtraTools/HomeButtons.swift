//
//  HomeButtons.swift
//  Algorithothm
//
//  Created by Greibis Farias on 1/10/26.
//

import SwiftUI
import SwiftData

// The NavigationStack comes from AlgosHomeView, nesting another one here breaks the navigation.
// The language is chosen in the onboarding and changed from the menu (SettingsMenu).
struct HomeButtons: View {
    
    @AppStorage(ProgrammingLenguages.storageKey) private var language: ProgrammingLenguages = .swift
    @StateObject var vmStudy: ArchitectureStudyViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext){
        _vmStudy = StateObject(wrappedValue: ArchitectureStudyViewModel(modelContext: modelContext))
        
    }
    
    
    
    var body: some View {
        VStack{
                        NavigationLink{
                            RandomDeck()
                        }label: {
                            RetroMonitor{
                                MixScreenContent()
                            }
                        }
//            HStack() {
//                
//                NavigationLink{
//                    ArchitectureDeck()
//                }label: {
//                    deckButton("Architecture")
//                }
//                NavigationLink{
//                    SortingDeck()
//                }label: {
//                    deckButton("Sorting")
//                }
//            }
//            HStack{
//                NavigationLink{
//                    MultipleChoiceDeck(modelContext: modelContext)
//                }label: {
//                    deckButton("Predict")
//                }
//                Rectangle()
//                    .frame(width: 170, height: 190)
//                    .cornerRadius(20)
//            }
            
            
            VStack(alignment: .leading, spacing: 14) {
            
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 18), GridItem(.flexible())]) {
                    ForEach(HomeTile.allCases) { tile in
                        NavigationLink {
                            destination(for: tile)
                        } label: {
                            HomeTileCard(tile: tile)
                        }
                        .buttonStyle(PixelPressStyle())
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder
    private func destination(for tile: HomeTile) -> some View {
        switch tile {
        case .predict:      MultipleChoiceDeck(modelContext: modelContext)
        case .sorting:      SortingDeck(vmStudy: vmStudy)
        case .architecture: ArchitectureDeck()
        case .rewards:      Text("Premios")
        }
    }
    
    private func deckButton(_ title: String) -> some View {
        Rectangle()
            .frame(width: 170, height: 190)
            .cornerRadius(20)
            .overlay {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
    }
    
    private func randomButton(_ title: String) -> some View {
        Rectangle()
            .frame(width: 345, height: 120)
            .cornerRadius(20)
            .overlay{
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.green)
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardItem.self, configurations: config)
    
    // 2. Inyectar el mainContext del contenedor
    return NavigationStack {
        HomeButtons(modelContext: container.mainContext)
    }
    .modelContainer(container) // Inyecta el contenedor en la jerarquía
    .environmentObject(ValidationOfArch())
}


import SwiftUI
import SwiftUI
import SwiftData

// MARK: - Paleta (sacada del HTML)

enum Pixel {
    static let bg        = Color(hex: 0x171021)   // fondo de la pantalla
    static let tile      = Color(hex: 0x2D192C)   // relleno de las tarjetas
    static let cream     = Color(hex: 0xF3EDE0)   // texto principal
    static let lilac     = Color(hex: 0xCFC5D6)   // títulos de sección
    static let green     = Color(hex: 0x4CE07A)   // Tipo 1 / glow mascota
    static let orange    = Color(hex: 0xDD9A64)   // Tipo 2 / "Estudiando Swift"
    static let sky       = Color(hex: 0xB9D7DD)   // Tipo 3
    static let gold      = Color(hex: 0xEAD18E)   // Logros
    static let goldShade = Color(hex: 0xC2A556)
    static let goldLight = Color(hex: 0xFFF6D2)
    static let goldBase  = Color(hex: 0x8A6A2A)
    
    static func font(_ size: CGFloat) -> Font { .custom("Pixelta", size: size) }
}

extension Color {
    init(hex: UInt32) {
        self.init(red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8)  & 0xFF) / 255,
                  blue:  Double(hex & 0xFF) / 255)
    }
}

// MARK: - Borde pixelado (equivalente a los 4 box-shadow del HTML)
// Cuatro copias del color desplazadas 4pt arriba/abajo/izq/der detrás del relleno:
// así quedan las esquinas "mordidas" típicas del pixel art.

struct PixelBorder: ViewModifier {
    let color: Color
    var width: CGFloat = 4
    var fill: Color = Pixel.tile
    
    func body(content: Content) -> some View {
        content
            .background(fill)
            .background {
                ZStack {
                    color.offset(y: -width)
                    color.offset(y:  width)
                    color.offset(x: -width)
                    color.offset(x:  width)
                }
            }
            .padding(width) // reserva el espacio del borde (el margin: 4px del HTML)
    }
}

extension View {
    func pixelBorder(_ color: Color, width: CGFloat = 4, fill: Color = Pixel.tile) -> some View {
        modifier(PixelBorder(color: color, width: width, fill: fill))
    }
}

// MARK: - Iconos pixel (rejilla 16×16, igual que los <svg viewBox="0 0 16 16">)

struct PixelRect {
    let x, y, w, h: CGFloat
    var color: Color? = nil          // nil = usa el tint (currentColor)
    
    /// Un rectángulo con stroke de 1px convertido a 4 barras sólidas.
    static func outline(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> [PixelRect] {
        [PixelRect(x: x, y: y, w: w, h: 1),
         PixelRect(x: x, y: y + h - 1, w: w, h: 1),
         PixelRect(x: x, y: y, w: 1, h: h),
         PixelRect(x: x + w - 1, y: y, w: 1, h: h)]
    }
}

struct PixelIcon2: View {
    let rects: [PixelRect]
    var tint: Color
    var size: CGFloat = 44
    var grid: CGFloat
    
    var body: some View {
        Canvas { ctx, canvasSize in
            let s = canvasSize.width / 16
            for r in rects {
                let rect = CGRect(x: r.x * s, y: r.y * s, width: r.w * s, height: r.h * s)
                ctx.fill(Path(rect), with: .color(r.color ?? tint))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

enum PixelIcons {
    /// Tipo 1 · Predice — monitor con un "?"
    static let predict: [PixelRect] =
    PixelRect.outline(1, 2, 14, 10) + [
        .init(x: 6, y: 12, w: 4, h: 1), .init(x: 4, y: 13, w: 8, h: 1),
        .init(x: 6, y: 4,  w: 4, h: 1), .init(x: 9, y: 5,  w: 1, h: 2),
        .init(x: 7, y: 7,  w: 2, h: 1), .init(x: 7, y: 9,  w: 2, h: 1)
    ]
    
    /// Tipo 2 · Aprende y arma (sorting) — barras desordenadas
    static let sorting: [PixelRect] = [
        .init(x: 1, y: 2,  w: 8,  h: 3),
        .init(x: 5, y: 7,  w: 10, h: 3),
        .init(x: 2, y: 12, w: 7,  h: 3)
    ]
    
    /// Tipo 3 · Arquitectura — árbol / diagrama de módulos
    static let architecture: [PixelRect] = [
        .init(x: 5, y: 1, w: 6, h: 4), .init(x: 7, y: 5, w: 2, h: 2),
        .init(x: 3, y: 7, w: 10, h: 1),
        .init(x: 3, y: 8, w: 1, h: 2), .init(x: 12, y: 8, w: 1, h: 2)
    ] + PixelRect.outline(1, 10, 5, 4) + PixelRect.outline(10, 10, 5, 4)
    
    /// Logros · Premios — trofeo con colores propios
    static let trophy: [PixelRect] = {
        let g = Pixel.gold, sh = Pixel.goldShade, hi = Pixel.goldLight, b = Pixel.goldBase
        return [
            .init(x: 3, y: 2, w: 10, h: 1, color: g), .init(x: 4, y: 3, w: 8, h: 4, color: g),
            .init(x: 5, y: 7, w: 6, h: 1, color: g),  .init(x: 6, y: 8, w: 4, h: 1, color: g),
            .init(x: 9, y: 3, w: 3, h: 4, color: sh), .init(x: 9, y: 7, w: 2, h: 1, color: sh),
            .init(x: 8, y: 8, w: 2, h: 1, color: sh), .init(x: 5, y: 3, w: 1, h: 3, color: hi),
            // asas
            .init(x: 1, y: 3, w: 2, h: 1, color: g),  .init(x: 1, y: 4, w: 1, h: 2, color: g),
            .init(x: 2, y: 6, w: 2, h: 1, color: g),  .init(x: 13, y: 3, w: 2, h: 1, color: sh),
            .init(x: 14, y: 4, w: 1, h: 2, color: sh), .init(x: 12, y: 6, w: 2, h: 1, color: sh),
            // tallo y base
            .init(x: 7, y: 9, w: 2, h: 2, color: g),  .init(x: 8, y: 9, w: 1, h: 2, color: sh),
            .init(x: 5, y: 11, w: 6, h: 1, color: g), .init(x: 4, y: 12, w: 8, h: 2, color: g),
            .init(x: 9, y: 12, w: 3, h: 2, color: sh), .init(x: 4, y: 14, w: 8, h: 1, color: b),
            // destellos
            .init(x: 14, y: 0, w: 1, h: 1, color: hi), .init(x: 0, y: 9, w: 1, h: 1, color: g),
            .init(x: 15, y: 10, w: 1, h: 1, color: g)
        ]
    }()
}

// MARK: - Modelo de las tarjetas

enum HomeTile: String, CaseIterable, Identifiable, Hashable {
    case predict, sorting, architecture, rewards
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .predict: "TIPO 1"
        case .sorting: "TIPO 2"
        case .architecture: "TIPO 3"
        case .rewards: "LOGROS"
        }
    }
    var title: String {
        switch self {
        case .predict: "Predice"
        case .sorting: "Aprende y arma"
        case .architecture: "Arquitectura"
        case .rewards: "Premios"
        }
    }
    var accent: Color {
        switch self {
        case .predict: Pixel.green
        case .sorting: Pixel.orange
        case .architecture: Pixel.sky
        case .rewards: Pixel.gold
        }
    }
    var icon: [PixelRect] {
        switch self {
        case .predict: PixelIcons.predict
        case .sorting: PixelIcons.sorting
        case .architecture: PixelIcons.architecture
        case .rewards: PixelIcons.trophy
        }
    }
    /// El trofeo es más grande en el diseño (60 vs 44) y lleva menos padding arriba.
    var iconSize: CGFloat { self == .rewards ? 60 : 44 }
    var topPadding: CGFloat { self == .rewards ? 12 : 14 }
}

// MARK: - Tarjeta

struct HomeTileCard: View {
    let tile: HomeTile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PixelIcon2(rects: tile.icon, tint: tile.accent, size: tile.iconSize, grid: 8)
            Spacer(minLength: 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(tile.label)
                    .font(Pixel.font(13))
                    .foregroundStyle(tile.accent)
                Text(tile.title)
                    .font(Pixel.font(19))
                    .foregroundStyle(Pixel.cream)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.top, tile.topPadding)
        .padding([.horizontal, .bottom], 14)
        .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
        .pixelBorder(tile.accent)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

/// Efecto "botón de consola": baja 2pt al pulsar.
struct PixelPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(y: configuration.isPressed ? 2 : 0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

// MARK: - Secciones

struct GreetingHeader: View {
    let name: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                // "glow" cuadrado verde detrás de la mascota
                Pixel.green.opacity(0.16).frame(width: 132, height: 110)
                Pixel.green.opacity(0.35).frame(width: 76, height: 56).offset(y: 18)
                Image("mascota_compu")                // ← tu asset
                    .resizable()
                    .interpolation(.none)             // mantiene los píxeles nítidos
                    .scaledToFit()
                    .frame(width: 104, height: 120)
            }
            .frame(width: 104, height: 120)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("¡Hola,\n\(name)!")
                    .font(Pixel.font(32))
                    .tracking(1)
                    .lineSpacing(3)
                    .foregroundStyle(Pixel.cream)
                
                HStack(spacing: 6) {
                    Image("icono_swift")              // ← tu asset de 22×22
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 22, height: 22)
                    Text(subtitle)
                        .font(Pixel.font(15))
                }
                .foregroundStyle(Pixel.orange)
            }
            Spacer(minLength: 0)
        }
    }
}

struct FlashcardTypesSection: View {
    private let columns = [GridItem(.flexible(), spacing: 18),  // 18 entre bordes
                           GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TIPOS DE FLASHCARD")
                .font(Pixel.font(16).bold())
                .tracking(1)
                .foregroundStyle(Pixel.lilac)
            
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(HomeTile.allCases) { tile in
                    NavigationLink(value: tile) {
                        HomeTileCard(tile: tile)
                    }
                    .buttonStyle(PixelPressStyle())
                }
            }
        }
    }
}


extension Pixel {
    static let screen    = Color(hex: 0x0E1A12)   // fondo del monitor
    static let mintText  = Color(hex: 0xB9F5C9)   // subtítulo
}

extension PixelIcons {
    /// Dos cartas superpuestas (la de atrás con "+" y la de adelante con "↗")
    static let mix: [PixelRect] = {
        let bg = Pixel.screen
        return
            // carta de atrás
            [.init(x: 1, y: 4, w: 8, h: 10, color: bg)] + PixelRect.outline(1, 4, 8, 10) +
            // carta de adelante (tapa a la de atrás)
            [.init(x: 6, y: 1, w: 9, h: 11, color: bg)] + PixelRect.outline(6, 1, 9, 11) +
            // marcas
            [.init(x: 9, y: 5, w: 3, h: 1), .init(x: 11, y: 4, w: 1, h: 3),
             .init(x: 3, y: 10, w: 3, h: 1), .init(x: 3, y: 9, w: 1, h: 3)]
    }()
}

/// Lo que va DENTRO del monitor
struct MixScreenContent: View {
    var title = "MEZCLAR"
    var subtitle = "Repasa las tarjetas difíciles y las que fallaste"

    var body: some View {
        HStack(spacing: 16) {
            PixelIcon2(rects: PixelIcons.mix, tint: Pixel.green, size: 56, grid: 16)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Pixel.font(28))
                    .tracking(1)
                    .foregroundStyle(Pixel.green)
                Text(subtitle)
                    .font(Pixel.font(15))
                    .lineSpacing(4.5)            // line-height 19.5 del HTML
                    .foregroundStyle(Pixel.mintText)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Pixel.screen)
    }
}


// MARK: - Pantalla

