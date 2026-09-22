//
//  RootView.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct RootView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    
    public init() {}
    
    public var body: some View {
        MainMenuView()
    }
}
