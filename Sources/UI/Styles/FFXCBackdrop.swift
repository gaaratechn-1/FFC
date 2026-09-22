//
//  FFXCBackdrop.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct FFXCBackdrop: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var sweep: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Dark base background
            Color(red: 0.05, green: 0.05, blue: 0.07)
                .ignoresSafeArea()
            
            // Subtle ambient radial glow
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.22, blue: 0.38).opacity(0.4),
                    Color.clear
                ]),
                center: sweep ? .topTrailing : .bottomLeading,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
            .animation(
                reduceMotion ? nil : Animation.easeInOut(duration: 8.0).repeatForever(autoreverses: true),
                value: sweep
            )
            .onAppear {
                if !reduceMotion {
                    sweep = true
                }
            }
            
            // Cybernetic subtle grid texture overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.02),
                    Color.clear
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
