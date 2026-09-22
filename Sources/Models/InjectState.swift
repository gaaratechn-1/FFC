//
//  InjectState.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public enum InjectState: Equatable {
    case ready
    case checking
    case injecting
    case injected
    case failed(String)
    case unavailable(String)
    case simulator
    case gameNotInstalled
    case unsupportedOS(String)
    case unsupportedHardware(String)
    case containerAccessDenied(String)
    case containerBridgeUnavailable
    
    public var isBusy: Bool {
        switch self {
        case .checking, .injecting:
            return true
        default:
            return false
        }
    }
    
    public var isInjected: Bool {
        if case .injected = self {
            return true
        }
        return false
    }
}

public enum FFInjectError: LocalizedError {
    case fileUnavailable(String)
    case writeFailed(String)
    case gameNotInstalled(String)
    case containerAccessDenied(String)
    case containerNotFound
    case containerBridgeUnavailable
    case processResetUnavailable
    case launchFailed(String)
    case sessionInvalid
    case integrityFailed
    
    public var errorDescription: String? {
        switch self {
        case .fileUnavailable(let file):
            return "Required file unavailable: \(file)"
        case .writeFailed(let detail):
            return "Failed to write patch files: \(detail)"
        case .gameNotInstalled(let game):
            return "\(game) is not installed on this device."
        case .containerAccessDenied(let reason):
            return "Game container access denied: \(reason)"
        case .containerNotFound:
            return "Game data container not found. Open the game once first."
        case .containerBridgeUnavailable:
            return "Private container bridge unavailable. Requires TrollStore or Jailbreak entitlements."
        case .processResetUnavailable:
            return "Could not terminate game process."
        case .launchFailed(let scheme):
            return "Failed to launch game via \(scheme)."
        case .sessionInvalid:
            return "Session invalid or expired. Please re-authenticate."
        case .integrityFailed:
            return "Runtime patch integrity check failed."
        }
    }
}
