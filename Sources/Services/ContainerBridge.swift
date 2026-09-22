//
//  ContainerBridge.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition - ContainerBridge)
//

import Foundation

public final class ContainerBridge {
    public static let shared = ContainerBridge()
    
    private let searchPaths = [
        "/var/mobile/Containers/Data/Application",
        "/private/var/mobile/Containers/Data/Application"
    ]
    
    private let metadataPlistName = ".com.apple.mobile_container_manager.metadata.plist"
    private let accessProbeName = ".ffxc_access_probe"
    
    private init() {}
    
    /// Finds the absolute container root URL for the specified bundle identifier
    public func findContainer(for bundleID: String) -> URL? {
        let fileManager = FileManager.default
        
        for basePath in searchPaths {
            guard fileManager.fileExists(atPath: basePath) else { continue }
            
            do {
                let subdirs = try fileManager.contentsOfDirectory(atPath: basePath)
                for dir in subdirs {
                    let containerDir = (basePath as NSString).appendingPathComponent(dir)
                    let plistPath = (containerDir as NSString).appendingPathComponent(metadataPlistName)
                    
                    if fileManager.fileExists(atPath: plistPath) {
                        if let plistData = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
                           let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                            
                            if let identifier = plist["MCMMetadataIdentifier"] as? String,
                               identifier == bundleID {
                                let url = URL(fileURLWithPath: containerDir)
                                AppLog.shared.info("Located container for \(bundleID) at: \(dir)")
                                return url
                            }
                        }
                    }
                }
            } catch {
                AppLog.shared.warning("Error reading container base path \(basePath): \(error.localizedDescription)")
            }
        }
        
        // Fallback check: On non-jailbroken / sandboxed test devices or simulator, check app's own container or test dir
        #if targetEnvironment(simulator)
        let simTestDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SimulatedContainers/\(bundleID)")
        if let simTestDir = simTestDir {
            try? fileManager.createDirectory(at: simTestDir, withIntermediateDirectories: true)
            return simTestDir
        }
        #endif
        
        return nil
    }
    
    /// Tests read/write access inside the target container using a canary file
    public func testContainerAccess(at containerURL: URL) -> Bool {
        let probeURL = containerURL.appendingPathComponent(accessProbeName)
        let canaryData = "FFXC_CANARY_\(UUID().uuidString)".data(using: .utf8)!
        
        do {
            try canaryData.write(to: probeURL, options: .atomic)
            let readBack = try Data(contentsOf: probeURL)
            try FileManager.default.removeItem(at: probeURL)
            return readBack == canaryData
        } catch {
            AppLog.shared.error("Container canary access probe failed at \(containerURL.path): \(error.localizedDescription)")
            return false
        }
    }
}
