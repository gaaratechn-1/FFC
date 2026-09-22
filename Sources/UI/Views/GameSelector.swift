//
//  GameSelector.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct GameSelector: View {
    @ObservedObject var menuStore = MenuStore.shared
    @ObservedObject var languageStore = LanguageStore.shared
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(FFGame.allCases) { game in
                let isSelected = menuStore.selectedGame == game
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        menuStore.selectedGame = game
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: game == .freeFire ? "flame.fill" : "bolt.shield.fill")
                            .font(.system(size: 13, weight: .semibold))
                        
                        Text(game.displayName)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(isSelected ? .white : Color.white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(isSelected ? Color(red: 0.25, green: 0.58, blue: 0.98) : Color.white.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(isSelected ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
                    )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(red: 0.08, green: 0.09, blue: 0.12).opacity(0.8))
        )
    }
}
