//
//  DragAndHoldTecnicvIEW.swift
//  Algorithothm
//
//  Created by Greibis Farias on 30/9/26.
//
import SwiftUI
import SwiftData

// ─────────────────────────────────────────────────────────────
// Necesita lo que ya tienes en PixelUI.swift:
// Pixel, Color(hex:), PixelRect, PixelIcon, PixelPressStyle.
//
// ÚNICO cambio en PixelIcon: añade un parámetro `grid` para
// poder dibujar iconos de 8×8 además de los de 16×16:
//
//     var grid: CGFloat = 16
//     ...
//     let s = canvasSize.width / grid      // antes: / 16
// ─────────────────────────────────────────────────────────────

// MARK: - Colores nuevos de esta pantalla

extension Pixel {
    static let board      = Color(hex: 0x120C1A)   // fondo del tablero
    static let nodeBlue   = Color(hex: 0x22324A)   // pieza conectada
    static let idleBorder = Color(hex: 0x6E5F78)   // pieza sin conectar
    static let statusLine = Color(hex: 0x4A3A52)
    static let statusText = Color(hex: 0xA99BB3)
    static let backBorder = Color(hex: 0x69283B)
    static let bezel      = Color(hex: 0xD4CAB2)
    static let bezelDark  = Color(hex: 0x8A806E)

    /// Fuente de terminal (VT323, Google Fonts, licencia OFL). Regístrala en el Info.plist.
    static func terminal(_ size: CGFloat) -> Font { .custom("VT323", size: size) }
}

// MARK: - Iconos 8×8

extension PixelIcons {
    static let chevronLeft: [PixelRect] = [
        .init(x: 4, y: 1, w: 1, h: 1), .init(x: 3, y: 2, w: 1, h: 1),
        .init(x: 2, y: 3, w: 1, h: 2), .init(x: 3, y: 5, w: 1, h: 1),
        .init(x: 4, y: 6, w: 1, h: 1)
    ]
    static let pointer: [PixelRect] = [
        .init(x: 0, y: 0, w: 1, h: 7), .init(x: 1, y: 1, w: 1, h: 5),
        .init(x: 2, y: 2, w: 1, h: 4), .init(x: 3, y: 3, w: 1, h: 3),
        .init(x: 4, y: 4, w: 1, h: 2), .init(x: 5, y: 5, w: 1, h: 1),
        .init(x: 2, y: 6, w: 1, h: 2)
    ]
}

// MARK: - Componentes reutilizables

/// Fondo oscuro + textura (en el home va al 22 %, en estudio al 14 %).
struct PixelBackground: View {
    var opacity: Double = 0.14
    var body: some View {
        ZStack {
            Pixel.bg
            Image("home_bg").resizable().interpolation(.none).scaledToFill().opacity(opacity)
        }
        .ignoresSafeArea()
    }
}

/// Botón cuadrado 44×44 con chevron pixelado.
struct PixelBackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            PixelIcon2(rects: PixelIcons.chevronLeft, tint: Pixel.cream, size: 20, grid: 16)
                .frame(width: 44, height: 44)
                .background(Pixel.tile)
                .overlay(Rectangle().strokeBorder(Pixel.backBorder, lineWidth: 2))
        }
        .buttonStyle(PixelPressStyle())
        .accessibilityLabel("Volver")
    }
}

/// Cabecera de sesión: volver + "TIPO 3 · ARQUITECTURA  1/3" + barra segmentada.
/// Sirve igual para Predice y Sorting cambiando label y accent.
struct StudyHeader: View {
    let label: String
    let accent: Color
    let current: Int      // 1-based
    let total: Int
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            PixelBackButton(action: onBack)
            VStack(spacing: 6) {
                HStack {
                    Text(label).foregroundStyle(accent)
                    Spacer()
                    Text("\(current)/\(total)").foregroundStyle(Pixel.cream)
                }
                .font(Pixel.font(14))

                HStack(spacing: 2) {
                    ForEach(0..<max(total, 1), id: \.self) { i in
                        Rectangle().fill(i < current ? accent : .clear)
                    }
                }
                .frame(height: 8)
                .background(Pixel.tile)
            }
        }
    }
}

/// Monitor beige (el mismo look que el de "Mezclar").
struct PixelMonitor<Content: View>: View {
    var padding: CGFloat = 10
    var foot: CGFloat = 8
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .background(Pixel.bezel)
            .background {
                ZStack {
                    Pixel.bezelDark.offset(y: foot)
                    Pixel.bezel.offset(y: -4)
                    Pixel.bezelDark.offset(y: 4)
                    Pixel.bezel.offset(x: -4)
                    Pixel.bezel.offset(x: 4)
                }
            }
            .padding(.horizontal, 4).padding(.top, 4).padding(.bottom, foot)
    }
}

/// Texto verde de terminal con el cursor ▌ parpadeando.
struct TerminalPrompt: View {
    let text: String
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { ctx in
            let on = Int(ctx.date.timeIntervalSinceReferenceDate * 2) % 2 == 0
            (Text("> \(text) ").foregroundColor(Pixel.green)
             + Text("▌").foregroundColor(Pixel.mintText.opacity(on ? 1 : 0)))
                .font(Pixel.terminal(20))
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12).padding(.horizontal, 14)
                .background(Pixel.screen)
        }
    }
}

/// Recuadro inferior "Faltan 2 conexiones".
struct StatusBox: View {
    let text: String
    var done = false
    var body: some View {
        Text(text)
            .font(Pixel.font(20))
            .foregroundStyle(done ? Pixel.green : Pixel.statusText)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Pixel.tile)
            .overlay(Rectangle().strokeBorder(done ? Pixel.green : Pixel.statusLine, lineWidth: 3))
    }
}

// MARK: - Tablero: piezas y cables

enum ArchNodeState { case idle, connected, active }

struct ArchNodeView: View {
    let name: String
    let size: CGSize
    let state: ArchNodeState
    var showsTopPort = true
    var showsBottomPort = true

    private var fill: Color   { state == .connected ? Pixel.nodeBlue : Pixel.tile }
    private var border: Color {
        switch state {
        case .idle: Pixel.idleBorder
        case .connected: Pixel.sky
        case .active: Pixel.green
        }
    }
    private var textColor: Color { state == .idle ? Pixel.lilac : Pixel.cream }

    var body: some View {
        Text(name)
            .font(Pixel.font(16))
            .foregroundStyle(textColor)
            .lineLimit(1).minimumScaleFactor(0.7)
            .padding(.horizontal, 6)
            .frame(width: size.width, height: size.height)
            .background(fill)
            .overlay(Rectangle().strokeBorder(border, lineWidth: 3))
            .overlay(alignment: .top)    { if showsTopPort    { port.offset(y: -4) } }
            .overlay(alignment: .bottom) { if showsBottomPort { port.offset(y:  4) } }
            .shadow(color: state == .active ? Pixel.green.opacity(0.4) : .clear, radius: 8)
            .animation(.easeOut(duration: 0.12), value: state)
    }

    private var port: some View { Rectangle().fill(border).frame(width: 8, height: 8) }
}

/// Cuadrícula de puntos del fondo del tablero.
struct DotGrid: View {
    var spacing: CGFloat = 16
    var body: some View {
        Canvas { ctx, size in
            var y = spacing / 2
            while y < size.height {
                var x = spacing / 2
                while x < size.width {
                    ctx.fill(Path(ellipseIn: CGRect(x: x - 1.5, y: y - 1.5, width: 3, height: 3)),
                             with: .color(Pixel.tile))
                    x += spacing
                }
                y += spacing
            }
        }
    }
}

enum PixelWire {
    /// Cable en "L" doble: baja, cruza y vuelve a bajar (como el polyline del HTML).
    static func path(from a: CGPoint, to b: CGPoint) -> Path {
        let midY = (a.y + b.y) / 2
        var p = Path()
        p.move(to: a)
        p.addLine(to: CGPoint(x: a.x, y: midY))
        p.addLine(to: CGPoint(x: b.x, y: midY))
        p.addLine(to: b)
        return p
    }

    /// Sale por el puerto de abajo si el destino está más abajo; si no, por el de arriba.
    static func ports(from pa: CGPoint, _ sa: CGSize, to pb: CGPoint, _ sb: CGSize) -> (CGPoint, CGPoint) {
        if pb.y >= pa.y {
            return (CGPoint(x: pa.x, y: pa.y + sa.height / 2), CGPoint(x: pb.x, y: pb.y - sb.height / 2))
        } else {
            return (CGPoint(x: pa.x, y: pa.y - sa.height / 2), CGPoint(x: pb.x, y: pb.y + sb.height / 2))
        }
    }

    static let solid  = StrokeStyle(lineWidth: 4, lineCap: .butt, lineJoin: .miter)
    static let dashed = StrokeStyle(lineWidth: 4, lineCap: .butt, lineJoin: .miter, dash: [8, 6])
}

// MARK: - DragAndHoldTecnicView (tablero + pistas)

struct DragAndHoldTecnicView: View {
    @ObservedObject var vmStudy: ArchitectureStudyViewModel     // ← ahora lo recibe del padre
    @EnvironmentObject var validator: ValidationOfArch

    @State private var moduleWhereArrowIs: UUID? = nil
    @State private var whereYouLetTheArrow: CGPoint? = nil

    /// TODO: saca este número de tu tarjeta (conexiones correctas que exige el ejercicio).
    var requiredConnections: Int = 3

    var body: some View {
        Group {
            if vmStudy.isFinished {
                PixelMonitor {
                    TerminalPrompt(text: "¡Terminaste las arquitecturas de hoy!")
                }
            } else if !vmStudy.activeArchitectureModules.isEmpty {
                let modules = vmStudy.activeArchitectureModules
                let made = modules.reduce(0) { $0 + $1.moduleMustBeConnected.count }
                let missing = max(requiredConnections - made, 0)

                // Pieza bajo el dedo mientras arrastras (se resalta en verde)
                let hoveredId = whereYouLetTheArrow.flatMap { point in
                    modules.first { m in
                        m.id != moduleWhereArrowIs &&
                        CGRect(x: m.position.x - m.size.width / 2, y: m.position.y - m.size.height / 2,
                               width: m.size.width, height: m.size.height).contains(point)
                    }?.id
                }

                VStack(spacing: 16) {
                    // ── A. TABLERO ─────────────────────────────
                    ZStack {
                        DotGrid()

                        Canvas { context, _ in
                            for node in modules {
                                // conexiones ya validadas: azul sólido
                                for targetId in node.moduleMustBeConnected {
                                    guard let target = modules.first(where: { $0.id == targetId }) else { continue }
                                    let (a, b) = PixelWire.ports(from: node.position, node.size,
                                                                 to: target.position, target.size)
                                    context.stroke(PixelWire.path(from: a, to: b),
                                                   with: .color(Pixel.sky), style: PixelWire.solid)
                                }
                                // cable en vivo: verde discontinuo + puntero
                                if moduleWhereArrowIs == node.id, let p = whereYouLetTheArrow {
                                    let (a, _) = PixelWire.ports(from: node.position, node.size,
                                                                 to: p, .zero)
                                    context.stroke(PixelWire.path(from: a, to: p),
                                                   with: .color(Pixel.green), style: PixelWire.dashed)
                                    let s: CGFloat = 26 / 8
                                    for r in PixelIcons.pointer {
                                        context.fill(Path(CGRect(x: p.x + 6 + r.x * s, y: p.y - 18 + r.y * s,
                                                                 width: r.w * s, height: r.h * s)),
                                                     with: .color(Pixel.cream))
                                    }
                                }
                            }
                        }

                        // ── B. PIEZAS ──────────────────────────
                        ForEach(modules) { node in
                            let isConnected = !node.moduleMustBeConnected.isEmpty ||
                                modules.contains { $0.moduleMustBeConnected.contains(node.id) }
                            let isActive = node.id == moduleWhereArrowIs || node.id == hoveredId

                            ArchNodeView(
                                name: node.name,
                                size: node.size,
                                state: isActive ? .active : (isConnected ? .connected : .idle),
                                showsTopPort: modules.contains { $0.position.y < node.position.y - 1 },
                                showsBottomPort: modules.contains { $0.position.y > node.position.y + 1 }
                            )
                            .position(node.position)
                            .highPriorityGesture(        // gana al scroll cuando arrastras una pieza
                                DragGesture(coordinateSpace: .named("Lienzo"))
                                    .onChanged { value in
                                        moduleWhereArrowIs = node.id
                                        whereYouLetTheArrow = value.location
                                    }
                                    .onEnded { value in
                                        var currentModules = vmStudy.activeArchitectureModules
                                        validator.validateAndConnect(validationModules: &currentModules,
                                                                     from: node.id, at: value.location)
                                        // Si tus módulos son struct, devuelve el resultado al VM:
                                        // vmStudy.activeArchitectureModules = currentModules
                                        moduleWhereArrowIs = nil
                                        whereYouLetTheArrow = nil
                                    }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .background(Pixel.board)
                    .overlay(Rectangle().strokeBorder(Pixel.tile, lineWidth: 2))
                    .clipped()
                    .coordinateSpace(name: "Lienzo")

                    // ── C. PISTA + CONTADOR ───────────────────
                    HStack {
                        Text("Arrastra desde un punto ■ hasta otra pieza")
                            .font(Pixel.font(14))
                            .foregroundStyle(Pixel.lilac)
                        Spacer()
                        Text("\(made)/\(requiredConnections)")
                            .font(Pixel.terminal(18))
                            .foregroundStyle(Pixel.sky)
                    }

                    StatusBox(
                        text: missing == 0 ? "¡Arquitectura completa!"
                            : "Faltan \(missing) conexi\(missing == 1 ? "ón" : "ones")",
                        done: missing == 0
                    )
                }
                .sheet(isPresented: $validator.showCongratsAlert) {
                    FeedBackView(studyVM: vmStudy)
                }
                .alert("Respuesta Incorrecta", isPresented: $validator.showErrorAlert) {
                    Button("Reintentar", role: .cancel) { }
                } message: {
                    Text(validator.errorMessage ?? "")
                }
            } else {
                Text("Cargando módulos…")
                    .font(Pixel.terminal(20))
                    .foregroundStyle(Pixel.green)
                    .frame(maxWidth: .infinity, minHeight: 400)
            }
        }
    }
}

// MARK: - DragAndHoldView (pantalla completa)

