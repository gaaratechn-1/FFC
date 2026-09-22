//
//  BottomInjectBar.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct BottomInjectBar: View {
    @ObservedObject var menuStore = MenuStore.shared
    @ObservedObject var languageStore = LanguageStore.shared
    
    public init() {}
    
    public var body: some View {
        let game = menuStore.selectedGame
        let state = menuStore.injectStates[game] ?? .ready
        
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                // RESET Button
                Button(action: {
                    InjectionManager.shared.reset(game: game) { _ in }
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white.opacity(0.8))
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                }
                
                // INJECT Button
                Button(action: {
                    guard !state.isBusy else { return }
                    InjectionManager.shared.inject(game: game, configuration: menuStore.currentConfig) { _ in }
                }) {
                    HStack(spacing: 8) {
                        if state.isBusy {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.9)
                        } else if state.isInjected {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 16, weight: .bold))
                        } else {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        Text(buttonTitle(for: state))
                            .font(.system(size: 15, weight: .heavy, design: .monospaced))
                    }
                }
                .buttonStyle(PrimaryButtonStyle(color: buttonColor(for: state)))
                .disabled(state.isBusy)
            }
            
            // Status text line
            if case .failed(let err) = state {
                Text(err)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                    .multilineTextAlignment(.center)
            } else if state.isInjected {
                Text(languageStore.text("inject_success"))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red: 0.35, green: 0.95, blue: 0.55))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.08, green: 0.09, blue: 0.12).opacity(0.92))
                .shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: -4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 6)
    }
    
    private func buttonTitle(for state: InjectState) -> String {
        switch state {
        case .ready:
            return languageStore.text("inject_button")
        case .checking:
            return languageStore.text("validating")
        case .injecting:
            return languageStore.text("status_injecting")
        case .injected:
            return "INJECTED"
        case .failed:
            return "RETRY INJECT"
        default:
            return languageStore.text("inject_button")
        }
    }
    
    private func buttonColor(for state: InjectState) -> Color {
        switch state {
        case .injected:
            return Color(red: 0.18, green: 0.75, blue: 0.40)
        case .failed:
            return Color(red: 0.85, green: 0.25, blue: 0.25)
        default:
            return Color(red: 0.25, green: 0.58, blue: 0.98)
        }
    }
}
