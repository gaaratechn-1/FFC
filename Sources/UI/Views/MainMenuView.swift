//
//  MainMenuView.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct MainMenuView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    @ObservedObject var languageStore = LanguageStore.shared
    @ObservedObject var menuStore = MenuStore.shared
    
    @State private var showLogoutAlert: Bool = false
    @State private var showLanguagePicker: Bool = false
    @State private var showLogs: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            FFXCBackdrop()
            
            VStack(spacing: 0) {
                // Navigation Header
                HStack {
                    FFXCBrandMark(compact: true)
                    
                    Spacer()
                    
                    // Diagnostic log button
                    Button(action: { showLogs = true }) {
                        Image(systemName: "terminal.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .buttonStyle(GlassButtonStyle())
                    
                    // Language button
                    Button(action: { showLanguagePicker = true }) {
                        Image(systemName: "globe")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(GlassButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // License Status Banner
                        if let session = sessionManager.session {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("FFXC PRIVATE EDITION")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                    
                                    Text("STATUS: FULL VIP UNLOCKED • LIFETIME")
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundColor(Color(red: 0.35, green: 0.95, blue: 0.55))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                            }
                            .glassPanel(padding: 12, radius: 12)
                            .padding(.horizontal, 16)
                        }
                        
                        // Game Selector (Free Fire vs Free Fire MAX)
                        GameSelector()
                            .padding(.horizontal, 16)
                        
                        // Feature Section Cards
                        ForEach(menuStore.catalog.sections) { section in
                            FeatureSectionCard(section: section)
                                .padding(.horizontal, 16)
                        }
                        
                        // Spacer for bottom floating bar
                        Spacer()
                            .frame(height: 90)
                    }
                    .padding(.top, 8)
                }
            }
            
            // Bottom floating inject bar
            VStack {
                Spacer()
                BottomInjectBar()
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView()
        }
        .sheet(isPresented: $showLogs) {
            NavigationView {
                ZStack {
                    FFXCBackdrop()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(AppLog.shared.entries) { entry in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("[\(entry.level.rawValue)]")
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                        .foregroundColor(entry.level == .error ? .red : (entry.level == .success ? .green : .yellow))
                                    Text(entry.message)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Diagnostics & Logs")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text(languageStore.text("logout_confirm_title")),
                message: Text(languageStore.text("logout_confirm_msg")),
                primaryButton: .destructive(Text(languageStore.text("logout_confirm_yes"))) {
                    sessionManager.logout()
                },
                secondaryButton: .cancel(Text(languageStore.text("logout_confirm_cancel")))
            )
        }
    }
}
