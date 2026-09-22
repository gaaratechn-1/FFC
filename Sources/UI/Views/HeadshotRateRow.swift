//
//  HeadshotRateRow.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct HeadshotRateRow: View {
    public let policy: SliderPolicy
    @ObservedObject var menuStore = MenuStore.shared
    @ObservedObject var languageStore = LanguageStore.shared
    
    public init(policy: SliderPolicy) {
        self.policy = policy
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "target")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                    
                    Text(languageStore.text("headshot_label"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(Int(menuStore.currentConfig.headshot)) %")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
            }
            
            Slider(
                value: Binding(
                    get: { menuStore.currentConfig.headshot },
                    set: { menuStore.setHeadshot($0) }
                ),
                in: policy.min...policy.max,
                step: policy.step
            )
            .tint(Color(red: 0.25, green: 0.58, blue: 0.98))
        }
        .padding(.vertical, 4)
    }
}
