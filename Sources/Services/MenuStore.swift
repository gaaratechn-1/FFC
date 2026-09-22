//
//  MenuStore.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition - M4)
//

import Foundation
import Combine

public final class MenuStore: ObservableObject {
    public static let shared = MenuStore()
    
    private let selectedGameKey = "ffxc.selectedGame"
    private let controlsPrefix = "ffxc.controls.v3."
    
    @Published public var selectedGame: FFGame {
        didSet {
            UserDefaults.standard.set(selectedGame.rawValue, forKey: selectedGameKey)
        }
    }
    
    @Published public var catalog: Catalog
    @Published public var configurations: [FFGame: GameConfiguration] = [:]
    @Published public var injectStates: [FFGame: InjectState] = [:]
    
    public init() {
        let defaultGame: FFGame
        if let saved = UserDefaults.standard.string(forKey: "ffxc.selectedGame"),
           let g = FFGame(rawValue: saved) {
            defaultGame = g
        } else {
            defaultGame = .freeFire
        }
        self.selectedGame = defaultGame
        self.catalog = .default
        
        // Initialize configurations for both games
        for game in FFGame.allCases {
            configurations[game] = loadConfiguration(for: game)
            injectStates[game] = .ready
        }
    }
    
    public var currentConfig: GameConfiguration {
        get {
            configurations[selectedGame] ?? GameConfiguration(game: selectedGame)
        }
        set {
            configurations[selectedGame] = newValue
            saveConfiguration(newValue, for: selectedGame)
        }
    }
    
    public func isOptionEnabled(_ id: String) -> Bool {
        return currentConfig.selected.contains(id)
    }
    
    public func toggleOption(_ id: String) {
        var conf = currentConfig
        if conf.selected.contains(id) {
            conf.selected.remove(id)
        } else {
            // Check exclusive groups if any
            if let option = catalog.options.first(where: { $0.id == id }),
               let group = option.exclusiveGroup {
                for sibling in catalog.options where sibling.exclusiveGroup == group {
                    conf.selected.remove(sibling.id)
                }
            }
            conf.selected.insert(id)
        }
        currentConfig = conf
    }
    
    public func setRadius(_ value: Double) {
        var conf = currentConfig
        conf.radius = value
        currentConfig = conf
    }
    
    public func setHeadshot(_ value: Double) {
        var conf = currentConfig
        conf.headshot = value
        currentConfig = conf
    }
    
    public func setAimTarget(_ target: String) {
        var conf = currentConfig
        conf.aimTarget = target
        currentConfig = conf
    }
    
    public func resetSelectedGameSettings() {
        let conf = GameConfiguration(game: selectedGame)
        currentConfig = conf
        AppLog.shared.info("Settings reset for \(selectedGame.displayName)")
    }
    
    public func setInjectState(_ state: InjectState, for game: FFGame) {
        DispatchQueue.main.async {
            self.injectStates[game] = state
        }
    }
    
    private func loadConfiguration(for game: FFGame) -> GameConfiguration {
        let key = "\(controlsPrefix)\(game.rawValue)"
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(GameConfiguration.self, from: data) {
            return decoded
        }
        return GameConfiguration(game: game)
    }
    
    private func saveConfiguration(_ config: GameConfiguration, for game: FFGame) {
        let key = "\(controlsPrefix)\(game.rawValue)"
        if let encoded = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
