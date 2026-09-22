//
//  FFXCApp.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//  Enhanced with 3105 (ThreeOneOSFive) Exploit & Container Engine
//

import SwiftUI

@main
struct FFXCApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var sessionManager = SessionManager.shared
    @StateObject private var languageStore = LanguageStore.shared
    @StateObject private var menuStore = MenuStore.shared
    
    init() {
        setupLogCapture()
        AppLog.shared.info("[3105] YABAOCHEAT launching — iOS \(AppInfo.osVersion) (\(AppInfo.osBuild)) \(AppInfo.machineName)")
        
        let v = AppInfo.versionTuple
        if KernelExploit.isApplicable(major: v.major, minor: v.minor, patch: v.patch, build: AppInfo.osBuild) {
            if !KernelExploit.hasSandboxAccess() {
                AppLog.shared.info("[3105] Running kernel exploit chain on background...")
                DispatchQueue.global(qos: .userInitiated).async {
                    let success = KernelExploit.run()
                    if success {
                        AppLog.shared.success("[3105] Kernel exploit established & sandbox escaped.")
                    } else {
                        AppLog.shared.warning("[3105] Kernel exploit bypassed or completed.")
                    }
                }
            }
        }
    }
    
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
