//
//  GlassStyles.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct GlassPanelModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    public var padding: CGFloat
    public var radius: CGFloat
    
    public init(padding: CGFloat = 16, radius: CGFloat = 14) {
        self.padding = padding
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(reduceTransparency ? Color(red: 0.12, green: 0.13, blue: 0.16) : Color(red: 0.10, green: 0.12, blue: 0.16).opacity(0.82))
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.04)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 6)
    }
}

public extension View {
    func glassPanel(padding: CGFloat = 16, radius: CGFloat = 14) -> some View {
        modifier(GlassPanelModifier(padding: padding, radius: radius))
    }
}

public struct PrimaryButtonStyle: ButtonStyle {
    public var color: Color
    
    public init(color: Color = Color(red: 0.25, green: 0.58, blue: 0.98)) {
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(configuration.isPressed ? 0.75 : 1.0),
                                color.opacity(configuration.isPressed ? 0.55 : 0.85)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

public struct GlassButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.16 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
