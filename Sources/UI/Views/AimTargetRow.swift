//
//  AimTargetRow.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct AimTargetRow: View {
    @ObservedObject var menuStore = MenuStore.shared
    @ObservedObject var languageStore = LanguageStore.shared
    
    private let targets = ["Head", "Neck", "Chest"]
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "person.fill.viewfinder")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                
                Text(languageStore.text("target_label"))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 6) {
                ForEach(targets, id: \.self) { target in
                    let isSelected = menuStore.currentConfig.aimTarget == target
                    Button(action: {
                        menuStore.setAimTarget(target)
                    }) {
                        Text(target)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(isSelected ? .white : Color.white.opacity(0.45))
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(isSelected ? Color(red: 0.25, green: 0.58, blue: 0.98).opacity(0.8) : Color.white.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isSelected ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
