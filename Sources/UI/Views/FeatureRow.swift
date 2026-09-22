//
//  FeatureRow.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct FeatureRow: View {
    public let option: FeatureOption
    @ObservedObject var menuStore = MenuStore.shared
    
    public init(option: FeatureOption) {
        self.option = option
    }
    
    public var body: some View {
        let isEnabled = menuStore.isOptionEnabled(option.id)
        
        HStack(spacing: 12) {
            if let symbol = option.symbol {
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isEnabled ? Color(red: 0.25, green: 0.58, blue: 0.98) : Color.white.opacity(0.35))
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(option.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                if let sub = option.subtitle {
                    Text(sub)
                        .font(.system(size: 11))
                        .foregroundColor(Color.white.opacity(0.45))
                }
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: { _ in menuStore.toggleOption(option.id) }
            ))
            .toggleStyle(MonochromeToggleStyle())
            .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}
