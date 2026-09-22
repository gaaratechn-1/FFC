//
//  SessionManager.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition - Q7 / S5)
//

import Foundation
import Combine
import UIKit
import CryptoKit

public final class SessionManager: ObservableObject {
    public static let shared = SessionManager()
    
    private let authKeychainKey = "com.apple.mobile.MobileHouseArrest.ffxc.auth"
    private let apiEndpoint = URL(string: "https://crackbomaydi.dev/api")!
    
    @Published public var session: Session? = Session(
        displayKey: "NO-KEY-UNLOCKED",
        plan: "VIP UNLOCKED",
        keyExpiryRaw: "Permanent",
        keyExpiresAt: nil,
        authorization: "PERMANENT-BYPASS",
        catalog: .default,
        sessionExpiresAt: nil
    )
    @Published public var isOnline: Bool = true
    @Published public var isValidating: Bool = false
    @Published public var errorMessage: String? = nil
    
    public var isAuthenticated: Bool {
        return true
    }
    
    public init() {
        // Automatically authorized on launch without requiring any key
    }
    
    public func restoreSession() {
        // No-op: always authenticated
    }
    
    public func validateKey(_ key: String, completion: @escaping (Result<Session, Error>) -> Void) {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion(.failure(NSError(domain: "FFXC", code: -1, userInfo: [NSLocalizedDescriptionKey: "Key cannot be empty."])))
            return
        }
        
        self.isValidating = true
        self.errorMessage = nil
        
        // Check for offline / bypass keys for local testing
        if trimmed.uppercased().hasPrefix("FOX") || trimmed.uppercased().hasPrefix("YABAO") || trimmed.uppercased() == "OFFLINE" || trimmed.count >= 8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let localSession = Session(
                    displayKey: trimmed.uppercased(),
                    plan: "VIP / LIFETIME",
                    keyExpiryRaw: "2099-12-31",
                    keyExpiresAt: Date().addingTimeInterval(86400 * 3650),
                    authorization: "AUTHORIZED-LOCAL-BYPASS",
                    catalog: .default,
                    sessionExpiresAt: Date().addingTimeInterval(86400 * 30)
                )
                self.saveSession(localSession)
                self.session = localSession
                self.isValidating = false
                AppLog.shared.success("Authorized with key: \(trimmed.uppercased())")
                completion(.success(localSession))
            }
            return
        }
        
        // Remote API validation request
        var request = URLRequest(url: apiEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10.0
        
        let payload: [String: Any] = [
            "key": trimmed,
            "device_name": UIDevice.current.name,
            "model": UIDevice.current.model,
            "system_version": UIDevice.current.systemVersion,
            "identifier_for_vendor": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "client_timestamp": Int(Date().timeIntervalSince1970)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isValidating = false
                
                if let error = error {
                    AppLog.shared.warning("Network validation failed, falling back to local verification: \(error.localizedDescription)")
                    // Fallback local session if server unreachable
                    let fallbackSession = Session(
                        displayKey: trimmed,
                        plan: "VIP STANDALONE",
                        keyExpiryRaw: "Active",
                        keyExpiresAt: Date().addingTimeInterval(86400 * 365),
                        authorization: "AUTHORIZED-FALLBACK",
                        catalog: .default,
                        sessionExpiresAt: Date().addingTimeInterval(86400 * 7)
                    )
                    self.saveSession(fallbackSession)
                    self.session = fallbackSession
                    completion(.success(fallbackSession))
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.errorMessage = "Invalid server response"
                    completion(.failure(NSError(domain: "FFXC", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                    return
                }
                
                if let status = json["status"] as? String, status == "success" || status == "valid" {
                    let plan = json["plan"] as? String ?? "VIP"
                    let expiry = json["expiresAt"] as? String ?? "Permanent"
                    let auth = json["authorization"] as? String ?? "AUTHORIZED"
                    
                    let remoteSession = Session(
                        displayKey: trimmed,
                        plan: plan,
                        keyExpiryRaw: expiry,
                        keyExpiresAt: nil,
                        authorization: auth,
                        catalog: .default,
                        sessionExpiresAt: Date().addingTimeInterval(86400)
                    )
                    self.saveSession(remoteSession)
                    self.session = remoteSession
                    completion(.success(remoteSession))
                } else {
                    let msg = json["message"] as? String ?? "Invalid or expired key"
                    self.errorMessage = msg
                    completion(.failure(NSError(domain: "FFXC", code: -3, userInfo: [NSLocalizedDescriptionKey: msg])))
                }
            }
        }
        task.resume()
    }
    
    public func logout() {
        UserDefaults.standard.removeObject(forKey: authKeychainKey)
        self.session = nil
        AppLog.shared.info("Logged out successfully.")
    }
    
    private func saveSession(_ session: Session) {
        if let encoded = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(encoded, forKey: authKeychainKey)
        }
    }
}
