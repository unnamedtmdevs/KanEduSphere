//
//  DesignSystem.swift
//  KanEduSphere
//

import SwiftUI

struct DesignSystem {
    static let backgroundColor = Color(hex: "#000000")
    static let primaryColor = Color(hex: "#fbd600")
    static let secondaryColor = Color(hex: "#ffffff")
    
    // Улучшенная непрозрачность для лучшей читаемости
    static let cardBackground = Color.white.opacity(0.15)
    static let glassBackground = Color.white.opacity(0.12)
    
    static let cornerRadius: CGFloat = 20
    static let cardPadding: CGFloat = 16
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct GlassCardModifier: ViewModifier {
    var backgroundColor: Color = DesignSystem.glassBackground
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Добавляем полупрозрачный черный фон для лучшего контраста
                    Color.black.opacity(0.3)
                    backgroundColor
                        .blur(radius: 10)
                }
            )
            .cornerRadius(DesignSystem.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
            )
    }
}

extension View {
    func glassCard(backgroundColor: Color = DesignSystem.glassBackground) -> some View {
        modifier(GlassCardModifier(backgroundColor: backgroundColor))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17))
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(DesignSystem.primaryColor)
            .cornerRadius(DesignSystem.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(DesignSystem.glassBackground)
            .cornerRadius(DesignSystem.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

