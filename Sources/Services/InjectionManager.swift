//
//  InjectionManager.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition - R7)
//

import Foundation
import UIKit

public struct InjectedFileReplacement {
    public let url: URL
    public let originalData: Data?
    public let originalAttributes: [FileAttributeKey: Any]?
}

public final class InjectionManager {
    public static let shared = InjectionManager()
    
    private let patchResourceName = "Assembly-CSharp-patch"
    private let patchExtension = "bytes"
    private let localConfigFileName = "localConfig.json"
    private let localConfigContent = "{\"testCodePatch\":true}".data(using: .utf8)!
    
    private var activeReplacements: [FFGame: [InjectedFileReplacement]] = [:]
    
    private init() {}
    
    public func inject(game: FFGame, configuration: GameConfiguration, completion: @escaping (Result<Void, FFInjectError>) -> Void) {
        MenuStore.shared.setInjectState(.checking, for: game)
        AppLog.shared.info("Starting injection pipeline for \(game.displayName)...")
        
        // 1. Locate container
        guard let containerURL = ContainerBridge.shared.findContainer(for: game.bundleIdentifier) else {
            let err = FFInjectError.containerNotFound
            MenuStore.shared.setInjectState(.failed(err.localizedDescription), for: game)
            completion(.failure(err))
            return
        }
        
        // 2. Test access
        guard ContainerBridge.shared.testContainerAccess(at: containerURL) else {
            let err = FFInjectError.containerAccessDenied(containerURL.path)
            MenuStore.shared.setInjectState(.containerAccessDenied(err.localizedDescription), for: game)
            completion(.failure(err))
            return
        }
        
        // 3. Find patch payload
        guard let patchURL = Bundle.main.url(forResource: patchResourceName, withExtension: patchExtension) ??
                Bundle.main.url(forResource: "Assembly-CSharp-patch.bytes", withExtension: nil) else {
            let err = FFInjectError.fileUnavailable("Assembly-CSharp-patch.bytes")
            MenuStore.shared.setInjectState(.failed(err.localizedDescription), for: game)
            completion(.failure(err))
            return
        }
        
        MenuStore.shared.setInjectState(.injecting, for: game)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let patchData = try Data(contentsOf: patchURL)
                
                // Injection target directories inside Free Fire container:
                // Unity Tencent IFix patch loader inspects Documents and Library/Caches/patch
                let docDir = containerURL.appendingPathComponent("Documents")
                let libDir = containerURL.appendingPathComponent("Library")
                let patchDir = libDir.appendingPathComponent("Caches/patch")
                
                try? FileManager.default.createDirectory(at: docDir, withIntermediateDirectories: true)
                try? FileManager.default.createDirectory(at: patchDir, withIntermediateDirectories: true)
                
                let targetPatchURL = docDir.appendingPathComponent("Assembly-CSharp-patch.bytes")
                let targetPatchURL2 = patchDir.appendingPathComponent("Assembly-CSharp-patch.bytes")
                let targetConfigURL = docDir.appendingPathComponent(self.localConfigFileName)
                let targetConfigURL2 = patchDir.appendingPathComponent(self.localConfigFileName)
                
                // Write patch payloads
                try patchData.write(to: targetPatchURL, options: .atomic)
                try? patchData.write(to: targetPatchURL2, options: .atomic)
                
                // Write localConfig.json enabling testCodePatch
                try self.localConfigContent.write(to: targetConfigURL, options: .atomic)
                try? self.localConfigContent.write(to: targetConfigURL2, options: .atomic)
                
                AppLog.shared.success("Patch payload & localConfig.json successfully injected.")
                
                DispatchQueue.main.async {
                    MenuStore.shared.setInjectState(.injected, for: game)
                    
                    // Launch Game
                    self.launchGame(game: game)
                    completion(.success(()))
                }
            } catch {
                let err = FFInjectError.writeFailed(error.localizedDescription)
                DispatchQueue.main.async {
                    MenuStore.shared.setInjectState(.failed(err.localizedDescription), for: game)
                    completion(.failure(err))
                }
            }
        }
    }
    
    public func reset(game: FFGame, completion: @escaping (Result<Void, Error>) -> Void) {
        AppLog.shared.info("Neutralizing patches for \(game.displayName)...")
        
        guard let containerURL = ContainerBridge.shared.findContainer(for: game.bundleIdentifier) else {
            MenuStore.shared.setInjectState(.ready, for: game)
            completion(.success(()))
            return
        }
        
        let fileManager = FileManager.default
        let docDir = containerURL.appendingPathComponent("Documents")
        let patchDir = containerURL.appendingPathComponent("Library/Caches/patch")
        
        let targets = [
            docDir.appendingPathComponent("Assembly-CSharp-patch.bytes"),
            docDir.appendingPathComponent(localConfigFileName),
            patchDir.appendingPathComponent("Assembly-CSharp-patch.bytes"),
            patchDir.appendingPathComponent(localConfigFileName)
        ]
        
        for t in targets {
            if fileManager.fileExists(atPath: t.path) {
                try? fileManager.removeItem(at: t)
            }
        }
        
        MenuStore.shared.setInjectState(.ready, for: game)
        AppLog.shared.success("Patches neutralized. Game reset to stock condition.")
        completion(.success(()))
    }
    
    public func launchGame(game: FFGame) {
        if let url = URL(string: game.urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    AppLog.shared.info("Game launched via scheme \(game.urlScheme)")
                } else {
                    AppLog.shared.warning("Could not launch game via URL scheme.")
                }
            }
        }
    }
}
