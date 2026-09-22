//
//  MonochromeToggleStyle.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct MonochromeToggleStyle: ToggleStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(configuration.isOn ? Color(red: 0.25, green: 0.58, blue: 0.98) : Color.white.opacity(0.12))
                .frame(width: 46, height: 26)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                )
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
