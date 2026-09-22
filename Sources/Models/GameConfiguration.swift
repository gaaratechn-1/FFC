//
//  GameConfiguration.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public struct GameConfiguration: Codable, Hashable {
    public var game: FFGame
    public var selected: Set<String>
    public var radius: Double
    public var headshot: Double
    public var aimTarget: String
    
    enum CodingKeys: String, CodingKey {
        case game
        case selected
        case radius
        case headshot = "h0"
        case aimTarget = "a0"
    }
    
    public init(game: FFGame, selected: Set<String> = [], radius: Double = 120.0, headshot: Double = 85.0, aimTarget: String = "Head") {
        self.game = game
        self.selected = selected
        self.radius = radius
        self.headshot = headshot
        self.aimTarget = aimTarget
    }
}
