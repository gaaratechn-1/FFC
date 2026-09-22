//
//  LoginView.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct LoginView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    @ObservedObject var languageStore = LanguageStore.shared
    
    @State private var keyInput: String = ""
    @State private var showLanguagePicker: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            FFXCBackdrop()
            
            VStack(spacing: 28) {
                // Top Bar with Language and Status
                HStack {
                    Button(action: {
                        showLanguagePicker = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "globe")
                                .font(.system(size: 13))
                            Text(languageStore.current.title)
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    .buttonStyle(GlassButtonStyle())
                    
                    Spacer()
                    
                    // Server Status Badge
                    HStack(spacing: 6) {
                        Circle()
                            .fill(sessionManager.isOnline ? Color(red: 0.35, green: 0.95, blue: 0.55) : Color.red)
                            .frame(width: 7, height: 7)
                        
                        Text(languageStore.text(sessionManager.isOnline ? "status_online" : "status_offline"))
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.06))
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Brand Mark Centerpiece
                VStack(spacing: 12) {
                    FFXCBrandMark()
                    
                    Text("SECURE RUNTIME INJECTOR")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(Color.white.opacity(0.4))
                }
                
                // Card with Key Input
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(languageStore.text("key_placeholder"))
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .tracking(1.5)
                            .foregroundColor(Color.white.opacity(0.5))
                        
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                                .font(.system(size: 14))
                            
                            TextField("XXXX-XXXX-XXXX-XXXX", text: $keyInput)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .autocapitalization(.allCharacters)
                                .disableAutocorrection(true)
                            
                            if !keyInput.isEmpty {
                                Button(action: { keyInput = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color.white.opacity(0.4))
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                    
                    if let error = sessionManager.errorMessage {
                        Text(error)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        sessionManager.validateKey(keyInput) { _ in }
                    }) {
                        HStack(spacing: 8) {
                            if sessionManager.isValidating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "shield.righthalf.filled")
                            }
                            Text(sessionManager.isValidating ? languageStore.text("validating") : languageStore.text("verify_key"))
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(sessionManager.isValidating || keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .glassPanel(padding: 20, radius: 18)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Telegram support link
                Button(action: {
                    if let url = URL(string: "https://t.me/YaPaoCheat") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 12))
                        Text(languageStore.text("telegram_link") + " (t.me/YaPaoCheat)")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                }
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView()
        }
    }
}
