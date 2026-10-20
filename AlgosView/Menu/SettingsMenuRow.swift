//
//  SettingsMenuRow.swift
//  Algorithothm
//
//  Created by Gregori Farias on 19/10/26.
//
//  One option of the side menu: icon, name, current value and an arrow. Options that don't
//  work yet show "Pronto" instead of the arrow and can't be tapped.
//

import SwiftUI

struct SettingsMenuRow<Icon: View>: View {
    let title: String
    let value: String
    let valueColor: Color
    var isAvailable = true
    let action: () -> Void
    @ViewBuilder var icon: Icon

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                icon
                    .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(RetroFont.pixel(17))
                    Text(value)
                        .font(RetroFont.pixel(14))
                        .foregroundStyle(valueColor)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.8)

                Spacer(minLength: 4)

                if isAvailable {
                    Text("›")
                        .font(RetroFont.pixel(18))
                        .foregroundStyle(Retro.disabledText)
                        .accessibilityHidden(true)
                } else {
                    Text("PRONTO")
                        .font(RetroFont.pixel(10, relativeTo: .caption2))
                        .foregroundStyle(Retro.disabledText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .overlay { Rectangle().strokeBorder(Retro.ghostStroke, lineWidth: 2) }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .background(Retro.background)
            .overlay { Rectangle().strokeBorder(Retro.ghostStroke, lineWidth: 2) }
            .opacity(isAvailable ? 1 : 0.6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isAvailable)
        .accessibilityElement(children: .combine)
        .accessibilityHint(isAvailable ? "" : "Próximamente")
    }
}
