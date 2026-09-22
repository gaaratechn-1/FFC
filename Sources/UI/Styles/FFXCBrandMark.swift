//
//  FFXCBrandMark.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct FFXCBrandMark: View {
    public let compact: Bool
    
    public init(compact: Bool = false) {
        self.compact = compact
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: compact ? 16 : 22, weight: .bold))
                .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("FFXC")
                    .font(.system(size: compact ? 15 : 20, weight: .heavy, design: .monospaced))
                    .foregroundColor(.white)
                
                if !compact {
                    Text("PRIVATE EDITION")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(2.5)
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }
        }
    }
}
