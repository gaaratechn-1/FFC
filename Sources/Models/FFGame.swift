//
//  FFGame.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public enum FFGame: String, CaseIterable, Identifiable, Codable {
    case freeFire = "freeFire"
    case freeFireMax = "freeFireMax"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .freeFire:
            return "Free Fire"
        case .freeFireMax:
            return "Free Fire MAX"
        }
    }
    
    public var bundleIdentifier: String {
        switch self {
        case .freeFire:
            return "com.dts.freefireth"
        case .freeFireMax:
            return "com.dts.freefiremax"
        }
    }
    
    public var urlScheme: String {
        switch self {
        case .freeFire:
            return "freefire://"
        case .freeFireMax:
            return "freefiremax://"
        }
    }
}
