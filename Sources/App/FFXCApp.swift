//
//  FFXCApp.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

@main
struct FFXCApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var sessionManager = SessionManager.shared
    @StateObject private var languageStore = LanguageStore.shared
    @StateObject private var menuStore = MenuStore.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .environmentObject(sessionManager)
                .environmentObject(languageStore)
                .environmentObject(menuStore)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                sessionManager.restoreSession()
            }
        }
    }
}
