//
//  FeatureSectionCard.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct FeatureSectionCard: View {
    public let section: FeatureSection
    @ObservedObject var menuStore = MenuStore.shared
    
    public init(section: FeatureSection) {
        self.section = section
    }
    
    public var body: some View {
        let options = menuStore.catalog.options.filter { $0.section == section.id }
        
        VStack(alignment: .leading, spacing: 14) {
            // Section Title
            HStack {
                Text(section.title.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                
                Spacer()
            }
            
            // Options list
            VStack(spacing: 8) {
                ForEach(options) { option in
                    FeatureRow(option: option)
                    
                    // If this option controls sliders or target, show them inline
                    if menuStore.isOptionEnabled(option.id) {
                        if option.radius == true {
                            FOVRadiusRow(policy: menuStore.catalog.radius)
                                .padding(.leading, 12)
                        }
                        if option.h0 == true {
                            HeadshotRateRow(policy: menuStore.catalog.h0)
                                .padding(.leading, 12)
                        }
                        if option.a0 == true {
                            AimTargetRow()
                                .padding(.leading, 12)
                        }
                    }
                    
                    if option.id != options.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.08))
                    }
                }
            }
        }
        .glassPanel(padding: 14, radius: 14)
    }
}
