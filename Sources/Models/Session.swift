//
//  Session.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public enum AuthFailureReason: String, Codable {
    case revoked
    case deleted
    case expired
    case deviceMismatch
    case invalid
    case server
    case network
    case malformedResponse
    case invalidSignature
    case replayDetected
    case secureStorage
    case integrityFailed
    
    public var localizedMessage: String {
        switch self {
        case .invalid, .expired:
            return "Invalid or expired key"
        case .deviceMismatch:
            return "Key is bound to another device"
        case .revoked:
            return "License has been revoked"
        case .deleted:
            return "Key no longer exists"
        case .network:
            return "Network connection error"
        case .server:
            return "License server error"
        case .integrityFailed:
            return "Runtime integrity verification failed"
        default:
            return "Authentication failed"
        }
    }
}

public struct DeviceCredential: Codable {
    public let displayKey: String
    public let plan: String
    public let expiryDate: String
    public let expiresAt: Date?
    public let deviceName: String
    public let hwid: String
    public let iOSVersion: String
    public let iPhoneModel: String
    
    public init(displayKey: String, plan: String = "VIP", expiryDate: String = "Permanent", expiresAt: Date? = nil, deviceName: String = "", hwid: String = "", iOSVersion: String = "", iPhoneModel: String = "") {
        self.displayKey = displayKey
        self.plan = plan
        self.expiryDate = expiryDate
        self.expiresAt = expiresAt
        self.deviceName = deviceName
        self.hwid = hwid
        self.iOSVersion = iOSVersion
        self.iPhoneModel = iPhoneModel
    }
}

public struct Session: Codable {
    public let displayKey: String
    public let plan: String
    public let keyExpiryRaw: String
    public let keyExpiresAt: Date?
    public let authorization: String
    public let catalog: Catalog
    public let sessionExpiresAt: Date?
    
    public init(displayKey: String, plan: String = "VIP", keyExpiryRaw: String = "Permanent", keyExpiresAt: Date? = nil, authorization: String = "AUTHORIZED", catalog: Catalog = .default, sessionExpiresAt: Date? = nil) {
        self.displayKey = displayKey
        self.plan = plan
        self.keyExpiryRaw = keyExpiryRaw
        self.keyExpiresAt = keyExpiresAt
        self.authorization = authorization
        self.catalog = catalog
        self.sessionExpiresAt = sessionExpiresAt
    }
}
