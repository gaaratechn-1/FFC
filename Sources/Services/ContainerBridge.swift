//
//  ContainerBridge.swift
//  YABAOCHEAT
//
//  Reconstructed with 3105 (ThreeOneOSFive) MHA-C2 Container Engine
//

import Foundation
import UIKit

public final class ContainerBridge {
    public static let shared = ContainerBridge()
    
    private let searchPaths = [
        "/var/mobile/Containers/Data/Application",
        "/private/var/mobile/Containers/Data/Application",
        "/var/containers/Data/Application",
        "/private/var/containers/Data/Application",
        "/var/jb/var/mobile/Containers/Data/Application"
    ]
    
    private let metadataPlistName = ".com.apple.mobile_container_manager.metadata.plist"
    private let accessProbeName = ".ffxc_access_probe"
    
    private init() {}
    
    /// Finds and activates the container root URL for the specified bundle identifier using 3105 MHA-C2
    public func findContainer(for bundleID: String) -> URL? {
        AppLog.shared.info("[3105] Locating container for: \(bundleID)")
        
        // Method 1: 3105 MHA-C2 MobileContainerManager Direct Activation
        if let containerURL = resolveVia3105MCM(bundleID: bundleID) {
            AppLog.shared.success("[3105] Container activated via MHA-C2 bridge: \(containerURL.path)")
            return containerURL
        }
        
        // Method 2: 3105 MCM Class-2 App Enumeration + Fuzzy Matching & Activation
        if let containerURL = discoverAndActivateViaMCM(targetBundleID: bundleID) {
            AppLog.shared.success("[3105] Container discovered & activated via MCM enum: \(containerURL.path)")
            return containerURL
        }
        
        // Method 3: Private LaunchServices LSApplicationWorkspace API
        if let containerURL = findViaLaunchServices(bundleID: bundleID) {
            AppLog.shared.success("[3105] Located container via LaunchServices: \(containerURL.path)")
            return containerURL
        }
        
        // Method 4: Filesystem container scan across all known iOS paths (with sandbox escape support)
        if let containerURL = findViaFilesystemScan(bundleID: bundleID) {
            AppLog.shared.success("[3105] Located container via filesystem scan: \(containerURL.path)")
            return containerURL
        }
        
        // Fallback for Simulator
        #if targetEnvironment(simulator)
        let fileManager = FileManager.default
        let simTestDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SimulatedContainers/\(bundleID)")
        if let simTestDir = simTestDir {
            try? fileManager.createDirectory(at: simTestDir, withIntermediateDirectories: true)
            AppLog.shared.info("[3105] Using Simulator test container: \(simTestDir.path)")
            return simTestDir
        }
        #endif
        
        AppLog.shared.error("[3105] Failed to locate container for \(bundleID)")
        return nil
    }
    
    // MARK: - 3105 MHA-C2 Direct Resolution
    
    private func resolveVia3105MCM(bundleID: String) -> URL? {
        guard MCMBridgeAvailable() else {
            AppLog.shared.warning("[3105] MCM bridge symbols unavailable on this build")
            return nil
        }
        
        var lookupError: NSString?
        // Class 2 = MCMContainerClassApp
        if let path = MCMActivateContainerPath(2, bundleID, false, &lookupError) {
            let normalized = path.hasPrefix("/var/") ? "/private" + path : path
            if FileManager.default.fileExists(atPath: normalized) {
                return URL(fileURLWithPath: normalized)
            }
        }
        
        if let error = lookupError {
            AppLog.shared.warning("[3105] MCM direct activate for \(bundleID) returned: \(error)")
        }
        return nil
    }
    
    // MARK: - 3105 MCM Class-2 Enumeration
    
    private func discoverAndActivateViaMCM(targetBundleID: String) -> URL? {
        guard MCMBridgeAvailable() else { return nil }
        
        var enumerationError: NSString?
        let identifiers = MCMEnumerateIdentifiersForClass(2, 1024, &enumerationError)
        
        if let error = enumerationError {
            AppLog.shared.warning("[3105] MCM enum error: \(error)")
        }
        
        for candidate in identifiers {
            if matchesBundleIdentifier(candidate: candidate, target: targetBundleID) {
                var activateError: NSString?
                if let path = MCMActivateContainerPath(2, candidate, false, &activateError) {
                    let normalized = path.hasPrefix("/var/") ? "/private" + path : path
                    if FileManager.default.fileExists(atPath: normalized) {
                        AppLog.shared.success("[3105] Matched sideload/app [\(candidate)] for target [\(targetBundleID)]")
                        return URL(fileURLWithPath: normalized)
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - LaunchServices
    
    private func findViaLaunchServices(bundleID: String) -> URL? {
        guard let workspaceClass = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type else {
            return nil
        }
        
        let defaultWorkspaceSelector = NSSelectorFromString("defaultWorkspace")
        guard workspaceClass.responds(to: defaultWorkspaceSelector),
              let workspace = workspaceClass.perform(defaultWorkspaceSelector)?.takeUnretainedValue() as? NSObject else {
            return nil
        }
        
        let proxySelector = NSSelectorFromString("applicationProxyForIdentifier:")
        guard workspace.responds(to: proxySelector) else {
            return nil
        }
        
        let candidateIDs = [
            bundleID,
            bundleID.lowercased(),
            "com.dts.freefireth",
            "com.dts.freefiremax"
        ]
        
        for candidate in candidateIDs {
            if let proxy = workspace.perform(proxySelector, with: candidate)?.takeUnretainedValue() as? NSObject {
                let containerSelector = NSSelectorFromString("dataContainerURL")
                if proxy.responds(to: containerSelector),
                   let url = proxy.perform(containerSelector)?.takeUnretainedValue() as? URL {
                    return url
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Filesystem Scan
    
    private func findViaFilesystemScan(bundleID: String) -> URL? {
        let fileManager = FileManager.default
        var checkedFolders = 0
        var foundIdentifiers: [String] = []
        
        for basePath in searchPaths {
            guard fileManager.fileExists(atPath: basePath) else {
                continue
            }
            
            do {
                let subdirs = try fileManager.contentsOfDirectory(atPath: basePath)
                for dir in subdirs {
                    checkedFolders += 1
                    let containerDir = (basePath as NSString).appendingPathComponent(dir)
                    let plistPath = (containerDir as NSString).appendingPathComponent(metadataPlistName)
                    
                    if fileManager.fileExists(atPath: plistPath) {
                        if let plistData = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
                           let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                            
                            let mcmId = plist["MCMMetadataIdentifier"] as? String ?? ""
                            let bundleIdFromPlist = plist["CFBundleIdentifier"] as? String ?? ""
                            let identifier = mcmId.isEmpty ? bundleIdFromPlist : mcmId
                            
                            if !identifier.isEmpty {
                                foundIdentifiers.append(identifier)
                            }
                            
                            if matchesBundleIdentifier(candidate: identifier, target: bundleID) {
                                let url = URL(fileURLWithPath: containerDir)
                                return url
                            }
                        }
                    }
                }
            } catch {
                AppLog.shared.warning("[3105] Filesystem scan restricted on \(basePath): \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    // MARK: - Fuzzy Matching
    
    public func matchesBundleIdentifier(candidate: String, target: String) -> Bool {
        let candLower = candidate.lowercased()
        let targetLower = target.lowercased()
        
        if candLower == targetLower {
            return true
        }
        
        if targetLower.contains("max") {
            if candLower.contains("freefiremax") || candLower.contains("freefire_max") || candLower == "com.dts.freefiremax" {
                return true
            }
        } else {
            if (candLower.contains("freefireth") || candLower.contains("freefirevn") || candLower.contains("freefire")) && !candLower.contains("max") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Verification
    
    public func testContainerAccess(at containerURL: URL) -> Bool {
        let probeURL = containerURL.appendingPathComponent(accessProbeName)
        let canaryData = "FFXC_CANARY_\(UUID().uuidString)".data(using: .utf8)!
        
        do {
            try canaryData.write(to: probeURL, options: .atomic)
            let readBack = try Data(contentsOf: probeURL)
            try FileManager.default.removeItem(at: probeURL)
            let success = readBack == canaryData
            if success {
                AppLog.shared.success("[3105] Container read/write sandbox verification passed.")
            }
            return success
        } catch {
            AppLog.shared.error("[3105] Sandbox access probe failed at \(containerURL.path): \(error.localizedDescription)")
            return false
        }
    }
}
